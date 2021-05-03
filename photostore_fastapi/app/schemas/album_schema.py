from typing import Optional, Any, Type, List

from pydantic import BaseModel


class AlbumSchema(BaseModel):
    @classmethod
    def from_orm(cls: Type['Model'], obj: Any) -> 'Model':
        if obj is None:
            return None
        return super().from_orm(obj)

    # media_metadata = Column(JSON(none_as_null=True), nullable=True, default=None)

    class Config:
        orm_mode = True


class AlbumSchemaFull(AlbumSchema):
    id: Optional[int]
    name: Optional[str]
    photo_ids: Optional[List[int]]


class AlbumSchemaAdd(AlbumSchema):
    name: Optional[str]


class AlbumSchemaUpdate(AlbumSchema):
    id: Optional[int]
    name: Optional[str]


class AlbumSchemaAssociate(AlbumSchema):
    name: Optional[str]
    device_id: Optional[str]
    native_id: Optional[str]
