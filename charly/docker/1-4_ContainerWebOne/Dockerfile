# Utiliser l'image de base Ubuntu 22.04
FROM ubuntu:22.04

# Éviter les prompts interactifs durant l'installation des paquets
ENV DEBIAN_FRONTEND=noninteractive

# Installer les mises à jour, les certificats CA et les dépendances nécessaires
RUN apt-get update && apt-get upgrade --no-install-recommends -y && \
    apt-get install --no-install-recommends -y \
    ca-certificates \
    apache2 \
    mysql-server \
    php \
    php-mysql \
    libapache2-mod-php \
    wget \
    unzip \
    vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Télécharger et installer WordPress
    RUN wget --progress=dot:giga https://wordpress.org/latest.zip -O /tmp/wordpress.zip && \
    unzip /tmp/wordpress.zip -d /var/www/html/ && \
    chown -R www-data:www-data /var/www/html/wordpress

# Télécharger et installer phpMyAdmin
    RUN wget --progress=dot:giga https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.zip -O /tmp/phpmyadmin.zip && \
    unzip /tmp/phpmyadmin.zip -d /var/www/html/ && \
    mv /var/www/html/phpMyAdmin-* /var/www/html/phpmyadmin && \
    chown -R www-data:www-data /var/www/html/phpmyadmin

# Copier la configuration d'Apache
COPY apache2.conf /etc/apache2/sites-available/000-default.conf

# Copier le fichier de configuration de WordPress
COPY wp-config.php /var/www/html/wordpress/wp-config.php
COPY scripts/init.sql /root/init.sql

# Exposer le port 80 pour Apache et le port 3306 pour MySQL
EXPOSE 80 3306

# Démarrer les services Apache et MySQL
CMD ["sh", "-c", "service mysql start && apachectl -D FOREGROUND && sleep 10 && mysql -v < /root/init.sql"]
