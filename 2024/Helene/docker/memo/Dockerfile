FROM httpd:2.4
LABEL authors="helene"

# Créer le répertoire des logs avec les permissions appropriées
RUN mkdir -p /usr/local/apache2/logs && chmod -R 755 /usr/local/apache2/logs

# Copier le fichier index.html dans le répertoire approprié de l'image Apache
COPY ./index.html /usr/local/apache2/htdocs/

# Exposer le port 80 pour l'accès HTTP
EXPOSE 80

# Démarrer Apache en mode foreground
CMD ["apachectl", "-D", "FOREGROUND"]