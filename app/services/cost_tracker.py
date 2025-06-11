import logging
from datetime import datetime, timedelta
from typing import Dict, Optional
from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession
from app.models import LLMCall, User
from app.config import get_settings

logger = logging.getLogger(__name__)
settings = get_settings()


class CostTracker:
    """Track and manage API costs per user"""
    
    def __init__(self, db: AsyncSession):
        self.db = db
    
    async def can_make_api_call(self, user_id: int) -> tuple[bool, str]:
        """
        Check if user can make an API call based on cost and rate limits
        
        Returns:
            Tuple of (allowed, reason_if_not)
        """
        # Check cost limit
        total_cost = await self.get_user_total_cost(user_id)
        if total_cost >= settings.max_cost_per_user:
            return False, f"Kostenlimit erreicht (€{settings.max_cost_per_user:.2f})"
        
        # Check rate limit
        recent_calls = await self.get_recent_api_calls(user_id, minutes=1)
        if recent_calls >= settings.max_api_calls_per_minute:
            return False, f"Zu viele Anfragen (max. {settings.max_api_calls_per_minute}/Minute)"
        
        return True, ""
    
    async def get_user_total_cost(self, user_id: int) -> float:
        """Get total cost for a user"""
        result = await self.db.execute(
            select(func.sum(LLMCall.cost))
            .where(LLMCall.user_id == user_id)
        )
        total = result.scalar()
        return float(total) if total else 0.0
    
    async def get_recent_api_calls(self, user_id: int, minutes: int = 1) -> int:
        """Count API calls in the last N minutes"""
        since = datetime.utcnow() - timedelta(minutes=minutes)
        result = await self.db.execute(
            select(func.count(LLMCall.id))
            .where(LLMCall.user_id == user_id)
            .where(LLMCall.created_at >= since)
        )
        return result.scalar() or 0
    
    async def record_api_call(
        self,
        user_id: int,
        website_id: int,
        prompt: str,
        response_type: str,
        response_data: Dict,
        prompt_tokens: int,
        completion_tokens: int,
        cost: float,
        duration_ms: int,
        error_message: Optional[str] = None
    ) -> LLMCall:
        """Record an API call in the database"""
        logger.info(f"Creating LLMCall with response_type: {response_type} (type: {type(response_type)})")
        
        llm_call = LLMCall(
            user_id=user_id,
            website_id=website_id,
            prompt=prompt,
            response_type=response_type,
            response_data=response_data,
            prompt_tokens=prompt_tokens,
            completion_tokens=completion_tokens,
            total_tokens=prompt_tokens + completion_tokens,
            cost=cost,
            duration_ms=duration_ms,
            error_message=error_message
        )
        
        self.db.add(llm_call)
        await self.db.commit()
        
        logger.info(f"Recorded API call for user {user_id}: "
                   f"cost=€{cost:.4f}, tokens={prompt_tokens + completion_tokens}")
        
        return llm_call
    
    async def get_user_stats(self, user_id: int) -> Dict:
        """Get usage statistics for a user"""
        # Total cost
        total_cost = await self.get_user_total_cost(user_id)
        
        # Total calls
        result = await self.db.execute(
            select(func.count(LLMCall.id))
            .where(LLMCall.user_id == user_id)
        )
        total_calls = result.scalar() or 0
        
        # Total tokens
        result = await self.db.execute(
            select(func.sum(LLMCall.total_tokens))
            .where(LLMCall.user_id == user_id)
        )
        total_tokens = result.scalar() or 0
        
        # Recent activity
        recent_calls = await self.get_recent_api_calls(user_id, minutes=5)
        
        return {
            "total_cost": total_cost,
            "total_calls": total_calls,
            "total_tokens": total_tokens,
            "recent_calls_5min": recent_calls,
            "cost_limit": settings.max_cost_per_user,
            "cost_percentage": (total_cost / settings.max_cost_per_user * 100) if settings.max_cost_per_user > 0 else 0
        }