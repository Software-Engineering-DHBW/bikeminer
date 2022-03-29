#!/bin/bash
sudo rm -r db
cp -r ../api_bikeminer/sql_app api-container/sql_app
docker stop containers-bikedb-1 containers-fastapi-1 && docker rm containers-bikedb-1 containers-fastapi-1
docker-compose build
docker-compose -f docker-compose.yml up 
