from sqlalchemy import Column, Integer, String, Text, Boolean, ForeignKey, Enum, DateTime
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
    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())
    
    # Relationships
    user = relationship("User", back_populates="websites")
    code_history = relationship("CodeHistory", back_populates="website", cascade="all, delete-orphan")
    llm_calls = relationship("LLMCall", back_populates="website", cascade="all, delete-orphan")
    chat_messages = relationship("ChatMessage", back_populates="website", cascade="all, delete-orphan")
    likes = relationship("WebsiteLike", back_populates="website", cascade="all, delete-orphan")


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