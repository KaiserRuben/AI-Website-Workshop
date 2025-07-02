from sqlalchemy import Column, Integer, String, Text, DECIMAL, Boolean, ForeignKey, JSON, Enum, DateTime, CheckConstraint
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from app.database import Base
import enum


class ResponseType(str, enum.Enum):
    CHAT = "chat"
    UPDATE = "update"
    UPDATE_ALL = "update_all"
    REWRITE = "rewrite"


class MessageRole(str, enum.Enum):
    USER = "user"
    ASSISTANT = "assistant"
    SYSTEM = "system"


class LLMCall(Base):
    __tablename__ = "llm_calls"
    
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"))
    website_id = Column(Integer, ForeignKey("websites.id", ondelete="CASCADE"))
    prompt = Column(Text, nullable=False)
    response_type = Column(Enum(ResponseType))
    response_data = Column(JSON, nullable=False)
    model = Column(String(50), default="gpt-4.1-mini")
    prompt_tokens = Column(Integer, nullable=False)
    completion_tokens = Column(Integer, nullable=False)
    total_tokens = Column(Integer, nullable=False)
    cost = Column(DECIMAL(10, 6), nullable=False)
    error_message = Column(Text)
    is_error_fix = Column(Boolean, default=False)
    parent_call_id = Column(Integer, ForeignKey("llm_calls.id"))
    duration_ms = Column(Integer)
    created_at = Column(DateTime, server_default=func.now())
    
    # Relationships
    user = relationship("User", back_populates="llm_calls")
    website = relationship("Website", back_populates="llm_calls")
    parent_call = relationship("LLMCall", remote_side=[id])
    
    __table_args__ = (
        CheckConstraint("response_type IN ('chat', 'update', 'update_all', 'rewrite')", name='llm_calls_response_type_check'),
    )


class ChatMessage(Base):
    __tablename__ = "chat_messages"
    
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"))
    website_id = Column(Integer, ForeignKey("websites.id", ondelete="CASCADE"))
    role = Column(Enum(MessageRole), nullable=False)
    content = Column(Text, nullable=False)
    created_at = Column(DateTime, server_default=func.now())
    
    # Relationships
    user = relationship("User", back_populates="chat_messages")
    website = relationship("Website", back_populates="chat_messages")