from fastapi import APIRouter, HTTPException, Request, Depends
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, and_, func
from typing import Optional

from app.database import get_db
from app.models.user import User
from app.models.website import Website

router = APIRouter()
templates = Jinja2Templates(directory="app/templates")


@router.get("/u/{username}", response_class=HTMLResponse)
async def user_profile(
    request: Request,
    username: str,
    db: AsyncSession = Depends(get_db)
):
    """Display user profile with their public projects"""
    # Find user
    result = await db.execute(
        select(User).where(User.username == username)
    )
    user = result.scalar_one_or_none()
    
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    # Get user's public projects
    result = await db.execute(
        select(Website).where(
            and_(
                Website.user_id == user.id,
                Website.is_public == True,
                Website.is_deployed == True
            )
        ).order_by(Website.updated_at.desc())
    )
    projects = result.scalars().all()
    
    # Get stats
    total_likes = sum(p.likes_count for p in projects)
    total_views = sum(p.views_count for p in projects)
    
    return templates.TemplateResponse(
        "user_profile.html",
        {
            "request": request,
            "user": user,
            "projects": projects,
            "total_likes": total_likes,
            "total_views": total_views,
            "project_count": len(projects)
        }
    )


@router.get("/u/{username}/{project_slug}", response_class=HTMLResponse)
async def view_project(
    request: Request,
    username: str,
    project_slug: str,
    db: AsyncSession = Depends(get_db)
):
    """Display a specific public project"""
    # Find user
    user_result = await db.execute(
        select(User).where(User.username == username)
    )
    user = user_result.scalar_one_or_none()
    
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    # Find project
    project_result = await db.execute(
        select(Website).where(
            and_(
                Website.user_id == user.id,
                Website.slug == project_slug,
                Website.is_public == True,
                Website.is_deployed == True
            )
        )
    )
    project = project_result.scalar_one_or_none()
    
    if not project:
        raise HTTPException(status_code=404, detail="Project not found")
    
    # Increment view count
    project.views_count += 1
    await db.commit()
    
    # Get other projects from the same user (for sidebar)
    other_projects_result = await db.execute(
        select(Website).where(
            and_(
                Website.user_id == user.id,
                Website.id != project.id,
                Website.is_public == True,
                Website.is_deployed == True
            )
        ).limit(5).order_by(Website.updated_at.desc())
    )
    other_projects = other_projects_result.scalars().all()
    
    return templates.TemplateResponse(
        "project_view.html",
        {
            "request": request,
            "user": user,
            "project": project,
            "other_projects": other_projects
        }
    )


@router.get("/p/{project_id}", response_class=HTMLResponse)
async def view_project_by_id(
    request: Request,
    project_id: int,
    db: AsyncSession = Depends(get_db)
):
    """Short URL for direct project access"""
    # Find project with user
    result = await db.execute(
        select(Website).where(
            and_(
                Website.id == project_id,
                Website.is_public == True,
                Website.is_deployed == True
            )
        )
    )
    project = result.scalar_one_or_none()
    
    if not project:
        raise HTTPException(status_code=404, detail="Project not found")
    
    # Load user relationship
    await db.refresh(project, ["user"])
    
    # Redirect to canonical URL
    from fastapi.responses import RedirectResponse
    return RedirectResponse(
        url=f"/u/{project.user.username}/{project.slug}",
        status_code=301
    )