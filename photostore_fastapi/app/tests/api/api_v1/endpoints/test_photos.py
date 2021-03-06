from io import BytesIO

import pytest
from loguru import logger

from app.schemas.photo_schema import PhotoSchemaFull, PhotoDiffResultSchema, \
    PhotoDiffRequestSchema


# @pytest.mark.unit
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
        schema = PhotoSchemaFull(filename=photo.filename, device_id=photo.device_id, native_id=photo.native_id,
                                 path=photo.path)
        logger.debug("photo created by factory {}", photo)
        data = {
            'file': (photo.filename, open(photo.path, 'rb')),
            'metadata': ('metadata.json', BytesIO(bytes(schema.json(), 'utf8')), 'application/json')
        }

        # assign an id as if it was saved to the db
        photo.id = 1
        # mock the actual add_photo service function so that it returns the exact photo object we are working with
        mocker.patch('app.api.api_v1.endpoints.photos.add_photo', return_value=schema)
        resp = test_client.post('/api/v1/photos/upload', files=data)
        logger.debug('test_simple resp {}', resp)
        logger.debug('test_simple resp.json {}', resp.json)
        added_photo = resp.json()
        logger.debug('test_simple added_photo {}', added_photo)

        assert resp
        assert resp.json
        assert added_photo
        # make sure the response matches the test data
        assert added_photo['filename'] == schema.filename
        assert added_photo['checksum'] == schema.checksum

    def test_get_thumbnail(self, mocker, test_client, photo_factory):
        photo = photo_factory()
        schema = PhotoSchemaFull(filename=photo.filename, device_id=photo.device_id, native_id=photo.native_id,
                                 path=photo.path, thumbnail_path=photo.thumbnail_path)
        photo.id = 1
        mocker.patch('app.api.api_v1.endpoints.photos.get_photo', return_value=schema)
        url = f'/api/v1/photos/thumbnail/{photo.id}'
        logger.debug('test_get_thumbnail url {}', url)
        logger.debug('photo.path  {}', photo.path)
        logger.debug('photo.thumbnail_path  {}', photo.thumbnail_path)
        resp = test_client.get(url)
        assert resp

    def test_get_original_file(self, mocker, test_client, photo_factory):
        photo = photo_factory()
        schema = PhotoSchemaFull(filename=photo.filename, device_id=photo.device_id, native_id=photo.native_id,
                                 path=photo.path, thumbnail_path=photo.thumbnail_path)
        photo.id = 1
        mocker.patch('app.api.api_v1.endpoints.photos.get_photo', return_value=schema)
        url = f'/api/v1/photos/original_file/{photo.id}'
        logger.debug('test_get_original_file url {}', url)
        logger.debug('photo.path  {}', photo.path)
        logger.debug('photo.thumbnail_path  {}', photo.thumbnail_path)
        resp = test_client.get(url)
        assert resp

    def test_post_diff(self, mocker, test_client, photo_factory):
        req_schema = PhotoDiffRequestSchema(native_id='1', device_id='1')
        schema = PhotoDiffResultSchema(exists=True)
        mocker.patch('app.api.api_v1.endpoints.photos.diff_photos', return_value=[schema])
        url = f'/api/v1/photos/diff'
        resp = test_client.post(url, json=[req_schema.dict()])
        assert resp

    def test_get_latest(self, mocker, test_client, photo_factory):
        photo = photo_factory()
        mocker.patch('app.api.api_v1.endpoints.photos.get_latest_photo', return_value=photo)
        url = f'/api/v1/photos/latest/{photo.device_id}'
        resp = test_client.get(url)
        assert resp


    def test_count_photos(self, mocker, test_client, photo_factory):
        photo = photo_factory()
        mocker.patch('app.api.api_v1.endpoints.photos.count_photos', return_value=1)
        url = f'/api/v1/photos/count/{photo.device_id}'
        resp = test_client.get(url)
        assert resp