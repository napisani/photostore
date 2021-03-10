import io
import json

from fastapi import APIRouter, Depends
from fastapi import File, UploadFile
from loguru import logger
from sqlalchemy.orm import Session
from starlette.responses import StreamingResponse

from app.api import deps
from app.exception.photo_exceptions import PhotoExceptions
from app.schemas.health_schema import HealthSchema
from app.schemas.pagination_schema import PaginationSchema
from app.schemas.photo_schema import PhotoSchema
from app.service.photo_service import get_photos, allowed_file, add_photo, get_photo

router = APIRouter()


@router.get("/health", response_model=HealthSchema)
def api_get_health(
        db: Session = Depends(deps.get_db)
) -> PaginationSchema[PhotoSchema]:
    """
    health check
    """
    health = HealthSchema()
    health.status = 'OKAY'
    logger.debug('api_get_health {}', health)

    return health


@router.get("/", response_model=PaginationSchema[PhotoSchema])
def api_get_photos(
        db: Session = Depends(deps.get_db),
        page: int = 1
) -> PaginationSchema[PhotoSchema]:
    """
    Retrieve photos by page.
    """
    photos = get_photos(db, page, 20)
    logger.debug('view_get_photos {}', photos)
    logger.debug('view_get_photos {}', photos.__dict__)

    return photos


@router.post('/upload', response_model=PhotoSchema)
def api_upload_photo(db: Session = Depends(deps.get_db),
                     file: UploadFile = File(...),
                     metadata: UploadFile = File(...)):
    meta = json.load(metadata.file)
    logger.debug(f'metadata: {meta}, file: {file}')

    # check if the post request has the file part
    if file is None:
        raise PhotoExceptions.no_file_passed()
    if metadata is None:
        raise PhotoExceptions.metadata_not_passed()

    # if user does not select file, browser also
    # submit an empty part without filename
    if file.filename == '':
        raise PhotoExceptions.filename_not_passed()
    if not file or not allowed_file(file.filename):
        raise PhotoExceptions.invalid_photo_passed()
    # logger.debug(f'json_metadata: {json_metadata}')
    photo_info = PhotoSchema.parse_obj(meta)
    added_photo = add_photo(db, photo=photo_info, file=file)
    logger.debug('view_upload_photo added_photo {}', added_photo)
    return added_photo


@router.get('/fullsize/{photo_id}')
def api_get_fullsize_image(photo_id: int, db: Session = Depends(deps.get_db)):
    photo = get_photo(db, photo_id=photo_id)
    logger.debug('view_get_fullsize photo: {}', photo)
    with open(photo.path, 'rb') as f:
        return StreamingResponse(io.BytesIO(f.read()), media_type="image/png")


@router.get('/thumbnail/{photo_id}')
def api_get_thumbnail_image(photo_id: int, db: Session = Depends(deps.get_db)):
    photo = get_photo(db, photo_id=photo_id)
    logger.debug('view_get_fullsize photo: {}', photo)
    with open(photo.thumbnail_path, 'rb') as f:
        return StreamingResponse(io.BytesIO(f.read()), media_type="image/png")
