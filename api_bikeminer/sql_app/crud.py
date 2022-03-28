import re
from sqlalchemy.orm import Session
from sqlalchemy.sql.expression import func
#from passlib.context import CryptContext

from . import models, schemas
import uuid
from datetime import date, datetime
from sqlalchemy.orm import Session


# Methods for API Calls
#CRUD  create read update delete



# User Methods


# This function might not be used much
def get_user(db: Session, user_id: int):
    return db.query(models.Users).filter(models.Users.userID == user_id).first()

def get_user_by_name(db: Session, user_name: str):
    return db.query(models.Users).filter(models.Users.userName == user_name).first()

def get_user_by_email(db: Session, email: str):
    return db.query(models.Users).filter(models.Users.email == email).first()

#def get_users(db: Session, skip: int = 0, limit: int = 100):
#    return db.query(models.Users).offset(skip).limit(limit).all()

def get_users(db: Session):
    users = []
    users = [user for user in db.query(models.Users).all()]
    return users

def get_user_byid(db: Session, user_id: int):
    return db.query(models.Users).filter(models.Users.id == user_id).first()

def get_user_byname(db: Session, user_name: str):
    return db.query(models.Users).filter(models.Users.userName == user_name).first()

def create_user(db: Session, user: schemas.UserCreate):
    fake_hashed_password = user.password
    db_user = models.Users(email=user.email, password=fake_hashed_password, userName=user.userName, coins=user.coins)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

def create_history(db: Session, user_name: str,  history: schemas.HistoryCreate):
    user = db.query(models.Users).filter(models.Users.userName == history.userName).first()
    db_history = models.History(userID=user.userID, receivedCoins=history.receivedCoins,
                                 distanceTraveled=history.distanceTraveled, dateTime=history.dateTime)
    print(db_history)
    db.add(db_history)
    db.commit()
    db.refresh(db_history)
    return db_history

def get_history_by_user_name(db: Session, user_name: str):
    # db.query
    try:
        user = db.query(models.Users).filter(models.Users.userName == user_name).first()

        hist = []
        hist = [history for history in db.query(models.History).filter(models.History.userID == user.userID).all()]
    except AttributeError:
        pass
    return hist

    # Why does this not work??
    # return db.query(models.History, models.Users).join(models.Users, models.History.userID == models.Users.userID, isouter=True).filter(models.Users.userName == user_name).all()


def delete_history(db: Session, user_name: str, tour_id: int):
    result = None
    try:
        user = db.query(models.Users).filter(models.Users.userName == user_name).first()
        print(user.userID)
        result = db.query(models.History).filter(models.History.userID == user.userID,
                                                    models.History.historyID == tour_id).delete()
        db.commit()
    except AttributeError:
        print("can't delete")
    return result


def create_coordinate_entry(db: Session, coordinates: schemas.Coordinates):
    user = db.query(models.Users).filter(models.Users.userName == coordinates.userName).first()
    db_coordinates = models.Coordinates(userID=user.userID, tourID=coordinates.tourID, tourNumber=coordinates.tourNumber,
                                        longitude=coordinates.longitude, latitude=coordinates.latitude, datetime=coordinates.datetime)

    print(db_coordinates)
    db.add(db_coordinates)
    db.commit()
    db.refresh(db_coordinates)
    return 0



"""
def create_coordinate_entry(db: Session, coordinates: schemas.CoordinatesCreate):
    user = db.query(models.Users).filter(models.Users.userID == coordinates.userID).first()
    db_coordinates = models.CoordinatesCreate(userID=user.userID, tourID=coordinates.tourID, tourNumber=coordinates.tourNumber,
                                        longitude=coordinates.longitude, latitude=coordinates.latitude, datetime=coordinates.datetime)

    print(db_coordinates)
    db.add(db_coordinates)
    db.commit()
    db.refresh(db_coordinates)
    return db_coordinates
"""
















#def get_user_byname(db: Session, user_name: int):
#    return db.query(models.User).filter(models.User.name == user_name).first()


#def get_user_byid(db: Session, user_name: int):
#    return db.query(models.User).filter(models.User.id == user_name).first()


#def get_users(db: Session):
#    users = []
#    users = [user for user in db.query(models.User).all()]
#    return users


#def hash_password(password):
#    return CryptContext(schemes=["bcrypt"], deprecated="auto").hash(password)





