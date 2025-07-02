import re
import logging
from typing import Dict, List, Optional, Tuple
from bs4 import BeautifulSoup, Comment

logger = logging.getLogger(__name__)


class CodeProcessor:
    """Process and validate HTML/CSS/JS code for safety and functionality"""
    
    # Dangerous patterns to block
    DANGEROUS_PATTERNS = {
        'js': [
            # Only block truly dangerous patterns for educational workshop
            r'eval\s*\(',
            r'\bFunction\s*\(',  # Block Function constructor (capital F)
            r'document\.write',
            # r'innerHTML\s*=',  # Allow for DOM learning
            # r'outerHTML\s*=',  # Allow for DOM learning
            r'\.cookie',  # Still block cookie access
            # r'localStorage',  # Allow for data persistence learning
            # r'sessionStorage',  # Allow for session learning
            # r'indexedDB',  # Allow for database learning
            # r'fetch\s*\(',  # Allow for API learning
            # r'XMLHttpRequest',  # Allow for AJAX learning
            # r'WebSocket',  # Allow for WebSocket learning
            r'Worker\s*\(',  # Block workers (complexity)
            r'importScripts',  # Block dynamic imports
            r'window\.location\s*=',  # Block navigation hijacking
            r'document\.location\s*=',  # Block navigation hijacking
            r'window\.open',  # Block popups
            r'<script[^>]*src=',  # External scripts still blocked
        ],
        'html': [
            r'<script[^>]*src=',  # External scripts still blocked
            r'<link[^>]*href=["\'](?!https://(?:unpkg\.com|cdnjs\.cloudflare\.com|jsdelivr\.net))',  # Non-whitelisted external styles
            r'<iframe',  # Still block iframes
            r'<embed',  # Still block embeds
            r'<object',  # Still block objects
            r'<applet',  # Still block applets
            r'<form[^>]*action=',  # Still block forms with actions
            # r'on\w+\s*=',  # Allow inline event handlers for learning
        ],
        'css': [
            r'@import\s+["\'](?!https://(?:fonts\.googleapis\.com|unpkg\.com|cdnjs\.cloudflare\.com))',
            r'expression\s*\(',  # IE expressions
            r'javascript:',
            r'behavior\s*:',
        ]
    }
    
    # Whitelisted CDNs
    WHITELISTED_CDNS = [
        'https://unpkg.com',
        'https://cdnjs.cloudflare.com', 
        'https://cdn.jsdelivr.net',
        'https://fonts.googleapis.com',
        'https://fonts.gstatic.com'
    ]
    
    @classmethod
    def validate_code(cls, code: Dict[str, str]) -> Tuple[bool, List[str]]:
        """
        Validate code for safety
        
        Returns:
            Tuple of (is_valid, list_of_errors)
        """
        errors = []
        
        # Check HTML
        html_errors = cls._validate_html(code.get('html', ''))
        errors.extend(html_errors)
        
        # Check CSS
        css_errors = cls._validate_css(code.get('css', ''))
        errors.extend(css_errors)
        
        # Check JS
        js_errors = cls._validate_js(code.get('js', ''))
        errors.extend(js_errors)
        
        return len(errors) == 0, errors
    
    @classmethod
    def _validate_html(cls, html: str) -> List[str]:
        """Validate HTML for dangerous patterns"""
        errors = []
        
        # Check dangerous patterns
        for pattern in cls.DANGEROUS_PATTERNS['html']:
            if re.search(pattern, html, re.IGNORECASE):
                errors.append(f"Unsicheres HTML-Muster gefunden: {pattern}")
        
        # Parse and check with BeautifulSoup
        try:
            soup = BeautifulSoup(html, 'html.parser')
            
            # Check for script tags with src
            for script in soup.find_all('script', src=True):
                src = script.get('src', '')
                if not any(src.startswith(cdn) for cdn in cls.WHITELISTED_CDNS):
                    errors.append(f"Externe Skripte sind nicht erlaubt: {src}")
            
            # Check for external stylesheets
            for link in soup.find_all('link', rel='stylesheet'):
                href = link.get('href', '')
                if href and not any(href.startswith(cdn) for cdn in cls.WHITELISTED_CDNS):
                    errors.append(f"Externe Stylesheets sind nur von vertrauenswürdigen CDNs erlaubt: {href}")
                    
        except Exception as e:
            errors.append(f"HTML-Parsing-Fehler: {str(e)}")
        
        return errors
    
    @classmethod
    def _validate_css(cls, css: str) -> List[str]:
        """Validate CSS for dangerous patterns"""
        errors = []
        
        for pattern in cls.DANGEROUS_PATTERNS['css']:
            if re.search(pattern, css, re.IGNORECASE):
                errors.append(f"Unsicheres CSS-Muster gefunden: {pattern}")
        
        return errors
    
    @classmethod
    def _validate_js(cls, js: str) -> List[str]:
        """Validate JavaScript for dangerous patterns"""
        errors = []
        
        for pattern in cls.DANGEROUS_PATTERNS['js']:
            # Use case-sensitive matching for Function constructor to avoid matching "function"
            flags = 0 if pattern == r'\bFunction\s*\(' else re.IGNORECASE
            if re.search(pattern, js, flags):
                errors.append(f"Unsicheres JavaScript-Muster gefunden: {pattern}")
        
        return errors
    
    @classmethod
    def apply_updates(cls, current_code: Dict[str, str], updates: List[Dict], apply_all: bool = False) -> Dict[str, str]:
        """
        Apply code updates to current code
        
        Args:
            current_code: Current code dict with html, css, js
            updates: List of update operations
            apply_all: If True, replace all occurrences. If False, replace only first occurrence.
            
        Returns:
            Updated code dict
        """
        new_code = current_code.copy()
        
        for update in updates:
            file_type = update.get('file')
            old_str = update.get('old_str', '')
            new_str = update.get('new_str', '')
            
            if file_type in new_code and old_str in new_code[file_type]:
                if apply_all:
                    # Replace all occurrences
                    new_code[file_type] = new_code[file_type].replace(old_str, new_str)
                    logger.info(f"Applied update_all to {file_type}: {update.get('description', 'No description')} (all occurrences)")
                else:
                    # Replace only first occurrence
                    new_code[file_type] = new_code[file_type].replace(old_str, new_str, 1)
                    logger.info(f"Applied update to {file_type}: {update.get('description', 'No description')} (first occurrence)")
            else:
                logger.warning(f"Could not apply update to {file_type}: string not found.")
                logger.warning(f"Looking for: '{old_str}'")
                logger.warning(f"In {file_type} content: '{new_code.get(file_type, '')}'")
                # Instead of failing, log the error and continue
                # This allows partial updates to succeed
        
        return new_code
    
    @classmethod
    def sanitize_code(cls, code: Dict[str, str]) -> Dict[str, str]:
        """
        Sanitize code by removing dangerous elements
        
        Returns:
            Sanitized code dict
        """
        sanitized = {}
        
        # Sanitize HTML
        html = code.get('html', '')
        soup = BeautifulSoup(html, 'html.parser')
        
        # Remove all script tags with external src
        for script in soup.find_all('script', src=True):
            script.decompose()
        
        # Remove all inline event handlers
        for tag in soup.find_all(True):
            for attr in list(tag.attrs):
                if attr.startswith('on'):
                    del tag[attr]
        
        # Remove dangerous tags
        for tag_name in ['iframe', 'embed', 'object', 'applet']:
            for tag in soup.find_all(tag_name):
                tag.decompose()
        
        sanitized['html'] = str(soup)
        
        # Basic sanitization for CSS and JS (remove obvious dangerous patterns)
        sanitized['css'] = re.sub(r'@import\s+["\'][^"\']+["\']', '', code.get('css', ''))
        sanitized['css'] = re.sub(r'expression\s*\([^)]*\)', '', sanitized['css'])
        
        # For JS, remove fetch, XMLHttpRequest, etc
        js = code.get('js', '')
        for pattern in cls.DANGEROUS_PATTERNS['js']:
            js = re.sub(pattern, '// Removed unsafe code', js, flags=re.IGNORECASE)
        sanitized['js'] = js
        
        return sanitized