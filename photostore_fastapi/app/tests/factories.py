# -*- coding: utf-8 -*-
"""Factories to help in tests."""
import datetime
import os

import pytest
from factory import Sequence
from factory.alchemy import SQLAlchemyModelFactory
from sqlalchemy.orm import Session

from app.core.config import settings
from app.models.photo_model import Photo
from app.utils import get_file_checksum

def make_photo_factory(db: Session):
    class BaseFactory(SQLAlchemyModelFactory):
        """Base factory."""

        class Meta:
            """Factory configuration."""
            abstract = True
            sqlalchemy_session = db

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
        path = Sequence(lambda n: PhotoFactory.get_path_photo(n))
        thumbnail_path = Sequence(lambda n: PhotoFactory.get_path_photo(n))
        checksum = Sequence(lambda n: PhotoFactory._get_checksum(n))
        gphoto_id = Sequence(lambda n: f'gphoto_id_{n}')
        mime_type = Sequence(lambda n: 'image/png')
        creation_date = Sequence(lambda n: datetime.datetime.utcnow())

        # email = Sequence(lambda n: 'user{0}@example.com'.format(n))
        # password = PostGenerationMethodCall('set_password', 'example')
        media_metadata = Sequence(lambda n: PhotoFactory._get_metadata(n))

        class Meta:
            """Factory configuration."""
            model = Photo

    return PhotoFactory()
