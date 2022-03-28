from typing import List, Optional
from datetime import date, datetime
from pydantic import BaseModel
from fastapi.responses import FileResponse


# BaseModels for FastAPI: Used as form_data and response objects --> Transforms db models to json objects

class UserBase(BaseModel):
    userName: str
    email: str
    coins: float

class UserCreate(UserBase):
    userName: str
    password: str



class User(UserBase):
    userID: int
    userName: str
    email: str
    coins: float

    class Config:
        orm_mode = True

class HistoryBase(BaseModel):
    dateTime: datetime
    distanceTraveled: float

class HistoryCreate(HistoryBase):
    userName: str
    receivedCoins: float

class History(HistoryBase):
    historyID: int
    userID: int

    class Config:
        orm_mode = True


class CoordinatesCreate(BaseModel):
    tourID: int
    tourNumber: int
    userID: int
    longitude: float
    latitude: float
    datetime: datetime
class Coordinates(CoordinatesCreate):
    coordID: int


## for authentication
class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    username: Optional[str] = None
    project: Optional[str] = None












