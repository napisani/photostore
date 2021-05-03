from typing import TYPE_CHECKING

from sqlalchemy import Column, Integer, String, Table, ForeignKey

from ..db.base_class import Base

if TYPE_CHECKING:
    from .item import Item  # noqa: F401

album_to_photo_table = Table('album_to_photo', Base.metadata,
                             Column('album_id', Integer, ForeignKey('album.id')),
                             Column('photo_id', Integer, ForeignKey('photo.id'))
                             )


class Album(Base):
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(1024), unique=True, nullable=False, default='')
