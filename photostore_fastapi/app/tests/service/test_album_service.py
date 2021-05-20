import pytest
from loguru import logger
from werkzeug.datastructures import FileStorage

from app.schemas.album_schema import AlbumSchemaAdd, AlbumSchemaAssociate
from app.schemas.photo_schema import PhotoSchemaAdd
from app.service.album_service import add_album, delete_album, associate_photos_with_album, \
    remove_photo_associations_by_device_id, get_all_albums
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

        album_without_associations = await  remove_photo_associations_by_device_id(db, saved_album.name,
                                                                                   saved_photo.device_id)
        assert album_without_associations
        assert album_without_associations.id > -1
        assert len(album_without_associations.photo_ids) == 0

    @pytest.mark.asyncio
    async def test_get_all_albums(self, album_factory, db):
        logger.debug('test_get_all_albums')
        album1 = album_factory()
        album2 = album_factory()

        saved_album1 = await add_album(db, AlbumSchemaAdd.parse_obj(vars(album1)))
        saved_album2 = await add_album(db, AlbumSchemaAdd.parse_obj(vars(album2)))
        all_albums = await get_all_albums(db)

        assert all_albums
        assert len(all_albums) == 2
