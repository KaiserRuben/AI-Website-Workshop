from pydantic_settings import BaseSettings
from functools import lru_cache
from typing import Optional


class Settings(BaseSettings):
    # Server settings
    port: int = 8000
    environment: str = "development"

    # Database settings
    database_url: str = "postgresql://workshop:workshop@postgres:5432/workshop"
    sql_echo: bool = False

    # Security settings
    secret_key: str = "supersecretdevelopmentkey"
    jwt_algorithm: str = "HS256"
    session_expire_hours: int = 24

    # Azure AI settings (supports both OpenAI and AI Inference endpoints)
    azure_openai_api_key: str
    azure_openai_endpoint: str
    azure_openai_deployment: str = "gpt-4.1"  # For Azure OpenAI deployments
    azure_openai_api_version: str = "2024-12-01-preview"
    azure_model_name: str = "DeepSeek-R1-0528"  # For Azure AI Inference models

    # Workshop settings
    max_cost_per_user: float = 0.10
    max_api_calls_per_minute: int = 10
    workshop_admin_password: Optional[str] = None

    # WebSocket settings
    ws_heartbeat_interval: int = 30
    ws_max_connections: int = 100

    # Gallery settings
    gallery_update_batch_interval: float = 0.5

    # CORS settings
    allowed_origins: str = "*"

    # Logging
    log_level: str = "INFO"

    # Cost calculation (gpt-4.1-mini)
    # cost_per_1m_input_tokens: float = 0.40
    # cost_per_1m_output_tokens: float = 1.60
    # Cost calculation (gpt-4.1)
    cost_per_1m_input_tokens: float = 2
    cost_per_1m_output_tokens: float = 8

    class Config:
        env_file = ".env"
        case_sensitive = False


@lru_cache()
def get_settings() -> Settings:
    return Settings()
