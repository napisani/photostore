from flask import Flask

from photostore import photos, commands
from photostore.settings import establish_config
from .extensions import db, migrate
from flask_cors import CORS


# basedir = os.path.abspath(os.path.dirname(__file__))
# app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + \
#                                         os.path.join(basedir, 'db.sqlite3')


def create_app(config_object=establish_config()):
    """An application factory, as explained here:
    http://flask.pocoo.org/docs/patterns/appfactories/.

    :param config_object: The configuration object to use.
    """
    app = Flask(__name__)
    app.url_map.strict_slashes = False
    app.config.from_object(config_object)

#     cors = CORS(app, resources={r"/api": {"origins": "*"}})
#     app.config['CORS_HEADER'] = 'Content-Type'

    register_extensions(app)
    register_blueprints(app)
    register_commands(app)
    # register_errorhandlers(app)
    # register_shellcontext(app)
    return app


def register_blueprints(app):
    app.register_blueprint(photos.photo_views.blueprint)


def register_extensions(app):
    db.init_app(app)
    migrate.init_app(app, db)


def register_commands(app):
    """Register Click commands."""
    app.cli.add_command(commands.test)
    app.cli.add_command(commands.testgphoto)
    app.cli.add_command(commands.driver)
    app.cli.add_command(commands.clean)
