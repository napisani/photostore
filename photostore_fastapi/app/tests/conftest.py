from typing import Generator

import pytest
from fastapi.testclient import TestClient
from sqlalchemy.orm import Session

from app.core.config import settings
from app.db.session import SessionLocal
from app.main import app
# from app.tests.utils.user import authentication_token_from_email
# from app.tests.utils.utils import get_superuser_token_headers
from .factories import make_photo_factory


# import sys
# sys.path.insert(0, "/Users/nick/PycharmProjects/photostore-mono/photostore_fastapi")

@pytest.fixture(scope="session")
def db() -> Generator:
    yield SessionLocal()


@pytest.fixture(scope="module")
def test_client() -> Generator:
    with TestClient(app) as c:
        yield c


@pytest.fixture(scope="module")
def app_settings() -> Generator:
    yield settings


@pytest.fixture(scope="module")
def photo_factory(db: Session) -> Generator:
    yield make_photo_factory(db)

# @pytest.fixture(scope="module")
# def superuser_token_headers(client: TestClient) -> Dict[str, str]:
#     return get_superuser_token_headers(client)
#
#
# @pytest.fixture(scope="module")
# def normal_user_token_headers(client: TestClient, db: Session) -> Dict[str, str]:
#     return authentication_token_from_email(
#         client=client, email=settings.EMAIL_TEST_USER, db=db
#     )
