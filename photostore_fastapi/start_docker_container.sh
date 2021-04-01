#!/usr/bin/env bash

echo "---- Starting Photostore API ----"
cd /code
PYTHONPATH=$(pwd) alembic upgrade head
PYTHONPATH=$(pwd)/app uvicorn main:app --host 0.0.0.0 --port 8000 --reload