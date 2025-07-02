from sqlalchemy import Column, String, Integer, LargeBinary, DateTime, ForeignKey, Boolean
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.database import Base


class UserImage(Base):
    __tablename__ = "user_images"
    
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    website_id = Column(Integer, ForeignKey("websites.id", ondelete="CASCADE"), nullable=True)
    
    # Image metadata
    original_name = Column(String(255), nullable=False)
    mime_type = Column(String(50), nullable=False)
    file_size = Column(Integer, nullable=False)
    width = Column(Integer)
    height = Column(Integer)
    alt_text = Column(String)
    
    # Binary data storage
    image_data = Column(LargeBinary, nullable=False)
    thumbnail_data = Column(LargeBinary)
    
    # Timestamps
    uploaded_at = Column(DateTime, server_default=func.now())
    last_used_at = Column(DateTime)
    
    # Relationships
    user = relationship("User", back_populates="images")
    website = relationship("Website", back_populates="images")
    
    def to_dict(self):
        """Convert to dictionary for JSON responses (excluding binary data)"""
        return {
            "id": self.id,
            "user_id": self.user_id,
            "website_id": self.website_id,
            "original_name": self.original_name,
            "mime_type": self.mime_type,
            "file_size": self.file_size,
            "width": self.width,
            "height": self.height,
            "alt_text": self.alt_text,
            "uploaded_at": self.uploaded_at.isoformat() if self.uploaded_at else None,
            "last_used_at": self.last_used_at.isoformat() if self.last_used_at else None,
        }
    
    def get_data_url(self) -> str:
        """Generate data URL for embedding in HTML"""
        import base64
        if self.image_data:
            b64_data = base64.b64encode(self.image_data).decode('utf-8')
            return f"data:{self.mime_type};base64,{b64_data}"
        return None
    
    def get_thumbnail_data_url(self) -> str:
        """Generate data URL for thumbnails"""
        import base64
        if self.thumbnail_data:
            b64_data = base64.b64encode(self.thumbnail_data).decode('utf-8')
            return f"data:image/jpeg;base64,{b64_data}"
        return self.get_data_url()  # Fallback to full image