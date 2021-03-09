from fastapi import APIRouter

from app.api.api_v1.endpoints import photos

api_router = APIRouter()
# api_router.include_router(login.router, tags=["login"])
api_router.include_router(photos.router, prefix="/photos", tags=["photos"])
# api_router.include_router(utils.router, prefix="/utils", tags=["utils"])
# api_router.include_router(items.router, prefix="/items", tags=["items"])
