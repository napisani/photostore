import pytest
from loguru import logger
from sqlalchemy.orm import Session

from app.crud.crud_photo import PhotoRepo


@pytest.mark.unit
@pytest.mark.asyncio
class TestPhotoModel:
    async def test_add_and_get_photo(self, db: Session, photo_factory):
        photo = photo_factory()
        logger.debug('photo {}', photo)
        photo_saved = await PhotoRepo.create(db, obj_in=photo)
        logger.debug('photo_saved {}', photo_saved)
        photo_retrieved = await PhotoRepo.get_by_id(db, photo_saved.id)
        assert photo_retrieved.filename is not None
        assert photo_retrieved.filename != ''
        for attr in ['path', 'filename', 'checksum', 'gphoto_id', 'mime_type']:
            logger.debug('photo_retrieved {} = {}', attr, getattr(photo_retrieved, attr))
            assert getattr(photo_retrieved, attr) == getattr(photo, attr)
