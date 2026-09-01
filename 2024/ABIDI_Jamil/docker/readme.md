# Docker Command and Usage Guide

## Objective

- Understand container technology and its use cases.
- Differentiate between containers and virtual machines.
- Master container manipulation and architecture.
- Utilize Docker for scaling and autoscaling.
- Secure container access.

## Docker Basics

### Installation

1. **Install Docker on Ubuntu:**

```bash
sudo apt update
sudo apt install -y docker.io
```

### Starting with Containers

1. **Pull an Image and Run a Container:**

```bash
docker run -d -p 80:80 --name my\_apache apache
```

- **\-d:** Detached mode (run in the background).
- **\-p 80:80**: Map host port 80 to container port 80.
- **\--name my_apache**: Name the container my_apache.

2. **Access Container Shell**:

```bash
docker exec -it my\_apache /bin/bash
```

3. **Stop and Remove a Container:**

```bash
docker stop my\_apache
docker rm my\_apache
```

### Data Persistence with Volumes

1. Create and Use a Volume:

```bash
docker volume create my\_volume
docker run -d -p 80:80 -v my\_volume:/var/www/html --name web\_container apache
```

2. Inspect Volumes:

```bash
docker volume inspect my\_volume
```

## Advanced Docker Usage

### Multi-Container Applications

1. **Using Docker Compose:**

- Define services in a docker-compose.yml file:

```yaml
version: "3"
services:
  web:
    image: wordpress
    ports:
      - "8080:80"
    volumes:
      - wordpress_data:/var/www/html
  db:
    image: mariadb
    environment:
      MYSQL_ROOT_PASSWORD: example
    volumes:
      - db_data:/var/lib/mysql
volumes:
  wordpress_data:
  db_data:
```

2. **Deploy with Docker Compose:**

```bash
docker-compose up -d
```

### Creating Custom Docker Images

1. **Create a Dockerfile:**

```dockerfile
FROM ubuntu:22.04
RUN apt-get update && apt-get install -y apache2
COPY ./index.html /var/www/html/
CMD ["apache2ctl", "-D", "FOREGROUND"]
```

2. **Build and Tag the Image:**

```bash
docker build -t my\_custom\_apache .
```

3. **Run the Custom Image:**

```bash
docker run -d -p 8080:80 my\_custom\_apache
```

## Security and Best Practices

### 1. Restrict Container Access

Use firewall rules and network segmentation to restrict access to containers.

### 2. Use Non-Root Users

Configure containers to run as non-root users to enhance security.

### 3. Keep Docker and Images Updated

Regularly update Docker and the base images to incorporate security patches.

## Conclusion

- ### Containers vs. Virtual Machines

  Containers offer lightweight, portable environments, while VMs provide stronger isolation at the cost of higher resource usage.
- ### Practical Applications
- Use containers for microservices, development environments, and continuous integration pipelines.

#### Resources

- [Docker Documentation] (<https://docs.docker.com/>)
- [Docker Labs Cheatsheet]  (<https://dockerlabs.collabnix.com/docker/cheatsheet/>)

### examples

```Dockerfile
FROM ubuntu:22.04
COPY ./install.sh /tmp/
VOLUME ["/data"]

RUN DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
  && apt-get install --no-install-recommends -y \
    vim \
    wget \
  && apt-get install --no-install-recommends -y apache2 \
  && apt-get install --no-install-recommends -y mariadb-server mariadb-client \
  && apt-get install --no-install-recommends -y php phpmyadmin \
  && ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin \
  && apt-get install --no-install-recommends -y libapache2-mod-php php-mysql \
  && wget -q https://wordpress.org/latest.tar.gz \
  && tar -xvf latest.tar.gz \
  && rm -f latest.tar.gz \
  && cp -R wordpress /var/www/html/ \
  && chown -R www-data:www-data /var/www/html/wordpress/ \
  && chmod -R 755 /var/www/html/wordpress/ \
  && mkdir /var/www/html/wordpress/wp-content/uploads \
  && chown -R www-data:www-data /var/www/html/wordpress/wp-content/uploads/ \
  # clean apt \
  && rm -rf /var/lib/apt/lists/* \
    /var/cache/debconf/* \
  && apt-get clean

CMD ["apache2ctl", "-D", "FOREGROUND"]
```
