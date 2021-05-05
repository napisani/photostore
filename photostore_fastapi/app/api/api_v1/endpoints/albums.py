from typing import List

from fastapi import APIRouter, Depends
from fastapi.openapi.models import APIKey
from loguru import logger
from sqlalchemy.orm import Session

from app.api import deps
from app.api.deps import get_api_key
from app.schemas.album_schema import AlbumSchemaFull, AlbumSchemaAdd, AlbumSchemaAssociate
from app.service.album_service import delete_album, get_all_albums, add_album, get_album, \
    remove_photo_associations_by_device_id, associate_photos_with_album

router = APIRouter()


@router.post("/add_album", response_model=AlbumSchemaFull)
async def api_add_album(album: AlbumSchemaAdd,
                        api_key: APIKey = Depends(get_api_key),
                        db: Session = Depends(deps.get_async_db),
                        ) -> AlbumSchemaFull:
    logger.debug('in api_add_album album :{}', album)
    return await add_album(db=db, album_in=album)


@router.delete("/delete_album/{album_id}", response_model=AlbumSchemaFull)
async def api_delete_album(album_id: int,
                           api_key: APIKey = Depends(get_api_key),
                           db: Session = Depends(deps.get_async_db)) -> AlbumSchemaFull:
    logger.debug('in api_delete_album id :{}', album_id)
    return await delete_album(album_id)


@router.get("/get_albums", response_model=List[AlbumSchemaFull])
async def api_get_all_albums(api_key: APIKey = Depends(get_api_key),
                             db: Session = Depends(deps.get_async_db)) -> List[AlbumSchemaFull]:
    logger.debug('in get_all_albums')
    return await get_all_albums(db)


@router.get("/get_album/{album_id}", response_model=AlbumSchemaFull)
async def api_get_album(album_id: int,
                        api_key: APIKey = Depends(get_api_key),
                        db: Session = Depends(deps.get_async_db)) -> AlbumSchemaFull:
    logger.debug('in api_get_album id :{}', album_id)
    return await get_album(db, album_id)


@router.delete("/remove_photos_from_album/{name}/{device_id}", response_model=AlbumSchemaFull)
async def api_remove_photo_associations_by_device_id(name: str,
                                                     device_id: str,
                                                     api_key: APIKey = Depends(get_api_key),
                                                     db: Session = Depends(deps.get_async_db),
                                                     ) -> AlbumSchemaFull:
    logger.debug('in api_remove_photo_associations_by_device_id name :{} device_id: {}', name, device_id)
    return await remove_photo_associations_by_device_id(db=db, name=name, device_id=device_id)


@router.post("/add_photos_to_album", response_model=AlbumSchemaFull)
async def api_associate_photos_with_album(photos: List[AlbumSchemaAssociate],
                                          api_key: APIKey = Depends(get_api_key),
                                          db: Session = Depends(deps.get_async_db),
                                          ) -> AlbumSchemaFull:
    logger.debug('in api_associate_photos_with_album photo_refs :{}', photos)
    return await associate_photos_with_album(db=db, photo_refs=photos)
