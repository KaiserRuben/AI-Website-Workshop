"""
Unified project/website creation service
"""
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from typing import Optional
import re

from app.models.website import Website
from app.models.user import User
from app.services.template_service import TemplateService


class ProjectCreationService:
    """Handles all project/website creation with consistent logic"""
    
    @staticmethod
    def generate_slug(name: str) -> str:
        """Generate a URL-safe slug from project name"""
        if not name:
            return "project"
        
        # Convert to lowercase and replace spaces/underscores with hyphens
        slug = name.lower().replace(" ", "-").replace("_", "-")
        
        # Remove special characters, keep only alphanumeric and hyphens
        slug = re.sub(r'[^a-z0-9-]', '', slug)
        
        # Remove consecutive hyphens and trim
        slug = re.sub(r'-+', '-', slug).strip('-')
        
        # Default fallback
        return slug or "project"
    
    @staticmethod
    async def create_project(
        db: AsyncSession,
        user: User,
        name: Optional[str] = None,
        html: Optional[str] = None,
        css: Optional[str] = None,
        js: Optional[str] = None,
        is_public: Optional[bool] = None,
        is_default_project: bool = False
    ) -> Website:
        """
        Create a new project/website with unified logic
        
        Args:
            db: Database session
            user: User creating the project
            name: Project name (defaults to "{username}s Website")
            html: Initial HTML content
            css: Initial CSS content
            js: Initial JS content
            is_public: Explicit public setting (None = use smart defaults)
            is_default_project: Whether this is the auto-created default project
        """
        # Get user's existing projects to determine if this is their first
        result = await db.execute(
            select(Website).where(Website.user_id == user.id)
        )
        existing_projects = result.scalars().all()
        
        # Deactivate existing projects
        for project in existing_projects:
            project.is_active = False
        
        # Determine project name
        if not name:
            name = f"{user.username}s Website"
        
        # Determine publicity - first project (including default) should be public
        if is_public is None:
            is_first_project = len(existing_projects) == 0
            is_public = is_first_project
        
        # Set default content using template service
        if is_default_project and not html and not css:
            template_content = await TemplateService.get_default_template(db)
            html = html or template_content["html"]
            css = css or template_content["css"]
            js = js or template_content["js"]
        
        # Generate slug from name
        slug = ProjectCreationService.generate_slug(name)
        
        # Create the project
        website = Website(
            user_id=user.id,
            name=name,
            slug=slug,
            html=html or "",
            css=css or "",
            js=js or "",
            is_public=is_public,
            is_collaborative=False,
            allow_comments=True,
            allow_forks=True,
            is_active=True
        )
        
        db.add(website)
        await db.commit()
        await db.refresh(website)
        
        return website