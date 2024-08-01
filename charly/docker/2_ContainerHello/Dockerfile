FROM ubuntu:24.04

LABEL authors="olinger"

# Utiliser l'image de base officielle d'Apache
FROM httpd:2.4

# Installer vim
RUN apt-get update && apt-get install -y --no-install-recommends vim \
     && apt-get clean \
     && rm -rf /var/lib/apt/lists/*

# Copier la page d'accueil personnalisée dans le répertoire de serveur web d'Apache
COPY ./index.html /usr/local/apache2/htdocs/

# Exposer le port 80 pour le serveur web
EXPOSE 80
