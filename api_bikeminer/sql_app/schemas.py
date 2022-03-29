from typing import List, Optional
from datetime import date, datetime
from pydantic import BaseModel


# BaseModels for FastAPI: Used as form_data and response objects --> Transforms db models to json objects

class UserBase(BaseModel):
    userName: str
    email: str

class UserBalance(BaseModel):
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
    receivedCoins: float

    class Config:
        orm_mode = True


class History(HistoryBase):
    historyID: int
    userID: int

    class Config:
        orm_mode = True


class CoordinatesCreate(BaseModel):
    tourID: int
    tourNumber: int
    longitude: float
    latitude: float
    datetime: datetime


class Coordinates(CoordinatesCreate):
    coordID: int


# For authentication
class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    username: Optional[str] = None
    project: Optional[str] = None
