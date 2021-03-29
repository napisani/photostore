from pydantic import BaseModel, Field


class TaxiStats(BaseModel):
  ident: str
  server_timestamp: float = Field(None, alias='server.timestamp')
  longitude: float = Field(None, alias='position.longitude')
  latitude: float = Field(None, alias='position.latitude')
  timestamp: float
  altitude: float = Field(None, alias='position.altitude')
  direction: float = Field(None, alias='position.direction')
  speed: float = Field(None, alias='position.speed')
  satellites: int = Field(None, alias='position.satellites')

  class Config:
    orm_mode = True
