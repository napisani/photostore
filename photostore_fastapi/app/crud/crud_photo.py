from typing import Optional, List

from sqlalchemy import or_, and_, select, func
from sqlalchemy.orm import Session

from .base import CRUDBase
from ..models.pagination import Pagination
from ..models.photo_model import Photo
from ..obj.photo_sort_attribute import PhotoSortAttribute
from ..obj.sort_direction import SortDirection
from ..schemas.photo_schema import PhotoSchemaAdd, PhotoSchemaUpdate


class CRUDPhoto(CRUDBase[Photo, PhotoSchemaAdd, PhotoSchemaUpdate]):

    async def get_photos(self, db: Session, page, per_page=10,
                         order_by=PhotoSortAttribute.modified_date,
                         direction=SortDirection.desc,
                         device_id: str = None) -> Pagination:
        order_by_clause = getattr(self.model, order_by)
        order_by_with_direction_clause = getattr(order_by_clause, direction)
        total_query = select(func.count()).select_from(self.model)
        select_query = select(self.model)
        if device_id is not None:
            select_query = select_query.filter(self.model.device_id == device_id)
            total_query = total_query.filter(self.model.device_id == device_id)

        return await self._paginate(db, (select_query
                                         .order_by(order_by_with_direction_clause())),
                                    total_query,
                                    self.model,
                                    page=page,
                                    per_page=per_page,
                                    error_out=False)

    async def get_photos_by_native_ids(self, db: Session, device_native_id_pairs: List, ) -> List[Photo]:
        if len(device_native_id_pairs) == 0:
            return []

        cond = or_(*[and_(Photo.native_id == native, Photo.device_id == device)
                     for (device, native) in device_native_id_pairs])
        result_itr = await db.execute(select(self.model).where(cond))
        return result_itr.scalars().all()

    async def get_latest_photo(self, db: Session, device_id: str) -> Optional[Photo]:
        result_itr = await (db.execute(select(self.model)
                                       .filter_by(device_id=device_id)
                                       .order_by(self.model.creation_date.desc())))
        return result_itr.scalars().first()

    async def get_photo_count_by_device_id(self, db: Session, device_id):
        result_itr = await (db.execute(select(func.count())
                                       .select_from(self.model)
                                       .where(self.model.device_id == device_id)))
        return result_itr.scalars().first()

    async def get_photos_by_device_id(self, db: Session, device_id):
        result_itr = await (db.execute(select(self.model)
                                       .where(self.model.device_id == device_id)))
        return result_itr.scalars().all()

    async def get_devices(self, db: Session):
        result_itr = await (
            db.execute(select(
                self.model.device_id,
                func.count(self.model.device_id),
                func.sum(self.model.file_size),
                func.sum(self.model.thumbnail_file_size)
            ).group_by(self.model.device_id))
        )
        return result_itr.all()


PhotoRepo = CRUDPhoto(Photo)
