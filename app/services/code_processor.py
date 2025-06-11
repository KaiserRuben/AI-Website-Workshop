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
            r'eval\s*\(',
            r'Function\s*\(',
            r'setTimeout\s*\([^,]+,\s*[^0-9]',  # Dynamic setTimeout
            r'setInterval\s*\([^,]+,\s*[^0-9]', # Dynamic setInterval
            r'document\.write',
            r'innerHTML\s*=',
            r'outerHTML\s*=',
            r'\.cookie',
            r'localStorage',
            r'sessionStorage',
            r'indexedDB',
            r'fetch\s*\(',
            r'XMLHttpRequest',
            r'WebSocket',
            r'Worker\s*\(',
            r'importScripts',
            r'window\.location',
            r'document\.location',
            r'window\.open',
            r'<script[^>]*src=',  # External scripts
        ],
        'html': [
            r'<script[^>]*src=',  # External scripts
            r'<link[^>]*href=["\'](?!https://(?:unpkg\.com|cdnjs\.cloudflare\.com|jsdelivr\.net))',  # Non-whitelisted external styles
            r'<iframe',
            r'<embed',
            r'<object',
            r'<applet',
            r'<form[^>]*action=',
            r'on\w+\s*=',  # Inline event handlers
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
            if re.search(pattern, js, re.IGNORECASE):
                errors.append(f"Unsicheres JavaScript-Muster gefunden: {pattern}")
        
        return errors
    
    @classmethod
    def apply_updates(cls, current_code: Dict[str, str], updates: List[Dict]) -> Dict[str, str]:
        """
        Apply code updates to current code
        
        Args:
            current_code: Current code dict with html, css, js
            updates: List of update operations
            
        Returns:
            Updated code dict
        """
        new_code = current_code.copy()
        
        for update in updates:
            file_type = update.get('file')
            old_str = update.get('old_str', '')
            new_str = update.get('new_str', '')
            
            if file_type in new_code and old_str in new_code[file_type]:
                new_code[file_type] = new_code[file_type].replace(old_str, new_str)
                logger.info(f"Applied update to {file_type}: {update.get('description', 'No description')}")
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