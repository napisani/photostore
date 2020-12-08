import datetime

from sqlalchemy import Column

from photostore.database import SurrogatePK
from photostore.extensions import db


class Photo(SurrogatePK, db.Model):
    __tablename__ = 'photos'
    path = Column(db.String(1024), unique=False, nullable=False, default='')
    filename = Column(db.String(256), unique=False, nullable=False, default='')
    checksum = Column(db.String(256), unique=False, nullable=False, default='')
    gphoto_id = Column(db.String(256), unique=False, nullable=False, default='')
    mime_type = Column(db.String(50), unique=False, nullable=False, default='')
    media_metadata = Column(db.JSON(none_as_null=True), nullable=True, default=None)
    thumbnail_path = Column(db.String(1024), unique=False, nullable=False, default='')
    creation_date = Column(db.DateTime, nullable=False, default=datetime.datetime.utcnow)
