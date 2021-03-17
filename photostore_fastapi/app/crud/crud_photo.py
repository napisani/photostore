from typing import Optional, List

from sqlalchemy import or_, and_
from sqlalchemy.orm import Session

from .base import CRUDBase
from ..models.pagination import Pagination
from ..models.photo_model import Photo
from ..schemas.photo_schema import PhotoSchemaAdd, PhotoSchemaUpdate


class CRUDPhoto(CRUDBase[Photo, PhotoSchemaAdd, PhotoSchemaUpdate]):

    def get_photos(self, db: Session, page, per_page=10) -> Pagination:
        return self._paginate((db.query(self.model)
                               .order_by(self.model.creation_date.desc())),
                              page=page,
                              per_page=per_page,
                              error_out=False)

    def get_photos_by_native_ids(self, db: Session, device_native_id_pairs: List, ) -> List[Photo]:
        if len(device_native_id_pairs) == 0:
            return []

        cond = or_(*[and_(Photo.native_id == native, Photo.device_id == device)
                     for (device, native) in device_native_id_pairs])
        return db.query(self.model).filter(cond).all()

    def get_latest_photo(self, db: Session, device_id: str) -> Optional[Photo]:
        return (db.query(self.model)
                .filter_by(device_id=device_id)
                .order_by(self.model.creation_date.desc())
                .first())

        # def create_with_owner(
        #     self, db: Session, *, obj_in: ItemCreate, owner_id: int
        # ) -> Item:
        #     obj_in_data = jsonable_encoder(obj_in)
        #     db_obj = self.model(**obj_in_data, owner_id=owner_id)
        #     db.add(db_obj)
        #     db.commit()
        #     db.refresh(db_obj)
        #     return db_obj
        #
        # def get_multi_by_owner(
        #     self, db: Session, *, owner_id: int, skip: int = 0, limit: int = 100
        # ) -> List[Item]:
        #     return (
        #         db.query(self.model)
        #         .filter(Item.owner_id == owner_id)
        #         .offset(skip)
        #         .limit(limit)
        #         .all()
        #     )


PhotoRepo = CRUDPhoto(Photo)
