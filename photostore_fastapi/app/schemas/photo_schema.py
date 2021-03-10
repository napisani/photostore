import datetime
from typing import Optional, Dict

from pydantic import BaseModel



class PhotoSchema(BaseModel):
    id: Optional[int]
    path: Optional[str]
    filename: Optional[str]
    checksum: Optional[str]
    gphoto_id: Optional[str]
    mime_type: Optional[str]
    # media_metadata = Column(JSON(none_as_null=True), nullable=True, default=None)
    media_metadata: Optional[Dict]
    thumbnail_path: Optional[str]
    creation_date: Optional[datetime.datetime]

    class Config:
        orm_mode = True


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
