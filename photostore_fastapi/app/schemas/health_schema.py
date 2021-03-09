from typing import Optional

from pydantic import BaseModel


class HealthSchema(BaseModel):
    status: Optional[str]
