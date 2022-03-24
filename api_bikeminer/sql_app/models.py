from sqlalchemy import Column, Integer, String, Date, DateTime, ForeignKey, Float
from sqlalchemy.orm import relationship
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

    #history = relationship("History", back_populates=Users)

class History(Base):
    __tablename__ = "History"
    historyID = Column(Integer, primary_key=True, index=True)
    userID = Column(String, ForeignKey("Users.UserID"), index=True)
    recievedCoins = Column(String)
    distanceTraveled = Column(Float)
    dateTime = Column(DateTime)

    #users = relationship("Users", back_populates=History)
