# -*- coding: utf-8 -*-
"""Defines fixtures available to all tests."""
import os
import shutil

import pytest
from loguru import logger
from webtest import TestApp

from photostore.app import create_app
from photostore.extensions import db as _db
from photostore.settings import TestingConfig, establish_config


@pytest.yield_fixture(scope='function')
def config():
    return establish_config(TestingConfig)


@pytest.yield_fixture(scope='function')
def app(config):
    """An application for the tests."""
    _config = config

    if not os.path.exists(_config.SAVE_PHOTO_DIR):
        os.makedirs(_config.SAVE_PHOTO_DIR)
    _app = create_app(_config)

    with _app.app_context():
        _db.create_all()

    ctx = _app.test_request_context()
    ctx.push()

    yield _app

    if _config.CLEAN_UP_AFTER_TESTS:
        logger.debug('cleaning up photo directory')
        shutil.rmtree(_config.SAVE_PHOTO_DIR)

    ctx.pop()


@pytest.fixture(scope='function')
def testapp(app):
    """A Webtest app."""
    return TestApp(app)


@pytest.yield_fixture(scope='function')
def db(app, config):
    """A database for the tests."""
    _db.app = app
    with app.app_context():
        _db.create_all()

    yield _db

    # Explicitly close DB connection
    _db.session.close()
    if config.CLEAN_UP_AFTER_TESTS:
        logger.debug('cleaning up db')
        _db.drop_all()


@pytest.fixture(scope='function')
def test_client(app):
    flask_app = app
    testing_client = flask_app.test_client()
    ctx = flask_app.app_context()
    ctx.push()
    yield testing_client
    ctx.pop()
