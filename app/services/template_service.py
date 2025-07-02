"""
Template service for consistent template management
"""
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from typing import Optional, Dict, Any
import logging

from app.models.template import Template

logger = logging.getLogger(__name__)


class TemplateService:
    """Handles all template-related operations"""
    
    @staticmethod
    async def get_default_template(db: AsyncSession) -> Dict[str, str]:
        """
        Get the default template for new users
        Falls back to hardcoded content if no templates exist
        """
        try:
            # Try to get the first personal template as default
            result = await db.execute(
                select(Template)
                .where(Template.is_active == True)
                .where(Template.category == 'personal')
                .limit(1)
            )
            template = result.scalar_one_or_none()
            
            if template:
                return {
                    "html": template.html,
                    "css": template.css,
                    "js": template.js or ""
                }
        except Exception as e:
            logger.error(f"Error loading default template: {e}")
        
        # Fallback to hardcoded content if no templates exist
        return {
            "html": "<h1>Willkommen auf meiner Website!</h1>",
            "css": "body { font-family: Arial, sans-serif; margin: 20px; }",
            "js": ""
        }
    
    @staticmethod
    async def get_template_by_id(db: AsyncSession, template_id: int) -> Optional[Template]:
        """Get a specific template by ID"""
        try:
            result = await db.execute(
                select(Template)
                .where(Template.id == template_id)
                .where(Template.is_active == True)
            )
            return result.scalar_one_or_none()
        except Exception as e:
            logger.error(f"Error loading template {template_id}: {e}")
            return None
    
    @staticmethod
    async def get_empty_template() -> Dict[str, str]:
        """
        Get empty template that serves as HTML/CSS basics course for beginners
        Content explains web development fundamentals for users and AI context
        """
        return {
            "html": """<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HTML Grundlagen - Meine erste Website</title>
</head>
<body>
    <header>
        <h1>HTML Grundlagen lernen</h1>
        <p>Eine Schritt-für-Schritt Einführung in die Webentwicklung</p>
    </header>
    
    <main>
        <section>
            <h2>Was ist HTML?</h2>
            <p>HTML (HyperText Markup Language) ist die Grundsprache des Internets. Mit HTML strukturieren wir Inhalte auf Webseiten.</p>
            
            <h3>Grundlegende HTML-Elemente:</h3>
            <ul>
                <li><strong>Überschriften</strong> - h1, h2, h3 für Titel und Zwischentitel</li>
                <li><strong>Absätze</strong> - p für Textblöcke</li>
                <li><strong>Listen</strong> - ul für Aufzählungen, ol für nummerierte Listen</li>
                <li><strong>Links</strong> - a für Verlinkungen zu anderen Seiten</li>
                <li><strong>Bilder</strong> - img für Fotos und Grafiken</li>
            </ul>
        </section>
        
        <section>
            <h2>HTML-Struktur verstehen</h2>
            <p>Jede HTML-Seite hat den gleichen Aufbau:</p>
            
            <ol>
                <li><strong>DOCTYPE</strong> - sagt dem Browser, dass es sich um HTML5 handelt</li>
                <li><strong>html-Element</strong> - umschließt die gesamte Seite</li>
                <li><strong>head-Bereich</strong> - Informationen für den Browser (nicht sichtbar)</li>
                <li><strong>body-Bereich</strong> - der sichtbare Inhalt der Seite</li>
            </ol>
            
            <p>In diesem body-Bereich befinden wir uns gerade. Hier stehen alle Texte, Bilder und Inhalte, die Besucher sehen.</p>
        </section>
        
        <section>
            <h2>Semantische HTML-Elemente</h2>
            <p>Moderne Webseiten nutzen semantische Elemente, die die Bedeutung des Inhalts beschreiben:</p>
            
            <ul>
                <li><strong>header</strong> - Kopfbereich der Seite</li>
                <li><strong>main</strong> - Hauptinhalt der Seite</li>
                <li><strong>section</strong> - Thematische Bereiche</li>
                <li><strong>article</strong> - Eigenständige Inhalte</li>
                <li><strong>footer</strong> - Fußbereich der Seite</li>
            </ul>
            
            <p>Diese Struktur hilft sowohl Menschen als auch Suchmaschinen, den Inhalt besser zu verstehen.</p>
        </section>
        
        <section>
            <h2>Was ist CSS?</h2>
            <p>CSS (Cascading Style Sheets) macht Webseiten schön. Während HTML die Struktur vorgibt, bestimmt CSS das Aussehen.</p>
            
            <h3>CSS kann folgendes verändern:</h3>
            <ul>
                <li>Farben von Text und Hintergrund</li>
                <li>Schriftarten und Schriftgrößen</li>
                <li>Abstände zwischen Elementen</li>
                <li>Position und Anordnung von Inhalten</li>
                <li>Responsive Verhalten auf verschiedenen Geräten</li>
            </ul>
        </section>
        
        <section>
            <h2>Grundlegende CSS-Konzepte</h2>
            
            <h3>Selektoren</h3>
            <p>CSS-Selektoren bestimmen, welche HTML-Elemente gestaltet werden:</p>
            <ul>
                <li><strong>Element-Selektor</strong>: p { } - alle Absätze</li>
                <li><strong>Klassen-Selektor</strong>: .meine-klasse { } - Elemente mit class="meine-klasse"</li>
                <li><strong>ID-Selektor</strong>: #meine-id { } - Element mit id="meine-id"</li>
            </ul>
            
            <h3>Wichtige CSS-Eigenschaften</h3>
            <ul>
                <li><strong>color</strong> - Textfarbe</li>
                <li><strong>background-color</strong> - Hintergrundfarbe</li>
                <li><strong>font-size</strong> - Schriftgröße</li>
                <li><strong>margin</strong> - Außenabstand</li>
                <li><strong>padding</strong> - Innenabstand</li>
                <li><strong>border</strong> - Rahmen um Elemente</li>
            </ul>
        </section>
        
        <section>
            <h2>Responsive Design</h2>
            <p>Moderne Webseiten passen sich automatisch an verschiedene Bildschirmgrößen an. Das nennt man "responsive Design".</p>
            
            <p>Wichtige Konzepte:</p>
            <ul>
                <li><strong>Flexible Breiten</strong> - Elemente passen sich der verfügbaren Breite an</li>
                <li><strong>Media Queries</strong> - Unterschiedliche Styles für verschiedene Bildschirmgrößen</li>
                <li><strong>Mobile First</strong> - Zuerst für kleine Bildschirme entwerfen</li>
            </ul>
        </section>
        
        <section>
            <h2>Interaktive Elemente</h2>
            <p>Webseiten können interaktiv sein. Hier sind einige Beispiele:</p>
            
            <form>
                <label for="name">Ihr Name:</label>
                <input type="text" id="name" name="name" placeholder="Geben Sie Ihren Namen ein">
                
                <label for="email">E-Mail:</label>
                <input type="email" id="email" name="email" placeholder="ihre@email.de">
                
                <label for="nachricht">Nachricht:</label>
                <textarea id="nachricht" name="nachricht" rows="4" placeholder="Schreiben Sie uns eine Nachricht"></textarea>
                
                <button type="submit">Nachricht senden</button>
            </form>
        </section>
        
        <section>
            <h2>Nächste Schritte</h2>
            <p>Sie haben jetzt die Grundlagen von HTML und CSS kennengelernt. Hier sind einige Ideen für Ihre erste eigene Website:</p>
            
            <ul>
                <li>Erstellen Sie eine persönliche Vorstellungsseite</li>
                <li>Fügen Sie Ihre Hobbys und Interessen hinzu</li>
                <li>Experimentieren Sie mit verschiedenen Farben und Schriften</li>
                <li>Fügen Sie Bilder hinzu (mit dem img-Element)</li>
                <li>Erstellen Sie Links zu Ihren Lieblings-Websites</li>
                <li>Probieren Sie verschiedene CSS-Eigenschaften aus</li>
            </ul>
            
            <p><strong>Tipp:</strong> Fragen Sie die KI nach spezifischen Verbesserungen oder Ergänzungen. Sie kann Ihnen dabei helfen, Ihre Website Schritt für Schritt zu verbessern!</p>
        </section>
    </main>
    
    <footer>
        <p>Diese Seite zeigt die Grundlagen von HTML und CSS.</p>
        <p>Verwenden Sie dieses Wissen als Ausgangspunkt für Ihre eigene Website!</p>
    </footer>
</body>
</html>""",
            "css": """/* CSS demonstriert gute Styling-Prinzipien */

/* CSS Custom Properties für konsistente Werte */
:root {
    /* Farb-System */
    --text-primary: #333333;
    --text-secondary: #666666;
    --text-muted: #999999;
    
    --bg-primary: #ffffff;
    --bg-secondary: #f8f9fa;
    --bg-accent: #e9ecef;
    
    --border-color: #dee2e6;
    --focus-color: #0066cc;
    
    /* Spacing-System (basierend auf 8px Grid) */
    --space-xs: 0.5rem;   /* 8px */
    --space-sm: 1rem;     /* 16px */
    --space-md: 1.5rem;   /* 24px */
    --space-lg: 2rem;     /* 32px */
    --space-xl: 3rem;     /* 48px */
    
    /* Typography Scale */
    --font-size-sm: 0.875rem;  /* 14px */
    --font-size-base: 1rem;    /* 16px */
    --font-size-lg: 1.25rem;   /* 20px */
    --font-size-xl: 1.5rem;    /* 24px */
    --font-size-2xl: 2rem;     /* 32px */
    
    /* Layout */
    --border-radius: 0.25rem;
    --shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.05);
    --shadow-md: 0 4px 6px rgba(0, 0, 0, 0.1);
    --max-width: 800px;
}

/* Reset und Grundeinstellungen */
* {
    box-sizing: border-box;
}

/* Körper der Seite - Mobile First Approach */
body {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    font-size: var(--font-size-base);
    line-height: 1.6;
    color: var(--text-primary);
    margin: 0;
    padding: var(--space-sm);
    background-color: var(--bg-secondary);
}

/* Container für optimale Lesbarkeit */
.container {
    max-width: var(--max-width);
    margin: 0 auto;
}

/* Semantische Header-Struktur */
header {
    background-color: var(--bg-primary);
    padding: var(--space-lg);
    text-align: center;
    border-radius: var(--border-radius);
    box-shadow: var(--shadow-sm);
    margin-bottom: var(--space-lg);
}

header h1 {
    font-size: var(--font-size-2xl);
    color: var(--text-primary);
    margin: 0 0 var(--space-xs) 0;
    font-weight: 600;
}

header p {
    color: var(--text-secondary);
    margin: 0;
    font-size: var(--font-size-lg);
}

/* Hauptinhalt mit klarer Struktur */
main {
    background-color: var(--bg-primary);
    padding: var(--space-xl);
    border-radius: var(--border-radius);
    box-shadow: var(--shadow-md);
    margin-bottom: var(--space-lg);
}

/* Typografie-Hierarchie */
h1, h2, h3, h4, h5, h6 {
    color: var(--text-primary);
    margin-top: 0;
    line-height: 1.2;
}

h2 {
    font-size: var(--font-size-xl);
    margin-bottom: var(--space-md);
    padding-bottom: var(--space-xs);
    border-bottom: 2px solid var(--bg-accent);
}

h3 {
    font-size: var(--font-size-lg);
    margin-bottom: var(--space-sm);
    color: var(--text-secondary);
}

/* Optimaler Text-Flow */
p {
    margin-bottom: var(--space-md);
    max-width: 65ch; /* Optimale Zeilenlänge */
}

/* Listen mit konsistentem Spacing */
ul, ol {
    margin-bottom: var(--space-md);
    padding-left: var(--space-lg);
}

li {
    margin-bottom: var(--space-xs);
}

/* Visuelle Hierarchie durch Gewichtung */
strong {
    font-weight: 600;
    color: var(--text-primary);
}

/* Abschnitte mit klarer Trennung */
section {
    margin-bottom: var(--space-xl);
}

section:last-child {
    margin-bottom: 0;
}

/* Accessible Form Design */
form {
    background-color: var(--bg-secondary);
    padding: var(--space-lg);
    border-radius: var(--border-radius);
    border: 1px solid var(--border-color);
    margin-top: var(--space-lg);
}

/* Label-Input Pairing für Accessibility */
label {
    display: block;
    margin-bottom: var(--space-xs);
    font-weight: 500;
    color: var(--text-primary);
    font-size: var(--font-size-sm);
}

/* Konsistente Input-Gestaltung */
input, textarea {
    width: 100%;
    padding: var(--space-sm);
    margin-bottom: var(--space-md);
    border: 1px solid var(--border-color);
    border-radius: var(--border-radius);
    font-family: inherit;
    font-size: var(--font-size-base);
    transition: border-color 0.2s ease, box-shadow 0.2s ease;
}

/* Focus States für Keyboard Navigation */
input:focus, textarea:focus {
    outline: none;
    border-color: var(--focus-color);
    box-shadow: 0 0 0 3px rgba(0, 102, 204, 0.1);
}

/* Button mit klarer Interaktion */
button {
    background-color: var(--focus-color);
    color: white;
    border: none;
    padding: var(--space-sm) var(--space-lg);
    border-radius: var(--border-radius);
    font-size: var(--font-size-base);
    font-weight: 500;
    cursor: pointer;
    transition: background-color 0.2s ease, transform 0.1s ease;
}

button:hover {
    background-color: #0052a3;
}

button:active {
    transform: translateY(1px);
}

button:focus {
    outline: none;
    box-shadow: 0 0 0 3px rgba(0, 102, 204, 0.3);
}

/* Footer mit subtiler Trennung */
footer {
    background-color: var(--bg-primary);
    border-top: 1px solid var(--border-color);
    padding: var(--space-lg);
    text-align: center;
    border-radius: var(--border-radius);
    margin-top: var(--space-lg);
}

footer p {
    color: var(--text-secondary);
    font-size: var(--font-size-sm);
    margin: var(--space-xs) 0;
}

/* Responsive Design - Mobile First */
@media (min-width: 768px) {
    body {
        padding: var(--space-lg);
    }
    
    main {
        padding: var(--space-xl);
    }
    
    header {
        padding: var(--space-xl);
    }
    
    /* Größere Schrift auf Desktop */
    h1 {
        font-size: var(--font-size-2xl);
    }
}

/* Accessibility Improvements */
@media (prefers-reduced-motion: reduce) {
    * {
        animation-duration: 0.01ms !important;
        animation-iteration-count: 1 !important;
        transition-duration: 0.01ms !important;
    }
}

/* Print Styles */
@media print {
    body {
        background: white;
        color: black;
        font-size: 12pt;
    }
    
    header, footer {
        background: transparent !important;
        box-shadow: none !important;
    }
    
    button {
        display: none;
    }
}""",
            "js": ""
        }
    
    @staticmethod
    async def get_template_content(db: AsyncSession, template_id: Optional[int] = None) -> Dict[str, str]:
        """
        Get template content either by ID, empty, or default
        
        Args:
            db: Database session
            template_id: Optional template ID
                        - None: use default template (for signup)
                        - 0: use empty template (explicitly chosen)
                        - >0: use specific template
            
        Returns:
            Dict with html, css, js content
        """
        if template_id == 0:
            # Explicitly requested empty template
            return await TemplateService.get_empty_template()
        elif template_id and template_id > 0:
            # Specific template requested
            template = await TemplateService.get_template_by_id(db, template_id)
            if template:
                return {
                    "html": template.html,
                    "css": template.css,
                    "js": template.js or ""
                }
        
        # Fall back to default template (for signup or when template not found)
        return await TemplateService.get_default_template(db)
    
    @staticmethod
    async def list_templates(db: AsyncSession) -> list[Template]:
        """Get all active templates"""
        try:
            result = await db.execute(
                select(Template)
                .where(Template.is_active == True)
                .order_by(Template.category, Template.name)
            )
            return result.scalars().all()
        except Exception as e:
            logger.error(f"Error listing templates: {e}")
            return []