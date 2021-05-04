import datetime

from sqlalchemy import Column, Integer, String, DateTime, Float, UniqueConstraint
from sqlalchemy.orm import relationship

# from .album_to_photo_table import album_to_photo_table
from .album_to_photo_table import album_to_photo_table
from ..db.base_class import Base
from ..obj.media_type import MediaType


class Photo(Base):
    # __tablename__ = 'photos'
    id = Column(Integer, primary_key=True, index=True)
    native_id = Column(String(128), unique=False, nullable=False, default='')
    device_id = Column(String(128), unique=False, nullable=False, default='')
    media_type = Column(String(20), unique=False, nullable=False, default=MediaType.IMAGE)
    path = Column(String(1024), unique=False, nullable=False, default='')
    filename = Column(String(256), unique=False, nullable=False, default='')
    checksum = Column(String(256), unique=False, nullable=False, default='')
    gphoto_id = Column(String(256), unique=False, nullable=False, default='')
    mime_type = Column(String(50), unique=False, nullable=False, default='')
    # media_metadata = Column(JSON(none_as_null=True), nullable=True, default=None)
    thumbnail_path = Column(String(1024), unique=False, nullable=False, default='')
    creation_date = Column(DateTime, nullable=False, default=datetime.datetime.utcnow)
    modified_date = Column(DateTime, nullable=False, default=datetime.datetime.utcnow)
    width = Column(Integer, unique=False, nullable=False, default=0)
    height = Column(Integer, unique=False, nullable=False, default=0)
    longitude = Column(Float, unique=False, nullable=False, default=0.0)
    latitude = Column(Float, unique=False, nullable=False, default=0.0)
    file_size = Column(Float, unique=False, nullable=True, default=0.0)
    thumbnail_file_size = Column(Float, unique=False, nullable=True, default=0.0)
    # albums = relationship('Album', secondary=album_to_photo_table, backref='Photo', lazy='dynamic')

    UniqueConstraint('native_id', 'device_id', name='native_device_ids_idx')
