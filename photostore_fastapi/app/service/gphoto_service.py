import os

from PIL import Image
from gphotospy.album import Album
from gphotospy.media import Media, MediaItem
from loguru import logger
from app.service.gphoto_authorizer import authorize_gphoto_service


class GPhotoService:

    def get_google_photos(self):
        service = authorize_gphoto_service()

        # album_manager = Album(service)
        media_manager = Media(service)
        media_iterator = media_manager.list()
        logger.info('media item {} ', next(media_iterator))
        logger.info('media item {} ', next(media_iterator))
        logger.info('media item {} ', next(media_iterator))
        logger.info('media item {} ', next(media_iterator))

    def get_google_photos_from_album(self):
        service = authorize_gphoto_service()

        album_manager = Album(service)
        album_iterator = album_manager.list()
        first_album = next(album_iterator)
        logger.info('first_album {} ', first_album)

        media_manager = Media(service)
        media_iterator = media_manager.search_album(first_album.get('id'))
        logger.info('media item {} ', next(media_iterator))
        logger.info('media item {} ', next(media_iterator))
        logger.info('media item {} ', next(media_iterator))
        logger.info('media item {} ', next(media_iterator))

    def get_and_save(self):
        service = authorize_gphoto_service()
        media_manager = Media(service)
        media_iterator = media_manager.list()
        gphoto_item = MediaItem(next(media_iterator))
        logger.info('gphoto_item {} ', gphoto_item)
        temp_img = os.path.join('/tmp', gphoto_item.filename())
        with open(temp_img, 'wb') as output:
            output.write(gphoto_item.raw_download())
        image = Image.open(temp_img)


    def get_media_iterator(self):
        service = authorize_gphoto_service()
        media_manager = Media(service)
        media_iterator = media_manager.list()
        return media_iterator
