from typing import List, Dict, Any, Optional
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from app.models import UserImage, User
import logging

logger = logging.getLogger(__name__)


class ImageService:
    """Service for handling image-related operations"""
    
    @staticmethod
    async def get_user_images_for_ai_context(
        user_id: int, 
        website_id: Optional[int] = None,
        db: AsyncSession = None
    ) -> List[Dict[str, Any]]:
        """Get user's images formatted for AI context"""
        try:
            query = select(UserImage).where(UserImage.user_id == user_id)
            
            # If website_id is specified, filter by website
            if website_id:
                query = query.where(UserImage.website_id == website_id)
            
            # Order by most recent first
            query = query.order_by(UserImage.uploaded_at.desc())
            
            result = await db.execute(query)
            images = result.scalars().all()
            
            # Format for AI context
            ai_images = []
            for image in images:
                ai_images.append({
                    "id": str(image.id),
                    "original_name": image.original_name,
                    "width": image.width,
                    "height": image.height,
                    "alt_text": image.alt_text,
                    "mime_type": image.mime_type,
                    "file_size": image.file_size,
                    "uploaded_at": image.uploaded_at.isoformat() if image.uploaded_at else None
                })
            
            logger.info(f"Retrieved {len(ai_images)} images for AI context for user {user_id}")
            return ai_images
            
        except Exception as e:
            logger.error(f"Error retrieving images for AI context: {e}")
            return []
    
    @staticmethod
    async def get_recent_images_for_user(
        user_id: int,
        limit: int = 10,
        db: AsyncSession = None
    ) -> List[Dict[str, Any]]:
        """Get user's most recent images"""
        try:
            query = (
                select(UserImage)
                .where(UserImage.user_id == user_id)
                .order_by(UserImage.uploaded_at.desc())
                .limit(limit)
            )
            
            result = await db.execute(query)
            images = result.scalars().all()
            
            return [image.to_dict() for image in images]
            
        except Exception as e:
            logger.error(f"Error retrieving recent images: {e}")
            return []
    
    @staticmethod
    async def get_website_images(
        website_id: int,
        user_id: int,
        db: AsyncSession = None
    ) -> List[Dict[str, Any]]:
        """Get all images for a specific website"""
        try:
            query = (
                select(UserImage)
                .where(
                    UserImage.website_id == website_id,
                    UserImage.user_id == user_id
                )
                .order_by(UserImage.uploaded_at.desc())
            )
            
            result = await db.execute(query)
            images = result.scalars().all()
            
            return [image.to_dict() for image in images]
            
        except Exception as e:
            logger.error(f"Error retrieving project images: {e}")
            return []