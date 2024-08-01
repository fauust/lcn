# Docker Wordpress + Mariadb + PhpMyAdmin

## Without Docker Compose

### Create a network

```bash
docker network create wordpress
```

### Wordpress

1. Pull the image from Docker Hub

```bash
docker pull wordpress
```

1:bis. Or build the image from the Dockerfile

```bash
docker build -t wordpress .
```

2. Run the container with the network

```bash
docker run --name wordpress --network wordpress -p 8080:80 -d wordpress
```

3. Access the container

```bash
docker exec -it wordpress bash
```

4. Access the container's IP address

```bash
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' wordpress
```

### MariaDB

1. Pull the image from Docker Hub

```bash
docker pull mariadb
```

2. Run the container with the network and volume for persistence and init file for database creation

```bash
docker run --name mariadb \
        --network wordpress \
        -v mariadb:/var/lib/mysql \
        -v initfile.sql:/docker-entrypoint-initdb.d/initfile.sql \
       -e MYSQL_ROOT_PASSWORD=root -d mariadb
```

3. Check that mariadb is running

```bash
docker exec -it mariadb mysql -uroot -proot
```

## With Docker Compose

See the `docker-compose.yml` file

### Run the containers

```bash
docker-compose up
```

### Stop the containers

```bash
docker-compose down
```
