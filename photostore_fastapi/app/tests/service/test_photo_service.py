import datetime
import os

import pytest
from loguru import logger
from werkzeug.datastructures import FileStorage

from app.schemas.photo_schema import PhotoSchemaUpdate
from app.service.photo_service import _get_unique_filename, add_photo, delete_photo, get_photo, update_photo, \
    get_latest_photo, get_photos
from app.utils import get_file_checksum


@pytest.mark.unit
class TestPhotoService:
    def test_unique_filename(self, mocker, db):
        def mock_exists(filename):
            logger.debug(filename)
            if '(4)' in filename:
                return False
            return True

        mocker.patch('app.service.photo_service.os.path.exists', side_effect=mock_exists)
        unique_filename = _get_unique_filename('photo_0.PNG')
        assert unique_filename == 'photo_0_(4).PNG'

    def test_add_photo(self, app_settings, db, photo_factory):
        logger.debug('test_add_photo')
        photo = photo_factory()
        file = FileStorage(stream=open(photo.path, 'rb'), filename=photo.filename)
        saved_photo = add_photo(db, photo, file)

        assert saved_photo
        assert app_settings.SAVE_PHOTO_DIR in saved_photo.path
        assert saved_photo.checksum
        assert saved_photo.id
        assert saved_photo.id > 0
        assert os.path.exists(photo.path)
        assert os.path.exists(photo.thumbnail_path)
        assert photo.checksum == get_file_checksum(photo.path)
        assert photo.mime_type

    def test_add_and_delete(self, app_settings, db, photo_factory):
        logger.debug('test_add_and_delete')
        photo = photo_factory()
        file = FileStorage(stream=open(photo.path, 'rb'), filename=photo.filename)
        saved_photo = add_photo(db, photo, file)

        delete_photo(db, saved_photo.id)

        assert not os.path.exists(saved_photo.path)
        assert not get_photo(db, saved_photo.id)

    def test_add_and_update(self, photo_factory, db):
        today = datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S")
        today = datetime.datetime.strptime(today, "%Y-%m-%d %H:%M:%S")
        logger.debug('test_add_and_delete')
        photo = photo_factory()
        file = FileStorage(stream=open(photo.path, 'rb'), filename=photo.filename)
        saved_photo = add_photo(db, photo, file)
        # saved_photo.media_metadata = '_new_'

        photo_updates = PhotoSchemaUpdate(id=saved_photo.id, creation_date=today)
        updated_photo = update_photo(db, photo_updates)

        assert updated_photo
        # assert updated_photo.media_metadata == '_new_'
        assert updated_photo.creation_date.replace(hour=0, minute=0, second=0, microsecond=0) == today.replace(hour=0,
                                                                                                               minute=0,
                                                                                                               second=0,
                                                                                                               microsecond=0)

        latest_photo = get_latest_photo(db)

        assert latest_photo
        assert latest_photo.creation_date.replace(hour=0, minute=0, second=0, microsecond=0) == today.replace(hour=0,
                                                                                                              minute=0,
                                                                                                              second=0,
                                                                                                              microsecond=0)

    def test_add_photos_and_get_photos(self, photo_factory, db):
        logger.debug('test_add_photo')
        for _ in range(0, 4):
            photo = photo_factory()
            file = FileStorage(stream=open(photo.path, 'rb'), filename=photo.filename)
            saved_photo = add_photo(db, photo, file)
            assert saved_photo
        photos = get_photos(db, 1)
        logger.debug('test_add_photos_and_get_photos photos: {}', photos)
        assert photos
        assert photos.items
        assert photos.page == 1
        assert len(photos.items) >= 4
        assert photos.total >= len(photos.items)
