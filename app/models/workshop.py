from sqlalchemy import Column, Integer, String, Date, Boolean, ForeignKey, JSON, DECIMAL, DateTime
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from app.database import Base


class Workshop(Base):
    __tablename__ = "workshops"
    
    id = Column(Integer, primary_key=True)
    name = Column(String(255), nullable=False)
    date = Column(Date, nullable=False)
    password_hash = Column(String(255))
    max_cost_per_user = Column(DECIMAL(10, 2), default=1.00)
    is_active = Column(Boolean, default=False)
    admin_user_id = Column(Integer, ForeignKey("users.id"))
    settings = Column(JSON, default={})
    created_at = Column(DateTime, server_default=func.now())
    
    # Relationships
    users = relationship("User", back_populates="workshop", foreign_keys="User.workshop_id")
    admin_user = relationship("User", foreign_keys=[admin_user_id], post_update=True)