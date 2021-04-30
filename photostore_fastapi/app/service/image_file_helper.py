import os
import re
import shutil
from io import BytesIO
from typing import Dict, Set

from PIL import Image
from loguru import logger

from app.core.config import settings
from app.obj.media_type import MediaType
from app.service.video_file_helper import get_thumbnail_frame_from_video
from app.utils import get_file_extension

ALLOWED_IMAGE_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif', 'heic'}
ALLOWED_VIDEO_EXTENSIONS = {'mov', 'mp4', 'm4v'}


def get_media_type_by_extension(filename: str) -> MediaType:
    return MediaType.VIDEO if get_file_extension(filename) in ALLOWED_VIDEO_EXTENSIONS else MediaType.IMAGE


def get_allowed_extensions(include_image=True, include_video=True) -> Set[str]:
    allowed = set()
    if include_image:
        allowed = allowed.union(ALLOWED_IMAGE_EXTENSIONS)
    if include_video:
        allowed = allowed.union(ALLOWED_VIDEO_EXTENSIONS)
    return allowed


def secure_filename(uploaded_file_name: str) -> str:
    return uploaded_file_name  # todo


def _get_destination_path(filename: str, device_id: str, thumbnail=False) -> str:
    d = settings.SAVE_PHOTO_DIR
    device_dir = re.sub(r'\W+', '_', device_id)
    d = os.path.join(d, device_dir)

    if thumbnail:
        d = os.path.join(d, 'thumb')
    if not os.path.exists(d):
        os.mkdir(d)
    destination_file = os.path.join(d, filename)
    return destination_file


def _get_unique_filename(filename: str, device_id: str) -> str:
    if not os.path.exists(_get_destination_path(filename, device_id)):
        return filename
    filename_split = os.path.splitext(filename)

    match = re.search('_\\([0-9]+\\)$', filename_split[0])
    if not match:
        return _get_unique_filename(f'{filename_split[0]}_(1){filename_split[1]}', device_id)
    else:
        match_text = match.group(0)
        idx = int(match_text[2:-1]) + 1
        filename_pre = re.sub('_\\([0-9]+\\)$', f'_({idx})', filename_split[0])
        return _get_unique_filename(f'{filename_pre}{filename_split[1]}', device_id)


def save_photo_file(filename: str, device_id: str, uploaded_file: BytesIO) -> Dict[str, str]:
    try:
        filename = secure_filename(filename)
        filename = _get_unique_filename(filename, device_id)
        destination_file = _get_destination_path(filename, device_id)
        # uploaded_file.save(destination_file)
        with open(destination_file, 'wb') as dest_file:
            shutil.copyfileobj(uploaded_file, dest_file)
        return {"filename": filename, 'path': destination_file}
    except:
        raise
        raise PhotoExceptions.failed_to_save_photo_file()


def _create_thumbnail_from_image(photo_path: str, photo_filename: str) -> str:
    pass


def create_thumbnail(path: str, filename: str, device_id: str, media_type: MediaType) -> str:
    try:
        if MediaType.IMAGE == media_type:
            thumb_path = _get_destination_path(filename, device_id, thumbnail=True)
            filename_only, file_extension = os.path.splitext(path)
            if file_extension.lower() in ['.heic']:
                logger.debug('create_thumbnail working on HEIC IMAGE file {}', path)
                thumb_only, thumb_ext = os.path.splitext(thumb_path)
                thumb_path = thumb_only + '.png'
            else:
                logger.debug('create_thumbnail working on non-HEIC IMAGE file {}', path)
            image = Image.open(path)
            image.thumbnail((settings.THUMBNAIL_WIDTH, settings.THUMBNAIL_HEIGHT))
            # creating thumbnail
            logger.debug('creating thumbnail {}', thumb_path)
            image.save(thumb_path)
        else:
            logger.debug('create_thumbnail working on VIDEO file {}', path)
            generated_video_thumb = get_thumbnail_frame_from_video(path)
            generated_thumb_filename = os.path.basename(generated_video_thumb)
            thumb_path = _get_destination_path(generated_thumb_filename, device_id, thumbnail=True)
            shutil.copyfile(generated_video_thumb, thumb_path)
        return thumb_path
    except:
        raise
        raise PhotoExceptions.failed_to_create_thumbnail()
