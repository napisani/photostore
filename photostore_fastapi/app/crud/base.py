from typing import Any, Dict, Generic, List, Optional, Type, TypeVar, Union

from fastapi.encoders import jsonable_encoder
from pydantic import BaseModel
from sqlalchemy import select, func, delete
from sqlalchemy.orm import Session, Query

from app.db.base_class import Base
from app.models.pagination import Pagination

ModelType = TypeVar("ModelType", bound=Base)
CreateSchemaType = TypeVar("CreateSchemaType", bound=BaseModel)
UpdateSchemaType = TypeVar("UpdateSchemaType", bound=BaseModel)


class CRUDBase(Generic[ModelType, CreateSchemaType, UpdateSchemaType]):
    def __init__(self, model: Type[ModelType]):
        """
        CRUD object with default methods to Create, Read, Update, Delete (CRUD).

        **Parameters**

        * `model`: A SQLAlchemy model class
        * `schema`: A Pydantic model (schema) class
        """
        self.model = model

    async def get_by_id(self, db: Session, id: Any) -> Optional[ModelType]:
        return await db.execute(select(self.model).where(self.model.id == id).first())

    async def get_multi(
            self, db: Session, *, skip: int = 0, limit: int = 100
    ) -> List[ModelType]:
        return await db.execute(select(self.model)).offset(skip).limit(limit)

    async def create(self, db: Session, *, obj_in: CreateSchemaType) -> ModelType:
        obj_in_data = jsonable_encoder(obj_in)
        db_obj = self.model(**obj_in_data)  # type: ignore
        db.add(db_obj)
        await db.commit()
        await db.refresh(db_obj)
        return db_obj

    async def update(
            self,
            db: Session,
            *,
            db_obj: ModelType,
            obj_in: Union[UpdateSchemaType, Dict[str, Any]]
    ) -> ModelType:
        obj_data = jsonable_encoder(db_obj)
        if isinstance(obj_in, dict):
            update_data = obj_in
        else:
            update_data = obj_in.dict(exclude_unset=True)
        for field in obj_data:
            if field in update_data:
                setattr(db_obj, field, update_data[field])
        await db.add(db_obj)
        await db.commit()
        await db.refresh(db_obj)
        return db_obj

    async def remove(self, db: Session, *, id: int) -> ModelType:
        obj = db.execute(select(self.model).where(self.model.id == id))
        db.execute(delete(self.model).where(self.model.id == id))
        await db.commit()
        return obj

    async def delete_all(self, db: Session):
        await db.execute(delete(self.model))
        await db.commit()

    async def _paginate(self, db: Session, query: Query, model: BaseModel, page=None, per_page=None, error_out=True,
                        max_per_page=None):
        """Returns ``per_page`` items from page ``page``.

        If ``page`` or ``per_page`` are ``None``, they will be retrieved from
        the request query. If ``max_per_page`` is specified, ``per_page`` will
        be limited to that value. If there is no request or they aren't in the
        query, they default to 1 and 20 respectively.

        When ``error_out`` is ``True`` (default), the following rules will
        cause a 404 response:

        * No items are found and ``page`` is not 1.
        * ``page`` is less than 1, or ``per_page`` is negative.
        * ``page`` or ``per_page`` are not ints.

        When ``error_out`` is ``False``, ``page`` and ``per_page`` default to
        1 and 20 respectively.

        Returns a :class:`Pagination` object.
        """

        if page is None:
            page = 1

        if per_page is None:
            per_page = 20

        if max_per_page is not None:
            per_page = min(per_page, max_per_page)

        if page < 1:
            if error_out:
                _abort(404)
            else:
                page = 1

        if per_page < 0:
            if error_out:
                _abort(404)
            else:
                per_page = 20

        item_result = await db.execute(query.limit(per_page).offset((page - 1) * per_page))
        items = item_result.scalars().all()
        if not items and page != 1 and error_out:
            _abort(404)
        total = (
            (await db.execute(select(func.count()).select_from(model)))
                .scalars()
                .one()
        )
        print(f'total {total}')

        return Pagination(query, page, per_page, total, items)


def _abort(code):
    raise Exception('TODO Pagination exception')
