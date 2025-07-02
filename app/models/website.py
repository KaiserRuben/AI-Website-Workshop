from sqlalchemy import Column, Integer, String, Text, Boolean, ForeignKey, Enum, DateTime, ARRAY
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from app.database import Base
import enum


class ChangeType(str, enum.Enum):
    MANUAL = "manual"
    AI_UPDATE = "ai_update"
    AI_REWRITE = "ai_rewrite"
    ROLLBACK = "rollback"


class Website(Base):
    __tablename__ = "websites"
    
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"))
    name = Column(String(255), default="Meine Website")
    description = Column(Text)
    slug = Column(String(255))
    html = Column(Text, default='''<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Meine Website</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
</head>
<body class="bg-gray-50">
    <div class="container mx-auto px-4 py-8">
        <h1 class="text-4xl font-bold text-center text-gray-800 mb-4">Willkommen auf meiner Website!</h1>
        <p class="text-lg text-center text-gray-600">Hier kannst du deine eigene Website gestalten.</p>
    </div>
</body>
</html>''')
    css = Column(Text, default='/* Dein eigenes CSS hier */')
    js = Column(Text, default='// Dein JavaScript Code hier')
    is_active = Column(Boolean, default=True)
    is_public = Column(Boolean, default=False)
    is_collaborative = Column(Boolean, default=False)
    allow_comments = Column(Boolean, default=True)
    allow_forks = Column(Boolean, default=True)
    tags = Column(ARRAY(Text), default=list)
    parent_website_id = Column(Integer, ForeignKey("websites.id"))
    has_images = Column(Boolean, default=False)
    is_deployed = Column(Boolean, default=False)
    deployed_at = Column(DateTime)
    custom_domain = Column(String(255))  # optional premium feature
    views_count = Column(Integer, default=0)
    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())
    
    # Relationships
    user = relationship("User", back_populates="websites")
    code_history = relationship("CodeHistory", back_populates="website", cascade="all, delete-orphan")
    llm_calls = relationship("LLMCall", back_populates="website", cascade="all, delete-orphan")
    chat_messages = relationship("ChatMessage", back_populates="website", cascade="all, delete-orphan")
    likes = relationship("WebsiteLike", back_populates="website", cascade="all, delete-orphan")
    collaborators = relationship("WebsiteCollaborator", back_populates="website", cascade="all, delete-orphan")
    comments = relationship("WebsiteComment", back_populates="website", cascade="all, delete-orphan")
    shares = relationship("WebsiteShare", back_populates="website", cascade="all, delete-orphan")
    images = relationship("UserImage", back_populates="website", cascade="all, delete-orphan")
    
    # Fork relationships
    parent_website = relationship("Website", remote_side=[id], backref="forks")
    
    @property
    def likes_count(self) -> int:
        """Get the number of likes for this website"""
        return len(self.likes)
    
    @property 
    def html_content(self) -> str:
        """Get the HTML content for display (alias for html field)"""
        return self.html or ""
    
    @property
    def title(self) -> str:
        """Get the website title (alias for name field)"""
        return self.name or "Untitled Project"

    def get_subdomain(self) -> str:
        """Generate subdomain: projectname.user or just user for default project name"""
        if self.name == "Meine Website":
            return self.user.username.lower()
        else:
            # Sanitize project name for URL
            project_slug = self.name.lower().replace(" ", "-").replace("_", "-")
            # Remove special characters, keep only alphanumeric and hyphens
            import re
            project_slug = re.sub(r'[^a-z0-9-]', '', project_slug)
            return f"{project_slug}.{self.user.username.lower()}"


class CodeHistory(Base):
    __tablename__ = "code_history"
    
    id = Column(Integer, primary_key=True)
    website_id = Column(Integer, ForeignKey("websites.id", ondelete="CASCADE"))
    html = Column(Text, nullable=False)
    css = Column(Text, nullable=False)
    js = Column(Text, nullable=False)
    change_type = Column(Enum(ChangeType))
    llm_call_id = Column(Integer, ForeignKey("llm_calls.id"))
    created_at = Column(DateTime, server_default=func.now())
    
    # Relationships
    website = relationship("Website", back_populates="code_history")
    llm_call = relationship("LLMCall")


class WebsiteLike(Base):
    __tablename__ = "website_likes"
    
    id = Column(Integer, primary_key=True)
    website_id = Column(Integer, ForeignKey("websites.id", ondelete="CASCADE"))
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"))
    created_at = Column(DateTime, server_default=func.now())
    
    # Relationships
    website = relationship("Website", back_populates="likes")
    user = relationship("User", back_populates="liked_websites")


class WebsiteCollaborator(Base):
    __tablename__ = "website_collaborators"
    
    id = Column(Integer, primary_key=True)
    website_id = Column(Integer, ForeignKey("websites.id", ondelete="CASCADE"))
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"))
    can_edit = Column(Boolean, default=False)
    can_comment = Column(Boolean, default=True)
    invited_at = Column(DateTime, server_default=func.now())
    accepted_at = Column(DateTime)
    
    # Relationships
    website = relationship("Website", back_populates="collaborators")
    user = relationship("User", back_populates="website_collaborations")


class WebsiteComment(Base):
    __tablename__ = "website_comments"
    
    id = Column(Integer, primary_key=True)
    website_id = Column(Integer, ForeignKey("websites.id", ondelete="CASCADE"))
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"))
    parent_comment_id = Column(Integer, ForeignKey("website_comments.id", ondelete="CASCADE"))
    content = Column(Text, nullable=False)
    created_at = Column(DateTime, server_default=func.now())
    
    # Relationships
    website = relationship("Website", back_populates="comments")
    user = relationship("User", back_populates="website_comments")
    parent_comment = relationship("WebsiteComment", remote_side=[id])
    replies = relationship("WebsiteComment", back_populates="parent_comment", cascade="all, delete-orphan")


class WebsiteShare(Base):
    __tablename__ = "website_shares"
    
    id = Column(Integer, primary_key=True)
    website_id = Column(Integer, ForeignKey("websites.id", ondelete="CASCADE"))
    share_token = Column(String(255), unique=True, server_default=func.gen_random_uuid())
    created_by = Column(Integer, ForeignKey("users.id"))
    can_edit = Column(Boolean, default=False)
    expires_at = Column(DateTime)
    created_at = Column(DateTime, server_default=func.now())
    
    # Relationships
    website = relationship("Website", back_populates="shares")
    creator = relationship("User", foreign_keys=[created_by])