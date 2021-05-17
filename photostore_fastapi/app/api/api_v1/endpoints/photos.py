import io
import json
from datetime import datetime
from typing import List

from fastapi import APIRouter, Depends
from fastapi import File, UploadFile
from fastapi.openapi.models import APIKey
from loguru import logger
from sqlalchemy.orm import Session
from starlette.responses import StreamingResponse

from app.api import deps
from app.api.deps import get_api_key
from app.exception.photo_exceptions import PhotoExceptions
from app.obj.media_type import MediaType
from app.obj.photo_sort_attribute import PhotoSortAttribute
from app.obj.sort_direction import SortDirection
from app.schemas.health_schema import HealthSchema
from app.schemas.pagination_schema import PaginationSchema
from app.schemas.photo_schema import PhotoSchemaAdd, PhotoSchemaFull, PhotoDiffRequestSchema, PhotoDiffResultSchema, \
    DeviceResultSchema, PhotoDateRangeSchema
from app.service.photo_service import get_photos, add_photo, get_photo, diff_photos, get_latest_photo, \
    count_photos, allowed_file, delete_photos_by_device, get_devices, get_fullsize_photo_as_png, get_photo_date_ranges, \
    delete_photo

router = APIRouter()


@router.get("/health", response_model=HealthSchema)
async def api_get_health(
        api_key: APIKey = Depends(get_api_key),
        db: Session = Depends(deps.get_async_db)
) -> HealthSchema:
    """
    health check
    """
    health = HealthSchema()
    health.status = 'OKAY'
    logger.debug('api_get_health {}', health)

    return health


@router.get("/page/{page}", response_model=PaginationSchema[PhotoSchemaFull])
async def api_get_photos(
        api_key: APIKey = Depends(get_api_key),
        db: Session = Depends(deps.get_async_db),
        page: int = 1,
        per_page: int = 10,
        sort: PhotoSortAttribute = PhotoSortAttribute.creation_date,
        direction: SortDirection = SortDirection.desc,
        device_id: str = None,
        album_name: str = None,
        before_modified_date: datetime = None
) -> PaginationSchema[PhotoSchemaFull]:
    """
    Retrieve photos by page.
    """
    logger.debug(f'in api_get_photos page: {page}, per_page:{per_page}, device_id: {device_id}')
    pagination = await get_photos(db, page, per_page, sort, direction, device_id, album_name, before_modified_date)
    return pagination


@router.post('/upload', response_model=PhotoSchemaFull)
async def api_upload_photo(
        api_key: APIKey = Depends(get_api_key),
        db: Session = Depends(deps.get_async_db),
        file: UploadFile = File(...),
        metadata: UploadFile = File(...)) -> PhotoSchemaFull:
    meta = json.load(metadata.file)
    logger.debug(f'metadata: {meta}, file: {file}')

    # check if the post request has the file part
    if file is None:
        raise PhotoExceptions.no_file_passed()
    if metadata is None:
        raise PhotoExceptions.metadata_not_passed()

    # if user does not select file, browser also
    # submit an empty part without filename
    photo_info = PhotoSchemaAdd.parse_obj(meta)
    logger.debug(f'photo_info: {photo_info}')

    if photo_info.filename == '':
        raise PhotoExceptions.filename_not_passed()
    if not file or not allowed_file(photo_info.filename):
        raise PhotoExceptions.invalid_photo_passed()

    added_photo = await add_photo(db, photo=photo_info, file=file.file)
    logger.debug('view_upload_photo added_photo {}', added_photo)
    return added_photo


@router.get('/fullsize_photo/{photo_id}')
async def api_get_fullsize_photo(photo_id: int,
                                 api_key: APIKey = Depends(get_api_key),
                                 db: Session = Depends(deps.get_async_db)):
    photo = await get_photo(db, photo_id=photo_id)
    logger.debug('view_get_fullsize photo: {}', photo)
    p = photo.path
    mime = photo.mime_type
    if photo.media_type == MediaType.VIDEO:
        p = photo.thumbnail_path
        mime = 'image/png'
    with open(p, 'rb') as f:
        return StreamingResponse(io.BytesIO(f.read()), media_type=mime)


@router.get('/?/{photo_id}')
async def api_get_original_file(photo_id: int,
                                api_key: APIKey = Depends(get_api_key),
                                db: Session = Depends(deps.get_async_db)):
    photo = await get_photo(db, photo_id=photo_id)
    logger.debug('api_get_original_file photo: {}', photo)
    with open(photo.path, 'rb') as f:
        return StreamingResponse(io.BytesIO(f.read()), media_type=photo.mime_type)


@router.get('/fullsize_photo_as_png/{photo_id}')
async def api_get_fullsize_photo_as_png(photo_id: int,
                                        api_key: APIKey = Depends(get_api_key),
                                        db: Session = Depends(deps.get_async_db)):
    logger.debug('api_get_fullsize_photo_as_png photo_id: {}', photo_id)
    photo_bytes = await get_fullsize_photo_as_png(db, photo_id=photo_id)
    return StreamingResponse(photo_bytes, media_type='image/png')


@router.get('/thumbnail/{photo_id}')
async def api_get_thumbnail_image(photo_id: int, db: Session = Depends(deps.get_async_db),
                                  api_key: APIKey = Depends(get_api_key)):
    photo = await get_photo(db, photo_id=photo_id)
    logger.debug('view_get_fullsize photo: {}', photo)
    with open(photo.thumbnail_path, 'rb') as f:
        return StreamingResponse(io.BytesIO(f.read()), media_type="image/png")


@router.post('/diff', response_model=List[PhotoDiffResultSchema])
async def api_do_diff(diff_items: List[PhotoDiffRequestSchema],
                      api_key: APIKey = Depends(get_api_key),
                      db: Session = Depends(deps.get_async_db)) \
        -> List[PhotoDiffResultSchema]:
    result_list = await diff_photos(db=db, diff_reqs=diff_items)
    logger.debug('api_do_diff result_list: {}', result_list)
    return result_list


@router.get('/latest/{device_id}', response_model=PhotoSchemaFull)
async def api_get_latest_photo_for_device(device_id: str, api_key: APIKey = Depends(get_api_key),
                                          db=Depends(deps.get_async_db)) -> PhotoSchemaFull:
    photo = await get_latest_photo(db=db, device_id=device_id)
    logger.debug('api_get_latest_photo_for_device photo: {}', photo)
    return photo


@router.get('/count/{device_id}', response_model=int)
async def api_get_photo_count(device_id: str, api_key: APIKey = Depends(get_api_key),
                              db=Depends(deps.get_async_db)) -> int:
    photo_count = await count_photos(db=db, device_id=device_id)
    logger.debug('api_get_photo_count photo_count: {}', photo_count)
    return photo_count


@router.delete('/delete_by_device/{device_id}')
async def api_delete_photos_by_device_id(device_id: str, api_key: APIKey = Depends(get_api_key),
                                         db=Depends(deps.get_async_db)):
    await delete_photos_by_device(db=db, device_id=device_id)
    logger.debug('api_delete_photos_by_device_id  {}', device_id)


@router.delete('/delete_by_id/{photo_id}')
async def api_delete_photos_by_id(photo_id: int, api_key: APIKey = Depends(get_api_key),
                                  db=Depends(deps.get_async_db)):
    await delete_photo(db=db, photo_id=photo_id)
    logger.debug('api_delete_photos_by_id  {}', photo_id)


@router.get('/devices', response_model=List[DeviceResultSchema])
async def api_get_devices(api_key: APIKey = Depends(get_api_key),
                          db=Depends(deps.get_async_db)) -> List[DeviceResultSchema]:
    logger.debug('inside api_get_devices')
    results = await get_devices(db=db)

    logger.debug('api_get_devices results: {}', results)

    return results


@router.get('/dates', response_model=PhotoDateRangeSchema)
async def api_get_date_ranges(api_key: APIKey = Depends(get_api_key),
                              db=Depends(deps.get_async_db)) -> PhotoDateRangeSchema:
    logger.debug('inside api_get_date_ranges')
    results = await get_photo_date_ranges(db=db)
    logger.debug('api_get_date_ranges results: {}', results)
    return results
