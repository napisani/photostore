from typing import List

from loguru import logger
from sqlalchemy.orm import Session

from app.crud.crud_album import AlbumRepo
from app.crud.crud_photo import PhotoRepo
from app.schemas.album_schema import AlbumSchemaFull, AlbumSchemaAdd, AlbumSchemaAssociate


async def add_album(db: Session, album_in: AlbumSchemaAdd) -> AlbumSchemaFull:
    logger.debug('in add_album album_in :{}', album_in)
    added_album = await AlbumRepo.create(db=db, obj_in=album_in)
    logger.debug('in add_album added_album :{}', added_album)
    return AlbumSchemaFull.from_orm(added_album)


async def delete_album(db: Session, album_id: int) -> AlbumSchemaFull:
    logger.debug('in delete_album id :{}', album_id)
    deleted_album = await AlbumRepo.remove(db=db, id=album_id)
    logger.debug('in add_album deleted_album :{}', deleted_album)
    return AlbumSchemaFull.from_orm(deleted_album)


async def get_all_albums(db: Session) -> List[AlbumSchemaFull]:
    logger.debug('in get_all_albums')
    albums = await AlbumRepo.get_all(db)
    return [AlbumSchemaFull(name=a.name, photo_ids=[], id=a.id) for a in albums]


async def get_album(db: Session, album_id: int) -> AlbumSchemaFull:
    logger.debug('in get_album album_id :{}', id)
    album = await AlbumRepo.get_by_id(db=db, id=album_id)
    photo_ids = [p.id for p in album.photos]
    return AlbumSchemaFull(name=album.name, photo_ids=photo_ids, id=album.id)


async def remove_photo_associations_by_device_id(db: Session, name: str, device_id: str) -> AlbumSchemaFull:
    logger.debug('in remove_photo_associations_by_device_id name :{} device_id: {}', name, device_id)

    album = await AlbumRepo.get_by_name(db=db, name=name)
    photos_to_remove = [p for p in album.photos if p.device_id == device_id]
    await AlbumRepo.remove_photos(db=db, album=album, photos=photos_to_remove)
    return await get_album(db=db, album_id=album.id)


async def associate_photos_with_album(db: Session, photo_refs: List[AlbumSchemaAssociate]) -> AlbumSchemaFull:
    logger.debug('in associate_photos_to_album photo_refs :{}', photo_refs)
    if len(photo_refs) > 0:
        photos = await PhotoRepo.get_photos_by_native_ids(db=db,
                                                          device_native_id_pairs=[(ref.device_id, ref.native_id) for ref
                                                                                  in photo_refs])
        album = await AlbumRepo.get_by_name(db=db, name=photo_refs[0].name)
        await AlbumRepo.append_photos(db=db, album=album, photos=photos)
        return await get_album(db, album.id)

#
# async def get_photos_by_album(db: Session, id: int) -> List[PhotoSchemaFull]:
