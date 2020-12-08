import os

from flask import Blueprint, request, send_from_directory
from flask_apispec import marshal_with, use_kwargs
from loguru import logger

from photostore.photos.photo_exceptions import PhotoExceptions
from photostore.photos.photo_model import Photo
from photostore.photos.photo_schema import photo_schema, paginated_photos
from photostore.photos.photo_service import allowed_file, add_photo, get_latest_photo, get_photos, get_photo

blueprint = Blueprint('photos', __name__)


@blueprint.route('/api/photos/simple', methods=('POST',))
def view_simple():
    return 'PHOTOS'


@blueprint.route('/api/photos/fullsize/<photo_id>', methods=('GET',))
def view_get_fullsize(photo_id):
    photo = get_photo(int(photo_id))
    logger.debug('view_get_fullsize photo: {}', photo)
    split = os.path.split(photo.path)
    return send_from_directory(split[0], split[1])

@blueprint.route('/api/photos/thumbnail/<photo_id>', methods=('GET',))
def view_get_thumbnail(photo_id):
    photo = get_photo(int(photo_id))
    logger.debug('view_get_thumbnail photo: {}', photo)
    split = os.path.split(photo.thumbnail_path)
    return send_from_directory(split[0], split[1])


@blueprint.route('/api/photos/<page>', methods=('GET',))
# @marshal_with(paginated_photos)
def view_get_photos(page):
    photos = get_photos(int(page), 10)
    del photos.query
    logger.debug('view_get_photos {}', photos)
    logger.debug('view_get_photos {}', photos.__dict__)

    resp = paginated_photos.dump(photos)
    logger.debug('resp {}', resp)

    return resp


@blueprint.route('/api/photos/latest', methods=('GET',))
@marshal_with(photo_schema)
def view_get_latest_photo():
    return get_latest_photo()


@blueprint.route('/api/photos', methods=('POST',))
@marshal_with(photo_schema)
@use_kwargs(photo_schema)
def view_add_photo(filename, checksum, **kwargs):
    p = Photo()
    p.filename = filename
    p.checksum = checksum
    p.save()
    logger.debug('in add_photo {}', p)
    return p


@blueprint.route('/api/photos/upload', methods=('POST',))
@marshal_with(photo_schema)
def view_upload_photo():
    logger.debug('view_upload_photo request {}', request)
    logger.debug('view_upload_photo request.__dict__ {}', request.__dict__)

    # check if the post request has the file part
    if 'file' not in request.files:
        raise PhotoExceptions.no_file_passed()
    if 'metadata' not in request.files:
        raise PhotoExceptions.metadata_not_passed()
    file = request.files['file']
    metadata_file = request.files['metadata']
    metadata = metadata_file.read()
    logger.debug('view_upload_photo metadata {}', metadata)
    photo_info = photo_schema.loads(metadata)
    logger.debug('view_upload_photo photo_info {}', photo_info)

    # if user does not select file, browser also
    # submit an empty part without filename
    if file.filename == '':
        raise PhotoExceptions.filename_not_passed()
    if not file or not allowed_file(file.filename):
        raise PhotoExceptions.invalid_photo_passed()
    added_photo = add_photo(photo_info=photo_info, file=file)
    logger.debug('view_upload_photo added_photo {}', added_photo)
    return added_photo
