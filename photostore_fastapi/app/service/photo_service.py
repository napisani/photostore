import os
from datetime import datetime
from io import BytesIO
from typing import Optional, List

import magic
from loguru import logger
from pyheif_pillow_opener import register_heif_opener
from sqlalchemy.orm import Session

from app.crud.crud_photo import PhotoRepo
from app.exception.photo_exceptions import PhotoExceptions
from app.models.pagination import Pagination
from app.models.photo_model import Photo
from app.obj.photo_sort_attribute import PhotoSortAttribute
from app.obj.sort_direction import SortDirection
from app.schemas.pagination_schema import PaginationSchema
from app.schemas.photo_schema import PhotoSchemaFull, PhotoSchemaAdd, PhotoSchemaUpdate, PhotoDiffRequestSchema, \
    PhotoDiffResultSchema, DeviceResultSchema, PhotoDateRangeSchema
from app.service.image_file_helper import save_photo_file, create_thumbnail, get_allowed_extensions, \
    get_media_type_by_extension, get_media_as_png
from app.utils import get_file_checksum, get_file_extension

# from werkzeug.utils import secure_filename
# register to support .HEIC files

register_heif_opener()


def allowed_file(filename):
    return '.' in filename and \
           get_file_extension(filename) in get_allowed_extensions()


async def add_photo(db: Session, photo: PhotoSchemaAdd, file) -> PhotoSchemaFull:
    logger.debug('in add_photo photo: {}', photo)
    # photo.id = None
    base_path, filename = os.path.split(photo.filename)
    photo.filename = filename
    save_file_return = save_photo_file(photo.filename, photo.device_id, file)
    logger.debug('in add_photo save_file_return :{}', save_file_return)
    photo_full = PhotoSchemaFull.parse_obj(photo.dict())
    photo_full.media_type = get_media_type_by_extension(photo.filename)
    photo_full.filename = save_file_return['filename']
    photo_full.path = save_file_return['path']
    photo_full.checksum = get_file_checksum(photo_full.path)
    photo_full.thumbnail_path = create_thumbnail(filename=photo_full.filename,
                                                 path=photo_full.path,
                                                 device_id=photo.device_id,
                                                 media_type=photo_full.media_type)
    photo_full.file_size = os.path.getsize(photo_full.path) / 1024
    photo_full.thumbnail_file_size = os.path.getsize(photo_full.thumbnail_path) / 1024
    mime = magic.Magic(mime=True)
    photo_full.mime_type = mime.from_file(photo_full.path)
    try:
        added_photo = await PhotoRepo.create(db, obj_in=photo_full)
    except:
        raise
        raise PhotoExceptions.failed_to_save_photo_to_db()

    logger.debug('in add_photo added_photo :{}', added_photo)
    return PhotoSchemaFull.from_orm(added_photo)


async def delete_photos_by_device(db: Session, device_id: str):
    photos = await PhotoRepo.get_photos_by_device_id(db=db, device_id=device_id)
    logger.debug('delete_photos_by_device photo with photos: {}', photos)
    for photo in photos:
        try:
            logger.debug('deleting photo with id: {}', photo.id)
            await delete_photo(db, photo.id)
        except Exception as e:
            logger.warning(f"failed to delete photo with id: {photo.id} - {e}")


async def delete_photo(db: Session, photo_id: int):
    photo = await PhotoRepo.get_by_id(db, id=photo_id)
    if not photo:
        raise PhotoExceptions.photo_not_found()
    if os.path.exists(photo.path):
        try:
            os.remove(photo.path)
        except:
            raise PhotoExceptions.failed_to_delete_photo_file()
    if os.path.exists(photo.thumbnail_path):
        try:
            os.remove(photo.thumbnail_path)
        except:
            raise PhotoExceptions.failed_to_delete_thumbnail_file()
    try:
        # sync wrapper to support lazy loading with async db session
        def remove_photos_from_albums(sync_db_session):
            photo.albums = []
            sync_db_session.commit()

        await db.run_sync(remove_photos_from_albums)
        await PhotoRepo.remove(db, id=photo.id)
    except Exception as e:
        logger.error(f'delete_photo error:  {e}')
        raise PhotoExceptions.failed_to_delete_photo_from_db()


async def get_photo(db: Session, photo_id: int) -> PhotoSchemaFull:
    return PhotoSchemaFull.from_orm(await PhotoRepo.get_by_id(db, id=photo_id))


async def get_fullsize_photo_as_png(db: Session, photo_id: int) -> BytesIO:
    photo = await get_photo(db, photo_id=photo_id)
    logger.debug('get_fullsize_photo_as_png photo: {}', photo)
    return get_media_as_png(photo)


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


async def get_photos(db: Session,
                     page: int,
                     per_page: int = 10,
                     order_by=PhotoSortAttribute.modified_date,
                     direction=SortDirection.desc,
                     device_id: str = None,
                     album_name: str = None,
                     before_modified_date: datetime = None
                     ) -> Pagination:
    photos = await PhotoRepo.get_photos(db,
                                        page=page,
                                        per_page=per_page,
                                        order_by=order_by,
                                        direction=direction,
                                        device_id=device_id,
                                        album_name=album_name,
                                        before_modified_date=before_modified_date)
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


async def get_devices(db: Session) -> List[DeviceResultSchema]:
    devices = await PhotoRepo.get_devices(db)
    logger.info(devices)
    logger.debug('get_devices photo: {}', devices)
    results = [DeviceResultSchema(device_id=device_id, count=cnt, file_size_total=size_total,
                                  thumbnail_file_size_total=thumb_total) for device_id, cnt, size_total, thumb_total in
               devices]
    return results


async def get_photo_date_ranges(db: Session) -> PhotoDateRangeSchema:
    ranges = await PhotoRepo.get_photo_date_range(db)

    mod_min, mod_max, create_min, create_max = ranges[0]
    results = PhotoDateRangeSchema(modified_date_start=mod_min,
                                   modified_date_end=mod_max,
                                   create_date_start=create_min,
                                   create_date_end=create_max)
    return results
