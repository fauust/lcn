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

### WordPress

- **Builds** the WordPress image from the Dockerfile in the current directory.
- **Ports**: Maps port 80 on the host to port 80 in the container.
- **Hostname**: Sets the hostname to `wordpress.local`.
- **Networks**: Connects to both `frontend` and `backend` networks.

### MariaDB Service

- **Image**: Uses the `mariadb:11.2` image.
- **Restart**: Always restarts the container if it stops.
- **Environment**: Sets the root password for MariaDB using `MARIADB_ROOT_PASSWORD`.
- **Volumes**: Persists MariaDB data in a Docker volume (`mariadb-data`).
- **Networks**: Connects to the `backend` network.

### phpMyAdmin

- **Image**: Uses the `phpmyadmin/phpmyadmin:5.2.1` image.
- **Ports**: Maps port 8080 on the host to port 80 in the container.
- **Depends_on**: Ensures the MariaDB container starts before phpMyAdmin.
- **Hostname**: Sets the hostname to `phpmyadmin.local`.
- **Networks**: Connects to both `frontend` and `backend` networks.
- **Environment**: (See [phpMyAdmin Docker Hub](https://hub.docker.com/r/phpmyadmin))
   - `PMA_ARBITRARY=1`: Allows arbitrary server connections.
   - `PMA_HOST=mariadb`: Sets the default server to `mariadb`.

## Volumes

- **mariadb-data**: Defines a Docker volume for MariaDB data persistence.

## Networks

### frontend

- **Name**: Names the frontend network `frontend-network`.

### backend

- **Name**: Names the backend network `backend-network`.
- **Internal**: Makes the backend network internal (not accessible from outside Docker).
- **IPAM**: Configures the IP address management:
   - `subnet`: Defines the subnet as `172.28.0.0/16`.
   - `ip_range`: Defines the IP range as `172.28.5.0/24`.
   - `gateway`: Sets the gateway to `172.28.5.254`.
   - `aux_addresses`: Assigns specific IP addresses to services:
      - `wordpress`: `172.28.1.5`
      - `phpmyadmin`: `172.28.1.6`
      - `mariadb`: `172.28.1.7`

## How to Use

1. **Clone the repository**:

    ```bash
    git clone <repository-url>
    cd <repository-directory>
    ```

2. **Build and start the containers**:

    ```bash
    docker-compose up -d
    ```

3. **Access the services**:
   - **WordPress**: Open your browser and navigate to `http://localhost`.
   - **phpMyAdmin**: Open your browser and navigate to `http://localhost:8080`.

4. **Stop the containers**:

    ```bash
    docker-compose down
    ```

This setup ensures that WordPress, MariaDB, and phpMyAdmin are properly networked and configured for development or testing purposes.
