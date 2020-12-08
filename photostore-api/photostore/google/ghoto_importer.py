from datetime import datetime
from io import BytesIO

from gphotospy.media import MediaItem
from loguru import logger
from werkzeug.datastructures import FileStorage

from photostore.google.gphoto_service import GPhotoService
from photostore.photos.photo_model import Photo
from photostore.photos.photo_service import add_photo, allowed_file


def import_google_photos():
    gphoto_service = GPhotoService()
    media_iterator = gphoto_service.get_media_iterator()
    for i in range(0, 100):
        media_item_raw = next(media_iterator)
        media_item = MediaItem(media_item_raw)

        logger.info('gphoto_item {} ', media_item)
        # temp_img = os.path.join('/tmp/gphoto', media_item.filename())

        file = FileStorage(stream=BytesIO(media_item.raw_download()), filename=media_item.filename())
        photo = Photo()
        photo.media_metadata = media_item.metadata()
        photo.gphoto_id = media_item_raw['id']
        photo.creation_date = _get_creation_date(photo.media_metadata)
        if allowed_file(media_item.filename()):
            saved_photo = add_photo(file=file, photo=photo)
            logger.debug('saved photo {}', saved_photo)
        else:
            logger.debug('skipping file becuase its not an allowed ext  {}', media_item.filename())

        #
        # with open(temp_img, 'wb') as output:
        #     output.write(media_item.raw_download())


def _get_creation_date(meta):
    try:
        # meta = json.loads(metadata_json_string)
        if meta['creationTime']:
            date = datetime.strptime(meta['creationTime'], '%Y-%m-%dT%H:%M:%SZ')
            return date
    except KeyError:
        pass
    return None
