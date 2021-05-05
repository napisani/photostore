from typing import Optional, List

from sqlalchemy import select
from sqlalchemy.orm import Session, lazyload

from .base import CRUDBase, ModelType
from ..models.album_model import Album
from ..models.album_to_photo_table import album_to_photo_table
from ..models.photo_model import Photo
from ..schemas.album_schema import AlbumSchemaAdd, AlbumSchemaUpdate


class CRUDAlbum(CRUDBase[Album, AlbumSchemaAdd, AlbumSchemaUpdate]):
    async def get_by_name(self, db: Session, name: str) -> Optional[ModelType]:
        items_itr = await db.execute(select(self.model).where(self.model.name == name))
        return items_itr.scalars().first()

    async def append_photos(self, db: Session, album: Album, photos: List[Photo]):
        for p in photos:
            album.photos.append(p)
        await db.commit()

    async def remove_photos(self, db: Session, album: Album, photos: List[Photo]):
        for p in photos:
            album.photos.remove(p)
        await db.commit()

    async def get_all(self, db: Session) -> List[ModelType]:
        r = await db.execute(select(self.model).options(lazyload(self.model.photos)))
        return r.scalars().all()

    async def associate_photos_with_album(self, db: Session, album_id: int, photo_ids: List[int]) -> ModelType:
        await db.execute(album_to_photo_table.insert().values([(album_id, p) for p in photo_ids]))
        await db.commit()
        return await self.get_by_id(db=db, id=album_id)

    # async def get_photos(self, db: Session, album_id: int) -> List[Photo]:
    #     album = await self.get_by_id(db=db, id=album_id)
    #     await db.execute(album.photos).scalars().all()


AlbumRepo = CRUDAlbum(Album)
