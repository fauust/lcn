
# Commande de base pour docker

## Création d'un conteneur de base

Si l'image est déjà sur le système alors elle est utilisé sinon on télécharge la latest

```
docker run alpine
```

## Rentrons en intéraction avec le conteneur et donnons lui un nom

```
docker run --name mon_conteneur -it alpine sh
```

De cette manière nous rentrons à l'intérieur du conteneur avec le shell sh

### On lui expose un port afin de pouvoir ouvrir un service vers l'extérieur, on lui attribu des ressources, un volume pour le stockage et un point de montage pour partager facilement des fichier

```
docker run --name mon_conteneur --p 80:80 --cpus="2" --memory="2g" -v volume_created:/data --mount type=bind,src=~/data_pour_conteneur,target=/data_dans_conteneur -it alpine sh
```

De cette manière nous pouvons aussi ajouter un network ou différents volumes.
