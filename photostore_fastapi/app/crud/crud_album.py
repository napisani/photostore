from typing import Optional, List

from sqlalchemy import select
from sqlalchemy.orm import Session

from .base import CRUDBase, ModelType
from ..models.album_model import Album
from ..models.album_to_photo_table import album_to_photo_table
from ..schemas.album_schema import AlbumSchemaAdd, AlbumSchemaUpdate


class CRUDAlbum(CRUDBase[Album, AlbumSchemaAdd, AlbumSchemaUpdate]):
    async def get_by_name(self, db: Session, name: str) -> Optional[ModelType]:
        items_itr = await db.execute(select(self.model).where(self.model.name == name))
        return items_itr.scalars().first()

    async def associate_photos_with_album(self, db: Session, album_id: int, photo_ids: List[int]) -> ModelType:
        await db.execute(album_to_photo_table.insert().values([(album_id, p) for p in photo_ids]))
        await db.commit()
        return await self.get_by_id(db=db, id=album_id)

    # async def get_photos(self, db: Session, album_id: int) -> List[Photo]:
    #     album = await self.get_by_id(db=db, id=album_id)
    #     await db.execute(album.photos).scalars().all()


AlbumRepo = CRUDAlbum(Album)
