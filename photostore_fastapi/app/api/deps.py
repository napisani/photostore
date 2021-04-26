from typing import Generator

# from fastapi import Depends, HTTPException, status
# from jose import jwt
# from pydantic import ValidationError
# from sqlalchemy.orm import Session
#
# from app import crud, models, schemas
# from app.core import security
# from app.core.config import settings
from fastapi import Security, HTTPException
from fastapi.openapi.models import APIKey
from fastapi.security import APIKeyQuery, APIKeyHeader
from starlette.status import HTTP_403_FORBIDDEN

from app.core.config import settings
from app.db.session import SessionLocalAsync


# reusable_oauth2 = OAuth2PasswordBearer(
#     tokenUrl=f"{settings.API_V1_STR}/login/access-token"
# )


async def get_async_db() -> Generator:
    try:
        db = SessionLocalAsync()
        yield db
    finally:
        await db.close()


API_KEY_NAME = "access_token"

api_key_query = APIKeyQuery(name=API_KEY_NAME, auto_error=False)
api_key_header = APIKeyHeader(name=API_KEY_NAME, auto_error=False)


# api_key_cookie = APIKeyCookie(name=API_KEY_NAME, auto_error=False)

async def get_api_key(
        api_key_query: str = Security(api_key_query),
        api_key_header: str = Security(api_key_header),
        # api_key_cookie: str = Security(api_key_cookie),
):
    if api_key_query == settings.API_KEY:
        return api_key_query
    elif api_key_header == settings.API_KEY:
        return api_key_header
    elif settings.API_KEY is None or settings.API_KEY == '':
        # if no API_KEY is configured, just pass through without responding with a 401 response
        return APIKey()
    # elif api_key_cookie == API_KEY:
    #     return api_key_cookie
    else:
        raise HTTPException(
            status_code=HTTP_403_FORBIDDEN, detail="Could not validate API KEY"
        )

# def get_current_user(
#     db: Session = Depends(get_db), token: str = Depends(reusable_oauth2)
# ) -> models.User:
#     try:
#         payload = jwt.decode(
#             token, settings.SECRET_KEY, algorithms=[security.ALGORITHM]
#         )
#         token_data = schemas.TokenPayload(**payload)
#     except (jwt.JWTError, ValidationError):
#         raise HTTPException(
#             status_code=status.HTTP_403_FORBIDDEN,
#             detail="Could not validate credentials",
#         )
#     user = crud.user.get(db, id=token_data.sub)
#     if not user:
#         raise HTTPException(status_code=404, detail="User not found")
#     return user
#
#
# def get_current_active_user(
#     current_user: models.User = Depends(get_current_user),
# ) -> models.User:
#     if not crud.user.is_active(current_user):
#         raise HTTPException(status_code=400, detail="Inactive user")
#     return current_user
#
#
# def get_current_active_superuser(
#     current_user: models.User = Depends(get_current_user),
# ) -> models.User:
#     if not crud.user.is_superuser(current_user):
#         raise HTTPException(
#             status_code=400, detail="The user doesn't have enough privileges"
#         )
#     return current_user
