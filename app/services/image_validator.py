import io
import logging
from typing import Tuple, Optional, Dict, Any
from PIL import Image, ImageSequence
import hashlib
import struct

# Try to import magic, fallback if not available
try:
    import magic
    MAGIC_AVAILABLE = True
except ImportError:
    MAGIC_AVAILABLE = False
    magic = None

logger = logging.getLogger(__name__)


class ImageSecurityValidator:
    """Comprehensive image security and validation service"""
    
    # Allowed MIME types with strict validation
    ALLOWED_MIME_TYPES = {
        'image/jpeg': [b'\xff\xd8\xff'],
        'image/png': [b'\x89\x50\x4e\x47'],
        'image/webp': [b'RIFF'],
        'image/heic': [b'ftyp'],
        'image/heif': [b'ftyp']
    }
    
    # Maximum dimensions to prevent resource exhaustion
    MAX_DIMENSIONS = (8192, 8192)  # 8K max resolution
    MIN_DIMENSIONS = (1, 1)
    
    # File size limits
    MAX_FILE_SIZE = 10 * 1024 * 1024  # 10MB
    MIN_FILE_SIZE = 100  # 100 bytes minimum
    
    # Security limits
    MAX_ANIMATION_FRAMES = 100  # For animated images
    
    @staticmethod
    def validate_file_signature(file_data: bytes, declared_mime_type: str) -> bool:
        """Validate file signature matches declared MIME type"""
        try:
            if declared_mime_type not in ImageSecurityValidator.ALLOWED_MIME_TYPES:
                return False
            
            signatures = ImageSecurityValidator.ALLOWED_MIME_TYPES[declared_mime_type]
            
            # Special handling for WebP
            if declared_mime_type == 'image/webp':
                return (file_data.startswith(b'RIFF') and 
                       b'WEBP' in file_data[:12])
            
            # Special handling for HEIC/HEIF
            if declared_mime_type in ['image/heic', 'image/heif']:
                return (b'ftyp' in file_data[:20] and 
                       (b'heic' in file_data[:20] or b'mif1' in file_data[:20]))
            
            # Standard signature check
            return any(file_data.startswith(sig) for sig in signatures)
            
        except Exception as e:
            logger.error(f"Error validating file signature: {e}")
            return False
    
    @staticmethod
    def detect_mime_type_with_magic(file_data: bytes) -> Optional[str]:
        """Use python-magic to detect actual MIME type"""
        if not MAGIC_AVAILABLE:
            logger.warning("python-magic not available, skipping MIME type detection")
            return None
            
        try:
            mime_type = magic.from_buffer(file_data, mime=True)
            return mime_type if mime_type in ImageSecurityValidator.ALLOWED_MIME_TYPES else None
        except Exception as e:
            logger.error(f"Error detecting MIME type: {e}")
            return None
    
    @staticmethod
    def validate_image_content(file_data: bytes) -> Tuple[bool, Optional[str], Optional[Dict[str, Any]]]:
        """
        Comprehensive image content validation
        Returns: (is_valid, error_message, image_info)
        """
        try:
            # Basic size check
            if len(file_data) < ImageSecurityValidator.MIN_FILE_SIZE:
                return False, "File too small", None
            
            if len(file_data) > ImageSecurityValidator.MAX_FILE_SIZE:
                return False, "File too large", None
            
            # Load image with PIL
            image = Image.open(io.BytesIO(file_data))
            
            # Validate dimensions
            width, height = image.size
            if (width < ImageSecurityValidator.MIN_DIMENSIONS[0] or 
                height < ImageSecurityValidator.MIN_DIMENSIONS[1]):
                return False, "Image dimensions too small", None
            
            if (width > ImageSecurityValidator.MAX_DIMENSIONS[0] or 
                height > ImageSecurityValidator.MAX_DIMENSIONS[1]):
                return False, "Image dimensions too large", None
            
            # Check for excessive animation frames (potential DoS)
            frame_count = 1
            if hasattr(image, 'is_animated') and image.is_animated:
                try:
                    frame_count = len(list(ImageSequence.Iterator(image)))
                    if frame_count > ImageSecurityValidator.MAX_ANIMATION_FRAMES:
                        return False, "Too many animation frames", None
                except Exception:
                    # If we can't count frames, treat as single frame
                    frame_count = 1
            
            # Validate color mode
            if image.mode not in ['RGB', 'RGBA', 'L', 'LA', 'P']:
                return False, "Unsupported color mode", None
            
            # Calculate actual image hash for deduplication
            image_hash = hashlib.md5(file_data).hexdigest()
            
            image_info = {
                'width': width,
                'height': height,
                'mode': image.mode,
                'format': image.format,
                'frame_count': frame_count,
                'is_animated': getattr(image, 'is_animated', False),
                'hash': image_hash
            }
            
            return True, None, image_info
            
        except Exception as e:
            logger.error(f"Error validating image content: {e}")
            return False, f"Invalid image format: {str(e)}", None
    
    @staticmethod
    def sanitize_filename(filename: str) -> str:
        """Sanitize filename to prevent path traversal and other attacks"""
        import re
        import os
        
        if not filename:
            return "image"
        
        # Get just the filename, no directory components
        filename = os.path.basename(filename)
        
        # Remove or replace dangerous characters
        filename = re.sub(r'[^\w\-_\.]', '_', filename)
        
        # Limit length
        if len(filename) > 100:
            name, ext = os.path.splitext(filename)
            filename = name[:90] + ext
        
        # Ensure it has an extension
        if '.' not in filename:
            filename += '.jpg'
        
        return filename
    
    @staticmethod
    def check_file_entropy(file_data: bytes) -> float:
        """
        Calculate file entropy to detect potential steganography or encrypted content
        High entropy might indicate hidden data
        """
        try:
            if len(file_data) == 0:
                return 0.0
            
            # Count byte frequencies
            byte_counts = [0] * 256
            for byte in file_data:
                byte_counts[byte] += 1
            
            # Calculate entropy
            entropy = 0.0
            length = len(file_data)
            
            import math
            for count in byte_counts:
                if count > 0:
                    probability = count / length
                    entropy -= probability * math.log2(probability)
            
            return entropy
            
        except Exception as e:
            logger.error(f"Error calculating entropy: {e}")
            return 0.0
    
    @staticmethod
    def validate_image_comprehensive(
        file_data: bytes, 
        declared_mime_type: str, 
        filename: str
    ) -> Tuple[bool, Optional[str], Optional[Dict[str, Any]]]:
        """
        Perform comprehensive image validation including security checks
        """
        # 1. Validate file signature
        if not ImageSecurityValidator.validate_file_signature(file_data, declared_mime_type):
            return False, "File signature doesn't match declared type", None
        
        # 2. Detect actual MIME type
        actual_mime_type = ImageSecurityValidator.detect_mime_type_with_magic(file_data)
        if actual_mime_type != declared_mime_type:
            logger.warning(f"MIME type mismatch: declared={declared_mime_type}, actual={actual_mime_type}")
            # For now, log but don't block - some variations are acceptable
        
        # 3. Validate image content
        is_valid, error, image_info = ImageSecurityValidator.validate_image_content(file_data)
        if not is_valid:
            return False, error, None
        
        # 4. Check entropy (basic steganography detection)
        entropy = ImageSecurityValidator.check_file_entropy(file_data)
        if entropy > 7.5:  # Very high entropy threshold
            logger.warning(f"High entropy detected in image: {entropy}")
            # Log but don't block - many legitimate images have high entropy
        
        # 5. Sanitize filename
        safe_filename = ImageSecurityValidator.sanitize_filename(filename)
        
        # Add security info to image_info
        if image_info:
            image_info.update({
                'entropy': entropy,
                'safe_filename': safe_filename,
                'original_filename': filename,
                'actual_mime_type': actual_mime_type
            })
        
        return True, None, image_info


class ImageProcessingError(Exception):
    """Custom exception for image processing errors"""
    pass


class ImageSecurityError(Exception):
    """Custom exception for image security validation errors"""
    pass