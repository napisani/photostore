# @pytest.mark.unit
import pytest
from loguru import logger
from werkzeug.datastructures import FileStorage

from app.schemas.album_schema import AlbumSchemaAdd, AlbumSchemaAssociate
from app.schemas.photo_schema import PhotoSchemaAdd
from app.service.album_service import add_album, delete_album, associate_photos_with_album
from app.service.photo_service import add_photo


class TestAlbumService:
    @pytest.mark.asyncio
    async def test_add_album(self, album_factory, db):
        logger.debug('test_add_album')
        album = album_factory()
        saved_album = await add_album(db, AlbumSchemaAdd.parse_obj(vars(album)))
        assert saved_album
        assert saved_album.id > -1
        assert saved_album.name == album.name

    @pytest.mark.asyncio
    async def test_delete_album(self, album_factory, db):
        logger.debug('test_delete_album')
        album = album_factory()
        saved_album = await add_album(db, AlbumSchemaAdd.parse_obj(vars(album)))
        assert saved_album
        deleted_album = await delete_album(db, saved_album.id)
        assert deleted_album
        assert deleted_album.id > -1

    @pytest.mark.asyncio
    async def test_associate(self, album_factory, photo_factory, db):
        logger.debug('test_associate')

        photo = photo_factory()
        file = FileStorage(stream=open(photo.path, 'rb'), filename=photo.filename)
        saved_photo = await add_photo(db, PhotoSchemaAdd.parse_obj(vars(photo)), file)
        assert saved_photo

        album = album_factory()
        saved_album = await add_album(db, AlbumSchemaAdd.parse_obj(vars(album)))
        assert saved_album

        associated_album = await associate_photos_with_album(db, [AlbumSchemaAssociate(name=saved_album.name,
                                                                                       native_id=saved_photo.native_id,
                                                                                       device_id=saved_photo.device_id)])

        assert associated_album
        assert associated_album.id > -1
        assert len(associated_album.photo_ids) > 0
