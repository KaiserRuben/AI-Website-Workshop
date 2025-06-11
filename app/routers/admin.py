from fastapi import APIRouter, Depends, HTTPException, Request
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func
from sqlalchemy.orm import selectinload
from pydantic import BaseModel
from typing import List, Dict

from app.database import get_db
from app.models import User, Workshop, LLMCall, Website, UserRole
from app.middleware.auth import get_current_user_from_state
from app.services import CostTracker

router = APIRouter()


def require_admin(request: Request):
    """Require admin role"""
    current_user = get_current_user_from_state(request)
    if current_user.role != UserRole.ADMIN.value:
        raise HTTPException(status_code=403, detail="Admin-Berechtigung erforderlich")
    return current_user


class AdminStats(BaseModel):
    total_users: int
    active_users: int
    total_cost: float
    total_api_calls: int
    total_websites: int
    avg_cost_per_user: float


class UserDetail(BaseModel):
    id: int
    username: str
    display_name: str
    role: str
    total_cost: float
    total_calls: int
    total_tokens: int
    last_seen: str
    website_count: int


class WorkshopDetail(BaseModel):
    id: int
    name: str
    date: str
    is_active: bool
    max_cost_per_user: float
    user_count: int
    total_cost: float


@router.get("/stats", response_model=AdminStats)
async def get_admin_stats(
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """Get workshop statistics"""
    admin_user = require_admin(request)
    workshop_id = admin_user.workshop_id
    
    # Total users
    result = await db.execute(
        select(func.count(User.id)).where(User.workshop_id == workshop_id)
    )
    total_users = result.scalar() or 0
    
    # Active users (last 5 minutes)
    from datetime import datetime, timedelta
    since = datetime.utcnow() - timedelta(minutes=5)
    result = await db.execute(
        select(func.count(User.id))
        .where(User.workshop_id == workshop_id)
        .where(User.last_seen >= since)
    )
    active_users = result.scalar() or 0
    
    # Total cost
    result = await db.execute(
        select(func.sum(LLMCall.cost))
        .join(User)
        .where(User.workshop_id == workshop_id)
    )
    total_cost = float(result.scalar() or 0)
    
    # Total API calls
    result = await db.execute(
        select(func.count(LLMCall.id))
        .join(User)
        .where(User.workshop_id == workshop_id)
    )
    total_api_calls = result.scalar() or 0
    
    # Total websites
    result = await db.execute(
        select(func.count(Website.id))
        .join(User)
        .where(User.workshop_id == workshop_id)
    )
    total_websites = result.scalar() or 0
    
    # Average cost per user
    avg_cost = total_cost / total_users if total_users > 0 else 0
    
    return AdminStats(
        total_users=total_users,
        active_users=active_users,
        total_cost=total_cost,
        total_api_calls=total_api_calls,
        total_websites=total_websites,
        avg_cost_per_user=avg_cost
    )


@router.get("/users", response_model=List[UserDetail])
async def get_all_users(
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """Get detailed user information"""
    admin_user = require_admin(request)
    result = await db.execute(
        select(User).where(User.workshop_id == admin_user.workshop_id)
    )
    users = result.scalars().all()
    
    cost_tracker = CostTracker(db)
    user_details = []
    
    for user in users:
        stats = await cost_tracker.get_user_stats(user.id)
        
        # Count websites
        result = await db.execute(
            select(func.count(Website.id)).where(Website.user_id == user.id)
        )
        website_count = result.scalar() or 0
        
        user_details.append(UserDetail(
            id=user.id,
            username=user.username,
            display_name=user.display_name or user.username,
            role=user.role,
            total_cost=stats["total_cost"],
            total_calls=stats["total_calls"],
            total_tokens=stats["total_tokens"],
            last_seen=user.last_seen.isoformat(),
            website_count=website_count
        ))
    
    return user_details


@router.get("/workshop", response_model=WorkshopDetail)
async def get_workshop_details(
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """Get workshop details"""
    admin_user = require_admin(request)
    # Fetch workshop since it might not be loaded
    result = await db.execute(
        select(Workshop).where(Workshop.id == admin_user.workshop_id)
    )
    workshop = result.scalar_one_or_none()
    
    if not workshop:
        raise HTTPException(status_code=404, detail="Workshop nicht gefunden")
    
    # User count
    result = await db.execute(
        select(func.count(User.id)).where(User.workshop_id == workshop.id)
    )
    user_count = result.scalar() or 0
    
    # Total cost
    result = await db.execute(
        select(func.sum(LLMCall.cost))
        .join(User)
        .where(User.workshop_id == workshop.id)
    )
    total_cost = float(result.scalar() or 0)
    
    return WorkshopDetail(
        id=workshop.id,
        name=workshop.name,
        date=workshop.date.isoformat(),
        is_active=workshop.is_active,
        max_cost_per_user=float(workshop.max_cost_per_user),
        user_count=user_count,
        total_cost=total_cost
    )


@router.post("/workshop/stop")
async def stop_workshop(
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """Stop the workshop"""
    admin_user = require_admin(request)
    # Fetch workshop since it might not be loaded
    result = await db.execute(
        select(Workshop).where(Workshop.id == admin_user.workshop_id)
    )
    workshop = result.scalar_one_or_none()
    
    if not workshop:
        raise HTTPException(status_code=404, detail="Workshop nicht gefunden")
    
    workshop.is_active = False
    await db.commit()
    
    return {"message": "Workshop beendet"}


@router.get("/export")
async def export_workshop_data(
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """Export workshop data"""
    admin_user = require_admin(request)
    workshop_id = admin_user.workshop_id
    
    # Get all users and their data
    result = await db.execute(
        select(User).where(User.workshop_id == workshop_id)
    )
    users = result.scalars().all()
    
    # Fetch workshop details
    result = await db.execute(
        select(Workshop).where(Workshop.id == workshop_id)
    )
    workshop = result.scalar_one_or_none()
    
    if not workshop:
        raise HTTPException(status_code=404, detail="Workshop nicht gefunden")
    
    export_data = {
        "workshop": {
            "id": workshop.id,
            "name": workshop.name,
            "date": workshop.date.isoformat(),
            "max_cost_per_user": float(workshop.max_cost_per_user)
        },
        "users": []
    }
    
    for user in users:
        # Get user's websites
        result = await db.execute(
            select(Website).where(Website.user_id == user.id)
        )
        websites = result.scalars().all()
        
        # Get user's costs
        cost_tracker = CostTracker(db)
        stats = await cost_tracker.get_user_stats(user.id)
        
        user_data = {
            "id": user.id,
            "username": user.username,
            "display_name": user.display_name,
            "role": user.role.value,
            "joined_at": user.joined_at.isoformat(),
            "stats": stats,
            "websites": [
                {
                    "id": w.id,
                    "name": w.name,
                    "html": w.html,
                    "css": w.css,
                    "js": w.js,
                    "created_at": w.created_at.isoformat(),
                    "updated_at": w.updated_at.isoformat()
                }
                for w in websites
            ]
        }
        export_data["users"].append(user_data)
    
    return export_data