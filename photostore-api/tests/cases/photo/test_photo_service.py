import datetime
import os

import pytest
from loguru import logger
from werkzeug.datastructures import FileStorage

from photostore.photos.photo_service import _get_unique_filename, add_photo, delete_photo, get_photo, update_photo, \
    get_latest_photo, get_photos
from photostore.utils import get_file_checksum
from tests.factories import PhotoFactory


@pytest.mark.unit
class TestPhotoService:
    def test_unique_filename(self, testapp, mocker, db):
        def mock_exists(filename):
            logger.debug(filename)
            if '(4)' in filename:
                return False
            return True

        mocker.patch('photostore.photos.photo_service.os.path.exists', side_effect=mock_exists)
        unique_filename = _get_unique_filename('photo_0.PNG')
        assert unique_filename == 'photo_0_(4).PNG'

    def test_add_photo(self, testapp, config, db):
        logger.debug('test_add_photo')
        photo = PhotoFactory()
        file = FileStorage(stream=open(photo.path, 'rb'), filename=photo.filename)
        saved_photo = add_photo(photo, file)

        assert saved_photo
        assert config.SAVE_PHOTO_DIR in saved_photo.path
        assert saved_photo.checksum
        assert saved_photo.id
        assert saved_photo.id > 0
        assert os.path.exists(photo.path)
        assert os.path.exists(photo.thumbnail_path)
        assert photo.checksum == get_file_checksum(photo.path)
        assert photo.mime_type

    def test_add_and_delete(self, testapp, config, db):
        logger.debug('test_add_and_delete')
        photo = PhotoFactory()
        file = FileStorage(stream=open(photo.path, 'rb'), filename=photo.filename)
        saved_photo = add_photo(photo, file)

        delete_photo(saved_photo.id)

        assert not os.path.exists(saved_photo.path)
        assert not get_photo(saved_photo.id)

    def test_add_and_update(self, testapp, config, db):
        today = datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S")
        today = datetime.datetime.strptime(today, "%Y-%m-%d %H:%M:%S")
        logger.debug('test_add_and_delete')
        photo = PhotoFactory()
        file = FileStorage(stream=open(photo.path, 'rb'), filename=photo.filename)
        saved_photo = add_photo(photo, file)
        saved_photo.media_metadata = '_new_'
        saved_photo.creation_date = today
        updated_photo = update_photo(saved_photo)

        assert updated_photo
        assert updated_photo.media_metadata == '_new_'
        assert updated_photo.creation_date == today

        latest_photo = get_latest_photo()

        assert latest_photo
        assert latest_photo.creation_date == today

    def test_add_photos_and_get_photos(self, testapp, config, db):
        logger.debug('test_add_photo')
        for _ in range(0, 4):
            photo = PhotoFactory()
            file = FileStorage(stream=open(photo.path, 'rb'), filename=photo.filename)
            saved_photo = add_photo(photo, file)
            assert saved_photo
        photos = get_photos(1)
        logger.debug('test_add_photos_and_get_photos photos: {}', photos)
        assert photos
        assert photos.items
        assert photos.page == 1
        assert len(photos.items) >= 4
        assert photos.total >= len(photos.items)
