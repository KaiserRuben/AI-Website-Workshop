import json
import asyncio
import logging
from typing import Dict, Set, Optional
from fastapi import APIRouter, WebSocket, WebSocketDisconnect, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from sqlalchemy.orm import selectinload

from app.database import get_db
from app.models import User, Website, ChatMessage, MessageRole, ChangeType, CodeHistory
from app.services import AzureAIService, CostTracker, CodeProcessor
from app.config import get_settings

router = APIRouter()
settings = get_settings()
logger = logging.getLogger(__name__)


class ConnectionManager:
    """Manage WebSocket connections"""
    
    def __init__(self):
        self.active_connections: Dict[int, WebSocket] = {}
        self.user_connections: Dict[str, int] = {}  # session_token -> user_id
        
    async def connect(self, websocket: WebSocket, user_id: int, session_token: str):
        await websocket.accept()
        self.active_connections[user_id] = websocket
        self.user_connections[session_token] = user_id
        logger.info(f"WebSocket connected: user_id={user_id}")
        
    def disconnect(self, user_id: int):
        if user_id in self.active_connections:
            del self.active_connections[user_id]
        # Remove from user_connections
        for token, uid in list(self.user_connections.items()):
            if uid == user_id:
                del self.user_connections[token]
                break
        logger.info(f"WebSocket disconnected: user_id={user_id}")
        
    async def send_personal_message(self, message: dict, user_id: int):
        if user_id in self.active_connections:
            try:
                await self.active_connections[user_id].send_text(json.dumps(message))
            except:
                self.disconnect(user_id)
                
    async def broadcast_to_workshop(self, message: dict, workshop_id: int, exclude_user: Optional[int] = None):
        disconnected = []
        for user_id, websocket in self.active_connections.items():
            if exclude_user and user_id == exclude_user:
                continue
            try:
                await websocket.send_text(json.dumps(message))
            except:
                disconnected.append(user_id)
        
        # Clean up disconnected
        for user_id in disconnected:
            self.disconnect(user_id)


manager = ConnectionManager()


class GalleryUpdateManager:
    """Batch gallery updates for performance"""
    
    def __init__(self):
        self.pending_updates: Dict[int, dict] = {}
        self.update_task: Optional[asyncio.Task] = None
        
    async def queue_update(self, user_id: int, preview: dict, workshop_id: int):
        self.pending_updates[user_id] = preview
        
        if not self.update_task:
            self.update_task = asyncio.create_task(self._batch_send(workshop_id))
            
    async def _batch_send(self, workshop_id: int):
        await asyncio.sleep(settings.gallery_update_batch_interval)
        
        if self.pending_updates:
            updates = self.pending_updates.copy()
            self.pending_updates.clear()
            
            await manager.broadcast_to_workshop({
                "type": "gallery_batch_update",
                "updates": updates
            }, workshop_id)
            
        self.update_task = None


gallery_manager = GalleryUpdateManager()


async def get_user_from_token(session_token: str, db: AsyncSession) -> Optional[User]:
    """Get user from session token"""
    result = await db.execute(
        select(User)
        .options(selectinload(User.workshop))
        .where(User.session_token == session_token)
    )
    return result.scalar_one_or_none()


@router.websocket("/ws/{session_token}")
async def websocket_endpoint(
    websocket: WebSocket, 
    session_token: str,
    db: AsyncSession = Depends(get_db)
):
    """WebSocket endpoint for real-time communication"""
    user = await get_user_from_token(session_token, db)
    if not user:
        await websocket.close(code=4001)
        return
    
    await manager.connect(websocket, user.id, session_token)
    
    # Get user's active website to send current state
    result = await db.execute(
        select(Website)
        .options(selectinload(Website.user))
        .where(Website.user_id == user.id)
        .where(Website.is_active == True)
    )
    website = result.scalar_one_or_none()
    
    # Send welcome message with current code state
    welcome_message = {
        "type": "connection_status", 
        "status": "connected",
        "user_id": user.id,
        "username": user.username
    }
    
    if website:
        # Send current database state to sync frontend
        await manager.send_personal_message({
            "type": "code_update",
            "code": {
                "html": website.html,
                "css": website.css,
                "js": website.js
            },
            "changeType": "sync",
            "sync": True  # Flag to indicate this is initial sync
        }, user.id)
    
    await manager.send_personal_message(welcome_message, user.id)
    
    azure_ai = AzureAIService()
    cost_tracker = CostTracker(db)
    
    try:
        while True:
            # Receive message
            data = await websocket.receive_text()
            message = json.loads(data)
            message_type = message.get("type")
            
            if message_type == "ping":
                await manager.send_personal_message({"type": "pong"}, user.id)
                
            elif message_type == "ai_request":
                await handle_ai_request(
                    message, user, db, azure_ai, cost_tracker
                )
                
            elif message_type == "code_update":
                await handle_code_update(
                    message, user, db
                )
                
            elif message_type == "toggle_like":
                await handle_toggle_like(
                    message, user, db
                )
                
    except WebSocketDisconnect:
        manager.disconnect(user.id)
    except Exception as e:
        logger.error(f"WebSocket error for user {user.id}: {e}")
        manager.disconnect(user.id)


async def handle_ai_request(
    message: dict,
    user: User,
    db: AsyncSession,
    azure_ai: AzureAIService,
    cost_tracker: CostTracker
):
    """Handle AI request from user"""
    prompt = message.get("prompt", "")
    current_code = message.get("currentCode", {})
    
    # Check if user can make API call
    can_call, reason = await cost_tracker.can_make_api_call(user.id)
    if not can_call:
        await manager.send_personal_message({
            "type": "error",
            "message": reason
        }, user.id)
        return
    
    # Get user's active website
    result = await db.execute(
        select(Website)
        .options(selectinload(Website.user))
        .where(Website.user_id == user.id)
        .where(Website.is_active == True)
    )
    website = result.scalar_one_or_none()
    if not website:
        await manager.send_personal_message({
            "type": "error",
            "message": "Keine aktive Website gefunden"
        }, user.id)
        return
    
    try:
        # Ensure we use the most current code from the database
        # The frontend might have stale data
        actual_current_code = {
            "html": website.html,
            "css": website.css,
            "js": website.js
        }
        
        # Log for debugging
        logger.info(f"Using current code from database for AI - HTML preview: {actual_current_code['html'][:100]}...")
        
        # Generate AI response
        llm_response, response_data = await azure_ai.generate_response(
            prompt=prompt,
            current_code=actual_current_code
        )
        
        # Calculate cost
        cost = azure_ai.calculate_cost(
            llm_response.prompt_tokens,
            llm_response.completion_tokens
        )
        
        # Record API call - ensure response_type is proper enum value
        from app.models.llm import ResponseType
        response_type_str = response_data["response_type"].lower()
        
        # Convert to enum to ensure it's valid
        try:
            response_type = ResponseType(response_type_str)
            logger.info(f"Using response_type: {response_type} (value: {response_type.value})")
        except ValueError:
            logger.error(f"Invalid response_type: {response_type_str}, falling back to chat")
            response_type = ResponseType.CHAT
        await cost_tracker.record_api_call(
            user_id=user.id,
            website_id=website.id,
            prompt=prompt,
            response_type=response_type,
            response_data=response_data,
            prompt_tokens=llm_response.prompt_tokens,
            completion_tokens=llm_response.completion_tokens,
            cost=cost,
            duration_ms=0  # Add timing if needed
        )
        
        # Send chat message
        await manager.send_personal_message({
            "type": "chat_message",
            "role": "assistant",
            "content": llm_response.content
        }, user.id)
        
        # Process code changes
        if response_data["response_type"].lower() in ["update", "rewrite"]:
            # Refresh website object to ensure it's attached to the session
            await db.refresh(website)
            await process_code_changes(
                response_data, website, user, db
            )
        
        # Send cost update
        stats = await cost_tracker.get_user_stats(user.id)
        await manager.send_personal_message({
            "type": "cost_update",
            "totalCost": stats["total_cost"],
            "lastCallCost": cost,
            "costPercentage": stats["cost_percentage"]
        }, user.id)
        
    except Exception as e:
        await db.rollback()  # Rollback transaction on error
        logger.error(f"AI request error for user {user.id}: {e}")
        await manager.send_personal_message({
            "type": "error",
            "message": "Fehler bei der KI-Anfrage"
        }, user.id)


async def process_code_changes(
    response_data: dict,
    website: Website,
    user: User,
    db: AsyncSession
):
    """Process code changes from AI response"""
    # Save current state to history
    history = CodeHistory(
        website_id=website.id,
        html=website.html,
        css=website.css,
        js=website.js,
        change_type=ChangeType.AI_UPDATE if response_data["response_type"].lower() == "update" else ChangeType.AI_REWRITE
    )
    db.add(history)
    
    if response_data["response_type"].lower() == "update":
        # Apply updates
        current_code = {
            "html": website.html,
            "css": website.css,
            "js": website.js
        }
        new_code = CodeProcessor.apply_updates(current_code, response_data.get("updates", []))
    else:
        # Complete rewrite
        new_code = response_data.get("new_code", {})
    
    # Validate and sanitize
    is_valid, errors = CodeProcessor.validate_code(new_code)
    if not is_valid:
        new_code = CodeProcessor.sanitize_code(new_code)
    
    # Update website
    website.html = new_code.get("html", website.html)
    website.css = new_code.get("css", website.css)
    website.js = new_code.get("js", website.js)
    
    await db.commit()
    await db.refresh(website)  # Refresh to get updated timestamp
    
    # Send code update
    await manager.send_personal_message({
        "type": "code_update",
        "code": new_code,
        "changeType": response_data["response_type"]
    }, user.id)
    
    # Update gallery
    await gallery_manager.queue_update(
        user.id,
        {
            "html": website.html,
            "css": website.css,
            "js": website.js,
            "name": website.name,
            "username": user.username,
            "updated_at": website.updated_at.isoformat()
        },
        user.workshop_id
    )


async def handle_code_update(
    message: dict,
    user: User,
    db: AsyncSession
):
    """Handle manual code update"""
    code = message.get("code", {})
    
    # Get user's active website
    result = await db.execute(
        select(Website)
        .options(selectinload(Website.user))
        .where(Website.user_id == user.id)
        .where(Website.is_active == True)
    )
    website = result.scalar_one_or_none()
    if not website:
        return
    
    # Validate code
    is_valid, errors = CodeProcessor.validate_code(code)
    if not is_valid:
        await manager.send_personal_message({
            "type": "error",
            "message": f"Code-Validierung fehlgeschlagen: {'; '.join(errors)}"
        }, user.id)
        return
    
    # Save to history
    history = CodeHistory(
        website_id=website.id,
        html=website.html,
        css=website.css,
        js=website.js,
        change_type=ChangeType.MANUAL
    )
    db.add(history)
    
    # Update website
    website.html = code.get("html", website.html)
    website.css = code.get("css", website.css)
    website.js = code.get("js", website.js)
    
    await db.commit()
    await db.refresh(website)  # Refresh to get updated timestamp
    
    # Send save confirmation back to user
    await manager.send_personal_message({
        "type": "save_confirmation",
        "timestamp": website.updated_at.isoformat(),
        "message": "Code gespeichert"
    }, user.id)
    
    # Update gallery
    await gallery_manager.queue_update(
        user.id,
        {
            "html": website.html,
            "css": website.css,
            "js": website.js,
            "name": website.name,
            "username": user.username,
            "updated_at": website.updated_at.isoformat()
        },
        user.workshop_id
    )


async def handle_toggle_like(
    message: dict,
    user: User,
    db: AsyncSession
):
    """Handle like/unlike action from user"""
    website_id = message.get("website_id")
    
    if not website_id:
        await manager.send_personal_message({
            "type": "error",
            "message": "Website ID fehlt"
        }, user.id)
        return
    
    # Import WebsiteLike model and func
    from app.models import WebsiteLike
    from sqlalchemy import func
    
    # Check if website exists
    result = await db.execute(
        select(Website).where(Website.id == website_id)
    )
    website = result.scalar_one_or_none()
    
    if not website:
        await manager.send_personal_message({
            "type": "error",
            "message": "Website nicht gefunden"
        }, user.id)
        return
    
    # Check if user already liked this website
    result = await db.execute(
        select(WebsiteLike)
        .where(WebsiteLike.website_id == website_id)
        .where(WebsiteLike.user_id == user.id)
    )
    existing_like = result.scalar_one_or_none()
    
    if existing_like:
        # Unlike - remove the like
        await db.delete(existing_like)
        liked = False
    else:
        # Like - add new like
        new_like = WebsiteLike(
            website_id=website_id,
            user_id=user.id
        )
        db.add(new_like)
        liked = True
    
    await db.commit()
    
    # Get updated like count
    result = await db.execute(
        select(func.count(WebsiteLike.id))
        .where(WebsiteLike.website_id == website_id)
    )
    likes_count = result.scalar()
    
    # Send response to user
    await manager.send_personal_message({
        "type": "like_update",
        "website_id": website_id,
        "liked": liked,
        "likes_count": likes_count
    }, user.id)
    
    # Broadcast update to all users in workshop
    await manager.broadcast_to_workshop({
        "type": "gallery_like_update",
        "website_id": website_id,
        "likes_count": likes_count
    }, user.workshop_id)