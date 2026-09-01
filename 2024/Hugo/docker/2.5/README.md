# Docker 2.5

## Docker Swarm initialisé

```
docker swarm init
```

## Build & deploy services

```
docker-compose down
dokcer-compose up --build -d
```
## Simulation de l'utilisation normale

Pour simuler une utilisation normale de l'application WordPress,
envoyez plusieurs requêtes successives

```
seq 1 200 | xargs -Iname -P10 curl -I "http://IP/wp-admin"
```

- 200 : Nombre de requêtes souhaitées.
- -P10 : Nombre de requêtes simultanées.


## Test request with siege

Installation de siege

```
sudo apt-get install siege
```

Pour refaire le test précédent avec Siege

```
siege http://[ip-docker-wordpress]/wp-admin
```