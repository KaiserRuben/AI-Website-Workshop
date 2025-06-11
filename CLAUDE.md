# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Quick Start (Recommended)
```bash
# Use the startup script for guided setup
./start.sh
```

### Manual Development Setup
```bash
# 1. Environment setup
cp .env.example .env
# Edit .env with Azure OpenAI credentials

# 2. Start with Docker (Full Stack)
docker compose up --build

# 3. Local development (FastAPI only)
python -m venv venv
source venv/bin/activate  # Linux/Mac
pip install -r requirements.txt
docker compose up postgres -d  # Database only
uvicorn app.main:app --reload

# 4. Database initialization
docker compose exec postgres psql -U workshop -d workshop -f /docker-entrypoint-initdb.d/init.sql
```

### Testing & Quality
```bash
# Run tests
pytest tests/

# Integration tests
pytest tests/integration/

# Load testing
locust -f tests/load/locustfile.py
```

### Production Deployment
```bash
# Production setup
docker compose -f docker-compose.prod.yml up -d

# SSL certificates (Let's Encrypt)
certbot certonly --webroot -w /var/www/certbot -d your-domain.com
```

## Architecture Overview

This is a **real-time workshop platform** where participants create websites using AI assistance. The architecture is built for **live collaboration** and **cost-controlled AI usage**.

### Core Components

1. **FastAPI Backend** (`app/main.py`)
   - RESTful API + WebSocket endpoints
   - Real-time communication for live workshop experience
   - Cost tracking and rate limiting for Azure OpenAI

2. **WebSocket Architecture** (`app/routers/websocket.py`)
   - `ConnectionManager`: Handles all WebSocket connections
   - `GalleryUpdateManager`: Batches real-time gallery updates for performance
   - Real-time AI chat, code updates, and live gallery

3. **AI Integration** (`app/services/azure_ai.py`)
   - Azure OpenAI (GPT-4.1-mini) for code generation
   - Structured responses: updates vs. complete rewrites
   - Cost calculation and transparent tracking

4. **Data Models** (`app/models/`)
   - `User`: Workshop participants with role-based access
   - `Website`: User's website with versioned code (HTML/CSS/JS)
   - `CodeHistory`: Change tracking for rollback functionality
   - `LLMCall`: Cost and usage tracking per AI interaction

### Key Features

- **Live Preview**: iframe with `srcdoc` for secure code execution
- **Real-time Gallery**: All participants see each other's work live
- **Code Sandbox**: CSP + iframe isolation for security
- **Cost Control**: Per-user spending limits with transparent tracking
- **Version History**: Code rollback functionality

## Required Environment Variables

Critical variables that must be set in `.env`:

```bash
# Azure OpenAI (Required)
AZURE_OPENAI_API_KEY=your-key
AZURE_OPENAI_ENDPOINT=https://your-endpoint.openai.azure.com/
AZURE_OPENAI_DEPLOYMENT=gpt-4.1-mini

# Security
SECRET_KEY=your-secret-key-change-this-in-production

# Workshop Settings
MAX_COST_PER_USER=1.00
MAX_API_CALLS_PER_MINUTE=10
```

## Database Schema Notes

- **Async SQLAlchemy**: All database operations are async
- **PostgreSQL 15+**: Primary database with JSON support
- **Cascade Deletes**: User deletion removes all associated data
- **Session-based Auth**: No passwords, session tokens only

## WebSocket Message Types

### Client → Server
- `ai_request`: User prompt + current code → AI generates response
- `code_update`: Manual code changes → Update website
- `ping`: Heartbeat for connection monitoring

### Server → Client
- `code_update`: New code from AI or manual changes
- `chat_message`: AI responses in chat interface
- `gallery_batch_update`: Batched updates for performance
- `cost_update`: Real-time cost tracking updates

## Security Considerations

- **Code Execution**: Sandbox with CSP headers, no `eval()`
- **Input Validation**: HTML sanitization, CSS validation
- **Rate Limiting**: API calls per minute per user
- **Cost Protection**: Hard limits to prevent runaway costs

## Workshop Flow

1. **Entry** (`/`): User joins with username
2. **Workshop** (`/workshop`): Main interface with chat, editor, preview
3. **Admin** (`/admin`): Real-time monitoring, cost tracking, data export

The first user automatically becomes admin. Workshop is designed for single-day events with 20-50 participants.

## Development Preferences

### Content Truncation Policy
- **NEVER truncate HTML, CSS, or JS content** without explicit user permission
- Truncation can break code structure and make previews malfunction
- Always ask user before implementing any content limits or truncation
- Full content should be sent for gallery updates and real-time previews