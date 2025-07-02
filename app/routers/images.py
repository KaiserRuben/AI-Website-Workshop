from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form, Response
from fastapi.security import HTTPBearer
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, update, delete, func
from typing import List, Optional
import io
import base64
import logging

# Image processing
from PIL import Image, ImageOps
import pillow_heif

# App imports
from app.database import get_db
from app.models import User, UserImage, Website
from app.middleware.auth import get_current_user_from_state
from app.routers.websocket import manager as websocket_manager
from app.services.image_validator import ImageSecurityValidator, ImageSecurityError
from app.services.rate_limiter import image_rate_limiter

router = APIRouter(prefix="/api/images", tags=["images"])
security = HTTPBearer()
logger = logging.getLogger(__name__)

# Configuration
ALLOWED_MIME_TYPES = {
    'image/jpeg',
    'image/jpg', 
    'image/png',
    'image/webp',
    'image/heic',
    'image/heif'
}
MAX_FILE_SIZE = 10 * 1024 * 1024  # 10MB
MAX_IMAGES_PER_USER = 50
THUMBNAIL_SIZE = (200, 200)

# Enable HEIC support
pillow_heif.register_heif_opener()


@router.post("/upload")
async def upload_image(
    file: UploadFile = File(...),
    website_id: int = Form(...),
    alt_text: Optional[str] = Form(None),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user_from_state)
):
    """Upload an image and store it in the database"""
    
    # Check rate limits
    rate_allowed, rate_message = image_rate_limiter.check_rate_limit(
        current_user.id, 
        window_seconds=300,  # 5 minutes
        max_uploads=5  # 5 uploads per 5 minutes
    )
    if not rate_allowed:
        raise HTTPException(status_code=429, detail=rate_message)
    
    # Validate file type
    if file.content_type not in ALLOWED_MIME_TYPES:
        raise HTTPException(
            status_code=400, 
            detail=f"Unsupported file type. Allowed types: {', '.join(ALLOWED_MIME_TYPES)}"
        )
    
    # Validate file size
    if file.size > MAX_FILE_SIZE:
        raise HTTPException(
            status_code=400,
            detail=f"File too large. Maximum size: {MAX_FILE_SIZE // (1024*1024)}MB"
        )
    
    # Check user's image limit
    existing_count = await db.scalar(
        select(func.count(UserImage.id)).where(UserImage.user_id == current_user.id)
    )
    if existing_count >= MAX_IMAGES_PER_USER:
        raise HTTPException(
            status_code=400,
            detail=f"Image limit reached. Maximum {MAX_IMAGES_PER_USER} images per user."
        )
    
    # Verify website exists and user has access
    website = await db.scalar(
        select(Website).where(Website.id == website_id, Website.user_id == current_user.id)
    )
    if not website:
        raise HTTPException(status_code=404, detail="Website not found or access denied")
    
    try:
        # Read image data
        image_data = await file.read()
        
        # Comprehensive security validation
        is_valid, error_msg, image_info = ImageSecurityValidator.validate_image_comprehensive(
            image_data, file.content_type, file.filename
        )
        
        if not is_valid:
            raise ImageSecurityError(error_msg)
        
        # Check for duplicate images
        existing_image = await db.scalar(
            select(UserImage).where(
                UserImage.user_id == current_user.id,
                UserImage.file_size == len(image_data)
            )
        )
        
        if existing_image and existing_image.image_data == image_data:
            raise HTTPException(
                status_code=400,
                detail="Dieses Bild wurde bereits hochgeladen"
            )
        
        # Process image with PIL
        image = Image.open(io.BytesIO(image_data))
        
        # Convert HEIC/HEIF to JPEG for storage
        if file.content_type in ['image/heic', 'image/heif']:
            image = image.convert('RGB')
            output_buffer = io.BytesIO()
            image.save(output_buffer, format='JPEG', quality=90)
            image_data = output_buffer.getvalue()
            mime_type = 'image/jpeg'
        else:
            mime_type = file.content_type
        
        # Fix orientation based on EXIF data and strip EXIF for privacy
        image = ImageOps.exif_transpose(image)
        
        # Remove EXIF data for privacy and security
        if image.mode in ('RGBA', 'LA'):
            # Convert to RGB for JPEG
            background = Image.new('RGB', image.size, (255, 255, 255))
            if image.mode == 'RGBA':
                background.paste(image, mask=image.split()[-1])  # Use alpha channel as mask
            else:
                background.paste(image)
            image = background
        
        # Re-save to remove metadata
        clean_buffer = io.BytesIO()
        image.save(clean_buffer, format='JPEG', quality=90, optimize=True)
        image_data = clean_buffer.getvalue()
        
        # Generate thumbnail
        thumbnail = image.copy()
        thumbnail.thumbnail(THUMBNAIL_SIZE, Image.Resampling.LANCZOS)
        thumbnail_buffer = io.BytesIO()
        thumbnail.save(thumbnail_buffer, format='JPEG', quality=85, optimize=True)
        thumbnail_data = thumbnail_buffer.getvalue()
        
        # Generate alt text if not provided
        if not alt_text:
            alt_text = f"User uploaded image: {image_info['safe_filename']}"
        
        # Create database record
        db_image = UserImage(
            # id will be auto-generated by database
            user_id=current_user.id,
            website_id=website_id,
            original_name=image_info['safe_filename'],
            mime_type=mime_type,
            file_size=len(image_data),
            width=image.width,
            height=image.height,
            alt_text=alt_text,
            image_data=image_data,
            thumbnail_data=thumbnail_data
        )
        
        db.add(db_image)
        await db.commit()
        await db.refresh(db_image)
        
        # Update user image count
        await db.execute(
            update(User)
            .where(User.id == current_user.id)
            .values(image_count=User.image_count + 1)
        )
        
        # Update project has_images flag
        await db.execute(
            update(Website)
            .where(Website.id == website_id)
            .values(has_images=True)
        )
        
        await db.commit()
        
        # Notify via WebSocket
        await websocket_manager.broadcast_to_user(current_user.id, {
            "type": "image_uploaded",
            "image": db_image.to_dict(),
            "thumbnail_url": db_image.get_thumbnail_data_url()
        })
        
        return {
            "success": True,
            "image": db_image.to_dict(),
            "message": "Image uploaded successfully"
        }
        
    except ImageSecurityError as e:
        await db.rollback()
        raise HTTPException(status_code=400, detail=f"Sicherheitsproblem: {str(e)}")
    except HTTPException:
        await db.rollback()
        raise  # Re-raise HTTP exceptions as-is
    except Exception as e:
        await db.rollback()
        logger.error(f"Unexpected error processing image: {e}")
        raise HTTPException(status_code=500, detail="Fehler beim Verarbeiten des Bildes")


@router.get("/")
async def list_user_images(
    website_id: Optional[int] = None,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user_from_state)
):
    """List user's images, optionally filtered by website"""
    
    query = select(UserImage).where(UserImage.user_id == current_user.id)
    
    if website_id:
        query = query.where(UserImage.website_id == website_id)
    
    query = query.order_by(UserImage.uploaded_at.desc())
    
    result = await db.execute(query)
    images = result.scalars().all()
    
    return {
        "images": [
            {
                **image.to_dict(),
                "thumbnail_url": image.get_thumbnail_data_url()
            }
            for image in images
        ]
    }


@router.get("/{image_id}")
async def get_image_details(
    image_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user_from_state)
):
    """Get image details and metadata"""
    
    image = await db.scalar(
        select(UserImage).where(
            UserImage.id == image_id,
            UserImage.user_id == current_user.id
        )
    )
    
    if not image:
        raise HTTPException(status_code=404, detail="Image not found")
    
    return {
        **image.to_dict(),
        "data_url": image.get_data_url(),
        "thumbnail_url": image.get_thumbnail_data_url()
    }


@router.get("/{image_id}/data")
async def serve_image_data(
    image_id: int,
    thumbnail: bool = False,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user_from_state)
):
    """Serve raw image data with proper headers (authenticated)"""
    
    image = await db.scalar(
        select(UserImage).where(
            UserImage.id == image_id,
            UserImage.user_id == current_user.id
        )
    )
    
    if not image:
        raise HTTPException(status_code=404, detail="Image not found")
    
    # Update last_used_at
    await db.execute(
        update(UserImage)
        .where(UserImage.id == image_id)
        .values(last_used_at=func.now())
    )
    await db.commit()
    
    # Return thumbnail or full image
    if thumbnail and image.thumbnail_data:
        return Response(
            content=image.thumbnail_data,
            media_type="image/jpeg",
            headers={
                "Cache-Control": "public, max-age=3600",
                "Content-Disposition": f"inline; filename=thumb_{image.original_name}"
            }
        )
    else:
        return Response(
            content=image.image_data,
            media_type=image.mime_type,
            headers={
                "Cache-Control": "public, max-age=3600",
                "Content-Disposition": f"inline; filename={image.original_name}"
            }
        )


@router.get("/public/{image_id}/data")
async def serve_public_image_data(
    image_id: int,
    thumbnail: bool = False,
    db: AsyncSession = Depends(get_db)
):
    """Serve raw image data publicly (for gallery and template use)"""
    
    image = await db.scalar(
        select(UserImage).where(UserImage.id == image_id)
    )
    
    if not image:
        raise HTTPException(status_code=404, detail="Image not found")
    
    # Update last_used_at
    await db.execute(
        update(UserImage)
        .where(UserImage.id == image_id)
        .values(last_used_at=func.now())
    )
    await db.commit()
    
    # Return thumbnail or full image
    if thumbnail and image.thumbnail_data:
        return Response(
            content=image.thumbnail_data,
            media_type="image/jpeg",
            headers={
                "Cache-Control": "public, max-age=3600",
                "Content-Disposition": f"inline; filename=thumb_{image.original_name}",
                "Access-Control-Allow-Origin": "*"
            }
        )
    else:
        return Response(
            content=image.image_data,
            media_type=image.mime_type,
            headers={
                "Cache-Control": "public, max-age=3600",
                "Content-Disposition": f"inline; filename={image.original_name}",
                "Access-Control-Allow-Origin": "*"
            }
        )


@router.put("/{image_id}")
async def update_image_metadata(
    image_id: int,
    alt_text: Optional[str] = None,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user_from_state)
):
    """Update image metadata (alt text, etc.)"""
    
    image = await db.scalar(
        select(UserImage).where(
            UserImage.id == image_id,
            UserImage.user_id == current_user.id
        )
    )
    
    if not image:
        raise HTTPException(status_code=404, detail="Image not found")
    
    # Update fields
    if alt_text is not None:
        image.alt_text = alt_text
    
    await db.commit()
    
    return {
        "success": True,
        "image": image.to_dict(),
        "message": "Image updated successfully"
    }


@router.delete("/{image_id}")
async def delete_image(
    image_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user_from_state)
):
    """Delete an image"""
    
    image = await db.scalar(
        select(UserImage).where(
            UserImage.id == image_id,
            UserImage.user_id == current_user.id
        )
    )
    
    if not image:
        raise HTTPException(status_code=404, detail="Image not found")
    
    website_id = image.website_id
    
    # Delete the image
    await db.execute(delete(UserImage).where(UserImage.id == image_id))
    
    # Update user image count
    await db.execute(
        update(User)
        .where(User.id == current_user.id)
        .values(image_count=User.image_count - 1)
    )
    
    # Check if project still has images
    if website_id:
        remaining_images = await db.scalar(
            select(func.count(UserImage.id)).where(UserImage.website_id == website_id)
        )
        if remaining_images == 0:
            await db.execute(
                update(Website)
                .where(Website.id == website_id)
                .values(has_images=False)
            )
    
    await db.commit()
    
    # Notify via WebSocket
    await websocket_manager.broadcast_to_user(current_user.id, {
        "type": "image_deleted",
        "image_id": str(image_id)
    })
    
    return {
        "success": True,
        "message": "Image deleted successfully"
    }


@router.get("/{image_id}/usage")
async def get_image_usage_stats(
    image_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user_from_state)
):
    """Get usage statistics for an image"""
    
    image = await db.scalar(
        select(UserImage).where(
            UserImage.id == image_id,
            UserImage.user_id == current_user.id
        )
    )
    
    if not image:
        raise HTTPException(status_code=404, detail="Image not found")
    
    return {
        "image_id": str(image_id),
        "uploaded_at": image.uploaded_at.isoformat() if image.uploaded_at else None,
        "last_used_at": image.last_used_at.isoformat() if image.last_used_at else None,
        "file_size": image.file_size,
        "dimensions": f"{image.width}x{image.height}" if image.width and image.height else None
    }


@router.get("/stats")
async def get_upload_stats(
    current_user: User = Depends(get_current_user_from_state)
):
    """Get user's upload statistics and rate limit status"""
    
    rate_stats = image_rate_limiter.get_user_stats(current_user.id)
    
    # Check current rate limit status
    rate_allowed, rate_message = image_rate_limiter.check_rate_limit(
        current_user.id, 
        window_seconds=300,  # 5 minutes
        max_uploads=5,  # 5 uploads per 5 minutes
        
    )
    
    # Don't actually record this check
    if not rate_allowed:
        # Remove the check we just added
        uploads = image_rate_limiter.user_uploads[current_user.id]
        if uploads:
            uploads.pop()
    
    return {
        "rate_limit_status": {
            "allowed": rate_allowed,
            "message": rate_message if not rate_allowed else "OK",
            "remaining_uploads": max(0, 5 - rate_stats["last_5_minutes"])
        },
        "upload_stats": rate_stats,
        "limits": {
            "max_uploads_per_5_minutes": 5,
            "max_images_total": MAX_IMAGES_PER_USER,
            "max_file_size_mb": MAX_FILE_SIZE // (1024 * 1024)
        }
    }