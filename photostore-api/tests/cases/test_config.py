# -*- coding: utf-8 -*-
"""Test configs."""
import pytest

from photostore.app import create_app
from photostore.settings import ProdConfig, DevConfig

@pytest.mark.unit
def test_production_config():
    """Production config."""
    app = create_app(ProdConfig)
    assert app.config['ENV'] == 'PROD'
    assert not app.config['DEBUG']

@pytest.mark.unit
def test_dev_config():
    """Development config."""
    app = create_app(DevConfig)
    assert app.config['ENV'] == 'DEV'
    assert app.config['DEBUG']

