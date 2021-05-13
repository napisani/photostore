import datetime
from typing import Optional, Any, Type

from pydantic import BaseModel

from app.obj.media_type import MediaType


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
    media_type: Optional[MediaType]

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
    file_size: Optional[float]
    thumbnail_file_size: Optional[float]


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


class PhotoDiffRequestSchema(BaseModel):
    native_id: Optional[str]
    device_id: Optional[str]
    modified_date: Optional[datetime.datetime]
    checksum: Optional[str]


class PhotoDiffResultSchema(BaseModel):
    photo_id: Optional[int]
    native_id: Optional[str]
    device_id: Optional[str]
    exists: Optional[bool]
    same_date: Optional[bool]
    same_checksum: Optional[bool]


class DeviceResultSchema(BaseModel):
    device_id: Optional[str]
    count: Optional[str]
    file_size_total: Optional[float]
    thumbnail_file_size_total: Optional[float]


class PhotoDateRangeSchema(BaseModel):
    modified_date_start: Optional[datetime.datetime]
    modified_date_end: Optional[datetime.datetime]
    create_date_start: Optional[datetime.datetime]
    create_date_end: Optional[datetime.datetime]
