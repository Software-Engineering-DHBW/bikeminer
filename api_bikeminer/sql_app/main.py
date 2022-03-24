from typing import Optional, List
from datetime import datetime, timedelta
import uvicorn
from fastapi import Depends, FastAPI, HTTPException, status, Request, File, UploadFile
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from .database import SessionLocal, engine
from . import crud, models, schemas

from sqlalchemy.orm import Session
from fastapi.responses import StreamingResponse


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


@app.post("/users/", response_model=schemas.User)
def create_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    db_user = crud.get_user_by_email(db, email=user.email)
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    return crud.create_user(db=db, user=user)


@app.get("/users/", response_model=list[schemas.User])
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





#@app.get("/users/{user_id}", response_model=schemas.User)
#def read_user(user_id: int, db: Session = Depends(get_db)):
#    db_user = crud.get_user(db, user_id=user_id)
#    if db_user is None:
#        raise HTTPException(status_code=404, detail="User not found")
#    return db_user


#@app.post("/users/{user_id}/History/", response_model=schemas.History)
#def create_history_for_user(
#    user_id: int, item: schemas.HistoryCreate, db: Session = Depends(get_db)
#):
#    return crud.create_user_item(db=db, item=item, user_id=user_id)









##### kkkkk kk kkkk kk kk------------------------------

# Authentication:
#def verify_password(plain_password, hashed_password):
#    return pwd_context.verify(plain_password, hashed_password)


#def get_password_hash(password):
#    return pwd_context.hash(password)


#def authenticate_user(username: str, password: str, db):
#    user = crud.get_user_byname(db, username)
#    if not user:
#        return False
#    if not verify_password(password, user.password):
#        return False
#    return user




# API Routes:
#@app.post("/token", response_model=schema.Token, tags=['users'])
#async def login_for_access_token(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
#    user = authenticate_user(form_data.username, form_data.password, db)
#    if not user:
#        raise HTTPException(
#            status_code=status.HTTP_401_UNAUTHORIZED,
#            detail="Incorrect username or password",
#            headers={"WWW-Authenticate": "Bearer"},
#        )
#    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
#    access_token = create_access_token(
#        data={"sub": user.name}, expires_delta=access_token_expires
#    )
#    return {"access_token": access_token, "token_type": "bearer"}


#@app.post("/token/{project_accesskey}", response_model=schema.Token, tags=['project'])
#def login_for_access_token(project_accesskey: str, db: Session = Depends(get_db)):
#    project = crud.get_projects_byaccesskey(db, project_accesskey)
#    if not project:
#        raise HTTPException(
#            status_code=status.HTTP_401_UNAUTHORIZED,
#            detail="Incorrect Project access key",
#            headers={"WWW-Authenticate": "Bearer"},
#        )
#    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
#    access_token = create_access_token(
#        data={"sub": project_accesskey}, expires_delta=access_token_expires, client_token=True
#    )
#    return {"access_token": access_token, "token_type": "bearer"}


#@app.get("/users/me/", response_model=schema.UserBase, tags=['users'])
#async def read_users_me(current_user: schema.UserBase = Depends(oauth2_scheme), db: Session = Depends(get_db)):
#    user = await get_current_user(db=db, token=current_user)
#    if not current_user:
#        raise HTTPException(
#            status_code=status.HTTP_401_UNAUTHORIZED,
#            detail="Incorrect username or password",
#            headers={"WWW-Authenticate": "Bearer"},
#        )
#    return schema.UserBase(id=user.id, name=user.name, role=user.role,
 #                          password=user.password)
