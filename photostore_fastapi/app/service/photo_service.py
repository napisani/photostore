import os
import re
import shutil
from typing import Optional, List, Awaitable

import magic
from PIL import Image
from loguru import logger
from pyheif_pillow_opener import register_heif_opener
from sqlalchemy.orm import Session

# from werkzeug.utils import secure_filename
from app.core.config import settings
# register to support .HEIC files
from app.crud.crud_photo import PhotoRepo
from app.exception.photo_exceptions import PhotoExceptions
from app.models.pagination import Pagination
from app.models.photo_model import Photo
from app.schemas.pagination_schema import PaginationSchema
from app.schemas.photo_schema import PhotoSchemaFull, PhotoSchemaAdd, PhotoSchemaUpdate, PhotoDiffRequestSchema, \
    PhotoDiffResultSchema
from app.utils import get_file_checksum

register_heif_opener()
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif', 'heic'}


def secure_filename(uploaded_file_name):
    return uploaded_file_name  # todo


def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


def _get_destination_path(filename, thumbnail=False):
    d = settings.SAVE_PHOTO_DIR
    if thumbnail:
        d = os.path.join(d, 'thumb')
    if not os.path.exists(d):
        os.mkdir(d)
    destination_file = os.path.join(d, filename)
    return destination_file


def _get_unique_filename(filename):
    if not os.path.exists(_get_destination_path(filename)):
        return filename
    filename_split = os.path.splitext(filename)

    match = re.search('_\\([0-9]+\\)$', filename_split[0])
    if not match:
        return _get_unique_filename(f'{filename_split[0]}_(1){filename_split[1]}')
    else:
        match_text = match.group(0)
        idx = int(match_text[2:-1]) + 1
        filename_pre = re.sub('_\\([0-9]+\\)$', f'_({idx})', filename_split[0])
        return _get_unique_filename(f'{filename_pre}{filename_split[1]}')


def _save_photo_file(filename: str, uploaded_file):
    try:
        filename = secure_filename(filename)
        filename = _get_unique_filename(filename)
        destination_file = _get_destination_path(filename)
        # uploaded_file.save(destination_file)
        with open(destination_file, 'wb') as dest_file:
            shutil.copyfileobj(uploaded_file, dest_file)
        return {"filename": filename, 'path': destination_file}
    except:
        raise
        raise PhotoExceptions.failed_to_save_photo_file()


def _create_thumbnail(photo_path, photo_filename):
    try:

        thumb_path = _get_destination_path(photo_filename, thumbnail=True)
        filename_only, file_extension = os.path.splitext(photo_path)
        if file_extension.lower() in ['.heic']:
            logger.debug('_create_thumbnail working on heic file {}', photo_path)
            # with open(photo_path, 'rb') as photo_stream:
            #     heif_file = pyheif.read(photo_stream.read())
            #     image = Image.frombytes(
            #         heif_file.mode,
            #         heif_file.size,
            #         heif_file.data,
            #         "raw",
            #         heif_file.mode,
            #         heif_file.stride,
            #     )
            thumb_only, thumb_ext = os.path.splitext(thumb_path)
            thumb_path = thumb_only + '.png'
        # else:
        logger.debug('_create_thumbnail working on NON heic file {}', photo_path)
        image = Image.open(photo_path)
        image.thumbnail((500, 500))
        # creating thumbnail
        logger.debug('creating thumbnail {}', thumb_path)
        image.save(thumb_path)
        return thumb_path
    except:
        raise
        raise PhotoExceptions.failed_to_save_photo_file()


async def add_photo(db: Session, photo: PhotoSchemaAdd, file) -> PhotoSchemaFull:
    logger.debug('in add_photo photo: {}', photo)
    # photo.id = None
    base_path, filename = os.path.split(photo.filename)
    photo.filename = filename
    save_file_return = _save_photo_file(photo.filename, file)
    logger.debug('in add_photo save_file_return :{}', save_file_return)
    photo_full = PhotoSchemaFull.parse_obj(photo.dict())

    photo_full.filename = save_file_return['filename']
    photo_full.path = save_file_return['path']
    photo_full.checksum = get_file_checksum(photo_full.path)
    photo_full.thumbnail_path = _create_thumbnail(photo_filename=photo_full.filename,
                                                  photo_path=photo_full.path)
    mime = magic.Magic(mime=True)
    photo_full.mime_type = mime.from_file(photo_full.path)
    try:
        added_photo = await PhotoRepo.create(db, obj_in=photo_full)
    except:
        raise
        raise PhotoExceptions.failed_to_save_photo_to_db()

    logger.debug('in add_photo added_photo :{}', added_photo)
    return PhotoSchemaFull.from_orm(added_photo)


async def delete_photo(db: Session, photo_id: int):
    photo = await get_photo(db, photo_id)
    if not photo:
        raise PhotoExceptions.photo_not_found()
    if os.path.exists(photo.path):
        try:
            os.remove(photo.path)
        except:
            raise
            raise PhotoExceptions.failed_to_delete_photo_file()
    try:
        await PhotoRepo.remove(db, id=photo.id)
    except:
        raise
        raise PhotoExceptions.failed_to_delete_photo_from_db()


async def get_photo(db: Session, photo_id: int) -> PhotoSchemaFull:
    return PhotoSchemaFull.from_orm(await PhotoRepo.get_by_id(db, id=photo_id))


async def get_latest_photo(db: Session, device_id: str) -> Optional[PhotoSchemaFull]:
    photo = await PhotoRepo.get_latest_photo(db, device_id)
    return PhotoSchemaFull.from_orm(photo)


async def update_photo(db: Session, photo: PhotoSchemaUpdate) -> PhotoSchemaFull:
    saved_photo = await PhotoRepo.get_by_id(db, id=photo.id)
    # current = copy.deepcopy(saved_photo)
    if not saved_photo:
        raise PhotoExceptions.photo_not_found()
    # saved_photo.media_metadata = photo.media_metadata
    # saved_photo.gphoto_id = photo.gphoto_id
    # saved_photo.creation_date = photo.creation_date

    return PhotoSchemaFull.from_orm(await PhotoRepo.update(db, db_obj=saved_photo, obj_in=photo))


async def get_photos(db: Session, page: int, per_page: int = 10) -> Awaitable[Pagination]:
    photos = await PhotoRepo.get_photos(db, page=page, per_page=per_page)
    pagination = PaginationSchema.from_orm(photos)
    pagination.items = [PhotoSchemaFull.from_orm(p) for p in photos.items]
    return pagination


async def diff_photos(db: Session, diff_reqs: List[PhotoDiffRequestSchema]) -> List[PhotoDiffResultSchema]:
    pairs = [(req.device_id, req.native_id) for req in diff_reqs]
    photos = await  PhotoRepo.get_photos_by_native_ids(db=db, device_native_id_pairs=pairs)

    existing_dict = {photo.native_id: photo for photo in photos}
    return [_make_diff_result(req, existing_dict.get(req.native_id)) for req in diff_reqs]


def _make_diff_result(req: PhotoDiffRequestSchema, photo: Photo) -> PhotoDiffResultSchema:
    res = PhotoDiffResultSchema(exists=False,
                                same_date=False,
                                same_checksum=False,
                                native_id=req.native_id,
                                device_id=req.device_id)
    if not photo:
        return res
    res.exists = True
    res.same_date = photo.modified_date == req.modified_date
    res.same_checksum = photo.checksum == req.checksum
    res.photo_id = photo.id
    return res


async def count_photos(db: Session, device_id: str) -> int:
    return await PhotoRepo.get_photo_count_by_device_id(db, device_id)
