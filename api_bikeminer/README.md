### Change directory to bikeminer/containers
```cd containers```

### Build a mariaDB-Docker-Container
```docker-compose build```

### Run container by using docker-compose.yml
```docker-compose -f docker-compose.yml up -d```

### To take a look inside of the container
```docker exec -it containers_bikedb_1 mysql -u profi -p```
([Database-Login](https://github.com/Software-Engineering-DHBW/bikeminer/wiki/Docker-Container))

### Change directory to bikeminer/api_bikeminer & start API Connection 
```uvicorn sql_app.main:app --reload```
