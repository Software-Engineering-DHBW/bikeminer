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

def create_history(db: Session, history: schemas.HistoryCreate):
    user = db.query(models.Users).filter(models.Users.userName == history.userName).first()
    print("-------")
    print(user.userID)
    print(type(user.userID))
    print("------ " + history.userName)
    db_history = models.History(userID=user.userID, recievedCoins=history.recievedCoins,
                                 distanceTraveled=history.distanceTraveled, dateTime=history.dateTime)
    print(db_history)
    db.add(db_history)
    db.commit()
    db.refresh(db_history)
    return db_history

# TODO: Fix this function
def get_history_by_user_name(db: Session, user_name: str):
    # db.query
    user = db.query(models.Users).filter(models.Users.userName == user_name).first()
    print("userID: " + str(user.userID))
    hist = []
    hist = [history for history in db.query(models.History).all()]
    return hist

    # Why does this not work??
    # return db.query(models.History, models.Users).join(models.Users, models.History.userID == models.Users.userID, isouter=True).filter(models.Users.userName == user_name).all()


""" 
select h.recievedCoins, h.distanceTraveled, h.dateTime
from History as h
left join Users as u
on h.userID = u.userID
where u.userName = 'testUser';
"""


### create user
#def create_user(db: Session, user: schemas.UserCreate):
#    fake_hashed_password = user.password + "notreallyhashed"
#    db_user = models.User(email=user.email, hashed_password=fake_hashed_password)
#    db.add(db_user)
#    db.commit()
#    db.refresh(db_user)
#    return db_user

















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





