import sqlalchemy
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker


DB_URL = "bikedb:3306"
DB_USER = 'profi'
DB_PW = 'bikeminerdb'
DB_NAME = 'bikeminer'
URL = f"mysql://{DB_USER}:{DB_PW}@{DB_URL}/{DB_NAME}"

SQLALCHEMY_DATABASE_URL = URL

engine = create_engine(
    SQLALCHEMY_DATABASE_URL,
    echo=True, pool_size=6, max_overflow=10, encoding='latin1'
)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()
