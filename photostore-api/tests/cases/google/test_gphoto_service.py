import pytest

from photostore.google.gphoto_service import GPhotoService

@pytest.mark.gphoto
class TestGPhotoService:

    # def test_gphoto(self):
    #     gphoto = GPhotoService()
    #     gphoto.get_google_photos_from_album()
    #
    #     logger.debug('testingggggg')

    def test_save_file(self):
        gphoto = GPhotoService()
        gphoto.get_and_save()
