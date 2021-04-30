from app.exception.exceptions import APIError


class PhotoExceptions(APIError):

    @classmethod
    def no_file_passed(cls):
        return cls(**cls._template("No file passed", code=500))

    @classmethod
    def filename_not_passed(cls):
        return cls(**cls._template("filename not passed", code=500))

    @classmethod
    def invalid_photo_passed(cls):
        return cls(**cls._template("invalid photo passed", code=500))

    @classmethod
    def metadata_not_passed(cls):
        return cls(**cls._template("metadata not passed", code=500))

    @classmethod
    def failed_to_save_photo_file(cls):
        return cls(**cls._template("failed to save photo file to disk", code=500))

    @classmethod
    def failed_to_get_image_as_png(cls):
        return cls(**cls._template("failed to convert to png", code=500))

    @classmethod
    def failed_to_create_thumbnail(cls):
        return cls(**cls._template("failed to create thumbnail", code=500))

    @classmethod
    def failed_to_save_photo_to_db(cls):
        return cls(**cls._template("failed to save photo to db", code=500))

    @classmethod
    def failed_to_delete_photo_from_db(cls):
        return cls(**cls._template("failed to delete photo  from db", code=500))

    @classmethod
    def failed_to_delete_photo_file(cls):
        return cls(**cls._template("failed to delete photo file from disk", code=500))

    @classmethod
    def failed_to_delete_thumbnail_file(cls):
        return cls(**cls._template("failed to delete thumbnail file from disk", code=500))

    @classmethod
    def photo_not_found(cls):
        return cls(**cls._template("photo not found", code=500))
