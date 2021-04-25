import asyncio
import datetime
import os

import pytest
from loguru import logger
from werkzeug.datastructures import FileStorage

from app.obj.media_type import MediaType
from app.schemas.photo_schema import PhotoSchemaUpdate, PhotoDiffRequestSchema, PhotoSchemaAdd, PhotoSchemaFull
from app.service.photo_service import add_photo, delete_photo, get_photo, update_photo, \
    get_latest_photo, get_photos, diff_photos, count_photos, allowed_file, delete_photos_by_device, get_devices
from app.utils import get_file_checksum


# @pytest.mark.unit
class TestPhotoService:
    @pytest.mark.asyncio
    async def test_delete_photos_by_device(self, photo_factory, db):
        logger.debug('test_delete_photos_by_device')
        photo1 = photo_factory()
        file1 = FileStorage(stream=open(photo1.path, 'rb'), filename=photo1.filename)

        second_dev = 'new_device_1111'
        photo2 = photo_factory()
        photo2.device_id = second_dev
        file2 = FileStorage(stream=open(photo2.path, 'rb'), filename=photo2.filename)
        await add_photo(db, PhotoSchemaAdd.parse_obj(vars(photo1)), file1)
        await add_photo(db, PhotoSchemaAdd.parse_obj(vars(photo2)), file2)
        device_list = get_devices(db)
        assert device_list
        assert len(device_list) == 2
        found_count = 0
        for device in device_list:
            assert device.count == 1
            if second_dev == device.device_id:
                found_count += 1
        assert found_count == 1

    @pytest.mark.asyncio
    async def test_delete_photos_by_device(self, photo_factory, db):
        logger.debug('test_delete_photos_by_device')
        photo = photo_factory()
        file = FileStorage(stream=open(photo.path, 'rb'), filename=photo.filename)
        saved_photo = await add_photo(db, PhotoSchemaAdd.parse_obj(vars(photo)), file)
        await delete_photos_by_device(db, saved_photo.device_id)
        assert not os.path.exists(saved_photo.path)
        assert not os.path.exists(saved_photo.thumbnail_path)
        assert not await get_photo(db, saved_photo.id)

    def test_allowed_filename(self):
        assert allowed_file("something.png")
        assert allowed_file("something.PNG")
        assert allowed_file("something.jpeg")
        assert allowed_file("something.jpg")
        assert allowed_file("something.mov")
        assert allowed_file("something.mp4")
        assert allowed_file("something.MOV")
        assert allowed_file("/tmp/.video/FB4F2B49-5E10-486E-A18F-CAE1FA8FE399_L0_001_origin.IMG_6572.MOV")

    @pytest.mark.asyncio
    async def test_add_photo(self, app_settings, db, photo_factory):
        logger.debug('test_add_photo')
        photo = photo_factory()
        file = FileStorage(stream=open(photo.path, 'rb'), filename=photo.filename)
        saved_photo = await add_photo(db, PhotoSchemaAdd.parse_obj(vars(photo)), file)
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
        assert photo.media_type == MediaType.IMAGE

    @pytest.mark.asyncio
    async def test_add_and_delete(self, app_settings, db, photo_factory):
        logger.debug('test_add_and_delete')
        photo = photo_factory()
        file = FileStorage(stream=open(photo.path, 'rb'), filename=photo.filename)
        saved_photo = await add_photo(db, PhotoSchemaAdd.parse_obj(vars(photo)), file)
        await delete_photo(db, saved_photo.id)
        assert not os.path.exists(saved_photo.path)
        assert not os.path.exists(saved_photo.thumbnail_path)
        assert not await get_photo(db, saved_photo.id)

    @pytest.mark.asyncio
    async def test_add_and_update(self, photo_factory, db):
        today = datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S")
        today = datetime.datetime.strptime(today, "%Y-%m-%d %H:%M:%S")
        logger.debug('test_add_and_delete')
        photo = photo_factory()
        file = FileStorage(stream=open(photo.path, 'rb'), filename=photo.filename)
        saved_photo = await add_photo(db, PhotoSchemaAdd.parse_obj(vars(photo)), file)
        # saved_photo.media_metadata = '_new_'

        photo_updates = PhotoSchemaUpdate(id=saved_photo.id, creation_date=today)
        updated_photo = await update_photo(db, photo_updates)

        assert updated_photo
        # assert updated_photo.media_metadata == '_new_'
        assert updated_photo.creation_date.replace(hour=0, minute=0, second=0, microsecond=0) == today.replace(hour=0,
                                                                                                               minute=0,
                                                                                                               second=0,
                                                                                                               microsecond=0)

        latest_photo = await get_latest_photo(db, device_id=photo.device_id)
        assert latest_photo
        assert latest_photo.creation_date.replace(hour=0, minute=0, second=0, microsecond=0) == today.replace(hour=0,
                                                                                                              minute=0,
                                                                                                              second=0,
                                                                                                              microsecond=0)

    @pytest.mark.asyncio
    async def test_add_two_and_get_latest(self, photo_factory, db):
        today = datetime.datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S")
        today = datetime.datetime.strptime(today, "%Y-%m-%d %H:%M:%S")
        logger.debug('test_add_and_delete')
        photo = photo_factory()
        file = FileStorage(stream=open(photo.path, 'rb'), filename=photo.filename)
        saved_photo = await add_photo(db, PhotoSchemaAdd.parse_obj(vars(photo)), file)

        await asyncio.sleep(1)

        photo2 = photo_factory()
        file2 = FileStorage(stream=open(photo.path, 'rb'), filename=photo2.filename)
        saved_photo2 = await add_photo(db, PhotoSchemaAdd.parse_obj(vars(photo2)), file2)

        assert saved_photo2
        # assert updated_photo.media_metadata == '_new_'
        assert saved_photo2.creation_date.replace(hour=0, minute=0, second=0, microsecond=0) == today.replace(hour=0,
                                                                                                              minute=0,
                                                                                                              second=0,
                                                                                                              microsecond=0)
        latest_photo = await get_latest_photo(db, device_id=photo.device_id)

        assert latest_photo
        assert latest_photo.id == saved_photo2.id

    @pytest.mark.asyncio
    async def test_add_photos_and_get_photos(self, photo_factory, db):
        logger.debug('test_add_photo')
        for _ in range(0, 4):
            photo = photo_factory()
            file = FileStorage(stream=open(photo.path, 'rb'), filename=photo.filename)
            saved_photo = await add_photo(db, PhotoSchemaAdd.parse_obj(vars(photo)), file)
            assert saved_photo
        photos = await get_photos(db, 1)
        logger.debug('test_add_photos_and_get_photos photos: {}', photos)
        assert photos
        assert photos.items
        assert photos.page == 1
        assert len(photos.items) >= 4
        assert photos.total >= len(photos.items)

    @pytest.mark.asyncio
    async def test_diff_photos(self, photo_factory, db):
        logger.debug('test_diff_photos')
        photo_same = photo_factory()
        photo_same_file = FileStorage(stream=open(photo_same.path, 'rb'), filename=photo_same.filename)
        photo_diff = photo_factory()
        photo_diff_file = FileStorage(stream=open(photo_diff.path, 'rb'), filename=photo_diff.filename)
        photo_missing = PhotoSchemaFull.parse_obj(vars(photo_factory()))
        await add_photo(db, PhotoSchemaAdd.parse_obj(vars(photo_same)), photo_same_file)
        await add_photo(db, PhotoSchemaAdd.parse_obj(vars(photo_diff)), photo_diff_file)

        photo_diff.checksum = 'ffffffff'
        photo_diff.modified_date = datetime.datetime.utcnow() + datetime.timedelta(days=10)

        diff_reqs = [PhotoDiffRequestSchema(native_id=p.native_id, device_id=p.device_id, modified_date=p.modified_date,
                                            checksum=p.checksum) for p in [photo_same, photo_diff, photo_missing]]

        results = await diff_photos(db, diff_reqs)
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

    @pytest.mark.asyncio
    async def test_add_photo_and_count(self, app_settings, db, photo_factory):
        logger.debug('test_add_photo_and_count')
        photo = photo_factory()
        file = FileStorage(stream=open(photo.path, 'rb'), filename=photo.filename)
        saved_photo = await add_photo(db, PhotoSchemaAdd.parse_obj(vars(photo)), file)
        count = await  count_photos(db, saved_photo.device_id)
        assert count == 1

    @pytest.mark.asyncio
    async def test_add_and_get_video(self, video_factory, app_settings, db):
        logger.debug('test_add_photo')
        video = video_factory()
        file = FileStorage(stream=open(video.path, 'rb'), filename=video.filename)
        saved_photo = await add_photo(db, PhotoSchemaAdd.parse_obj(vars(video)), file)
        assert saved_photo
        assert app_settings.SAVE_PHOTO_DIR in saved_photo.path
        assert saved_photo.checksum
        assert saved_photo.id
        assert saved_photo.id > 0
        assert os.path.exists(video.path)
        assert os.path.exists(video.thumbnail_path)
        assert video.checksum == get_file_checksum(video.path)
        assert video.mime_type
        assert video.media_type == MediaType.VIDEO
        assert video.native_id
        assert video.device_id
        assert video.width > 0
        assert video.height > 0

    @pytest.mark.asyncio
    async def test_add_photos_and_get_photos_by_device_id(self, photo_factory, db):
        logger.debug('test_add_photos_and_get_photos_by_device_id')
        for _ in range(0, 4):
            photo = photo_factory()
            file = FileStorage(stream=open(photo.path, 'rb'), filename=photo.filename)
            saved_photo = await add_photo(db, PhotoSchemaAdd.parse_obj(vars(photo)), file)
            assert saved_photo
        photos = await get_photos(db, 1, device_id=photo.device_id)
        logger.debug('test_add_photos_and_get_photos photos: {}', photos)
        assert photos
        assert photos.items
        assert photos.page == 1
        assert len(photos.items) >= 4
        assert photos.total >= len(photos.items)

        photos = await get_photos(db, 1, device_id=(photo.device_id + "NOTFOUND"))
        assert photos
        assert photos.page == 1
        assert len(photos.items) == 0
        assert photos.total == len(photos.items)
