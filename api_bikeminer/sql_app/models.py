from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Float
from .database import Base

# ORM Mapper for Database: Every Class represents one Database object
# these classes are the sqlalchemy models


class Users(Base):
    __tablename__ = "Users"
    userID = Column(Integer, primary_key=True)
    userName = Column(String,unique=True)
    password = Column(String)
    email = Column(String, unique=True)
    coins = Column(Float)


class History(Base):
    __tablename__ = "History"
    historyID = Column(Integer, primary_key=True, index=True)
    userID = Column(String, ForeignKey("Users.userID"), index=True)
    receivedCoins = Column(String)
    distanceTraveled = Column(Float)
    dateTime = Column(DateTime)


class Coordinates(Base):
    __tablename__ = "Coordinates"
    coordID = Column(Integer, primary_key=True, index=True)
    tourID = Column(Integer)
    tourNumber = Column(Integer)
    userID = Column(Integer, ForeignKey("Users.userID"), index=True)
    longitude = Column(Float)
    latitude = Column(Float)
    datetime = Column(DateTime)
