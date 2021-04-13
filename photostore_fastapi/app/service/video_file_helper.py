import os

from app.core.config import settings


def get_thumbnail_frame_from_video(path, offset=5):
    # pipeline = gst.parse_launch('playbin')
    # pipeline.props.uri = 'file://' + os.path.abspath(path)
    # pipeline.props.audio_sink = gst.element_factory_make('fakesink')
    # pipeline.props.video_sink = gst.element_factory_make('fakesink')
    # pipeline.set_state(gst.STATE_PAUSED)
    # # Wait for state change to finish.
    # pipeline.get_state()
    # assert pipeline.seek_simple(
    #     gst.FORMAT_TIME, gst.SEEK_FLAG_FLUSH, offset * gst.SECOND)
    # # Wait for seek to finish.
    # pipeline.get_state()
    # buffer = pipeline.emit('convert-sample', caps)
    # pipeline.set_state(gst.STATE_NULL)
    #
    #

    return os.path.join(settings.PROJECT_ROOT, 'runtime_resources', 'video_thumb.PNG')
