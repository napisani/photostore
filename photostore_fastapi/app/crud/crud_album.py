from .base import CRUDBase
from ..models.album_model import Album
from ..schemas.album_schema import AlbumSchemaAdd, AlbumSchemaUpdate


class CRUDAlbum(CRUDBase[Album, AlbumSchemaAdd, AlbumSchemaUpdate]):
    pass


AlbumRepo = CRUDAlbum(Album)
