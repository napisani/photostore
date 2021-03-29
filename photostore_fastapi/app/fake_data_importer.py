import datetime
import random
import uuid

from PIL import Image
from loguru import logger
from werkzeug.datastructures import FileStorage

from app.db.session import SessionLocal
from app.schemas.photo_schema import PhotoSchemaAdd
from app.service.photo_service import add_photo


def init() -> None:
    db = SessionLocal()

    def generate_fake_image(width=1920, height=1080):
        width = int(width)
        height = int(height)
        # rgb_array = numpy.random.rand(height, width, 3) * 255
        # image = Image.fromarray(rgb_array.astype('uint8')).convert('RGB')

        image = Image.new('RGB', (width, height),
                          (random.randint(0, 255), random.randint(0, 255), random.randint(0, 255)))

        return image

    logger.debug('test_import')
    for i in range(0, 100):
        # temp_img = os.path.join('/tmp/gphoto', media_item.filename())
        image = generate_fake_image()
        image.save('/tmp/f.jpg', format='JPEG')
        filename = str(uuid.uuid1()) + ".JPG"
        file = FileStorage(stream=open('/tmp/f.jpg', 'rb'), filename=filename)

        photo = PhotoSchemaAdd()
        photo.filename = filename
        photo.creation_date = datetime.datetime.now()
        saved_photo = add_photo(db, file=file, photo=photo)
        logger.debug('saved photo {}', saved_photo)


def main() -> None:
    init()


if __name__ == "__main__":
    main()
