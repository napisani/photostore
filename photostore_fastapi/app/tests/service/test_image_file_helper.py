import pytest
from loguru import logger

from app.service.image_file_helper import _get_unique_filename


# @pytest.mark.unit
class TestPhotoService:
    def test_unique_filename(self, mocker, db):
        def mock_exists(filename):
            logger.debug(filename)
            if '(4)' in filename:
                return False
            return True

        mocker.patch('app.service.image_file_helper.os.path.exists', side_effect=mock_exists)
        unique_filename = _get_unique_filename('photo_0.PNG', 'dev1')
        assert unique_filename == 'photo_0_(4).PNG'
