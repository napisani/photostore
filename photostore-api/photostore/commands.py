# -*- coding: utf-8 -*-
"""Click commands."""
import os

import click

HERE = os.path.abspath(os.path.dirname(__file__))
PROJECT_ROOT = os.path.join(HERE, os.pardir)
TEST_PATH = os.path.join(PROJECT_ROOT, 'tests')


@click.command()
def test():
    """Run the tests."""
    import pytest
    rv = pytest.main([TEST_PATH, '--verbose', '-s', '-m', 'unit'])  # -s enables logging/print to stdout
    exit(rv)


@click.command()
def testgphoto():
    """Run the tests."""
    import pytest
    rv = pytest.main([TEST_PATH, '--verbose', '-s', '-m', 'gphoto'])  # -s enables logging/print to stdout
    exit(rv)


@click.command()
def driver():
    """Run the tests."""
    import pytest
    rv = pytest.main([TEST_PATH, '--verbose', '-s', '-m', 'driver'])  # -s enables logging/print to stdout
    exit(rv)


@click.command()
def clean():
    """Remove *.pyc and *.pyo files recursively starting at current directory.

    Borrowed from Flask-Script, converted to use Click.
    """
    for dirpath, _, filenames in os.walk('.'):
        for filename in filenames:
            if filename.endswith('.pyc') or filename.endswith('.pyo'):
                full_pathname = os.path.join(dirpath, filename)
                click.echo('Removing {}'.format(full_pathname))
                os.remove(full_pathname)
