import time
import logging
from typing import Dict, Tuple
from collections import defaultdict, deque
import asyncio

logger = logging.getLogger(__name__)


class RateLimiter:
    """Simple in-memory rate limiter for image uploads"""
    
    def __init__(self):
        # Store upload timestamps per user
        self.user_uploads: Dict[int, deque] = defaultdict(deque)
        # Store last cleanup time
        self.last_cleanup = time.time()
        # Cleanup interval (5 minutes)
        self.cleanup_interval = 300
    
    def cleanup_old_entries(self):
        """Remove old entries to prevent memory buildup"""
        current_time = time.time()
        
        if current_time - self.last_cleanup < self.cleanup_interval:
            return
        
        # Clean up entries older than 1 hour
        cutoff_time = current_time - 3600
        
        for user_id in list(self.user_uploads.keys()):
            uploads = self.user_uploads[user_id]
            
            # Remove old timestamps
            while uploads and uploads[0] < cutoff_time:
                uploads.popleft()
            
            # Remove empty deques
            if not uploads:
                del self.user_uploads[user_id]
        
        self.last_cleanup = current_time
        logger.info(f"Rate limiter cleanup completed. Active users: {len(self.user_uploads)}")
    
    def check_rate_limit(self, user_id: int, window_seconds: int = 300, max_uploads: int = 10) -> Tuple[bool, str]:
        """
        Check if user is within rate limits
        
        Args:
            user_id: User ID to check
            window_seconds: Time window in seconds (default: 5 minutes)
            max_uploads: Maximum uploads in window (default: 10)
        
        Returns:
            (allowed, message)
        """
        current_time = time.time()
        cutoff_time = current_time - window_seconds
        
        # Cleanup old entries periodically
        self.cleanup_old_entries()
        
        # Get user's upload history
        uploads = self.user_uploads[user_id]
        
        # Remove old uploads from this user's history
        while uploads and uploads[0] < cutoff_time:
            uploads.popleft()
        
        # Check if user is within limits
        if len(uploads) >= max_uploads:
            wait_time = int(uploads[0] + window_seconds - current_time)
            return False, f"Zu viele Uploads. Warte {wait_time} Sekunden."
        
        # Record this upload attempt
        uploads.append(current_time)
        
        return True, "OK"
    
    def get_user_stats(self, user_id: int) -> Dict[str, int]:
        """Get upload statistics for a user"""
        current_time = time.time()
        uploads = self.user_uploads.get(user_id, deque())
        
        # Count uploads in different time windows
        stats = {
            "last_5_minutes": 0,
            "last_hour": 0,
            "total_today": 0
        }
        
        for upload_time in uploads:
            age = current_time - upload_time
            
            if age <= 300:  # 5 minutes
                stats["last_5_minutes"] += 1
            if age <= 3600:  # 1 hour
                stats["last_hour"] += 1
            if age <= 86400:  # 24 hours
                stats["total_today"] += 1
        
        return stats


# Global rate limiter instance
image_rate_limiter = RateLimiter()