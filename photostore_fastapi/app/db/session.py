from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker

from app.core.config import settings

# engine = create_engine(settings.SQLALCHEMY_DATABASE_URI, pool_pre_ping=True, max_overflow=-1)
# SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

engine_async = create_async_engine(
    f"postgresql+asyncpg://{settings.POSTGRES_USER}:{settings.POSTGRES_PASSWORD}@{settings.POSTGRES_SERVER}/{settings.POSTGRES_DB}",
    pool_pre_ping=True, max_overflow=-1, echo=True,
)

SessionLocalAsync = sessionmaker(
    bind=engine_async, expire_on_commit=False, class_=AsyncSession, autocommit=False, autoflush=False
)
