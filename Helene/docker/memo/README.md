# Documentation pour le Projet Docker Apache

Ce projet vous guide à travers la création d'une image Docker basée sur Apache HTTP Server pour servir une page web simple. Vous trouverez ici les commandes nécessaires pour construire, tester et pousser l'image Docker, ainsi que les instructions Dockerfile détaillées.

## Prérequis

Avant de commencer, assurez-vous d'avoir installé [Docker](https://docs.docker.com/get-docker/) sur votre machine.

## Structure du Projet

- `Dockerfile` : Contient les instructions pour construire l'image Docker.
- `index.html` : Fichier HTML qui sera servi par le serveur Apache.

## Instructions Dockerfile

Voici les instructions Dockerfile les plus courantes que vous pouvez utiliser pour construire une image Docker :

- **FROM** : Indique l'image parente à partir de laquelle construire l'image. Par exemple, `FROM httpd:latest` utilise l'image officielle Apache HTTP Server.
- **MAINTAINER** : Définit l'auteur de l'image. Exemple : `MAINTAINER Nom <email>`.
- **WORKDIR** : Change le répertoire de travail dans l'image. Exemple : `WORKDIR /usr/local/apache2/htdocs/`.
- **RUN** : Exécute une commande lors de la construction de l'image. Exemple : `RUN apt-get update`.
- **COPY** : Copie des fichiers de l'hôte vers le système de fichiers de l'image. Exemple : `COPY index.html /usr/local/apache2/htdocs/`.
- **ADD** : Copie des fichiers et des dossiers depuis l'hôte ou depuis des URLs vers l'image. Exemple : `ADD http://example.com/file.tar.gz /app/`.
- **CMD** : Définit la commande par défaut à exécuter lors du lancement du conteneur. Exemple : `CMD ["httpd-foreground"]`.
- **ENTRYPOINT** : Définit la commande principale à exécuter lorsque le conteneur démarre. Exemple : `ENTRYPOINT ["httpd", "-D", "FOREGROUND"]`.
- **ARG** : Définit des variables qui peuvent être passées à l'image lors de sa construction. Exemple : `ARG VERSION=1.0`.
- **ENV** : Définit des variables d'environnement disponibles dans l'image et le conteneur. Exemple : `ENV APP_ENV=production`.
- **LABEL** : Ajoute des métadonnées à l'image. Exemple : `LABEL version="1.0"`.
- **EXPOSE** : Indique les ports sur lesquels l'application à l'intérieur du conteneur écoute. Exemple : `EXPOSE 80`.
- **VOLUME** : Définit un point de montage pour les volumes dans l'image. Exemple : `VOLUME ["/data"]`.

## Étapes de Construction et d'Exécution

### 1. Créer le Dockerfile

Créez un fichier nommé `Dockerfile` avec le contenu suivant :

```Dockerfile
# Utiliser l'image Apache officielle
FROM httpd:latest

# Copier le fichier index.html dans le répertoire de documents d'Apache
COPY index.html /usr/local/apache2/htdocs/

# Exposer le port 80 (port par défaut pour HTTP)
EXPOSE 80
```

2. Construire l'image Docker

Pour construire l'image Docker à partir du Dockerfile, utilisez la commande suivante :

```
docker build -t mon-apache-image .  # docker build -t apache-memo:latest .
```

3. Lancer un conteneur

Pour lancer un conteneur à partir de l'image construite, utilisez la commande suivante :

```
docker run -d -p 8080:80 --name mon-apache-container mon-apache-image
```

4. Vérifier le conteneur en cours d'exécution

Pour vérifier que le conteneur fonctionne correctement, utilisez :

```
docker ps
```
Vous pouvez accéder à la page web en visitant [Localhost](http://localhost:8080) dans votre navigateur.
5. Supprimer un conteneur

Pour supprimer un conteneur arrêté, utilisez la commande suivante :

```
docker rm mon-apache-container
```
Pour supprimer un conteneur en cours d'exécution, arrêtez-le d'abord avec :

```
docker stop mon-apache-container
```

Puis supprimez-le :

```
docker rm mon-apache-container
```

6. Utiliser un volume persistant

Pour utiliser un volume persistant avec votre conteneur, vous pouvez monter un volume en utilisant la commande suivante :

```
docker run -d -p 8080:80 -v /chemin/local:/usr/local/apache2/htdocs/ --name mon-apache-container mon-apache-image
```

7. Utiliser des images pour créer des conteneurs

Pour voir toutes les images disponibles sur votre machine, utilisez :

```
docker images
```
Pour supprimer une image, utilisez :

```
docker rmi mon-apache-image
```

8. Mettre à jour l'application dans le conteneur

Pour mettre à jour votre application, modifiez le fichier index.html, reconstruisez l'image et recréez le conteneur avec les nouvelles modifications :

```
docker build -t mon-apache-image .
docker stop mon-apache-container
docker rm mon-apache-container
docker run -d -p 8080:80 --name mon-apache-container mon-apache-image
```

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Copyright

© 2024 Hélène Finot. All rights reserved.