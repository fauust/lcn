# Create one container per service
Containers
----------

### WordPress

*   OS (Alpine…)
*   Apache ou Nginx
*   Wordpress
*   PHP

### MariaDB

*   mariadb-server

### PhpMyAdmin

*   phpMyAdmin

Network
-------

Create local network :

```text-x-sh
docker network create wp-network
```

Volumes
-------

```text-x-sh
docker volume create mariadb-data
```

MariaDB
-------

```text-x-sh
docker run -dit \
	-e MARIADB_ROOT_PASSWORD=toto \
    -e MARIADB_DATABASE=wpdb \
    -e MARIADB_USER=xav \
    -e MARIADB_PASSWORD=titi \
	--mount type=volume,src=mariadb-data,target=/var/lib/mysql \
	--name mydb \
	--network wp-network \	
	mariadb
```

WordPress
---------

```text-x-sh
docker run -dit \
	-e WORDPRESS_DB_USER=xav \
	-e WORDPRESS_DB_PASSWORD=titi \
	-e WORDPRESS_DB_HOST=mydb:3306 \
	-e WORDPRESS_DB_NAME=wpdb \
	-p 8080:80 \
	--name mywordpress \
	--network wp-network \
	wordpress
```

PHPMyAdmin
----------

See [https://hub.docker.com/\_/phpmyadmin](https://hub.docker.com/_/phpmyadmin) 

```text-x-sh
docker run -dit \
	-e MARIADB_ROOT_PASSWORD=toto \
	-e PMA_HOST=mydb \
	-p 8085:80 \
	--name myphpmyadmin \
	--network wp-network \
	phpmyadmin
```

L'option `-e PMA_PORT` n'est pas nécessaire si on utilise le port par défaut.

Il faut spécifier un autre port que 8080 car 8080 est déjà utilisé par Wordpress.