from datetime import datetime, timedelta
from typing import Optional
from fastapi import APIRouter, Depends, HTTPException, Response, Request
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from pydantic import BaseModel
import secrets

from app.database import get_db
from app.models import User, Workshop, Website, UserRole
from app.config import get_settings

router = APIRouter()
settings = get_settings()


class SignupRequest(BaseModel):
    username: str
    password: str


class LoginRequest(BaseModel):
    username: str
    password: str


class AuthResponse(BaseModel):
    session_token: str
    user_id: int
    role: str
    workshop_name: str


async def get_current_user(request: Request, db: AsyncSession = Depends(get_db)) -> User:
    """Get current user from session token"""
    session_token = request.cookies.get("session_token")
    if not session_token:
        raise HTTPException(status_code=401, detail="Nicht angemeldet")
    
    result = await db.execute(
        select(User).where(User.session_token == session_token)
    )
    user = result.scalar_one_or_none()
    
    if not user:
        raise HTTPException(status_code=401, detail="Ungültige Session")
    
    # Update last seen
    user.last_seen = datetime.utcnow()
    await db.commit()
    
    return user


@router.post("/signup", response_model=AuthResponse)
async def signup(
    signup_request: SignupRequest,
    response: Response,
    db: AsyncSession = Depends(get_db)
):
    """Create new user account"""
    # Get active workshop
    result = await db.execute(
        select(Workshop).where(Workshop.is_active == True)
    )
    workshop = result.scalar_one_or_none()
    
    if not workshop:
        # Create new workshop if none exists
        workshop = Workshop(
            name=f"Workshop {datetime.now().strftime('%d.%m.%Y')}",
            date=datetime.now().date(),
            is_active=True
        )
        db.add(workshop)
        await db.commit()
    
    # Check if username is taken in this workshop
    result = await db.execute(
        select(User)
        .where(User.workshop_id == workshop.id)
        .where(User.username == signup_request.username)
    )
    existing_user = result.scalar_one_or_none()
    
    if existing_user:
        raise HTTPException(status_code=400, detail="Nutzername bereits vergeben")
    
    # Determine role
    result = await db.execute(
        select(User).where(User.workshop_id == workshop.id)
    )
    users = result.scalars().all()
    
    is_first_user = len(users) == 0
    role = UserRole.ADMIN if is_first_user else UserRole.PARTICIPANT
    
    # Create user
    session_token = secrets.token_urlsafe(32)
    user = User(
        workshop_id=workshop.id,
        username=signup_request.username,
        display_name=signup_request.username,
        session_token=session_token,
        role=role
    )
    user.set_password(signup_request.password)
    db.add(user)
    await db.commit()
    
    # Set admin if first user
    if is_first_user:
        workshop.admin_user_id = user.id
        await db.commit()
    
    # Create default website
    website = Website(
        user_id=user.id,
        name=f"{user.username}s Website"
    )
    db.add(website)
    await db.commit()
    
    # Set session cookie (persistent)
    response.set_cookie(
        key="session_token",
        value=session_token,
        httponly=True,
        secure=settings.environment == "production",
        samesite="strict",
        max_age=settings.session_expire_hours * 3600
    )
    
    return AuthResponse(
        session_token=session_token,
        user_id=user.id,
        role=role.value,
        workshop_name=workshop.name
    )


@router.post("/login", response_model=AuthResponse)
async def login(
    login_request: LoginRequest,
    response: Response,
    db: AsyncSession = Depends(get_db)
):
    """Login existing user"""
    # Get active workshop
    result = await db.execute(
        select(Workshop).where(Workshop.is_active == True)
    )
    workshop = result.scalar_one_or_none()
    
    if not workshop:
        raise HTTPException(status_code=401, detail="Ungültige Anmeldedaten")
    
    # Find user by username in current workshop
    result = await db.execute(
        select(User)
        .where(User.workshop_id == workshop.id)
        .where(User.username == login_request.username)
    )
    user = result.scalar_one_or_none()
    
    if not user or not user.verify_password(login_request.password):
        raise HTTPException(status_code=401, detail="Ungültige Anmeldedaten")
    
    # Generate new session token
    session_token = secrets.token_urlsafe(32)
    user.session_token = session_token
    user.last_seen = datetime.utcnow()
    await db.commit()
    
    # Set session cookie (persistent)
    response.set_cookie(
        key="session_token",
        value=session_token,
        httponly=True,
        secure=settings.environment == "production",
        samesite="strict",
        max_age=settings.session_expire_hours * 3600
    )
    
    return AuthResponse(
        session_token=session_token,
        user_id=user.id,
        role=user.role.value,
        workshop_name=workshop.name
    )


@router.post("/logout")
async def logout(response: Response):
    """Logout user"""
    response.delete_cookie("session_token")
    return {"message": "Erfolgreich abgemeldet"}


class UsernameCheckResponse(BaseModel):
    available: bool
    message: Optional[str] = None


@router.get("/check-username", response_model=UsernameCheckResponse)
async def check_username(
    username: str,
    db: AsyncSession = Depends(get_db)
):
    """Check if username is available"""
    # Get active workshop
    result = await db.execute(
        select(Workshop).where(Workshop.is_active == True)
    )
    workshop = result.scalar_one_or_none()
    
    if not workshop:
        return UsernameCheckResponse(available=True)
    
    # Check if username exists in current workshop
    result = await db.execute(
        select(User)
        .where(User.workshop_id == workshop.id)
        .where(User.username == username)
    )
    existing_user = result.scalar_one_or_none()
    
    if existing_user:
        return UsernameCheckResponse(
            available=False,
            message="Dieser Name ist bereits vergeben"
        )
    
    return UsernameCheckResponse(available=True)


class JoinRequest(BaseModel):
    username: str
    password: str


@router.post("/join", response_model=AuthResponse)
async def join_workshop(
    join_request: JoinRequest,
    response: Response,
    db: AsyncSession = Depends(get_db)
):
    """Join workshop with username only (no password)"""
    # Get active workshop
    result = await db.execute(
        select(Workshop).where(Workshop.is_active == True)
    )
    workshop = result.scalar_one_or_none()
    
    if not workshop:
        # Create new workshop if none exists
        workshop = Workshop(
            name=f"Workshop {datetime.now().strftime('%d.%m.%Y')}",
            date=datetime.now().date(),
            is_active=True
        )
        db.add(workshop)
        await db.commit()
    
    # Check if username is taken in this workshop
    result = await db.execute(
        select(User)
        .where(User.workshop_id == workshop.id)
        .where(User.username == join_request.username)
    )
    existing_user = result.scalar_one_or_none()
    
    if existing_user:
        raise HTTPException(status_code=400, detail="Nutzername bereits vergeben")
    
    # Determine role
    result = await db.execute(
        select(User).where(User.workshop_id == workshop.id)
    )
    users = result.scalars().all()
    
    is_first_user = len(users) == 0
    role = UserRole.ADMIN if is_first_user else UserRole.PARTICIPANT
    
    # Create user with provided password
    session_token = secrets.token_urlsafe(32)
    user = User(
        workshop_id=workshop.id,
        username=join_request.username,
        display_name=join_request.username,
        session_token=session_token,
        role=role
    )
    user.set_password(join_request.password)
    db.add(user)
    await db.commit()
    
    # Set admin if first user
    if is_first_user:
        workshop.admin_user_id = user.id
        await db.commit()
    
    # Create default website
    website = Website(
        user_id=user.id,
        name=f"{user.username}s Website",
        html="<h1>Willkommen auf meiner Website!</h1>",
        css="body { font-family: Arial, sans-serif; margin: 20px; }"
    )
    db.add(website)
    await db.commit()
    
    # Set session cookie (persistent)
    response.set_cookie(
        key="session_token",
        value=session_token,
        httponly=True,
        secure=settings.environment == "production",
        samesite="strict",
        max_age=settings.session_expire_hours * 3600
    )
    
    return AuthResponse(
        session_token=session_token,
        user_id=user.id,
        role=role.value,
        workshop_name=workshop.name
    )