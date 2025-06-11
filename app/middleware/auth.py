from typing import Optional, Set
from fastapi import Request, HTTPException
from fastapi.responses import RedirectResponse
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.responses import Response
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.database import async_session_maker
from app.models import User


class AuthenticationMiddleware(BaseHTTPMiddleware):
    """Authentication middleware for protecting routes"""
    
    # Routes that don't require authentication
    EXCLUDED_PATHS: Set[str] = {
        "/",
        "/health",
        "/favicon.ico",
        "/api/signup",
        "/api/login",
        "/api/logout",
        "/api/check-username",
        "/api/join",
        "/api/workshop/session"
    }
    
    # Path prefixes that don't require authentication
    EXCLUDED_PREFIXES: Set[str] = {
        "/static/"
    }
    
    # Routes that require authentication but should redirect instead of returning 401
    REDIRECT_PATHS: Set[str] = {
        "/workshop",
        "/admin",
        "/gallery"
    }

    async def dispatch(self, request: Request, call_next):
        """Process request through authentication middleware"""
        
        # Skip authentication for excluded paths
        if self._should_skip_auth(request.url.path):
            return await call_next(request)
        
        # Get session token from cookies
        session_token = request.cookies.get("session_token")
        
        if not session_token:
            return self._handle_unauthenticated(request)
        
        # Validate session token and get user
        user = await self._get_user_from_token(session_token)
        
        if not user:
            return self._handle_invalid_session(request)
        
        # Add user to request state for use in route handlers
        request.state.user = user
        
        return await call_next(request)
    
    def _should_skip_auth(self, path: str) -> bool:
        """Check if path should skip authentication"""
        # Check exact paths
        if path in self.EXCLUDED_PATHS:
            return True
        
        # Check prefixes
        return any(
            path.startswith(prefix) 
            for prefix in self.EXCLUDED_PREFIXES
        )
    
    def _handle_unauthenticated(self, request: Request) -> Response:
        """Handle unauthenticated requests"""
        if any(path == request.url.path for path in self.REDIRECT_PATHS):
            return RedirectResponse(url="/", status_code=303)
        
        raise HTTPException(status_code=401, detail="Nicht angemeldet")
    
    def _handle_invalid_session(self, request: Request) -> Response:
        """Handle invalid session tokens"""
        if any(path == request.url.path for path in self.REDIRECT_PATHS):
            response = RedirectResponse(url="/", status_code=303)
            response.delete_cookie("session_token")
            return response
        
        raise HTTPException(status_code=401, detail="Ungültige Session")
    
    async def _get_user_from_token(self, session_token: str) -> Optional[User]:
        """Get user from session token"""
        try:
            async with async_session_maker() as db:
                result = await db.execute(
                    select(User).where(User.session_token == session_token)
                )
                user = result.scalar_one_or_none()
                
                if user:
                    # Update last seen timestamp
                    from datetime import datetime
                    user.last_seen = datetime.utcnow()
                    await db.commit()
                
                return user
        except Exception:
            return None


# Dependency to get current user from request state
def get_current_user_from_state(request: Request) -> User:
    """Get current user from request state (set by middleware)"""
    if not hasattr(request.state, 'user'):
        raise HTTPException(status_code=401, detail="Nicht angemeldet")
    
    return request.state.user