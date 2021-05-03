# @pytest.mark.unit
import pytest
from loguru import logger

from app.schemas.album_schema import AlbumSchemaAdd
from app.service.album_service import add_album


class TestAlbumService:
    @pytest.mark.asyncio
    async def test_add_album(self, album_factory, db):
        logger.debug('test_add_album')

        album = album_factory()

        saved_album = await add_album(db, AlbumSchemaAdd.parse_obj(vars(album)))

        assert saved_album
        assert saved_album.id > -1
        assert saved_album.name == album.name
