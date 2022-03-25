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






def get_user(db: Session, user_id: int):
    return db.query(models.Users).filter(models.Users.userID == user_id).first()

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

def create_user(db: Session, user: schemas.UserCreate):
    fake_hashed_password = user.password
    db_user = models.Users(email=user.email, password=fake_hashed_password, userName=user.userName, coins=user.coins)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

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





