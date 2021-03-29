import os
import sys
from typing import List

import uvicorn
from dotenv import load_dotenv
from fastapi import FastAPI, Request
from fastapi_sqlalchemy import DBSessionMiddleware
from fastapi_sqlalchemy import db

from app.models.taxi_stats import TaxiStats as ModelTaxiStats
from app.models.user import User as ModelUser
from app.schema.taxi_stats import TaxiStats as SchemaTaxiStats
from app.schema.user import User as SchemaUser

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
load_dotenv(os.path.join(BASE_DIR, ".env"))
# ---------------------------------------------------#

app = FastAPI()
# --------------- added code ------------------------#
app.add_middleware(DBSessionMiddleware, db_url=os.environ["DATABASE_URL"])


# ---------------------------------------------------#
# --------------- modified code ---------------------#
@app.post("/user/", response_model=SchemaUser)
def create_user(user: SchemaUser):
    db_user = ModelUser(
        first_name=user.first_name, last_name=user.last_name, age=user.age
    )
    db.session.add(db_user)
    db.session.commit()
    return db_user


# ---------------------------------------------------#


@app.post('/taxi-stats', response_model=SchemaTaxiStats)
def add_taxi_stats(stats: List[SchemaTaxiStats]):
    for stat in stats:
        db_taxi_stats = ModelTaxiStats(
            ident=stat.ident,
            longitude=stat.longitude
        )
        for key, val in stat.__dict__.items():
            setattr(db_taxi_stats, key, val)

        db.session.add(db_taxi_stats)
        db.session.commit()


# @app.middleware("http")
# async def add_process_time_header(request: Request, call_next):
#     try:
#         print(await request.json())
#     except:
#         print("Unexpected error:", sys.exc_info()[0])
#     response = await call_next(request)
#     return response
#

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
