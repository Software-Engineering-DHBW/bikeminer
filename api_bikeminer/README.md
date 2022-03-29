
# Requirements
- Docker Engine, latest version <https://docs.docker.com/get-docker/> - see installation guide for your OS
- Docker Compose, latest version <https://docs.docker.com/compose/install/> - see installation guide for your OS

# Build the container
Change directory to 'containers'

# Run the container
```
docker-compose -f docker-compose.yml up -d
```
or if you want to see how the container is starting  (use not '-d' flag)
```
docker-compose -f docker-compose.yml up
```
if you want to see whats going on inside the database
```
docker exec -it <containername> mysql -u profi -p
```


([Database-Login](https://github.com/Software-Engineering-DHBW/bikeminer/wiki/Docker-Container))




