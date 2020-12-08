import os
# OR, explicitly providing path to '.env'
from pathlib import Path  # Python 3.6+ only

from dotenv import load_dotenv

# # OR, the same with increased verbosity
# load_dotenv(verbose=True)

_app_dir = os.path.abspath(os.path.dirname(__file__))  # This directory
_project_root_dir = os.path.abspath(os.path.join(_app_dir, os.pardir))

env_path = Path(_project_root_dir) / '.env'
load_dotenv(dotenv_path=env_path, verbose=True)
basedir = os.path.abspath(os.path.dirname(__file__))


class Config(object):
    DEBUG = False
    TESTING = False
    CSRF_ENABLED = True

    APP_DIR = _app_dir  # This directory
    PROJECT_ROOT = _project_root_dir
    SECRET_KEY = os.environ.get('SECRET_KEY',
                                'some-default-value'),

    DB_NAME = 'photostore'
    DB_PATH = os.path.join(PROJECT_ROOT, DB_NAME)
    SQLALCHEMY_DATABASE_URI = 'sqlite:///{0}'.format(DB_PATH)
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    GOOGLE_PHOTOS_OAUTH_FILE = os.environ.get('GOOGLE_PHOTOS_OAUTH_FILE', '')

    SAVE_PHOTO_DIR = os.environ.get('SAVE_PHOTO_DIR', '/tmp/photostore')


class ProdConfig(Config):
    DEBUG = False
    ENV = 'PROD'


class StagingConfig(Config):
    DEVELOPMENT = True
    DEBUG = True
    ENV = 'STAGING'


class DevConfig(Config):
    DEVELOPMENT = True
    ENV = 'DEV'
    DEBUG = True

    SQLALCHEMY_DATABASE_URI = 'mysql+pymysql://photostore:just_testing@127.0.0.1/photostore?charset=utf8mb4'
    # Put the db file in project root


class TestingConfig(Config):
    ENV = 'TEST'
    TESTING = True
    SQLALCHEMY_DATABASE_URI = 'mysql+pymysql://photostore:just_testing@127.0.0.1/photostore?charset=utf8mb4'
    SAVE_PHOTO_DIR = '/tmp/photostore'

    CLEAN_UP_AFTER_TESTS = False



_current_config = None
def establish_config(config=ProdConfig):
    global _current_config
    _current_config = config
    return config;


def get_config():
    if _current_config is None:
        raise Exception("a Config class has not been established yet make sure to call establish_config() first")
    return _current_config
