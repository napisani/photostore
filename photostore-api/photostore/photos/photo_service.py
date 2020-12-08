import os
import re

import magic
from PIL import Image
from loguru import logger
from pyheif_pillow_opener import register_heif_opener
from werkzeug.utils import secure_filename

from photostore.photos.photo_exceptions import PhotoExceptions
from photostore.photos.photo_model import Photo
from photostore.settings import get_config
from photostore.utils import get_file_checksum

# register to support .HEIC files
register_heif_opener()
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif', 'heic'}


def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


def _get_destination_path(filename, thumbnail=False):
    config = get_config()
    d = config.SAVE_PHOTO_DIR
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


def _save_photo_file(uploaded_file):
    try:
        filename = secure_filename(uploaded_file.filename)
        filename = _get_unique_filename(filename)
        destination_file = _get_destination_path(filename)
        uploaded_file.save(destination_file)
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


def add_photo(photo: Photo, file):
    logger.debug('in add_photo photo: {}', photo)
    photo.id = None
    save_file_return = _save_photo_file(file)
    logger.debug('in add_photo save_file_return :{}', save_file_return)
    photo.filename = save_file_return['filename']
    photo.path = save_file_return['path']
    photo.checksum = get_file_checksum(photo.path)
    photo.thumbnail_path = _create_thumbnail(photo_filename=photo.filename,
                                             photo_path=photo.path)
    mime = magic.Magic(mime=True)
    photo.mime_type = mime.from_file(photo.path)
    try:
        added_photo = photo.save()
    except:
        raise
        raise PhotoExceptions.failed_to_save_photo_to_db()

    logger.debug('in add_photo added_photo :{}', added_photo)
    return photo


def delete_photo(id: int):
    photo = get_photo(id)
    if not photo:
        raise PhotoExceptions.photo_not_found()
    if os.path.exists(photo.path):
        try:
            os.remove(photo.path)
        except:
            raise
            raise PhotoExceptions.failed_to_delete_photo_file()
    try:
        photo.delete()
    except:
        raise
        raise PhotoExceptions.failed_to_delete_photo_from_db()


def get_photo(photo_id: int) -> Photo:
    return Photo.get_by_id(photo_id)


def get_latest_photo() -> Photo:
    return Photo.query \
        .order_by(Photo.creation_date.desc()) \
        .first()


def update_photo(photo: Photo) -> Photo:
    saved_photo = get_photo(photo.id)
    if not saved_photo:
        raise PhotoExceptions.photo_not_found()
    saved_photo.media_metadata = photo.media_metadata
    saved_photo.gphoto_id = photo.gphoto_id
    saved_photo.creation_date = photo.creation_date
    return saved_photo.update()


def get_photos(page, per_page=10):
    return Photo.query \
        .order_by(Photo.creation_date.desc()) \
        .paginate(page, per_page, error_out=False)
