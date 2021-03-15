import datetime
from typing import Optional, Any, Type

from pydantic import BaseModel


class PhotoSchema(BaseModel):
    @classmethod
    def from_orm(cls: Type['Model'], obj: Any) -> 'Model':
        if obj is None:
            return None
        return super().from_orm(obj)

    # media_metadata = Column(JSON(none_as_null=True), nullable=True, default=None)

    class Config:
        orm_mode = True


class PhotoSchemaFull(PhotoSchema):
    id: Optional[int]
    path: Optional[str]
    checksum: Optional[str]
    gphoto_id: Optional[str]
    mime_type: Optional[str]
    thumbnail_path: Optional[str]

    native_id: Optional[str]
    device_id: Optional[str]

    filename: Optional[str]
    # media_metadata: Optional[Dict]
    creation_date: Optional[datetime.datetime]
    modified_date: Optional[datetime.datetime]
    width: Optional[int]
    height: Optional[int]
    longitude: Optional[float]
    latitude: Optional[float]


class PhotoSchemaAdd(PhotoSchema):
    native_id: Optional[str]
    device_id: Optional[str]

    gphoto_id: Optional[str]
    filename: Optional[str]
    # media_metadata: Optional[Dict]
    creation_date: Optional[datetime.datetime]
    modified_date: Optional[datetime.datetime]
    width: Optional[int]
    height: Optional[int]
    longitude: Optional[float]
    latitude: Optional[float]


class PhotoSchemaUpdate(PhotoSchemaAdd):
    id: Optional[int]


class PhotoSchemaDelete(PhotoSchema):
    id: Optional[int]

# # Properties to receive on item creation
# class PhotoSchemaAdd(PhotoSchemaBase):
#     pass
#
#
# # Properties to receive on item update
# class PhotoSchemaUpdate(PhotoSchemaBase):
#     pass
#
#
# class PhotoSchemaInDBBase(PhotoSchemaBase):
#     class Config:
#         orm_mode = True
#
#
# # Properties to return to client
# class PhotoSchema(PhotoSchemaInDBBase):
#     pass
#
#
# # Properties properties stored in DB
# class PhotoInDB(PhotoSchemaInDBBase):
#     pass
#
