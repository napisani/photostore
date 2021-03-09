from io import BytesIO

import pytest
from loguru import logger

from app.schemas.photo_schema import PhotoSchema


@pytest.mark.unit
class TestPhotosAPI:
    def test_health(self, test_client):
        resp = test_client.get('/api/v1/photos/health')
        logger.debug('test_health {}', resp)
        assert resp
        assert resp.status_code == 200
        assert 'OKAY' in resp.json().values()

    # test uploading files
    def test_view_upload_photo(self, mocker, photo_factory, test_client):
        photo = photo_factory()
        schema = PhotoSchema(filename=photo.filename, path=photo.path)
        logger.debug("photo created by factory {}", photo)
        data = {
            'file': (photo.filename, open(photo.path, 'rb')),
            'metadata': ('metadata.json', BytesIO(bytes(schema.json(), 'utf8')), 'application/json')
        }

        # assign an id as if it was saved to the db
        photo.id = 1
        # mock the actual add_photo service function so that it returns the exact photo object we are working with
        # mocker.patch('photostore.photos.photo_views.add_photo', return_value=photo)
        resp = test_client.post('/api/v1/photos/upload', files=data)
        logger.debug('test_simple resp {}', resp)
        logger.debug('test_simple resp.json {}', resp.json)
        added_photo = resp.json()
        logger.debug('test_simple added_photo {}', added_photo)

        assert resp
        assert resp.json
        assert added_photo
        # make sure the response matches the test data
        assert added_photo['filename'] == photo.filename
        assert added_photo['checksum'] == photo.checksum
    #
    # def test_get_thumbnail(self, mocker, test_client):
    #     photo = PhotoFactory()
    #     photo.id = 1
    #     data = {
    #         'photo_id': f'{photo.id}'
    #     }
    #     mocker.patch('photostore.photos.photo_views.get_photo', return_value=photo)
    #     url = url_for('photos.view_get_thumbnail', photo_id=f'{photo.id}')
    #     logger.debug('test_get_thumbnail url {}', url)
    #     logger.debug('photo.path  {}', photo.path)
    #     logger.debug('photo.thumbnail_path  {}', photo.thumbnail_path)
    #     resp = test_client.get(url, headers={
    #         'Authorization': 'Token {}'.format('test')
    #     })
    #     assert resp
    #
    # def test_get_fullsize(self, mocker, test_client):
    #     photo = PhotoFactory()
    #     photo.id = 1
    #     data = {
    #         'photo_id': f'{photo.id}'
    #     }
    #     mocker.patch('photostore.photos.photo_views.get_photo', return_value=photo)
    #     url = url_for('photos.view_get_thumbnail', photo_id=f'{photo.id}')
    #     logger.debug('test_get_fullsize url {}', url)
    #     logger.debug('photo.path  {}', photo.path)
    #     resp = test_client.get(url, headers={
    #         'Authorization': 'Token {}'.format('test')
    #     })
    #     assert resp
