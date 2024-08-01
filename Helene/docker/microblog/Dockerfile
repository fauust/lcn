# Utiliser l'image de Python 3.9 (Alpine)
FROM python:3.9-alpine

# Définir le label de l'auteur
LABEL authors="helene"

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Installer les commandes nécessaires à la récupération de l'application
RUN apk add git \
    && git clone https://github.com/fheslouin/microblog /app \
    && rm -rf /app/.git* \
    && apk del git \
    # Installer les dépendances Python \
    && pip install -r requirements.txt

# Définir des variables d'environnement
ENV FLASK_APP=/app/microblog.py
ENV CONTEXT=PROD

# Exposer le port 5000 pour l'application
EXPOSE 5000

# Définir la commande par défaut pour exécuter le script boot.sh au démarrage du container
CMD ["sh", "/app/boot.sh"]