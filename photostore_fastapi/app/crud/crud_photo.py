from typing import Optional

from sqlalchemy.orm import Session

from .base import CRUDBase
from ..models.pagination import Pagination
from ..models.photo_model import Photo
from ..schemas.photo_schema import PhotoSchema


class CRUDPhoto(CRUDBase[Photo, PhotoSchema, PhotoSchema]):

    def get_photos(self, db: Session, page, per_page=10) -> Pagination:
        return self._paginate((db.query(self.model)
                               .order_by(self.model.creation_date.desc())),
                              page=page,
                              per_page=per_page,
                              error_out=False)

    def get_latest_photo(self, db: Session) -> Optional[Photo]:
        return db.query(self.model).order_by(self.model.creation_date.desc()).first()

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
