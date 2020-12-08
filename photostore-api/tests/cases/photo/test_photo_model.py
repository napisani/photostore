import pytest
from loguru import logger

from photostore.photos.photo_model import Photo
from tests.factories import PhotoFactory


@pytest.mark.unit
@pytest.mark.usefixtures('db')
class TestPhotoService:

    def test_add_and_get_photo(self, db):
        photo = PhotoFactory()
        logger.debug('photo {}', photo)
        photo_saved = photo.save()
        logger.debug('photo_saved {}', photo_saved)
        photo_retrieved = Photo.get_by_id(photo.id)
        assert photo_retrieved.filename is not None
        assert photo_retrieved.filename != ''
        for attr in ['path', 'filename', 'checksum', 'gphoto_id', 'mime_type', 'media_metadata']:
            logger.debug('photo_retrieved {} = {}', attr, getattr(photo_retrieved, attr))
            assert getattr(photo_retrieved, attr) == getattr(photo, attr)


