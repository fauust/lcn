
---

# Dockerfile for a Single Container with Apache, MySQL, WordPress, and PhpMyAdmin on Ubuntu with Persistent Data

```dockerfile
# Use the official Ubuntu base image
FROM ubuntu:22.04

# Set environment variable to prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update package list and install Apache, MySQL, PHP, and other dependencies
RUN apt-get update \
    && apt-get install -y apache2 mysql-server php php-mysql php-mbstring php-zip php-gd php-json php-curl wget unzip curl nano vim libapache2-mod-php \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Enable necessary PHP modules
RUN phpenmod mbstring \
    && phpenmod zip \
    && phpenmod gd

# Download and install PhpMyAdmin
RUN wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz -P /tmp \
    && tar xzf /tmp/phpMyAdmin-latest-all-languages.tar.gz -C /var/www/html \
    && mv /var/www/html/phpMyAdmin-* /var/www/html/phpmyadmin \
    && rm /tmp/phpMyAdmin-latest-all-languages.tar.gz

# Copy the PhpMyAdmin configuration file
COPY phpmyadmin-config.inc.php /var/www/html/phpmyadmin/config.inc.php

# Download and install WordPress
RUN wget https://wordpress.org/latest.tar.gz -P /tmp \
    && tar xzf /tmp/latest.tar.gz -C /var/www/html \
    && rm /tmp/latest.tar.gz

# Copy the WordPress configuration file
COPY wp-config.php /var/www/html/wordpress/wp-config.php

# Set permissions for the web root
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Configure Apache for WordPress
RUN echo '<VirtualHost *:80>\n\
    DocumentRoot /var/www/html/wordpress\n\
    <Directory /var/www/html/wordpress>\n\
        AllowOverride All\n\
        Require all granted\n\
    </Directory>\n\
</VirtualHost>' > /etc/apache2/sites-available/000-default.conf

# Enable Apache mod_rewrite module for WordPress
RUN a2enmod rewrite

# Copy the MySQL initialization script to the correct directory
COPY scripts/init.sql /docker-entrypoint-initdb.d/

# Expose ports for Apache and MySQL
EXPOSE 80 3306

# Start Apache and MySQL when the container is run
CMD service apache2 start && service mysql start && tail -f /dev/null
```

## Explanation of Dockerfile Instructions

1. **`FROM ubuntu:22.04`** :
   - This instruction uses the Ubuntu 22.04 LTS version as the base for the Docker image, providing a stable and secure foundation for our application stack.

2. **`ENV DEBIAN_FRONTEND=noninteractive`** :
   - Sets an environment variable to prevent interactive prompts during package installation, which is crucial for automation in Docker builds.

3. **`RUN apt-get update && apt-get install -y apache2 mysql-server php php-mysql php-mbstring php-zip php-gd php-json php-curl wget unzip curl nano vim libapache2-mod-php && apt-get clean && rm -rf /var/lib/apt/lists/*`** :
   - Updates the package list to ensure that we have access to the latest versions of all software.
   - Installs Apache, MySQL, PHP, and various essential PHP extensions needed for running WordPress and PhpMyAdmin.
   - Cleans up temporary files to reduce the size of the Docker image, ensuring efficiency.

4. **`RUN phpenmod mbstring && phpenmod zip && phpenmod gd`** :
   - Activates the necessary PHP extensions for PhpMyAdmin and WordPress functionality.

5. **`RUN wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz -P /tmp && tar xzf /tmp/phpMyAdmin-latest-all-languages.tar.gz -C /var/www/html && mv /var/www/html/phpMyAdmin-* /var/www/html/phpmyadmin && rm /tmp/phpMyAdmin-latest-all-languages.tar.gz`** :
   - Downloads the latest PhpMyAdmin release.
   - Extracts the files to the web server directory, renaming the directory for simplicity.
   - Cleans up downloaded archives to save space.

6. **`COPY phpmyadmin-config.inc.php /var/www/html/phpmyadmin/config.inc.php`** :
   - Copies a pre-configured PhpMyAdmin settings file from the host system to the container, setting the stage for database management.

7. **`RUN wget https://wordpress.org/latest.tar.gz -P /tmp && tar xzf /tmp/latest.tar.gz -C /var/www/html && rm /tmp/latest.tar.gz`** :
   - Downloads the latest WordPress version.
   - Extracts it into the Apache root directory, making it ready to use.
   - Removes the tar file to keep the image lean.

8. **`COPY wp-config.php /var/www/html/wordpress/wp-config.php`** :
   - Transfers the custom WordPress configuration file, ensuring the application can connect to the database correctly.

9. **`RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html`** :
   - Changes ownership of web directory files to the Apache user, allowing proper access and modifications.
   - Sets directory permissions to allow read and execute access, securing the environment.

10. **`RUN echo '<VirtualHost *:80>\n    DocumentRoot /var/www/html/wordpress\n    <Directory /var/www/html/wordpress>\n        AllowOverride All\n        Require all granted\n    </Directory>\n</VirtualHost>' > /etc/apache2/sites-available/000-default.conf`** :
    - Configures Apache to serve WordPress by updating the default site configuration file, enabling URL rewriting for SEO-friendly URLs and functionality.

11. **`RUN a2enmod rewrite`** :
    - Enables Apache's `mod_rewrite` module to allow the use of .htaccess files for URL rewriting, crucial for WordPress permalinks.

12. **`COPY scripts/init.sql /docker-entrypoint-initdb.d/`** :
    - Adds a SQL script that initializes the MySQL database, creating necessary tables and users upon container startup.

13. **`EXPOSE 80 3306`** :
    - Opens port 80 for web traffic and port 3306 for MySQL, allowing external access to the services.

14. **`CMD service apache2 start && service mysql start && tail -f /dev/null`** :
    - Defines the command to start Apache and MySQL when the container runs, ensuring both services operate simultaneously.
    - Uses `tail -f /dev/null` to keep the container running indefinitely for continuous operation.

---

## docker-compose.yml for Simplified Management

```yaml
version: '3.9'

services:
  web:
    build: .
    container_name: web
    ports:
      - "80:80"
      - "3306:3306"
    volumes:
      - web_data:/var/www/html
    environment:
      MYSQL_ROOT_PASSWORD: root_password
    networks:
      - webnet

volumes:
  web_data:

networks:
  webnet:
```

### Explanation of docker-compose.yml Instructions

1. **`version: '3.9'`** :
   - Specifies the version of Docker Compose syntax to use, ensuring compatibility and access to features.

2. **`services:`** :
   - Declares the services that will be orchestrated by Docker Compose, in this case, the web application stack.

3. **`web:`** :
   - Defines the `web` service, which builds and runs our Dockerfile to deploy the application.

4. **`build: .`** :
   - Indicates that the Dockerfile in the current directory should be used to build the service's image.

5. **`container_name: web`** :
   - Sets a specific name for the running container, simplifying identification and management.

6. **`ports:`** :
   - **`- "80:80"`** : Maps port 8080 on the host to port 8080 in the container, allowing web access to Apache.
   - **`- "3306:3306"`** : Maps port 3308 on the host to port 3308 in the container, facilitating MySQL connections.

7. **`volumes:`** :
   - **`web_data:/var/www/html`** : Mounts a Docker volume named `web_data` to persist data across container restarts, ensuring the database and website files remain intact.

8. **`environment:`** :
   - **`MYSQL_ROOT_PASSWORD: root_password`** : Sets an environment variable for the MySQL root password, enabling secure database access.

9. **`networks:`** :
   - **`- webnet`** : Assigns the service to a Docker network named `webnet`, providing network isolation and communication between services if expanded.

10. **`volumes:`** :
    - Declares named volumes, such as `web_data`, ensuring data persists independently of the container lifecycle.

11. **`networks:`** :
    - Defines custom networks, like `webnet`, for

 organized service interactions and isolation within the Docker environment.

---

## Custom Configuration Files

To ensure the correct configuration and operation of PhpMyAdmin and WordPress, we need custom configuration files. These files will be copied into the Docker container during the build process.

### phpmyadmin-config.inc.php

Create a file named `phpmyadmin-config.inc.php` in the same directory as your Dockerfile:

```php
<?php

/**
 * PhpMyAdmin configuration file
 */

/* Servers configuration */
$i = 0;
$i++;

/* Server: MySQL Server */
$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['host'] = 'localhost';
$cfg['Servers'][$i]['user'] = 'root';
$cfg['Servers'][$i]['password'] = 'root_password'; // Use the same root password as in docker-compose.yml
$cfg['Servers'][$i]['compress'] = false;
$cfg['Servers'][$i]['AllowNoPassword'] = false;

/* Directory where templates cache will be stored */
$cfg['TempDir'] = '/tmp';

/* Uncomment the following line to load extended configuration options */
#$cfg['Servers'][$i]['controluser'] = 'root';
#$cfg['Servers'][$i]['controlpass'] = '';

/* Uploads setup */
$cfg['UploadDir'] = '';
$cfg['SaveDir'] = '';

/* Blowfish secret for cookie encryption */
$cfg['blowfish_secret'] = 'your_unique_blowfish_secret';

/* Servers config */
$cfg['PmaAbsoluteUri'] = '/phpmyadmin';
```

### wp-config.php

Create a file named `wp-config.php` in the same directory as your Dockerfile:

```php
<?php

/**
 * The base configuration for WordPress
 */

/** The name of the database for WordPress */
define('DB_NAME', 'wordpress_db');

/** MySQL database username */
define('DB_USER', 'wp_user');

/** MySQL database password */
define('DB_PASSWORD', 'secure_password');

/** MySQL hostname */
define('DB_HOST', 'localhost');

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 */
define('AUTH_KEY',         'put your unique phrase here');
define('SECURE_AUTH_KEY',  'put your unique phrase here');
define('LOGGED_IN_KEY',    'put your unique phrase here');
define('NONCE_KEY',        'put your unique phrase here');
define('AUTH_SALT',        'put your unique phrase here');
define('SECURE_AUTH_SALT', 'put your unique phrase here');
define('LOGGED_IN_SALT',   'put your unique phrase here');
define('NONCE_SALT',       'put your unique phrase here');

/**#@-*/

/** WordPress Database Table prefix. */
$table_prefix = 'wp_';

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
```

### MySQL Initialization Script

Create a file named `init.sql` in the `scripts` directory (create this directory if it doesn't exist):

```sql
CREATE DATABASE IF NOT EXISTS wordpress_db;
CREATE USER IF NOT EXISTS 'wp_user'@'localhost' IDENTIFIED BY 'secure_password';
GRANT ALL PRIVILEGES ON wordpress_db.* TO 'wp_user'@'localhost';
FLUSH PRIVILEGES;
```

---

## Build and Run the Container

Follow these steps to build the Docker image and run the container using Docker Compose. Make sure all necessary files (`phpmyadmin-config.inc.php`, `wp-config.php`, and `init.sql`) are in place.

1. **Build the Docker Image:**

   Navigate to the directory containing your Dockerfile and run the following command to build the Docker image:

   ```bash
   docker-compose build
   ```

   This command builds the image defined in the Dockerfile as specified in `docker-compose.yml`.

2. **Run the Container with Docker Compose:**

   Start the container using Docker Compose to ensure all services are running correctly and are configured:

   ```bash
   docker-compose up -d
   ```

   - **-d** : Runs the containers in detached mode, allowing the terminal to be used for other tasks while the services run in the background.

3. **Access Your Application:**

   - **WordPress:** Open your browser and navigate to `http://localhost` to access the WordPress installation page.
   - **PhpMyAdmin:** Visit `http://localhost/phpmyadmin` to manage your MySQL databases with PhpMyAdmin.

4. **Stop and Remove Containers:**

   To stop the running containers and remove them, use the following command:

   ```bash
   docker-compose down
   ```

   This command stops and removes the containers, preserving the volumes for data persistence.

---

## Troubleshooting

Here are some tips for troubleshooting common issues that may arise during setup:

- **Port Conflicts:** Ensure that ports 80 and 3308 are not in use by other services on your host machine.
- **Database Connection Errors:** Check the MySQL credentials in `wp-config.php` and ensure the user and database exist with the correct privileges.
- **Permission Denied Errors:** Verify that the `/var/www/html` directory permissions allow read and write access for the Apache user (`www-data`).
- **Log Files:** Use the following command to view logs and identify potential issues:

  ```bash
  docker-compose logs
  ```

- **Rebuilding Images:** If you make changes to your Dockerfile or configurations, rebuild the images with:

  ```bash
  docker-compose build --no-cache
  ```

---
