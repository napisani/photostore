from marshmallow import fields

from photostore.extensions import ma


def get_pagination_schema(nested_type):
    class PaginationClass(ma.Schema):
        items = fields.List(fields.Nested(nested_type))
        total = fields.Int()
        per_page = fields.Int()
        page = fields.Int()

        class Meta:
            strict = True

    return PaginationClass()
