# Docker 1.7

## Étape 1 : Construire l'Image Docker

**Construisez l'image Docker :**

```
docker build -t my-apache-image .
```

## Étape 2 : Tester l'Image Docker

**Démarrez un conteneur à partir de l'image construite :**

```
docker run -d -p 8080:80 --name my-apache-container my-apache-image
```

**Accédez à l'application dans votre navigateur :**

Ouvrez votre navigateur et allez à

```
http://localhost:8080
```

Vous devriez voir le message "Bienvenue sur mon serveur Apache Dockerise!"
