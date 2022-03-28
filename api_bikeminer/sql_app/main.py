from lib2to3.pgen2 import token
# from msilib.schema import Error
from typing import Optional, List
from datetime import datetime, timedelta
from wsgiref import headers
import rsa
import uvicorn
from fastapi import Depends, FastAPI, HTTPException, status, Request, File, UploadFile
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from .database import SessionLocal, engine
from . import crud, models, schemas
import json
from sqlalchemy.orm import Session
from passlib.context import CryptContext
from fastapi.responses import StreamingResponse
from jose import JWTError, jwt
import geopy.distance as geopy

# needed for create_access_token()
SECRET_KEY = "55e52afbc03148bafc1c6f430c40041548ece633da626d5126738888239afe10"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30


# needed for pw hashing
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
models.Base.metadata.create_all(bind=engine)
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")
#f = open("tags_meta.conf", "r")
#tags_metadata = json.loads(f.read())



#start api
app = FastAPI()

# Dependency
# needed for closing the database session after request
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Authentication:
def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)


def get_password_hash(password):
    return pwd_context.hash(password)


def authenticate_user(username: str, password: str, db):
    user = crud.get_user_byname(db, username)
    if not user:
        return False
    if not verify_password(password, user.password):
        return False
    return user

def calculate_distance_with_coordinates(coords):
    last_point = None
    absolute_distance = 0
    for point in coords:
        c = (point.latitude, point.longitude)
        if last_point:
            absolute_distance += geopy.distance(c, last_point).km
        last_point = c

    return absolute_distance


async def get_current_user(db: Session, token: str = Depends(oauth2_scheme)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        if username is None:
            raise credentials_exception
        token_data = schemas.TokenData(username=username)
    except JWTError:
        raise credentials_exception
    user = crud.get_user_byname(user_name=token_data.username, db=db)
    if user is None:
        raise credentials_exception
    return user

def create_access_token(data: dict, expires_delta: Optional[timedelta] = None, client_token: bool = False):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=15)
    to_encode.update({"exp": expire})

    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt



#-------------- API-Routes --------------------------------------------------##

@app.post("/token", response_model=schemas.Token, tags=['users'])
async def login_for_access_token(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
    user = authenticate_user(form_data.username, form_data.password, db)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)

    # !!! -- attention  -- user.name not know , should be user.userName or something like this
    access_token = create_access_token(
        data={"sub": user.userName}, expires_delta=access_token_expires
    )
    return {"access_token": access_token, "token_type": "bearer"}

##--------------------------------- User Routes -------------------------------------------------------------#

@app.get("/users/me/", response_model=schemas.UserBase, tags=['users'])
async def read_users_me(current_user: schemas.UserBase = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    user = await get_current_user(db=db, token=current_user)
    if not current_user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    return schemas.UserBase( userName=user.userName, coins=user.coins, email=user.email)


@app.post("/users/create", response_model=schemas.User, tags=['users'])
def create_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    db_user = crud.get_user_by_email(db, email=user.email)
    db_user_by_name = crud.get_user_by_name(db, user_name=user.userName)

    # Hash password and write it into the user
    hashed_pwd = pwd_context.hash(user.password)
    user.password = hashed_pwd

    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    if db_user_by_name:
        raise HTTPException(status_code=400, detail="Username alread taken")
    return crud.create_user(db=db, user=user)



@app.get("/users/all", tags=['users'])
def read_users(db: Session = Depends(get_db)):
    users = crud.get_users(db)
    return users

# get user by id
@app.get("/users/{user_id}", response_model=schemas.User, tags=['users'])
def read_user(user_id: int, db: Session = Depends(get_db)):
    db_user = crud.get_user(db, user_id=user_id)
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return db_user

### ------------------  History Routes --------------------------------------------------#

@app.get("/history/me", tags=['history'])
async def get_history(current_user: schemas.UserBase = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    # db_user = crud.get_user_by_name(db, user_name=user_name)
    # if db_user is None:
    #     raise HTTPException(status_code=404, detail="User not found")
    user = await get_current_user(db=db, token=current_user)

    if not current_user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"}
        )

    history = crud.get_history_by_user_name(db, user_name=user.userName)
    if history == []:
        raise HTTPException(status_code=404, detail="User has no History")
    return history


@app.post("/history/create", tags=['history'])
async def create_history(history: schemas.HistoryCreate, current_user: schemas.UserBase = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    user = await get_current_user(db=db, token=current_user)

    if not current_user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"}
        )
    
    return crud.create_history(db=db, user_name=user, history=history)


@app.post("/history/delete", tags=['history'])
async def delete_history(history_id: int, current_user: schemas.UserBase = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    user = await get_current_user(db=db, token=current_user)

    if not current_user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"}
        )
    
    res = crud.delete_history(db, user_name=user.userName, history_id=history_id)
    if res == 0:
        raise HTTPException(status_code=404, detail="Could not delete history entry")
    return res


#-------------------------- Coordinate Routes ------------------------------------------------

@app.post("/coordinates/create", tags=['coordinates'])
async def create_coord_data(coordinates: schemas.CoordinatesCreate, current_user: schemas.UserBase = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    # TODO: I dont need that
    user = await get_current_user(db=db, token=current_user)

    if not current_user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"}
        )

    
    return crud.create_coordinate_entry(db=db, user_id = user.userID, coordinates=coordinates)

@app.post("/coordinates/delete", tags=['coordinates'])
async def delete_coordinates(tour_id: int, current_user: schemas.UserBase = Depends(oauth2_scheme),
                         db: Session = Depends(get_db)):
    user = await get_current_user(db=db, token=current_user)

    if not current_user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"}
        )

    res = crud.delete_all_coordinate(db, user_name=user.userName, tour_id=tour_id)
    if res == 0:
        raise HTTPException(status_code=404, detail="Could not delete coordinates entries")
    return res


@app.post("/coordinates/calculateDistance", tags=['coordinates'])
async def calculate_distance(tour_id: int, current_user: schemas.UserBase = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    # get all datasets from coordinates
    user = await get_current_user(db=db, token=current_user)

    if not current_user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"}
        )
    list_of_coords = crud.get_coord_by_tour_id(user_id=user.userID, tour_id=tour_id, db=db)
    
    distance = calculate_distance_with_coordinates(coords=list_of_coords)
    hist = schemas.HistoryCreate(dateTime=datetime.now(), distanceTraveled=distance, receivedCoins=distance/2)

    crud.create_history(user_name=user, history=hist, db=db)

    crud.delete_all_coordinates(tour_id=tour_id, user_name=user.userName, db=db)

    crud.user_update_coins(received_coins=distance/2, user=user, db=db)

    return 0

    







