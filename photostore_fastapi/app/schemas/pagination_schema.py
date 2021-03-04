from typing import List, Generic, TypeVar, Optional

from pydantic.generics import GenericModel

T = TypeVar('T')


class PaginationSchema(GenericModel, Generic[T]):
    items: Optional[List[T]]
    total: Optional[int]
    page: Optional[int]
    per_page: Optional[int]
