# Import all the models, so that Base has them before being
# imported by Alembic
from .base_class import Base  # noqa
from ..models.album_model import Album  # noqa
from ..models.album_to_photo_table import album_to_photo_table  # noqa
from ..models.photo_model import Photo  # noqa
