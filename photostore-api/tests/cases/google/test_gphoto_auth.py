import pytest

from photostore.google.gphoto_authorizer import authorize_gphoto_service


# def test_gphoto_auth_fails():
#     with pytest.raises(TimeoutError) as excinfo:
#         authorize_gphoto_service()
#     assert "Please visit this URL to authorize this application" in str(excinfo.value)
#
@pytest.mark.gphoto
def test_gphoto_auth_succeeds():
    s = authorize_gphoto_service()
    assert s is not None
