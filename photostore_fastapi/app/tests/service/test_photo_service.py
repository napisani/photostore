import datetime
import os

import pytest
from loguru import logger
from werkzeug.datastructures import FileStorage

from app.schemas.photo_schema import PhotoSchemaUpdate, PhotoDiffRequestSchema, PhotoSchemaAdd, PhotoSchemaFull
from app.service.photo_service import _get_unique_filename, add_photo, delete_photo, get_photo, update_photo, \
    get_latest_photo, get_photos, diff_photos
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
        saved_photo = add_photo(db, PhotoSchemaAdd.parse_obj(vars(photo)), file)

        assert saved_photo
        assert app_settings.SAVE_PHOTO_DIR in saved_photo.path
        assert saved_photo.checksum
        assert saved_photo.id
        assert saved_photo.id > 0
        assert os.path.exists(photo.path)
        assert os.path.exists(photo.thumbnail_path)
        assert photo.checksum == get_file_checksum(photo.path)
        assert photo.mime_type
        assert photo.native_id
        assert photo.device_id
        assert photo.width > 0
        assert photo.height > 0

    def test_add_and_delete(self, app_settings, db, photo_factory):
        logger.debug('test_add_and_delete')
        photo = photo_factory()
        file = FileStorage(stream=open(photo.path, 'rb'), filename=photo.filename)
        saved_photo = add_photo(db, PhotoSchemaAdd.parse_obj(vars(photo)), file)

        delete_photo(db, saved_photo.id)

        assert not os.path.exists(saved_photo.path)
        assert not get_photo(db, saved_photo.id)

    def test_add_and_update(self, photo_factory, db):
        today = datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S")
        today = datetime.datetime.strptime(today, "%Y-%m-%d %H:%M:%S")
        logger.debug('test_add_and_delete')
        photo = photo_factory()
        file = FileStorage(stream=open(photo.path, 'rb'), filename=photo.filename)
        saved_photo = add_photo(db, PhotoSchemaAdd.parse_obj(vars(photo)), file)
        # saved_photo.media_metadata = '_new_'

        photo_updates = PhotoSchemaUpdate(id=saved_photo.id, creation_date=today)
        updated_photo = update_photo(db, photo_updates)

        assert updated_photo
        # assert updated_photo.media_metadata == '_new_'
        assert updated_photo.creation_date.replace(hour=0, minute=0, second=0, microsecond=0) == today.replace(hour=0,
                                                                                                               minute=0,
                                                                                                               second=0,
                                                                                                               microsecond=0)

        latest_photo = get_latest_photo(db, device_id=photo.device_id)

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
            saved_photo = add_photo(db, PhotoSchemaAdd.parse_obj(vars(photo)), file)
            assert saved_photo
        photos = get_photos(db, 1)
        logger.debug('test_add_photos_and_get_photos photos: {}', photos)
        assert photos
        assert photos.items
        assert photos.page == 1
        assert len(photos.items) >= 4
        assert photos.total >= len(photos.items)

    def test_diff_photos(self, photo_factory, db):
        logger.debug('test_diff_photos')
        photo_same = photo_factory()
        photo_same_file = FileStorage(stream=open(photo_same.path, 'rb'), filename=photo_same.filename)
        photo_diff = photo_factory()
        photo_diff_file = FileStorage(stream=open(photo_diff.path, 'rb'), filename=photo_diff.filename)
        photo_missing = PhotoSchemaFull.parse_obj(vars(photo_factory()))
        add_photo(db, PhotoSchemaAdd.parse_obj(vars(photo_same)), photo_same_file)
        add_photo(db, PhotoSchemaAdd.parse_obj(vars(photo_diff)), photo_diff_file)

        photo_diff.checksum = 'ffffffff'
        photo_diff.modified_date = datetime.datetime.utcnow() + datetime.timedelta(days=10)

        diff_reqs = [PhotoDiffRequestSchema(native_id=p.native_id, device_id=p.device_id, modified_date=p.modified_date,
                                            checksum=p.checksum) for p in [photo_same, photo_diff, photo_missing]]

        results = diff_photos(db, diff_reqs)
        assert results is not None
        assert len(results) == 3
        res_dict = {res.native_id: res for res in results}
        assert res_dict[photo_same.native_id].exists
        assert res_dict[photo_same.native_id].same_date
        assert res_dict[photo_same.native_id].same_checksum
        assert res_dict[photo_diff.native_id].exists
        assert not res_dict[photo_diff.native_id].same_date
        assert not res_dict[photo_diff.native_id].same_checksum
        assert not res_dict[photo_missing.native_id].exists
        assert not res_dict[photo_missing.native_id].same_date
        assert not res_dict[photo_missing.native_id].same_checksum
