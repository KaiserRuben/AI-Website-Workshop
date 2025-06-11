from fastapi import APIRouter, Depends, HTTPException, Request
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from pydantic import BaseModel
from typing import List, Dict, Optional

from app.database import get_db
from app.models import Workshop, User, Template, Website, WebsiteLike
from app.middleware.auth import get_current_user_from_state
from app.services import CostTracker
from sqlalchemy import func

router = APIRouter()


class WorkshopInfo(BaseModel):
    id: int
    name: str
    is_active: bool
    user_count: int
    max_cost_per_user: float


class UserInfo(BaseModel):
    id: int
    username: str
    display_name: str
    role: str
    total_cost: float
    total_calls: int


class TemplateResponse(BaseModel):
    id: int
    name: str
    description: Optional[str]
    category: Optional[str]
    html: str
    css: str
    js: Optional[str]


@router.get("/workshop/info", response_model=WorkshopInfo)
async def get_workshop_info(
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """Get current workshop information"""
    current_user = get_current_user_from_state(request)
    workshop = current_user.workshop
    
    # Count users
    result = await db.execute(
        select(User).where(User.workshop_id == workshop.id)
    )
    users = result.scalars().all()
    
    return WorkshopInfo(
        id=workshop.id,
        name=workshop.name,
        is_active=workshop.is_active,
        user_count=len(users),
        max_cost_per_user=float(workshop.max_cost_per_user)
    )


@router.get("/workshop/stats")
async def get_user_stats(
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """Get current user statistics"""
    current_user = get_current_user_from_state(request)
    cost_tracker = CostTracker(db)
    stats = await cost_tracker.get_user_stats(current_user.id)
    
    return {
        "user_id": current_user.id,
        "username": current_user.username,
        "role": current_user.role,
        **stats
    }


@router.get("/workshop/users", response_model=List[UserInfo])
async def get_workshop_users(
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """Get all users in workshop (for gallery)"""
    current_user = get_current_user_from_state(request)
    result = await db.execute(
        select(User).where(User.workshop_id == current_user.workshop_id)
    )
    users = result.scalars().all()
    
    cost_tracker = CostTracker(db)
    user_list = []
    
    for user in users:
        stats = await cost_tracker.get_user_stats(user.id)
        user_list.append(UserInfo(
            id=user.id,
            username=user.username,
            display_name=user.display_name or user.username,
            role=user.role,
            total_cost=stats["total_cost"],
            total_calls=stats["total_calls"]
        ))
    
    return user_list


@router.get("/workshop/session")
async def get_session_info(request: Request, db: AsyncSession = Depends(get_db)):
    """Get session information including token for WebSocket connection"""
    # Get session token from cookies
    session_token = request.cookies.get("session_token")
    
    if not session_token:
        raise HTTPException(status_code=401, detail="Nicht angemeldet")
    
    # Get user from session token
    result = await db.execute(
        select(User).where(User.session_token == session_token)
    )
    user = result.scalar_one_or_none()
    
    if not user:
        raise HTTPException(status_code=401, detail="Ungültige Session")
    
    return {
        "session_token": user.session_token,
        "user_id": user.id,
        "username": user.username,
        "role": user.role.value
    }


@router.get("/templates", response_model=List[TemplateResponse])
async def get_templates(
    db: AsyncSession = Depends(get_db)
):
    """Get available templates"""
    result = await db.execute(
        select(Template).where(Template.is_active == True)
    )
    templates = result.scalars().all()
    
    return [
        TemplateResponse(
            id=t.id,
            name=t.name,
            description=t.description,
            category=t.category,
            html=t.html,
            css=t.css,
            js=t.js
        )
        for t in templates
    ]


class GalleryProject(BaseModel):
    id: int
    user_id: int
    username: str
    name: Optional[str]
    html: str
    css: str
    js: str
    updated_at: str
    likes: int = 0
    liked: bool = False


class GalleryStats(BaseModel):
    totalProjects: int
    activeCreators: int
    totalLikes: int


class GalleryResponse(BaseModel):
    projects: List[GalleryProject]
    stats: GalleryStats


@router.get("/gallery", response_model=GalleryResponse)
async def get_gallery(
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """Get all projects for gallery view"""
    current_user = get_current_user_from_state(request)
    
    # Get all websites with user info and like counts
    result = await db.execute(
        select(
            Website,
            User,
            func.count(WebsiteLike.id).label('like_count')
        )
        .join(User, Website.user_id == User.id)
        .outerjoin(WebsiteLike, WebsiteLike.website_id == Website.id)
        .where(Website.html.isnot(None))
        .where(Website.html != "")
        .group_by(Website.id, User.id)
    )
    
    websites_data = result.all()
    
    # Get user's liked websites
    liked_result = await db.execute(
        select(WebsiteLike.website_id)
        .where(WebsiteLike.user_id == current_user.id)
    )
    user_liked_websites = set(row[0] for row in liked_result.all())
    
    projects = []
    total_likes = 0
    
    for website, user, like_count in websites_data:
        projects.append(GalleryProject(
            id=website.id,
            user_id=user.id,
            username=user.username,
            name=website.name or f"{user.username}'s Website",
            html=website.html or "",
            css=website.css or "",
            js=website.js or "",
            updated_at=website.updated_at.isoformat(),
            likes=like_count,
            liked=website.id in user_liked_websites
        ))
        total_likes += like_count
    
    # Calculate stats
    stats = GalleryStats(
        totalProjects=len(projects),
        activeCreators=len(set(p.user_id for p in projects)),
        totalLikes=total_likes
    )
    
    return GalleryResponse(projects=projects, stats=stats)


class LikeRequest(BaseModel):
    liked: bool


@router.post("/gallery/{project_id}/like")
async def toggle_like(
    project_id: int,
    like_request: LikeRequest,
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """Toggle like status for a project"""
    current_user = get_current_user_from_state(request)
    
    # Verify project exists
    result = await db.execute(
        select(Website).where(Website.id == project_id)
    )
    website = result.scalar_one_or_none()
    
    if not website:
        raise HTTPException(status_code=404, detail="Project not found")
    
    # TODO: Implement actual likes system with database storage
    # For now, just return success
    return {"success": True, "liked": like_request.liked}