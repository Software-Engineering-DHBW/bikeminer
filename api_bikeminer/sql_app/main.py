from typing import Optional, List
from datetime import datetime, timedelta
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


#if __name__ == "__main__":
#    uvicorn.run(app, host="0.0.0.0", port=8000)

# Dependency#
# needed for closing the database session after request
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Authentication:
# this function needs attention hash cannnot verified  , kopple das zusamen mit create_user
# um hashed passwords in der db zu speichern
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

def create_access_token(data: dict, expires_delta: Optional[timedelta] = None, client_token: bool = False):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=15)
    to_encode.update({"exp": expire})

    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

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
        data={"sub": user.name}, expires_delta=access_token_expires
    )
    return {"access_token": access_token, "token_type": "bearer"}


## create_user muss angepasst werden damit hashed passwords in der db stehen

@app.post("/users/create", response_model=schemas.User)
def create_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    db_user = crud.get_user_by_email(db, email=user.email)
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    return crud.create_user(db=db, user=user)


@app.get("/users/all", response_model=list[schemas.User])
def read_users(db: Session = Depends(get_db)):
    users = crud.get_users(db)
    return users

# get user by id
@app.get("/users/{user_id}", response_model=schemas.User)
def read_user(user_id: int, db: Session = Depends(get_db)):
    db_user = crud.get_user(db, user_id=user_id)
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return db_user






#@app.post("/users/{user_id}/History/", response_model=schemas.History)
#def create_history_for_user(
#    user_id: int, item: schemas.HistoryCreate, db: Session = Depends(get_db)
#):
#    return crud.create_user_item(db=db, item=item, user_id=user_id)





