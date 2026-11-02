
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    """Konfigurasi dibaca dari environment variable."""
    database_url: str = (
        "mysql+pymysql://tabungku:rahasia_tabungku@localhost:3307/tabungku"
    )


settings = Settings()
