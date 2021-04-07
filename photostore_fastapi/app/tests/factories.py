# -*- coding: utf-8 -*-
"""Factories to help in tests."""
import datetime
import os

from factory import Sequence, Factory

from app.core.config import settings
from app.models.photo_model import Photo
from app.utils import get_file_checksum


def make_photo_factory():
    class BaseFactory(Factory):
        """Base factory."""

        class Meta:
            """Factory configuration."""
            abstract = True

    class PhotoFactory(BaseFactory):
        """User factory."""

        @staticmethod
        def get_path_photo(n):
            path = os.path.join(settings.PROJECT_ROOT, 'test_resources', 'photo_{0}.PNG'.format(n))
            return path

        @staticmethod
        def _get_checksum(n):
            return get_file_checksum(PhotoFactory.get_path_photo(n))

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

        filename = Sequence(lambda n: 'photo_{0}.PNG'.format(n))
        device_id = Sequence(lambda n: 'phone_1')
        native_id = Sequence(lambda n: 'native_id_{0}'.format(n))

        path = Sequence(lambda n: PhotoFactory.get_path_photo(n))
        thumbnail_path = Sequence(lambda n: PhotoFactory.get_path_photo(n))
        checksum = Sequence(lambda n: PhotoFactory._get_checksum(n))
        gphoto_id = Sequence(lambda n: f'gphoto_id_{n}')
        mime_type = Sequence(lambda n: 'image/png')
        creation_date = Sequence(lambda n: datetime.datetime.utcnow())
        modified_date = Sequence(lambda n: datetime.datetime.utcnow())
        height = Sequence(lambda n: 768)
        width = Sequence(lambda n: 1024)
        longitude = Sequence(lambda n: 0.0)
        latitude = Sequence(lambda n: 0.0)

        # email = Sequence(lambda n: 'user{0}@example.com'.format(n))
        # password = PostGenerationMethodCall('set_password', 'example')
        # media_metadata = Sequence(lambda n: PhotoFactory._get_metadata(n))

        class Meta:
            """Factory configuration."""
            model = Photo

    return PhotoFactory
