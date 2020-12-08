# -*- coding: utf-8 -*-
"""Create an application instance."""

from photostore.app import create_app
from photostore.settings import DevConfig, establish_config

# CONFIG = DevConfig if get_debug_flag() else ProdConfig
config = establish_config(DevConfig)
app = create_app(config)
# app.run()
