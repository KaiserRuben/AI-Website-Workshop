from sqlalchemy import Column, Integer, String, ForeignKey, DateTime, UniqueConstraint, CheckConstraint, Enum
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from app.database import Base
from passlib.context import CryptContext
import enum

# Password hashing
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


class UserRole(str, enum.Enum):
    ADMIN = "admin"
    PARTICIPANT = "participant"


class User(Base):
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True)
    workshop_id = Column(Integer, ForeignKey("workshops.id"))
    username = Column(String(100), nullable=False)
    display_name = Column(String(100))
    password_hash = Column(String(255), nullable=False)
    session_token = Column(String(255), unique=True, server_default=func.gen_random_uuid())
    role = Column(Enum(UserRole), default=UserRole.PARTICIPANT)
    joined_at = Column(DateTime, server_default=func.now())
    last_seen = Column(DateTime, server_default=func.now())
    
    def set_password(self, password: str):
        """Hash and set password"""
        self.password_hash = pwd_context.hash(password)
    
    def verify_password(self, password: str) -> bool:
        """Verify password against hash"""
        return pwd_context.verify(password, self.password_hash)
    
    # Relationships
    workshop = relationship("Workshop", back_populates="users", foreign_keys=[workshop_id])
    websites = relationship("Website", back_populates="user", cascade="all, delete-orphan")
    llm_calls = relationship("LLMCall", back_populates="user", cascade="all, delete-orphan")
    chat_messages = relationship("ChatMessage", back_populates="user", cascade="all, delete-orphan")
    liked_websites = relationship("WebsiteLike", back_populates="user", cascade="all, delete-orphan")
    
    __table_args__ = (
        UniqueConstraint("workshop_id", "username"),
        CheckConstraint("role IN ('admin', 'participant')", name='users_role_check'),
    )