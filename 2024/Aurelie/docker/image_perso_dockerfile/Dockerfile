FROM debian:12-slim

# Met à jour le système, installe Apache, MariaDB et PHP
RUN apt-get update -y && \
    apt-get install -q -y --no-install-recommends apache2 mariadb-server php php-mysql && \
    rm -f /var/www/html/index.html && \
    echo '<?php phpinfo(); ?>' > /var/www/html/index.php && \
    # Supprime les fichiers de liste pour réduire la taille de l'image
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoclean -y

# Expose le port 80
EXPOSE 80

# Définit le répertoire de travail
WORKDIR /var/www/html

# Démarre Apache en premier plan
CMD ["apachectl", "-D", "FOREGROUND"]
