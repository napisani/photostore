#!/bin/bash
flutter build web
rsync -rlv --delete  ./build/web/ ../photostore_fastapi/static
