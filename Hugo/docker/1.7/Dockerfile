# Utiliser une image de base Ubuntu
FROM ubuntu:22.04

# Mettre à jour le système et installer Apache
RUN apt-get update && apt-get install -y apache2

# Copier le fichier index.html dans le répertoire par défaut d'Apache
COPY index.html /var/www/html/

# Exposer le port 80 pour Apache
EXPOSE 80

# Démarrer Apache en avant-plan
CMD ["apache2ctl", "-D", "FOREGROUND"]
