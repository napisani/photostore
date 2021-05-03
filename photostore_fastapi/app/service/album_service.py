from loguru import logger
from sqlalchemy.orm import Session

from app.crud.crud_album import AlbumRepo
from app.schemas.album_schema import AlbumSchemaFull, AlbumSchemaAdd


async def add_album(db: Session, album_in: AlbumSchemaAdd) -> AlbumSchemaFull:
    logger.debug('in add_album album_in :{}', album_in)
    added_album = await  AlbumRepo.create(db=db, obj_in=album_in)

    logger.debug('in add_album added_album :{}', added_album)

    return AlbumSchemaFull.from_orm(added_album)
