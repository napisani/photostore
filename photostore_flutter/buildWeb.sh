#!/bin/bash
flutter build web
rm -rf ../photostore_fastapi/static/*
rsync -rlv --delete  ./build/web/ ../photostore_fastapi/static
