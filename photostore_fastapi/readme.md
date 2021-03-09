

PYTHONPATH=`pwd`/app uvicorn main:app --reload

PYTHONPATH=`pwd` alembic uapgrade head

PYTHONPATH=`pwd` alembic revision --autogenerate -m "init"

PYTHONPATH=`pwd` pytest  app/tests -s