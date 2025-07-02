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
    
    async def broadcast_to_user(self, user_id: int, message: dict):
        """Alias for send_personal_message for consistency"""
        await self.send_personal_message(message, user_id)
                
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
    
    # Get user's projects to send current state
    result = await db.execute(
        select(Website)
        .options(selectinload(Website.user))
        .where(Website.user_id == user.id)
        .order_by(Website.updated_at.desc())
    )
    projects = result.scalars().all()
    
    # Send welcome message with projects list
    welcome_message = {
        "type": "connection_status", 
        "status": "connected",
        "user_id": user.id,
        "username": user.username,
        "projects": [{
            "id": p.id,
            "name": p.name,
            "slug": p.slug,
            "is_active": p.is_active,
            "is_public": p.is_public,
            "is_collaborative": p.is_collaborative,
            "updated_at": p.updated_at.isoformat()
        } for p in projects]
    }
    
    # Send current active project code if exists
    active_project = next((p for p in projects if p.is_active), None)
    if active_project:
        await manager.send_personal_message({
            "type": "code_update",
            "project_id": active_project.id,
            "code": {
                "html": active_project.html,
                "css": active_project.css,
                "js": active_project.js
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
                
            elif message_type == "switch_project":
                await handle_switch_project(
                    message, user, db
                )
                
            elif message_type == "create_project":
                await handle_create_project(
                    message, user, db
                )
                
            elif message_type == "toggle_project_public":
                await handle_toggle_project_public(
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
    project_id = message.get("project_id")
    
    # Check if user can make API call
    can_call, reason = await cost_tracker.can_make_api_call(user.id)
    if not can_call:
        await manager.send_personal_message({
            "type": "error",
            "message": reason
        }, user.id)
        return
    
    # Get the specified project or user's active website
    if project_id:
        result = await db.execute(
            select(Website)
            .options(selectinload(Website.user))
            .where(Website.id == project_id)
            .where(Website.user_id == user.id)
        )
        website = result.scalar_one_or_none()
    else:
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
            "message": "Projekt nicht gefunden"
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
        
        # Get user's images for AI context
        from app.services.image_service import ImageService
        user_images = await ImageService.get_user_images_for_ai_context(
            user_id=user.id,
            website_id=website.id,  # Use website.id as context
            db=db
        )
        
        # Get user's learned concepts
        user_learned_concepts = user.learned_concepts or []
        
        # Generate AI response
        llm_response, response_data = await azure_ai.generate_response(
            prompt=prompt,
            current_code=actual_current_code,
            context="code_generation",
            user_images=user_images,
            learned_concepts=user_learned_concepts
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
            response_type=response_type.value,  # Use .value to get the string value
            response_data=response_data,
            prompt_tokens=llm_response.prompt_tokens,
            completion_tokens=llm_response.completion_tokens,
            cost=cost,
            duration_ms=0  # Add timing if needed
        )
        
        # Update learned concepts if new ones were introduced
        if "new_concepts" in response_data and response_data["new_concepts"]:
            new_concepts = response_data["new_concepts"]
            updated_concepts = list(set(user_learned_concepts + new_concepts))
            
            # Update user's learned concepts in database
            from sqlalchemy import update
            from app.models.user import User
            await db.execute(
                update(User)
                .where(User.id == user.id)
                .values(learned_concepts=updated_concepts)
            )
            await db.commit()
            
            logger.info(f"Updated learned concepts for user {user.id}: added {new_concepts}")
        
        # Send chat message
        await manager.send_personal_message({
            "type": "chat_message",
            "role": "assistant",
            "content": llm_response.content
        }, user.id)
        
        # Process code changes
        if response_data["response_type"].lower() in ["update", "update_all", "rewrite"]:
            # Check for ambiguous updates that need disambiguation
            if response_data["response_type"].lower() == "update" and response_data.get("updates"):
                needs_disambiguation = await check_for_disambiguation_needed(
                    response_data, actual_current_code, user, db, azure_ai, cost_tracker, prompt
                )
                if needs_disambiguation:
                    return  # Disambiguation request sent, don't process original request
            
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


async def check_for_disambiguation_needed(
    response_data: dict,
    current_code: Dict[str, str],
    user: User,
    db: AsyncSession,
    azure_ai: AzureAIService,
    cost_tracker: CostTracker,
    original_prompt: str
) -> bool:
    """Check if disambiguation is needed for update operations"""
    updates = response_data.get("updates", [])
    
    for update in updates:
        old_str = update.get("old_str", "")
        if not old_str:
            continue
            
        # Find all matches for this old_str
        matches = azure_ai.find_multiple_matches(old_str, current_code)
        
        if len(matches) > 1:
            # Multiple matches found, need disambiguation
            logger.info(f"Found {len(matches)} matches for '{old_str}', requesting disambiguation")
            
            # Check if user can make another API call
            can_call, reason = await cost_tracker.can_make_api_call(user.id)
            if not can_call:
                await manager.send_personal_message({
                    "type": "error",
                    "message": f"Mehrere Treffer gefunden, aber {reason}"
                }, user.id)
                return True  # Stop processing
                
            try:
                # Ask LLM for clarification
                website = await get_user_active_website(user, db)
                if not website:
                    return False
                    
                llm_response, clarification_data = await azure_ai.disambiguate_multiple_matches(
                    original_request=original_prompt,
                    old_str=old_str,
                    matches=matches,
                    current_code=current_code
                )
                
                # Calculate cost for disambiguation call
                cost = azure_ai.calculate_cost(
                    llm_response.prompt_tokens,
                    llm_response.completion_tokens
                )
                
                # Record the disambiguation API call
                from app.models.llm import ResponseType
                await cost_tracker.record_api_call(
                    user_id=user.id,
                    website_id=website.id,
                    prompt=f"Disambiguation for: {original_prompt}",
                    response_type=ResponseType.CHAT,  # Disambiguation is always chat first
                    response_data=clarification_data,
                    prompt_tokens=llm_response.prompt_tokens,
                    completion_tokens=llm_response.completion_tokens,
                    cost=cost,
                    duration_ms=0
                )
                
                # Send clarification message
                await manager.send_personal_message({
                    "type": "chat_message",
                    "role": "assistant",
                    "content": llm_response.content
                }, user.id)
                
                # Process the clarification response
                if clarification_data["response_type"].lower() in ["update", "update_all", "rewrite"]:
                    await process_code_changes(clarification_data, website, user, db)
                
                # Send cost update
                stats = await cost_tracker.get_user_stats(user.id)
                await manager.send_personal_message({
                    "type": "cost_update",
                    "totalCost": stats["total_cost"],
                    "lastCallCost": cost,
                    "costPercentage": stats["cost_percentage"]
                }, user.id)
                
                return True  # Disambiguation handled
                
            except Exception as e:
                logger.error(f"Disambiguation error: {e}")
                await manager.send_personal_message({
                    "type": "error",
                    "message": "Fehler bei der Klärung der Änderung"
                }, user.id)
                return True  # Stop processing
    
    return False  # No disambiguation needed


async def get_user_active_website(user: User, db: AsyncSession) -> Optional[Website]:
    """Get user's active website"""
    result = await db.execute(
        select(Website)
        .where(Website.user_id == user.id)
        .where(Website.is_active == True)
    )
    return result.scalar_one_or_none()


async def process_code_changes(
    response_data: dict,
    website: Website,
    user: User,
    db: AsyncSession
):
    """Process code changes from AI response"""
    response_type = response_data["response_type"].lower()
    
    # Save current state to history
    change_type = ChangeType.AI_REWRITE
    if response_type in ["update", "update_all"]:
        change_type = ChangeType.AI_UPDATE
        
    history = CodeHistory(
        website_id=website.id,
        html=website.html,
        css=website.css,
        js=website.js,
        change_type=change_type
    )
    db.add(history)
    
    if response_type in ["update", "update_all"]:
        # Apply updates
        current_code = {
            "html": website.html,
            "css": website.css,
            "js": website.js
        }
        new_code = CodeProcessor.apply_updates(
            current_code, 
            response_data.get("updates", []),
            apply_all=(response_type == "update_all")
        )
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
        "project_id": website.id,
        "code": new_code,
        "changeType": response_data["response_type"]
    }, user.id)
    
    # Update gallery (only if project is public)
    if website.is_public:
        await gallery_manager.queue_update(
            user.id,
            {
                "project_id": website.id,
                "html": website.html,
                "css": website.css,
                "js": website.js,
                "name": website.name,
                "slug": website.slug,
                "description": website.description,
                "tags": website.tags or [],
                "username": user.username,
                "user_display_name": user.display_name,
                "is_collaborative": website.is_collaborative,
                "has_images": website.has_images,
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
    project_id = message.get("project_id")
    
    # Get the specified project or user's active website
    if project_id:
        result = await db.execute(
            select(Website)
            .options(selectinload(Website.user))
            .where(Website.id == project_id)
            .where(Website.user_id == user.id)
        )
        website = result.scalar_one_or_none()
    else:
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
            "message": "Projekt nicht gefunden"
        }, user.id)
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
        "project_id": website.id,
        "timestamp": website.updated_at.isoformat(),
        "message": "Code gespeichert"
    }, user.id)
    
    # Update gallery (only if project is public)
    if website.is_public:
        await gallery_manager.queue_update(
            user.id,
            {
                "project_id": website.id,
                "html": website.html,
                "css": website.css,
                "js": website.js,
                "name": website.name,
                "slug": website.slug,
                "description": website.description,
                "tags": website.tags or [],
                "username": user.username,
                "user_display_name": user.display_name,
                "is_collaborative": website.is_collaborative,
                "has_images": website.has_images,
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


async def handle_switch_project(
    message: dict,
    user: User,
    db: AsyncSession
):
    """Handle switching active project"""
    project_id = message.get("project_id")
    
    if not project_id:
        await manager.send_personal_message({
            "type": "error",
            "message": "Projekt ID fehlt"
        }, user.id)
        return
    
    # Verify project belongs to user
    result = await db.execute(
        select(Website)
        .where(Website.id == project_id)
        .where(Website.user_id == user.id)
    )
    project = result.scalar_one_or_none()
    
    if not project:
        await manager.send_personal_message({
            "type": "error",
            "message": "Projekt nicht gefunden"
        }, user.id)
        return
    
    # Set all user's projects to inactive
    result = await db.execute(
        select(Website).where(Website.user_id == user.id)
    )
    user_projects = result.scalars().all()
    
    for p in user_projects:
        p.is_active = False
    
    # Set selected project as active
    project.is_active = True
    
    await db.commit()
    await db.refresh(project)
    
    # Send project switch confirmation with code
    await manager.send_personal_message({
        "type": "project_switched",
        "project_id": project.id,
        "code": {
            "html": project.html,
            "css": project.css,
            "js": project.js
        },
        "project_name": project.name
    }, user.id)


async def handle_create_project(
    message: dict,
    user: User,
    db: AsyncSession
):
    """Handle creating a new project"""
    project_name = message.get("name", "Neues Projekt")
    template_id = message.get("template_id")
    
    # Get template content using template service
    from app.services.template_service import TemplateService
    template_content = await TemplateService.get_template_content(db, template_id)
    template_html = template_content["html"]
    template_css = template_content["css"]
    template_js = template_content["js"]
    
    # Set all user's projects to inactive
    result = await db.execute(
        select(Website).where(Website.user_id == user.id)
    )
    user_projects = result.scalars().all()
    
    for p in user_projects:
        p.is_active = False
    
    # First project should be public by default
    is_first_project = len(user_projects) == 0
    
    # Create new project
    new_project = Website(
        user_id=user.id,
        name=project_name,
        html=template_html,
        css=template_css,
        js=template_js,
        is_active=True,
        is_public=is_first_project
    )
    
    db.add(new_project)
    await db.commit()
    await db.refresh(new_project)
    
    # Create initial code history
    from app.models import CodeHistory, ChangeType
    history = CodeHistory(
        website_id=new_project.id,
        html=new_project.html,
        css=new_project.css,
        js=new_project.js,
        change_type=ChangeType.MANUAL
    )
    db.add(history)
    await db.commit()
    
    # Send project creation confirmation
    await manager.send_personal_message({
        "type": "project_created",
        "project": {
            "id": new_project.id,
            "name": new_project.name,
            "slug": new_project.slug,
            "is_active": new_project.is_active,
            "is_public": new_project.is_public,
            "is_collaborative": new_project.is_collaborative,
            "updated_at": new_project.updated_at.isoformat()
        },
        "code": {
            "html": new_project.html,
            "css": new_project.css,
            "js": new_project.js
        }
    }, user.id)


async def handle_toggle_project_public(
    message: dict,
    user: User,
    db: AsyncSession
):
    """Handle toggling project public/private status"""
    project_id = message.get("project_id")
    
    if not project_id:
        await manager.send_personal_message({
            "type": "error",
            "message": "Projekt ID fehlt"
        }, user.id)
        return
    
    # Verify project belongs to user
    result = await db.execute(
        select(Website)
        .where(Website.id == project_id)
        .where(Website.user_id == user.id)
    )
    project = result.scalar_one_or_none()
    
    if not project:
        await manager.send_personal_message({
            "type": "error",
            "message": "Projekt nicht gefunden"
        }, user.id)
        return
    
    # Toggle public status
    project.is_public = not project.is_public
    
    await db.commit()
    
    # Send update confirmation
    await manager.send_personal_message({
        "type": "project_visibility_updated",
        "project_id": project.id,
        "is_public": project.is_public,
        "message": f"Projekt ist jetzt {'öffentlich' if project.is_public else 'privat'}"
    }, user.id)
    
    # If made public, update gallery for all workshop participants
    if project.is_public:
        await gallery_manager.queue_update(
            user.id,
            {
                "html": project.html,
                "css": project.css,
                "js": project.js,
                "name": project.name,
                "username": user.username,
                "updated_at": project.updated_at.isoformat()
            },
            user.workshop_id
        )