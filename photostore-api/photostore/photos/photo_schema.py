from marshmallow import pre_load

from photostore.extensions import ma
from photostore.pagination_schema import get_pagination_schema
from photostore.photos.photo_model import Photo


class PhotoSchema(ma.SQLAlchemyAutoSchema):

    # filename = fields.Str()
    # checksum = fields.Str()

    # username = fields.Str()
    # email = fields.Email()
    # password = fields.Str(load_only=True)
    # bio = fields.Str()
    # image = fields.Url()
    # following = fields.Boolean()
    # # ugly hack.
    # profile = fields.Nested('self', exclude=('profile',), default=True, load_only=True)

    # @pre_load
    # def make_user(self, data, **kwargs):
    #     return data['profile']
    #
    # @post_dump
    # def dump_user(self, data, **kwargs):
    #     return {'profile': data}

    @pre_load
    def make_photo(self, data, **kwargs):
        if not data['id']:
            data['id'] = 0
        if not data['thumbnail_path']:
            data['thumbnail_path'] = ''
        return data

    # @post_dump
    # def dump_article(self, data, **kwargs):
    #     data['author'] = data['author']['profile']
    #     return {'article': data}

    class Meta:
        # strict = True
        model = Photo


photo_schema = PhotoSchema()
photo_schemas = PhotoSchema(many=True)
paginated_photos = get_pagination_schema(photo_schema)
