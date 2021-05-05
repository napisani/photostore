from fastapi import APIRouter

from app.api.api_v1.endpoints import photos, albums

api_router = APIRouter()
# api_router.include_router(login.router, tags=["login"])
api_router.include_router(photos.router, prefix="/photos", tags=["photos"])
api_router.include_router(albums.router, prefix="/albums", tags=["albums"])
