"""Application configuration using Pydantic Settings."""

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Main application settings."""
    debug: bool = False
    jwt_secret: str = "secret123"
    database_url: str = "DATABASE_URL=postgresql+psycopg://torio:123@localhost/bookshop"

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
    )


settings = Settings()  # type: ignore
