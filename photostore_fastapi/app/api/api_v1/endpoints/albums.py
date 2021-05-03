# from fastapi import APIRouter, Depends
# from fastapi.openapi.models import APIKey
# from loguru import logger
# from sqlalchemy.orm import Session
#
# from app.api import deps
# from app.api.deps import get_api_key
# from app.obj.photo_sort_attribute import PhotoSortAttribute
# from app.obj.sort_direction import SortDirection
# from app.schemas.pagination_schema import PaginationSchema
# from app.schemas.photo_schema import PhotoSchemaFull
# from app.service.photo_service import get_photos
#
# router = APIRouter()
#
#
# @router.get("/albums/{page}", response_model=PaginationSchema[PhotoSchemaFull])
# async def api_get_albums(
#         api_key: APIKey = Depends(get_api_key),
#         db: Session = Depends(deps.get_async_db),
#         page: int = 1,
#         per_page: int = 10,
#         sort: PhotoSortAttribute = PhotoSortAttribute.creation_date,
#         direction: SortDirection = SortDirection.desc,
# ) -> PaginationSchema[PhotoSchemaFull]:
#     """
#     Retrieve photos by page.
#     """
#     logger.debug(f'in api_get_photos page: {page}, per_page:{per_page}, device_id: {device_id}')
#     pagination = await get_photos(db, page, per_page, sort, direction, device_id)
#     return pagination
#
