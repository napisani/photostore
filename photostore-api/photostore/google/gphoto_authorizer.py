import io
import signal
from contextlib import redirect_stdout

from gphotospy import authorize
from loguru import logger

from photostore.settings import get_config

_config = get_config()

def authorize_gphoto_service():
    logger.info('using config {}', _config.GOOGLE_PHOTOS_OAUTH_FILE)

    stdout_stream = io.StringIO()

    def _handle_timeout(signum, frame):
        auth_message = stdout_stream.getvalue()
        raise TimeoutError(auth_message)

    signal.signal(signal.SIGALRM, _handle_timeout)
    signal.alarm(20)
    with redirect_stdout(stdout_stream):
        try:
            service = authorize.init(_config.GOOGLE_PHOTOS_OAUTH_FILE)
        finally:
            signal.alarm(0)
        return service

    return service
