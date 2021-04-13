# -*- coding: utf-8 -*-
"""Factories to help in tests."""
import datetime
import os

from app.core.config import settings
from app.models.photo_model import Photo
from app.obj.media_type import MediaType
from app.utils import get_file_checksum


class _TestPhotoFactory:
    @staticmethod
    def get_path_photo(n):
        path = os.path.join(settings.PROJECT_ROOT, 'test_resources', 'photo_{0}.PNG'.format(n))
        return path

    @staticmethod
    def _get_checksum(n):
        return get_file_checksum(_TestPhotoFactory.get_path_photo(n))

    @staticmethod
    def _get_metadata(n):
        m = """
        "mediaMetadata":{
          "creationTime":"2020-11-17T20:10:58Z",
          "width":"3024",
          "height":"4032",
          "photo":{
             "cameraMake":"Apple",
             "cameraModel":"iPhone XR",
             "focalLength":4.25,
             "apertureFNumber":1.8,
             "isoEquivalent":40
          }
        }
        """
        return m

    def __init__(self, media_type=MediaType.IMAGE):
        self.cnt = 1
        self._generators = {
            'filename': (lambda n: 'photo_{0}.PNG'.format(n)) if media_type == MediaType.IMAGE else (
                lambda n: 'video_test{0}.mov'.format(n)),
            'device_id': lambda n: 'phone_1',
            'media_type': lambda n: media_type,
            'native_id': lambda n: 'native_id_{0}'.format(n),
            'path': lambda n: _TestPhotoFactory.get_path_photo(n),
            'thumbnail_path': lambda n: _TestPhotoFactory.get_path_photo(n),
            'checksum': lambda n: _TestPhotoFactory._get_checksum(n),
            'gphoto_id': lambda n: f'gphoto_id_{n}',
            'mime_type': lambda n: 'image/png',
            'creation_date': lambda n: datetime.datetime.utcnow(),
            'modified_date': lambda n: datetime.datetime.utcnow(),
            'height': lambda n: 768,
            'width': lambda n: 1024,
            'longitude': lambda n: 0.0,
            'latitude': lambda n: 0.0,
        }

    def generate(self):
        p = Photo()
        for attr, value in self._generators.items():
            setattr(p, attr, value(self.cnt))
        self.cnt += 1
        return p


def make_photo_factory():
    fact = _TestPhotoFactory()
    return fact.generate


def make_video_factory():
    fact = _TestPhotoFactory(media_type=MediaType.VIDEO)
    return fact.generate
