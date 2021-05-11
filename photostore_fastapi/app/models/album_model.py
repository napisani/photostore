from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship, backref

from .album_to_photo_table import album_to_photo_table
from ..db.base_class import Base


class Album(Base):
    __name__ = 'album'
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(1024), unique=True, nullable=False, default='')
    photos = relationship('Photo',
                          secondary=album_to_photo_table,
                          backref=backref('albums', uselist=True,
                                          # lazy='joined'
                                          ),
                          lazy='joined')
