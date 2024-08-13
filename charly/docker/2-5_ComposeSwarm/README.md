Voici un exemple de fichier `README.md` expliquant la configuration Docker Compose que vous avez mise en place. Ce fichier décrit les services définis dans votre `docker-compose.yaml`, les réseaux utilisés, ainsi que les secrets configurés.

---

# Configuration Docker Compose

Ce fichier `docker-compose.yaml` configure un environnement Docker avec trois services principaux : WordPress, phpMyAdmin et MariaDB. Voici une vue d'ensemble de chaque composant et de la configuration associée.

## Services

### WordPress

- **Image**: `wordpress:6.3`
- **Dépendances**: Dépend du service `mariadb`.
- **Redémarrage**: `unless-stopped` (le service redémarre automatiquement sauf si arrêté manuellement).
- **Ports**:
  - `8080:80` (expose le port 80 du conteneur sur le port 8080 de l'hôte).
- **Réseaux**:
  - `frontnet`
  - `backnet`
- **Environnement**:
  - `WORDPRESS_DB_HOST`: `mariadb:3306` (hôte de la base de données)
  - `WORDPRESS_DB_USER`: `wpuser` (utilisateur de la base de données)
  - `WORDPRESS_DB_PASSWORD_FILE`: `/run/secrets/password` (mot de passe de la base de données depuis un secret)
  - `WORDPRESS_DB_NAME`: `wpdb` (nom de la base de données)
- **Volumes**:
  - `/srv/wordpress:/var/www/html` (montage d'un volume pour persister les données de WordPress)
- **Secrets**:
  - `password` (utilisé pour le mot de passe de la base de données)

### phpMyAdmin

- **Image**: `phpmyadmin:latest`
- **Dépendances**: Dépend du service `mariadb`.
- **Redémarrage**: `unless-stopped` (le service redémarre automatiquement sauf si arrêté manuellement).
- **Ports**:
  - `127.0.0.1:8081:80` (expose le port 80 du conteneur sur le port 8081 de l'hôte, accessible uniquement depuis localhost)
- **Réseaux**:
  - `frontnet`
  - `backnet`
- **Environnement**:
  - `PMA_HOST`: `mariadb` (hôte de la base de données)
  - `PMA_PORT`: `3306` (port de la base de données)

### MariaDB

- **Image**: `mariadb:10.5`
- **Redémarrage**: `unless-stopped` (le service redémarre automatiquement sauf si arrêté manuellement).
- **Réseaux**:
  - `backnet` (réseau uniquement interne)
- **Environnement**:
  - `MYSQL_ROOT_PASSWORD_FILE`: `/run/secrets/password` (mot de passe root de la base de données depuis un secret)
  - `MYSQL_DATABASE`: `wpdb` (nom de la base de données à créer)
  - `MYSQL_USER`: `wpuser` (utilisateur de la base de données)
  - `MYSQL_PASSWORD_FILE`: `/run/secrets/password` (mot de passe de l'utilisateur de la base de données depuis un secret)
- **Volumes**:
  - `/srv/mariadb:/var/lib/mysql` (montage d'un volume pour persister les données de MariaDB)
- **Secrets**:
  - `password` (utilisé pour les mots de passe de la base de données)

## Réseaux

- **frontnet**: Réseau de pont pour les services front-end (WordPress et phpMyAdmin).
- **backnet**: Réseau de pont interne pour les services back-end (MariaDB). Ce réseau est marqué comme `internal`, ce qui signifie qu'il est inaccessible depuis l'extérieur.

## Secrets

- **password**: Ce secret est stocké dans le fichier `secrets/password.txt` et est utilisé pour les mots de passe des services.

## Points Clés

- **Séparation des Réseaux**: Les services front-end (WordPress et phpMyAdmin) et back-end (MariaDB) utilisent des réseaux séparés pour des raisons de sécurité et d'organisation.
- **Secrets**: Les secrets sont utilisés pour stocker de manière sécurisée les mots de passe et autres informations sensibles nécessaires pour la configuration des services.
- **Volumes**: Les volumes sont utilisés pour persister les données de WordPress et MariaDB.

Pour lancer cette configuration, assurez-vous d'avoir Docker et Docker Compose installés. Utilisez la commande suivante pour démarrer les services en arrière-plan :

```bash
docker-compose up -d
```

Pour arrêter et supprimer les services, utilisez :

```bash
docker-compose down
```
---