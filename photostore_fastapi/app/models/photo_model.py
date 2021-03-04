import datetime

from typing import TYPE_CHECKING

from sqlalchemy import Boolean, Column, Integer, String, DateTime, JSON

from ..db.base_class import Base

if TYPE_CHECKING:
    from .item import Item  # noqa: F401


class Photo(Base):
    # __tablename__ = 'photos'
    id = Column(Integer, primary_key=True, index=True)
    path = Column(String(1024), unique=False, nullable=False, default='')
    filename = Column(String(256), unique=False, nullable=False, default='')
    checksum = Column(String(256), unique=False, nullable=False, default='')
    gphoto_id = Column(String(256), unique=False, nullable=False, default='')
    mime_type = Column(String(50), unique=False, nullable=False, default='')
    media_metadata = Column(JSON(none_as_null=True), nullable=True, default=None)
    thumbnail_path = Column(String(1024), unique=False, nullable=False, default='')
    creation_date = Column(DateTime, nullable=False, default=datetime.datetime.utcnow)
