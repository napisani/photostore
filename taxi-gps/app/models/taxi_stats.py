from sqlalchemy import Column, Integer, String, Float

from app.models.base import Base


class TaxiStats(Base):
  __tablename__ = "taxi_stats"
  id = Column(Integer, primary_key=True, index=True)
  ident = Column(String, )
  server_timestamp = Column(Float)
  longitude = Column(Float)
  latitude = Column(Float)
  timestamp = Column(Float)
  altitude = Column(Float)
  direction = Column(Float)
  speed = Column(Float)
  satellites = Column(Integer)
