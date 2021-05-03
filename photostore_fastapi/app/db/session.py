from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker

from app.core.config import settings

# import aiosqlite
#
# _unused = aiosqlite
# engine = create_engine(settings.SQLALCHEMY_DATABASE_URI, pool_pre_ping=True, max_overflow=-1)
# SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# engine_async = create_async_engine(
#     f"postgresql+asyncpg://{settings.POSTGRES_USER}:{settings.POSTGRES_PASSWORD}@{settings.POSTGRES_SERVER}/{settings.POSTGRES_DB}",
#     pool_pre_ping=True, max_overflow=-1, echo=True,
# )

# engine_async = create_async_engine("sqlite+aiosqlite:////tmp/photostore.db", echo=True, future=True)

engine_async = create_async_engine(
    settings.DATABASE_URI_ASYNC, echo=True, future=True
)

SessionLocalAsync = sessionmaker(
    bind=engine_async, expire_on_commit=False, class_=AsyncSession, autocommit=False, autoflush=False
)

# engine_async = create_engine("sqlite:////tmp/photostore.db", echo=True)
# SessionLocalAsync = sessionmaker(autocommit=False, autoflush=False, bind=engine_async)
