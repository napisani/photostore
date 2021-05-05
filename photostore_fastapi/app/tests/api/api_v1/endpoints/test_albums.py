from loguru import logger

from app.schemas.album_schema import AlbumSchemaAdd, AlbumSchemaFull, AlbumSchemaAssociate


class TestAlbumAPI:
    def test_post_album(self, mocker, test_client, album_factory):
        req_schema = AlbumSchemaAdd(name='album_1')
        resp_schema = AlbumSchemaFull(name='album_1', id=1)
        mocker.patch('app.api.api_v1.endpoints.albums.add_album', return_value=resp_schema)
        url = f'/api/v1/albums/add_album'
        resp = test_client.post(url, json=[req_schema.dict()])
        logger.debug('test_post_album resp.json {}', resp.json)
        added_album = resp.json()
        logger.debug('test_post_album added_album {}', added_album)
        assert added_album
        assert added_album['id'] == 1

    def test_delete_album(self, mocker, test_client, album_factory):
        resp_schema = AlbumSchemaFull(name='album_1', id=1)
        mocker.patch('app.api.api_v1.endpoints.albums.delete_album', return_value=resp_schema)
        url = f'/api/v1/albums/delete_album/1'
        resp = test_client.delete(url)
        logger.debug('test_delete_album  resp.json {}', resp.json)
        deleted_album = resp.json()
        logger.debug('test_delete_album deleted_album {}', deleted_album)
        assert deleted_album
        assert deleted_album['id'] == 1

    def test_get_all_albums(self, mocker, test_client, album_factory):
        resp_schema = [AlbumSchemaFull(name='album_1', id=1)]
        mocker.patch('app.api.api_v1.endpoints.albums.get_all_albums', return_value=resp_schema)
        url = f'/api/v1/albums/get_albums'
        resp = test_client.get(url)
        logger.debug('test_get_all_albums  resp.json {}', resp.json)
        albums = resp.json()
        logger.debug('test_get_all_albums albums {}', albums)
        assert albums
        assert len(albums) == 1

    def test_get_album(self, mocker, test_client, album_factory):
        resp_schema = AlbumSchemaFull(name='album_1', id=1)
        mocker.patch('app.api.api_v1.endpoints.albums.get_album', return_value=resp_schema)
        url = f'/api/v1/albums/get_album/1'
        resp = test_client.get(url)
        logger.debug('test_get_album  resp.json {}', resp.json)
        get_album = resp.json()
        logger.debug('test_get_album get_album {}', get_album)
        assert get_album
        assert get_album['id'] == 1

    def test_remove_photo_associations_by_device_id(self, mocker, test_client, album_factory):
        resp_schema = AlbumSchemaFull(name='album_1', id=1)
        mocker.patch('app.api.api_v1.endpoints.albums.remove_photo_associations_by_device_id',
                     return_value=resp_schema)
        url = f'/api/v1/albums/remove_photos_from_album/album_1/dev_1'
        resp = test_client.delete(url)
        logger.debug('test_remove_photo_associations_by_device_id  resp.json {}', resp.json)
        album = resp.json()
        logger.debug('test_remove_photo_associations_by_device_id get_album {}', album)
        assert album
        assert album['id'] == 1

    def test_add_photos_album(self, mocker, test_client, album_factory):
        req_schema = AlbumSchemaAssociate(name='alum_1', device_id='dev_1', native_id='native_1')
        resp_schema = AlbumSchemaFull(name='album_1', id=1)
        mocker.patch('app.api.api_v1.endpoints.albums.associate_photos_with_album',
                     return_value=resp_schema)
        url = f'/api/v1/albums/add_photos_to_album'
        resp = test_client.post(url, json=[req_schema.dict()])
        logger.debug('test_add_photos_album  resp.json {}', resp.json)
        album = resp.json()
        logger.debug('test_add_photos_album get_album {}', album)
        assert album
        assert album['id'] == 1
