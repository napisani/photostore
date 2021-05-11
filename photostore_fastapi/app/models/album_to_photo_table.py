from sqlalchemy import Column, Integer, Table, ForeignKey

from ..db.base_class import Base

album_to_photo_table = Table('album_to_photo', Base.metadata,
                             Column('album_id', Integer, ForeignKey('album.id', ondelete='cascade'), primary_key=True),
                             Column('photo_id', Integer, ForeignKey('photo.id', ondelete='cascade'), primary_key=True, )
                             )
