from fastapi import APIRouter, Depends, HTTPException, Request
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from pydantic import BaseModel
from typing import Dict, List, Optional

from app.database import get_db
from app.models import Website, CodeHistory, ChangeType, User
from app.middleware.auth import get_current_user_from_state
from app.services import CodeProcessor

router = APIRouter()


class WebsiteResponse(BaseModel):
    id: int
    name: str
    html: str
    css: str
    js: str
    is_active: bool
    updated_at: str


class CodeUpdate(BaseModel):
    html: Optional[str] = None
    css: Optional[str] = None
    js: Optional[str] = None


class RollbackRequest(BaseModel):
    steps: int = 1


class CloneTemplateRequest(BaseModel):
    source_user_id: int


@router.get("/websites", response_model=List[WebsiteResponse])
async def get_user_websites(
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """Get user's websites"""
    current_user = get_current_user_from_state(request)
    result = await db.execute(
        select(Website).where(Website.user_id == current_user.id)
    )
    websites = result.scalars().all()
    
    return [
        WebsiteResponse(
            id=w.id,
            name=w.name,
            html=w.html,
            css=w.css,
            js=w.js,
            is_active=w.is_active,
            updated_at=w.updated_at.isoformat()
        )
        for w in websites
    ]


@router.get("/websites/{website_id}", response_model=WebsiteResponse)
async def get_website(
    website_id: int,
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """Get specific website"""
    current_user = get_current_user_from_state(request)
    result = await db.execute(
        select(Website)
        .where(Website.id == website_id)
        .where(Website.user_id == current_user.id)
    )
    website = result.scalar_one_or_none()
    
    if not website:
        raise HTTPException(status_code=404, detail="Website nicht gefunden")
    
    return WebsiteResponse(
        id=website.id,
        name=website.name,
        html=website.html,
        css=website.css,
        js=website.js,
        is_active=website.is_active,
        updated_at=website.updated_at.isoformat()
    )


@router.put("/websites/{website_id}", response_model=WebsiteResponse)
async def update_website(
    website_id: int,
    code_update: CodeUpdate,
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """Update website code manually"""
    current_user = get_current_user_from_state(request)
    result = await db.execute(
        select(Website)
        .where(Website.id == website_id)
        .where(Website.user_id == current_user.id)
    )
    website = result.scalar_one_or_none()
    
    if not website:
        raise HTTPException(status_code=404, detail="Website nicht gefunden")
    
    # Save current state to history
    history = CodeHistory(
        website_id=website.id,
        html=website.html,
        css=website.css,
        js=website.js,
        change_type=ChangeType.MANUAL
    )
    db.add(history)
    
    # Prepare new code
    new_code = {
        "html": code_update.html if code_update.html is not None else website.html,
        "css": code_update.css if code_update.css is not None else website.css,
        "js": code_update.js if code_update.js is not None else website.js
    }
    
    # Validate code
    is_valid, errors = CodeProcessor.validate_code(new_code)
    if not is_valid:
        raise HTTPException(status_code=400, detail=f"Code-Validierung fehlgeschlagen: {errors}")
    
    # Update website
    if code_update.html is not None:
        website.html = code_update.html
    if code_update.css is not None:
        website.css = code_update.css
    if code_update.js is not None:
        website.js = code_update.js
    
    await db.commit()
    
    return WebsiteResponse(
        id=website.id,
        name=website.name,
        html=website.html,
        css=website.css,
        js=website.js,
        is_active=website.is_active,
        updated_at=website.updated_at.isoformat()
    )


@router.post("/websites/{website_id}/rollback")
async def rollback_website(
    website_id: int,
    rollback_request: RollbackRequest,
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """Rollback website to previous version"""
    current_user = get_current_user_from_state(request)
    result = await db.execute(
        select(Website)
        .where(Website.id == website_id)
        .where(Website.user_id == current_user.id)
    )
    website = result.scalar_one_or_none()
    
    if not website:
        raise HTTPException(status_code=404, detail="Website nicht gefunden")
    
    # Get non-rollback history entries (avoid circular references)
    result = await db.execute(
        select(CodeHistory)
        .where(CodeHistory.website_id == website_id)
        .where(CodeHistory.change_type != ChangeType.ROLLBACK)
        .order_by(CodeHistory.created_at.desc())
        .limit(rollback_request.steps)
    )
    history_entries = result.scalars().all()
    
    if not history_entries:
        raise HTTPException(status_code=404, detail="Keine Rollback-Historie gefunden")
    
    # Get the target version (the nth previous non-rollback state)
    target = history_entries[-1]
    
    # Only save current state if it's different from target (avoid unnecessary entries)
    current_state = (website.html, website.css, website.js)
    target_state = (target.html, target.css, target.js)
    
    if current_state != target_state:
        # Save current state to history before rollback
        current_history = CodeHistory(
            website_id=website.id,
            html=website.html,
            css=website.css,
            js=website.js,
            change_type=ChangeType.ROLLBACK
        )
        db.add(current_history)
    
    # Apply rollback
    website.html = target.html
    website.css = target.css
    website.js = target.js
    
    await db.commit()
    
    return {
        "message": f"Website um {rollback_request.steps} Schritte zurückgesetzt",
        "rollback_to": target.created_at.isoformat()
    }


@router.post("/clone-template")
async def clone_template(
    clone_request: CloneTemplateRequest,
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """Clone another user's website as template"""
    current_user = get_current_user_from_state(request)
    
    # Get source user's active website
    result = await db.execute(
        select(Website)
        .where(Website.user_id == clone_request.source_user_id)
        .where(Website.is_active == True)
    )
    source_website = result.scalar_one_or_none()
    
    if not source_website:
        raise HTTPException(status_code=404, detail="Quell-Website nicht gefunden")
    
    # Get current user's active website
    result = await db.execute(
        select(Website)
        .where(Website.user_id == current_user.id)
        .where(Website.is_active == True)
    )
    current_website = result.scalar_one_or_none()
    
    if not current_website:
        raise HTTPException(status_code=404, detail="Keine aktive Website gefunden")
    
    # Save current state to history
    history = CodeHistory(
        website_id=current_website.id,
        html=current_website.html,
        css=current_website.css,
        js=current_website.js,
        change_type=ChangeType.MANUAL
    )
    db.add(history)
    
    # Clone the template
    current_website.html = source_website.html
    current_website.css = source_website.css
    current_website.js = source_website.js
    
    await db.commit()
    
    return {
        "message": "Vorlage erfolgreich übernommen",
        "source_user": clone_request.source_user_id
    }