

PYTHONPATH=`pwd`/app uvicorn main:app --reload

#apply generated sql
PYTHONPATH=`pwd` alembic upgrade head


#generate sql
PYTHONPATH=`pwd` alembic revision --autogenerate -m "init"

PYTHONPATH=`pwd` pytest  app/tests -s





 PYTHONPATH=`pwd` alembic revision --autogenerate -m "init" --version-path alembic/versions_sqlit
 e