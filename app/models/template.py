from sqlalchemy import Column, Integer, String, Text, Boolean, DateTime, JSON
from sqlalchemy.sql import func
from app.database import Base


class Template(Base):
    __tablename__ = "templates"
    
    id = Column(Integer, primary_key=True)
    name = Column(String(255), nullable=False)
    description = Column(Text)
    html = Column(Text, nullable=False)
    css = Column(Text, nullable=False)
    js = Column(Text)
    category = Column(String(50))
    is_active = Column(Boolean, default=True)
    order_index = Column(Integer, default=0)
    template_metadata = Column(JSON)
    created_at = Column(DateTime, server_default=func.now())