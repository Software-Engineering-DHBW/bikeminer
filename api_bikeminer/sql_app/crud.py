from sqlalchemy.orm import Session

from . import models, schemas
from sqlalchemy.orm import Session


# Functions for API Calls
# CRUD: Create Read Update Delete
# User Methods


# ---------------------------- User specific queries ---------------------------------------------------------

def get_user(db: Session, user_id: int):
    return db.query(models.Users).filter(models.Users.userID == user_id).first()


def get_user_by_name(db: Session, user_name: str):
    return db.query(models.Users).filter(models.Users.userName == user_name).first()


def get_user_by_email(db: Session, email: str):
    return db.query(models.Users).filter(models.Users.email == email).first()


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
    db_user = models.Users(email=user.email, password=fake_hashed_password, userName=user.userName, coins=0)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user


def user_update_coins(received_coins: float, db: Session, user: str):
    user.coins += received_coins
    db.commit()
    return 0


# -------------------------  History specific queries  ---------------------------------

def create_history(db: Session, user_name: str,  history: schemas.HistoryCreate):
    # user = db.query(models.Users).filter(models.Users.userName == history.userName).first()
    db_history = models.History(userID=user_name.userID, receivedCoins=history.receivedCoins,
                                 distanceTraveled=history.distanceTraveled, dateTime=history.dateTime)
    
    db.add(db_history)
    db.commit()
    db.refresh(db_history)
    return 0


def get_history_by_user_name(db: Session, user_name: str):
    try:
        user = db.query(models.Users).filter(models.Users.userName == user_name).first()

        hist = []
        hist = [history for history in db.query(models.History).filter(models.History.userID == user.userID).all()]
    except AttributeError:
        pass
    return hist


def delete_history(db: Session, user_name: str, history_id: int):
    result = None
    try:
        user = db.query(models.Users).filter(models.Users.userName == user_name).first()
        print(user.userID)
        result = db.query(models.History).filter(models.History.userID == user.userID,
                                                    models.History.historyID == history_id).delete()
        db.commit()
    except AttributeError:
        print("can't delete")
    return result


# ------------------------- Coordinates specific queries ------------------------

def create_coordinate_entry(db: Session, user_id: int, coordinates: schemas.Coordinates):
    #user = db.query(models.Users).filter(user_id == coordinates.userID).first()
    db_coordinates = models.Coordinates(userID=user_id, tourID=coordinates.tourID, tourNumber=coordinates.tourNumber,
                                        longitude=coordinates.longitude, latitude=coordinates.latitude, datetime=coordinates.datetime)

    db.add(db_coordinates)
    db.commit()
    db.refresh(db_coordinates)
    return 0


def delete_all_coordinates(db: Session, user_name: str, tour_id: int):
    result = None
    try:
        user = db.query(models.Users).filter(models.Users.userName == user_name).first()
        print(user.userID)
        result = db.query(models.Coordinates).filter(models.Coordinates.userID == user.userID,
                                                    models.Coordinates.tourID == tour_id).delete()
        db.commit()
    except AttributeError:
        print("can't delete")
    return result


def get_coord_by_tour_id(db:Session, user_id: int, tour_id: int):
    all_coordinates = []
    all_coordinates = [coord for coord in db.query(models.Coordinates.longitude, models.Coordinates.latitude).filter(models.Coordinates.userID == user_id, models.Coordinates.tourID == tour_id).all()]

    db.commit()
    return all_coordinates
