from fastapi import APIRouter, Depends, HTTPException, Request
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, and_, or_
from pydantic import BaseModel
from typing import Dict, List, Optional
from datetime import datetime, timedelta

from app.database import get_db
from app.models import Website, CodeHistory, ChangeType, User, WebsiteCollaborator, WebsiteShare, WebsiteComment, WebsiteLike, Template
from app.middleware.auth import get_current_user_from_state
from app.services import CodeProcessor
from app.services.deployment import deploy_website, undeploy_website
from app.services.project_service import ProjectCreationService

router = APIRouter()


class WebsiteResponse(BaseModel):
    id: int
    name: str
    html: str
    css: str
    js: str
    is_active: bool
    is_deployed: bool
    deployed_at: Optional[str]
    subdomain: Optional[str]
    updated_at: str


class CodeUpdate(BaseModel):
    html: Optional[str] = None
    css: Optional[str] = None
    js: Optional[str] = None


class RollbackRequest(BaseModel):
    steps: int = 1


class CloneTemplateRequest(BaseModel):
    source_user_id: int


class CreateWebsiteRequest(BaseModel):
    name: str
    template_id: Optional[int] = None
    is_public: bool = False


@router.post("/websites")
async def create_website(
    create_request: CreateWebsiteRequest,
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """Create a new website/project"""
    current_user = get_current_user_from_state(request)
    
    # Get template content using template service
    from app.services.template_service import TemplateService
    template_content = await TemplateService.get_template_content(db, create_request.template_id)
    template_html = template_content["html"]
    template_css = template_content["css"]
    template_js = template_content["js"]
    
    # Template-based projects are private by default (learning mode)
    is_public = create_request.is_public if create_request.template_id is None else False
    
    # Create new project using unified service
    new_project = await ProjectCreationService.create_project(
        db=db,
        user=current_user,
        name=create_request.name,
        html=template_html,
        css=template_css,
        js=template_js,
        is_public=is_public
    )
    
    # Create initial code history
    history = CodeHistory(
        website_id=new_project.id,
        html=new_project.html,
        css=new_project.css,
        js=new_project.js,
        change_type=ChangeType.MANUAL
    )
    db.add(history)
    await db.commit()
    
    return {
        "id": new_project.id,
        "name": new_project.name,
        "slug": new_project.slug,
        "is_active": new_project.is_active,
        "is_public": new_project.is_public,
        "is_collaborative": new_project.is_collaborative,
        "updated_at": new_project.updated_at.isoformat(),
        "template_id": create_request.template_id
    }


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
            is_deployed=w.is_deployed,
            deployed_at=w.deployed_at.isoformat() if w.deployed_at else None,
            subdomain=w.get_subdomain() if w.is_deployed else None,
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
        is_deployed=website.is_deployed,
        deployed_at=website.deployed_at.isoformat() if website.deployed_at else None,
        subdomain=website.get_subdomain() if website.is_deployed else None,
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
        is_deployed=website.is_deployed,
        deployed_at=website.deployed_at.isoformat() if website.deployed_at else None,
        subdomain=website.get_subdomain() if website.is_deployed else None,
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


# New collaboration endpoints

class ProjectUpdate(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None
    is_public: Optional[bool] = None
    is_collaborative: Optional[bool] = None
    allow_comments: Optional[bool] = None
    allow_forks: Optional[bool] = None
    tags: Optional[List[str]] = None


class CollaboratorAdd(BaseModel):
    username: str
    can_edit: bool = False
    can_comment: bool = True


class CommentCreate(BaseModel):
    content: str
    parent_comment_id: Optional[int] = None


class ShareCreate(BaseModel):
    can_edit: bool = False
    expires_in_hours: Optional[int] = 24


@router.get("/websites/public")
async def list_public_projects(
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """List all public projects"""
    current_user = get_current_user_from_state(request)
    
    result = await db.execute(
        select(Website).where(Website.is_public == True).order_by(Website.updated_at.desc())
    )
    projects = result.scalars().all()
    
    return [{
        "id": p.id,
        "name": p.name,
        "slug": p.slug,
        "description": p.description,
        "tags": p.tags or [],
        "owner": {
            "id": p.user.id,
            "username": p.user.username,
            "display_name": p.user.display_name
        },
        "updated_at": p.updated_at.isoformat(),
        "like_count": len(p.likes),
        "comment_count": len(p.comments),
        "has_liked": any(l.user_id == current_user.id for l in p.likes)
    } for p in projects]


@router.patch("/websites/{website_id}/metadata")
async def update_project_metadata(
    website_id: int,
    update: ProjectUpdate,
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """Update project metadata"""
    current_user = get_current_user_from_state(request)
    website = await db.get(Website, website_id)
    
    if not website or website.user_id != current_user.id:
        raise HTTPException(status_code=404, detail="Website nicht gefunden")
    
    # Update fields
    for field, value in update.dict(exclude_unset=True).items():
        setattr(website, field, value)
    
    await db.commit()
    return {"message": "Projekt-Metadaten aktualisiert"}


@router.post("/websites/{website_id}/fork")
async def fork_project(
    website_id: int,
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """Fork a project"""
    current_user = get_current_user_from_state(request)
    source_project = await db.get(Website, website_id)
    
    if not source_project:
        raise HTTPException(status_code=404, detail="Projekt nicht gefunden")
    
    # Check if forking is allowed
    if not source_project.allow_forks and source_project.user_id != current_user.id:
        raise HTTPException(status_code=403, detail="Forking ist für dieses Projekt nicht erlaubt")
    
    # Create the fork
    fork = Website(
        user_id=current_user.id,
        name=f"{source_project.name} (Fork)",
        description=f"Geforkt von {source_project.user.username}/{source_project.slug}",
        html=source_project.html,
        css=source_project.css,
        js=source_project.js,
        parent_website_id=source_project.id,
        tags=source_project.tags
    )
    
    db.add(fork)
    await db.commit()
    await db.refresh(fork)
    
    # Create initial code history
    history = CodeHistory(
        website_id=fork.id,
        html=fork.html,
        css=fork.css,
        js=fork.js,
        change_type=ChangeType.MANUAL
    )
    db.add(history)
    await db.commit()
    
    return {
        "id": fork.id,
        "name": fork.name,
        "slug": fork.slug,
        "message": "Projekt erfolgreich geforkt"
    }


@router.post("/websites/{website_id}/collaborators")
async def add_collaborator(
    website_id: int,
    collaborator: CollaboratorAdd,
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """Add a collaborator to the project"""
    current_user = get_current_user_from_state(request)
    website = await db.get(Website, website_id)
    
    if not website or website.user_id != current_user.id:
        raise HTTPException(status_code=404, detail="Website nicht gefunden")
    
    # Find the user
    user_result = await db.execute(
        select(User).where(User.username == collaborator.username)
    )
    user = user_result.scalar_one_or_none()
    if not user:
        raise HTTPException(status_code=404, detail="Benutzer nicht gefunden")
    
    # Check if already a collaborator
    existing = await db.execute(
        select(WebsiteCollaborator).where(
            and_(
                WebsiteCollaborator.website_id == website_id,
                WebsiteCollaborator.user_id == user.id
            )
        )
    )
    if existing.scalar_one_or_none():
        raise HTTPException(status_code=400, detail="Benutzer ist bereits ein Kollaborateur")
    
    # Add collaborator
    new_collab = WebsiteCollaborator(
        website_id=website_id,
        user_id=user.id,
        can_edit=collaborator.can_edit,
        can_comment=collaborator.can_comment,
        accepted_at=datetime.utcnow()  # Auto-accept for workshop
    )
    
    db.add(new_collab)
    await db.commit()
    
    return {"message": f"{user.username} als Kollaborateur hinzugefügt"}


@router.get("/websites/{website_id}/collaborators")
async def list_collaborators(
    website_id: int,
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """List project collaborators"""
    current_user = get_current_user_from_state(request)
    website = await db.get(Website, website_id)
    
    if not website:
        raise HTTPException(status_code=404, detail="Website nicht gefunden")
    
    # Check access
    has_access = (
        website.user_id == current_user.id or
        website.is_public or
        any(c.user_id == current_user.id and c.accepted_at for c in website.collaborators)
    )
    
    if not has_access:
        raise HTTPException(status_code=403, detail="Zugriff verweigert")
    
    return [{
        "id": c.id,
        "user": {
            "id": c.user.id,
            "username": c.user.username,
            "display_name": c.user.display_name
        },
        "can_edit": c.can_edit,
        "can_comment": c.can_comment,
        "invited_at": c.invited_at.isoformat(),
        "accepted_at": c.accepted_at.isoformat() if c.accepted_at else None
    } for c in website.collaborators]


@router.post("/websites/{website_id}/share")
async def create_share_link(
    website_id: int,
    share: ShareCreate,
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """Create a shareable link for the project"""
    current_user = get_current_user_from_state(request)
    website = await db.get(Website, website_id)
    
    if not website or website.user_id != current_user.id:
        raise HTTPException(status_code=404, detail="Website nicht gefunden")
    
    # Create share link
    expires_at = None
    if share.expires_in_hours:
        expires_at = datetime.utcnow() + timedelta(hours=share.expires_in_hours)
    
    share_link = WebsiteShare(
        website_id=website_id,
        created_by=current_user.id,
        can_edit=share.can_edit,
        expires_at=expires_at
    )
    
    db.add(share_link)
    await db.commit()
    await db.refresh(share_link)
    
    return {
        "share_token": share_link.share_token,
        "share_url": f"/share/{share_link.share_token}",
        "can_edit": share_link.can_edit,
        "expires_at": share_link.expires_at.isoformat() if share_link.expires_at else None
    }


@router.post("/websites/{website_id}/comments")
async def add_comment(
    website_id: int,
    comment: CommentCreate,
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """Add a comment to the project"""
    current_user = get_current_user_from_state(request)
    website = await db.get(Website, website_id)
    
    if not website:
        raise HTTPException(status_code=404, detail="Website nicht gefunden")
    
    # Check if comments are allowed
    if not website.allow_comments:
        raise HTTPException(status_code=403, detail="Kommentare sind für dieses Projekt deaktiviert")
    
    # Check access
    has_access = (
        website.user_id == current_user.id or
        website.is_public or
        any(c.user_id == current_user.id and c.can_comment and c.accepted_at 
            for c in website.collaborators)
    )
    
    if not has_access:
        raise HTTPException(status_code=403, detail="Keine Berechtigung zum Kommentieren")
    
    # Add comment
    new_comment = WebsiteComment(
        website_id=website_id,
        user_id=current_user.id,
        content=comment.content,
        parent_comment_id=comment.parent_comment_id
    )
    
    db.add(new_comment)
    await db.commit()
    await db.refresh(new_comment)
    
    return {
        "id": new_comment.id,
        "content": new_comment.content,
        "user": {
            "id": current_user.id,
            "username": current_user.username,
            "display_name": current_user.display_name
        },
        "created_at": new_comment.created_at.isoformat()
    }


@router.get("/websites/{website_id}/comments")
async def list_comments(
    website_id: int,
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """List project comments"""
    current_user = get_current_user_from_state(request)
    website = await db.get(Website, website_id)
    
    if not website:
        raise HTTPException(status_code=404, detail="Website nicht gefunden")
    
    # Check access
    has_access = (
        website.user_id == current_user.id or
        website.is_public or
        any(c.user_id == current_user.id and c.accepted_at for c in website.collaborators)
    )
    
    if not has_access:
        raise HTTPException(status_code=403, detail="Zugriff verweigert")
    
    # Build comment tree
    comments = []
    for comment in website.comments:
        if not comment.parent_comment_id:  # Top-level comments
            comment_data = {
                "id": comment.id,
                "content": comment.content,
                "user": {
                    "id": comment.user.id,
                    "username": comment.user.username,
                    "display_name": comment.user.display_name
                },
                "created_at": comment.created_at.isoformat(),
                "replies": []
            }
            
            # Add replies
            for reply in comment.replies:
                comment_data["replies"].append({
                    "id": reply.id,
                    "content": reply.content,
                    "user": {
                        "id": reply.user.id,
                        "username": reply.user.username,
                        "display_name": reply.user.display_name
                    },
                    "created_at": reply.created_at.isoformat()
                })
            
            comments.append(comment_data)
    
    return comments


@router.post("/websites/{website_id}/like")
async def toggle_like(
    website_id: int,
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """Toggle like on a project"""
    current_user = get_current_user_from_state(request)
    website = await db.get(Website, website_id)
    
    if not website:
        raise HTTPException(status_code=404, detail="Website nicht gefunden")
    
    # Check if already liked
    existing = await db.execute(
        select(WebsiteLike).where(
            and_(
                WebsiteLike.website_id == website_id,
                WebsiteLike.user_id == current_user.id
            )
        )
    )
    existing_like = existing.scalar_one_or_none()
    
    if existing_like:
        # Unlike
        await db.delete(existing_like)
        await db.commit()
        return {"liked": False, "message": "Projekt nicht mehr geliked"}
    else:
        # Like
        new_like = WebsiteLike(
            website_id=website_id,
            user_id=current_user.id
        )
        db.add(new_like)
        await db.commit()
        return {"liked": True, "message": "Projekt geliked"}


@router.get("/templates")
async def get_templates(
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """Get available project templates"""
    result = await db.execute(
        select(Template).where(Template.is_active == True).order_by(Template.category, Template.order_index, Template.name)
    )
    templates = result.scalars().all()
    
    return [
        {
            "id": t.id,
            "name": t.name,
            "description": t.description,
            "category": t.category,
            "level": getattr(t, 'template_metadata', {}).get('level', 1) if hasattr(t, 'template_metadata') and t.template_metadata else 1,
            "duration": getattr(t, 'template_metadata', {}).get('duration', '') if hasattr(t, 'template_metadata') and t.template_metadata else '',
            "order_index": getattr(t, 'order_index', 0) if hasattr(t, 'order_index') else 0
        }
        for t in templates
    ]


@router.get("/recent")
async def get_recent_projects(
    request: Request,
    db: AsyncSession = Depends(get_db),
    limit: int = 20
):
    """Get recent projects from all users for the landing page"""
    # Get recent active and public projects
    result = await db.execute(
        select(Website, User)
        .join(User, Website.user_id == User.id)
        .where(Website.is_active == True)
        .where(Website.is_public == True)
        .where(Website.html.isnot(None))
        .where(Website.html != "")
        .order_by(Website.updated_at.desc())
        .limit(limit)
    )
    projects_data = result.all()
    
    recent_projects = []
    for website, user in projects_data:
        recent_projects.append({
            "id": website.id,
            "name": website.name or f"{user.username}'s Website",
            "slug": website.slug,
            "html": website.html[:500] + "..." if len(website.html) > 500 else website.html,  # Truncated for preview
            "css": website.css[:200] + "..." if len(website.css) > 200 else website.css,  # Truncated for preview  
            "updated_at": website.updated_at.isoformat(),
            "user": {
                "id": user.id,
                "username": user.username,
                "display_name": user.display_name
            },
            "is_deployed": website.is_deployed,
            "subdomain": website.get_subdomain() if website.is_deployed else None
        })
    
    return recent_projects


# Deployment endpoints

@router.post("/websites/{website_id}/deploy")
async def deploy_website_endpoint(
    website_id: int,
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """Deploy website to make it publicly accessible"""
    current_user = get_current_user_from_state(request)
    
    # Check if user owns the website
    result = await db.execute(
        select(Website)
        .where(Website.id == website_id)
        .where(Website.user_id == current_user.id)
    )
    website = result.scalar_one_or_none()
    
    if not website:
        raise HTTPException(status_code=404, detail="Website nicht gefunden")
    
    if website.is_deployed:
        raise HTTPException(status_code=400, detail="Website ist bereits deployed")
    
    # Deploy the website
    success = await deploy_website(website_id)
    
    if not success:
        raise HTTPException(status_code=500, detail="Deployment fehlgeschlagen")
    
    # Refresh website to get updated data
    await db.refresh(website)
    
    return {
        "message": "Website erfolgreich deployed",
        "subdomain": website.get_subdomain(),
        "url": f"https://{website.get_subdomain()}.{request.headers.get('host', 'localhost').split('.')[-2:][-1] if '.' in request.headers.get('host', '') else 'localhost'}",
        "deployed_at": website.deployed_at.isoformat()
    }


@router.post("/websites/{website_id}/undeploy")
async def undeploy_website_endpoint(
    website_id: int,
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """Remove website from public access"""
    current_user = get_current_user_from_state(request)
    
    # Check if user owns the website
    result = await db.execute(
        select(Website)
        .where(Website.id == website_id)
        .where(Website.user_id == current_user.id)
    )
    website = result.scalar_one_or_none()
    
    if not website:
        raise HTTPException(status_code=404, detail="Website nicht gefunden")
    
    if not website.is_deployed:
        raise HTTPException(status_code=400, detail="Website ist nicht deployed")
    
    # Undeploy the website
    success = await undeploy_website(website_id)
    
    if not success:
        raise HTTPException(status_code=500, detail="Undeployment fehlgeschlagen")
    
    return {
        "message": "Website erfolgreich von der öffentlichen Verfügbarkeit entfernt"
    }


@router.get("/websites/{website_id}/deployment-status")
async def get_deployment_status(
    website_id: int,
    request: Request,
    db: AsyncSession = Depends(get_db)
):
    """Get deployment status of a website"""
    current_user = get_current_user_from_state(request)
    
    # Check if user owns the website
    result = await db.execute(
        select(Website)
        .where(Website.id == website_id)
        .where(Website.user_id == current_user.id)
    )
    website = result.scalar_one_or_none()
    
    if not website:
        raise HTTPException(status_code=404, detail="Website nicht gefunden")
    
    response = {
        "is_deployed": website.is_deployed,
        "deployed_at": website.deployed_at.isoformat() if website.deployed_at else None,
    }
    
    if website.is_deployed:
        host_parts = request.headers.get('host', 'localhost').split('.')
        domain = '.'.join(host_parts[-2:]) if len(host_parts) >= 2 else 'localhost'
        response.update({
            "subdomain": website.get_subdomain(),
            "url": f"https://{website.get_subdomain()}.{domain}",
            "custom_domain": website.custom_domain
        })
    
    return response