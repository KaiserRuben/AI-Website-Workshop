import os
import re
from pathlib import Path
from typing import Optional
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from app.database import async_session_maker
from app.models.website import Website
from app.models.user import User
import structlog

logger = structlog.get_logger()

PUBLISHED_SITES_DIR = Path("/var/www/published-sites")


async def get_published_site(subdomain: str) -> Optional[str]:
    """Get published site content by subdomain"""
    try:
        async with async_session_maker() as session:
            # Query for website by subdomain logic
            if "." in subdomain:
                # Format: projectname.username
                project_part, username = subdomain.rsplit(".", 1)
                result = await session.execute(
                    select(Website, User)
                    .join(User)
                    .where(
                        Website.is_deployed == True,
                        User.username.ilike(username),
                        Website.name != "Meine Website"
                    )
                )
                website, user = result.first() or (None, None)
                
                # Verify project name matches
                if website and website.get_subdomain() == subdomain:
                    return _build_html_response(website)
            else:
                # Format: username (default project)
                result = await session.execute(
                    select(Website, User)
                    .join(User)
                    .where(
                        Website.is_deployed == True,
                        User.username.ilike(subdomain),
                        Website.name == "Meine Website"
                    )
                )
                website, user = result.first() or (None, None)
                if website:
                    return _build_html_response(website)
                    
    except Exception as e:
        logger.error("Error fetching published site", subdomain=subdomain, error=str(e))
    
    return None


def _build_html_response(website: Website) -> str:
    """Build complete HTML response with CSS and JS embedded"""
    html = website.html or ""
    css = website.css or ""
    js = website.js or ""
    
    # If HTML doesn't contain CSS/JS, inject them
    if css and "<style>" not in html:
        css_tag = f"<style>\n{css}\n</style>"
        if "</head>" in html:
            html = html.replace("</head>", f"{css_tag}\n</head>")
        else:
            html = f"{css_tag}\n{html}"
    
    if js and "<script>" not in html and "script>" not in html.lower():
        js_tag = f"<script>\n{js}\n</script>"
        if "</body>" in html:
            html = html.replace("</body>", f"{js_tag}\n</body>")
        else:
            html = f"{html}\n{js_tag}"
    
    return html


async def deploy_website(website_id: int) -> bool:
    """Deploy a website to make it publicly accessible"""
    try:
        async with async_session_maker() as session:
            result = await session.execute(
                select(Website, User)
                .join(User)
                .where(Website.id == website_id)
            )
            website, user = result.first() or (None, None)
            
            if not website or not user:
                logger.error("Website or user not found", website_id=website_id)
                return False
            
            # Mark as deployed
            website.is_deployed = True
            from sqlalchemy.sql import func
            website.deployed_at = func.now()
            
            await session.commit()
            
            subdomain = website.get_subdomain()
            logger.info("Website deployed successfully", 
                       website_id=website_id, 
                       subdomain=subdomain,
                       user=user.username)
            
            return True
            
    except Exception as e:
        logger.error("Error deploying website", website_id=website_id, error=str(e))
        return False


async def undeploy_website(website_id: int) -> bool:
    """Remove website from public access"""
    try:
        async with async_session_maker() as session:
            result = await session.execute(
                select(Website).where(Website.id == website_id)
            )
            website = result.scalar_one_or_none()
            
            if not website:
                return False
            
            website.is_deployed = False
            website.deployed_at = None
            
            await session.commit()
            
            logger.info("Website undeployed successfully", website_id=website_id)
            return True
            
    except Exception as e:
        logger.error("Error undeploying website", website_id=website_id, error=str(e))
        return False