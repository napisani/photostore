import secrets
from typing import Any, Dict, List, Optional, Union

from pydantic import AnyHttpUrl, BaseSettings, validator
from dotenv import load_dotenv, find_dotenv
load_dotenv(find_dotenv(raise_error_if_not_found=True), verbose=True)

def assemble_db_connection(v: Optional[str], values: Dict[str, Any], is_async=False) -> Any:
    if isinstance(v, str):
        return v
    if values.get('DB_TYPE').upper() == 'POSTGRES':
        driver = 'postgresql'
        if is_async:
            driver += '+asyncpg'
        return f"{driver}://{values.get('POSTGRES_USER')}:{values.get('POSTGRES_PASSWORD')}@{values.get('POSTGRES_SERVER')}/{values.get('POSTGRES_DB')}"
    driver = 'sqlite'
    if is_async:
        driver += '+aiosqlite'
    return f"{driver}://{values.get('SQLITE_FILE')}"


class Settings(BaseSettings):
    API_V1_STR: str = "/api/v1"
    SECRET_KEY: str = secrets.token_urlsafe(32)

    API_KEY: Optional[str]
    PROJECT_ROOT: str
    PROJECT_NAME: str
    # 60 minutes * 24 hours * 8 days = 8 days
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 8
    # SERVER_HOST: AnyHttpUrl
    # BACKEND_CORS_ORIGINS is a JSON-formatted list of origins
    # e.g: '["http://localhost", "http://localhost:4200", "http://localhost:3000", \
    # "http://localhost:8080", "http://local.dockertoolbox.tiangolo.com"]'
    BACKEND_CORS_ORIGINS: List[AnyHttpUrl] = []

    @validator("BACKEND_CORS_ORIGINS", pre=True)
    def assemble_cors_origins(cls, v: Union[str, List[str]]) -> Union[List[str], str]:
        if isinstance(v, str) and not v.startswith("["):
            return [i.strip() for i in v.split(",")]
        elif isinstance(v, (list, str)):
            return v
        raise ValueError(v)

    DB_TYPE: str
    SQLITE_FILE: Optional[str]
    POSTGRES_SERVER: Optional[str]
    POSTGRES_USER: Optional[str]
    POSTGRES_PASSWORD: Optional[str]
    POSTGRES_DB: Optional[str]
    DATABASE_URI_ASYNC: Optional[str] = None
    DATABASE_URI: Optional[str] = None

    @validator("DATABASE_URI_ASYNC", pre=True)
    def assemble_db_uri_async(cls, v: Optional[str], values: Dict[str, Any]):
        return assemble_db_connection(v, values, True)

    @validator("DATABASE_URI", pre=True)
    def assemble_db_uri(cls, v: Optional[str], values: Dict[str, Any]):
        return assemble_db_connection(v, values, False)

    GOOGLE_PHOTOS_OAUTH_FILE: Optional[str]
    SAVE_PHOTO_DIR: str

    THUMBNAIL_HEIGHT: int
    THUMBNAIL_WIDTH: int

    class Config:
        case_sensitive = True
        env_file = 'env_example_sqlite'


settings = Settings()
