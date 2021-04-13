import os

from loguru import logger

from app.service.video_file_helper import get_thumbnail_frame_from_video


class TestVideoFileHelper:
    def test_get_thumbnail_frame_from_video(self, video_factory):
        video = video_factory()
        buffer = get_thumbnail_frame_from_video(path=video.path)
        logger.info(buffer)
        assert buffer
        assert os.path.exists(buffer)
