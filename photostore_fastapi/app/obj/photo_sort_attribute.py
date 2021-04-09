from enum import Enum


class PhotoSortAttribute(str, Enum):
    creation_date = 'creation_date'
    modified_date = 'modified_date'
