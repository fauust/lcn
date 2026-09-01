# Utilisez l'image PHP officielle avec Apache
FROM php:8.2-apache

# Créez un fichier PHP avec phpinfo() directement dans le conteneur
RUN echo '<?php phpinfo(); ?>' > /var/www/html/index.php\
   && chown -R www-data:www-data /var/www/html

# Exposez le port 80 pour le serveur web
EXPOSE 80

# Commande pour démarrer Apache en mode premier plan
CMD ["apache2-foreground"]




