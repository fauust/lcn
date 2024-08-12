FROM ubuntu:24.04

LABEL authors="olinger"

# Installer vim
RUN apt-get update && apt-get install -y --no-install-recommends vim apache2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copier une page d'accueil par défaut dans le répertoire de serveur web d'Apache
COPY ./index.html /var/www/html/index.html

# Exposer le port 80 pour le serveur web
EXPOSE 80

# Définir le point d'entrée pour démarrer Apache en mode premier plan
ENTRYPOINT ["apachectl", "-D", "FOREGROUND"]