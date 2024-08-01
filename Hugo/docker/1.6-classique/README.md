### Étape 1 : Préparer l'environnement

**Créer les volumes Docker :**
```
docker volume create mysql-data
docker volume create apache-data
```

**Créer le réseau Docker :**
```
docker network create wordpress-network
```

### Étape 2 : Configurer et démarrer le conteneur MySQL

**Démarrer le conteneur MySQL :**
```
docker run -d --name mysql-container \
  -e MYSQL_ROOT_PASSWORD=rootpassword \
  -e MYSQL_DATABASE=wordpress \
  -e MYSQL_USER=wordpressuser \
  -e MYSQL_PASSWORD=wordpresspassword \
  -v mysql-data:/var/lib/mysql \
  --network wordpress-network \
  mysql:latest
```
### Étape 3 : Configurer et démarrer le conteneur WordPress

**Construire l'image Docker pour WordPress :**
```
docker build -t wordpress-image -f Dockerfile-web .
```

Démarrer le conteneur WordPress :
```
docker run -d --name wordpress-container \
  -p 8080:80 \
  -v apache-data:/var/www/html \
  --network wordpress-network \
  wordpress-image
```

### Étape 4 : Configurer et démarrer le conteneur PhpMyAdmin

**Démarrer le conteneur PhpMyAdmin :**
```
docker run -d --name phpmyadmin-container \
  -e PMA_HOST=mysql-container \
  -e MYSQL_ROOT_PASSWORD=rootpassword \
  -p 8081:80 \
  --network wordpress-network \
  phpmyadmin/phpmyadmin:latest
```

### Vérification

- **Vérifiez que WordPress fonctionne :**
    
    Ouvrez votre navigateur et allez à `http://localhost:8080`.
    
- **Vérifiez que PhpMyAdmin fonctionne :**
    
    Ouvrez `http://localhost:8081`.