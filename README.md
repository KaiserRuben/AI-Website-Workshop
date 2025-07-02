# 🤖 KI Website Workshop

Ein Workshop-System, das Jugendlichen ermöglicht, ohne Programmierkenntnisse ihre eigene Website zu erstellen. Die Teilnehmer kommunizieren in natürlicher Sprache mit einer KI, die den Code für sie generiert.

## ✨ Features

- **Niedrigschwelliger Einstieg**: Keine Vorkenntnisse erforderlich
- **Sofortige Erfolgserlebnisse**: Live-Vorschau der Website
- **Peer-Learning**: Gallery zeigt Projekte aller Teilnehmer
- **Kosteneffizienz**: Transparente Kostenkontrolle der KI-Nutzung
- **Real-time Collaboration**: WebSocket-basierte Live-Updates
- **Sichere Code-Ausführung**: Sandbox-Umgebung für HTML/CSS/JS

## 🏗️ Architektur

- **Backend**: FastAPI (Python 3.11+)
- **Frontend**: Jinja2 Templates + Alpine.js
- **Database**: PostgreSQL 15+
- **WebSockets**: FastAPI native WebSocket support
- **AI Provider**: Azure OpenAI (GPT-4-mini)
- **Code Editor**: Monaco Editor
- **Deployment**: Docker + Docker Compose

## 🚀 Schnellstart

### 1. Repository klonen

```bash
git clone <repository-url>
cd ki-website-workshop
```

### 2. Umgebungsvariablen konfigurieren

```bash
cp .env.example .env
# .env mit Azure OpenAI Credentials bearbeiten
```

### 3. Mit Docker starten

```bash
docker compose up --build
```

Die Anwendung ist dann unter http://localhost:8000 verfügbar.

## 🔧 Entwicklung

### Lokale Entwicklung

```bash
# Python Umgebung erstellen
python -m venv venv
source venv/bin/activate  # Linux/Mac
# oder
venv\Scripts\activate  # Windows

# Dependencies installieren
pip install -r requirements.txt

# Datenbank mit Docker starten
docker compose up postgres -d

# FastAPI Server starten
uvicorn app.main:app --reload
```

### Datenbankmigrationen

```bash
# Datenbank initialisieren
docker compose exec postgres psql -U workshop -d workshop -f /docker-entrypoint-initdb.d/init.sql
```

## 📊 Workshop-Ablauf

### Zeitplan (7.5 Stunden)

- **09:00-09:30**: Ankommen & Setup
- **09:30-10:00**: KI-Grundlagen
- **10:00-10:30**: Prompting-Basics
- **10:30-11:00**: Website-Grundlagen
- **11:00-11:15**: Pause
- **11:15-12:30**: Praxis I
- **12:30-13:30**: Mittagspause
- **13:30-14:00**: Design & Psychologie
- **14:00-15:30**: Praxis II
- **15:30-15:45**: Pause
- **15:45-16:15**: Showcase
- **16:15-16:30**: Going Live

### Rollen

- **Admin**: Erster Nutzer wird automatisch Admin
- **Teilnehmer**: Können eigene Websites erstellen

## 💰 Kostenmanagement

- **Standard-Limit**: €1.00 pro Teilnehmer
- **Rate Limiting**: Max. 10 API-Calls pro Minute
- **Live-Tracking**: Echtzeit-Kostenüberwachung
- **Export**: Vollständiger Datenexport nach Workshop

### Geschätzte Kosten (50 Teilnehmer)

- Azure OpenAI API: €25-50
- Server (1 Tag): €5
- **Total: €30-55**

## 🛡️ Sicherheit

### Code-Sandbox

- `iframe` Isolation mit `sandbox="allow-scripts"`
- Content Security Policy (CSP)
- Keine `eval()` oder dynamische Code-Execution
- Whitelist für vertrauenswürdige CDNs

### Eingabe-Validierung

- HTML Sanitization
- CSS Validation
- JavaScript Restrictions
- Rate Limiting

## 🔌 API-Dokumentation

### REST Endpoints

```
GET  /                          # Workshop Entry Page
POST /api/join                  # Join Workshop
POST /api/logout               # Logout
GET  /api/workshop/info         # Workshop Information
GET  /api/websites              # List User Websites
PUT  /api/websites/{id}         # Update Website
POST /api/websites/{id}/rollback # Rollback Changes
GET  /api/admin/stats           # Admin Statistics
```

### WebSocket Messages

```javascript
// Client → Server
{
    "type": "ai_request",
    "prompt": "Mache den Hintergrund blau",
    "currentCode": { "html": "...", "css": "...", "js": "..." }
}

// Server → Client
{
    "type": "code_update",
    "code": { "html": "...", "css": "...", "js": "..." },
    "changeType": "ai_update"
}
```

## 📋 Admin Dashboard

Verfügbar unter `/admin` für Workshop-Administratoren:

- **Live-Monitoring**: Aktive Nutzer, Kosten, API-Calls
- **Nutzer-Verwaltung**: Übersicht aller Teilnehmer
- **Kostenüberwachung**: Detailliertes Cost-Tracking
- **Datenexport**: JSON-Export aller Workshop-Daten

## 🎨 Frontend-Features

### Workshop-Interface

- **Live-Vorschau**: Iframe mit srcdoc für sichere Ausführung
- **Monaco Editor**: Optionaler Code-Editor mit Syntax-Highlighting
- **Chat-Interface**: KI-Integration mit Nachrichtenverlauf
- **Gallery**: Horizontale Übersicht aller Teilnehmer-Projekte

### Template-System

Vorgefertigte Templates:
- Persönliche Vorstellung
- Fotosammlung
- Lieblingsspiel-Präsentation

## 🚀 Deployment

### Produktions-Setup

```bash
# SSL-Zertifikate mit Let's Encrypt
certbot certonly --webroot -w /var/www/certbot -d your-domain.com

# Produktions-Compose
docker compose -f docker-compose.prod.yml up -d
```

### Systemanforderungen

- 2 CPU Cores
- 4GB RAM
- 20GB SSD
- Ubuntu 22.04 LTS

## 🧪 Testing

```bash
# Unit Tests
pytest tests/

# Integration Tests
pytest tests/integration/

# Load Testing
locust -f tests/load/locustfile.py
```

## 📝 Umgebungsvariablen

Wichtige Konfigurationen in `.env`:

```bash
# Azure OpenAI
AZURE_OPENAI_API_KEY=your-key
AZURE_OPENAI_ENDPOINT=https://your-endpoint.openai.azure.com/
AZURE_OPENAI_DEPLOYMENT=gpt-4.1-mini

# Workshop-Einstellungen
MAX_COST_PER_USER=1.00
MAX_API_CALLS_PER_MINUTE=10

# Sicherheit
SECRET_KEY=your-secret-key
```

## 📚 Verwendete Technologien

- **FastAPI**: Moderne, schnelle Web-API
- **Alpine.js**: Leichtgewichtiges JavaScript-Framework
- **SQLAlchemy**: Python SQL Toolkit und ORM
- **Monaco Editor**: Code-Editor von VS Code
- **Tailwind CSS**: Utility-first CSS Framework
- **PostgreSQL**: Robuste relationale Datenbank
- **Docker**: Containerisierung und Deployment

## 🤝 Beitragen

1. Fork das Repository
2. Erstelle einen Feature-Branch (`git checkout -b feature/amazing-feature`)
3. Commit deine Änderungen (`git commit -m 'Add amazing feature'`)
4. Push zum Branch (`git push origin feature/amazing-feature`)
5. Öffne eine Pull Request

## 📄 Lizenz

@Copyright Ruben Kaiser

## 🆘 Support

Bei Fragen oder Problemen:

1. Prüfe die [Dokumentation](docs/)
2. Schaue in die [Issues](issues/)
3. Erstelle ein neues Issue mit detaillierter Beschreibung

## 🗺️ Roadmap

### Version 1.1
- [ ] Multi-Page Websites
- [ ] Export als ZIP-Datei
- [ ] Erweiterte Template-Bibliothek

### Version 1.2
- [ ] Datenbank-Integration (LocalStorage)
- [ ] Formular-Funktionalität
- [ ] SEO-Optimierung

### Version 2.0
- [ ] Eigenes Hosting für Teilnehmer
- [ ] CI/CD Pipeline Integration
- [ ] Versionskontrolle (Git)
- [ ] Collaboration Features

---

**Copyright © 2024 Ruben Kaiser**
