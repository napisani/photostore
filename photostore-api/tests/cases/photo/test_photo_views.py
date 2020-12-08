from io import BytesIO

import pytest
from flask import url_for
from loguru import logger

from photostore.photos.photo_schema import PhotoSchema
from tests.factories import PhotoFactory


@pytest.mark.unit
class TestPhotoViews:
    # def test_upload_photo(self, testapp):
    #     mocker.patch('photo_views.add_photo', return_value='ADDED MOCK PHOTO')

    def test_simple(self, testapp):
        resp = testapp.post(url_for('photos.view_simple', test_input='nick'), headers={
            'Authorization': 'Token {}'.format('test')
        })
        logger.debug('test_simple {}', resp)
        assert resp
        assert 'PHOTOS' in resp

    # test uploading files
    def test_view_upload_photo(self, mocker, test_client):
        schema = PhotoSchema()
        photo = PhotoFactory()
        logger.debug("photo created by factory {}", photo)
        data = {
            'file': (open(photo.path, 'rb'), photo.filename),
            'metadata': (BytesIO(bytes(schema.dumps(photo), 'utf8')), 'metadata', 'application/json')
        }

        # assign an id as if it was saved to the db
        photo.id = 1
        # mock the actual add_photo service function so that it returns the exact photo object we are working with
        mocker.patch('photostore.photos.photo_views.add_photo', return_value=photo)
        resp = test_client.post(url_for('photos.view_upload_photo'), data=data, headers={
            'Authorization': 'Token {}'.format('test')
        })
        logger.debug('test_simple resp {}', resp)
        logger.debug('test_simple resp.json {}', resp.json)
        added_photo = schema.load(resp.json)
        logger.debug('test_simple added_photo {}', added_photo)

        assert resp
        assert resp.json
        assert added_photo
        # make sure the response matches the test data
        assert added_photo['filename'] == photo.filename
        assert added_photo['checksum'] == photo.checksum

    def test_get_thumbnail(self, mocker, test_client):
        photo = PhotoFactory()
        photo.id = 1
        data = {
            'photo_id': f'{photo.id}'
        }
        mocker.patch('photostore.photos.photo_views.get_photo', return_value=photo)
        url = url_for('photos.view_get_thumbnail', photo_id=f'{photo.id}')
        logger.debug('test_get_thumbnail url {}', url)
        logger.debug('photo.path  {}', photo.path)
        logger.debug('photo.thumbnail_path  {}', photo.thumbnail_path)
        resp = test_client.get(url, headers={
            'Authorization': 'Token {}'.format('test')
        })
        assert resp

    def test_get_fullsize(self, mocker, test_client):
        photo = PhotoFactory()
        photo.id = 1
        data = {
            'photo_id': f'{photo.id}'
        }
        mocker.patch('photostore.photos.photo_views.get_photo', return_value=photo)
        url = url_for('photos.view_get_thumbnail', photo_id=f'{photo.id}')
        logger.debug('test_get_fullsize url {}', url)
        logger.debug('photo.path  {}', photo.path)
        resp = test_client.get(url, headers={
            'Authorization': 'Token {}'.format('test')
        })
        assert resp
