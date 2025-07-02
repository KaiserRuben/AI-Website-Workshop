import logging
from contextlib import asynccontextmanager
from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from fastapi.responses import HTMLResponse
import structlog

from app.config import get_settings
from app.database import init_db
from app.routers import auth, workshop, projects, websocket, admin, images, public
from app.middleware import AuthenticationMiddleware
from app.services.deployment import get_published_site

# Configure structured logging
structlog.configure(
    processors=[
        structlog.stdlib.filter_by_level,
        structlog.stdlib.add_logger_name,
        structlog.stdlib.add_log_level,
        structlog.stdlib.PositionalArgumentsFormatter(),
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.StackInfoRenderer(),
        structlog.processors.format_exc_info,
        structlog.processors.UnicodeDecoder(),
        structlog.dev.ConsoleRenderer()
    ],
    context_class=dict,
    logger_factory=structlog.stdlib.LoggerFactory(),
    cache_logger_on_first_use=True,
)

logger = structlog.get_logger()
settings = get_settings()

# Templates
templates = Jinja2Templates(directory="app/templates")


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Application lifespan manager"""
    # Startup
    logger.info("Starting KI Website Workshop Portal", environment=settings.environment)
    await init_db()
    logger.info("Database initialized")
    
    yield
    
    # Shutdown
    logger.info("Shutting down KI Website Workshop Portal")


# Create FastAPI app
app = FastAPI(
    title="KI Website Workshop",
    description="Workshop-System für Jugendliche zum Erstellen eigener Websites mit KI",
    version="1.0.0",
    lifespan=lifespan
)

# Add middlewares - CORS first, then auth
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.allowed_origins.split(",") if settings.allowed_origins != "*" else ["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.add_middleware(AuthenticationMiddleware)

# Mount static files
app.mount("/static", StaticFiles(directory="app/static"), name="static")

# Include routers
app.include_router(auth.router, prefix="/api", tags=["auth"])
app.include_router(workshop.router, prefix="/api", tags=["workshop"])
app.include_router(projects.router, prefix="/api", tags=["projects"])
app.include_router(images.router, tags=["images"])
app.include_router(websocket.router, tags=["websocket"])
app.include_router(admin.router, prefix="/api/admin", tags=["admin"])
app.include_router(public.router, tags=["public"])


@app.get("/", response_class=HTMLResponse)
async def root(request: Request):
    """Workshop entry page or published site"""
    host = request.headers.get("host", "")
    
    # Check if this is a subdomain request for a published site
    if "." in host and not host.startswith("workshop.") and not host in ["localhost", "127.0.0.1"]:
        # Extract subdomain (everything before the first dot)
        subdomain = host.split(".")[0]
        published_site = await get_published_site(subdomain)
        if published_site:
            return HTMLResponse(content=published_site)
    
    # Check if user is already logged in and redirect to landing
    user = getattr(request.state, 'user', None)
    if user:
        return templates.TemplateResponse(
            "landing.html",
            {"request": request, "title": "SkillSpace - Lernpfad"}
        )
    
    # Default workshop entry page for non-authenticated users
    return templates.TemplateResponse(
        "entry.html",
        {"request": request, "title": "KI Website Workshop"}
    )


@app.get("/landing", response_class=HTMLResponse)
async def landing_page(request: Request):
    """New landing page with recent projects and template guidance"""
    return templates.TemplateResponse(
        "landing.html",
        {"request": request, "title": "SkillSpace - Lernpfad"}
    )


@app.get("/workshop", response_class=HTMLResponse)
async def workshop_page(request: Request):
    """Main workshop interface"""
    # User authentication is handled by middleware
    return templates.TemplateResponse(
        "workshop.html",
        {"request": request, "title": "Workshop"}
    )


@app.get("/admin", response_class=HTMLResponse)
async def admin_page(request: Request):
    """Admin dashboard"""
    # User authentication is handled by middleware
    return templates.TemplateResponse(
        "admin.html",
        {"request": request, "title": "Admin Dashboard"}
    )


@app.get("/gallery", response_class=HTMLResponse)
async def gallery_page(request: Request):
    """Project gallery page"""
    return templates.TemplateResponse(
        "gallery.html",
        {"request": request, "title": "Projekt-Galerie"}
    )


@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "environment": settings.environment,
        "version": "1.0.0"
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "app.main:app",
        host="0.0.0.0",
        port=settings.port,
        reload=settings.environment == "development"
    )