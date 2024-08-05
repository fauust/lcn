
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

## Différence entre une VM et un Container

Une vm est une machine complète avec son système d'exploitation isolé du système hôte. L'hyperviseur transforme les instructions du système guest pour qu'elles soient exécuter par le processeur de la machine hôte. De ce fait ont peut utiliser un système windows sur une machine linux sans soucis grâce à cette couche de traduction.

Le container est quand à lui disponible uniquement en présence d'un noyau linux, car les containers tournent obligatoirement sur une image linux est transmettenent leurs instructions directement au système hôte. Le système d'un container restent toutefois isolé du système hôte.

Une des différences d'utilisation entre les deux systèmes et leurs performances vs leurs possibilités. Les vm offrents plus de possibilité au niveau de l'os choisi mais perdent en performance à cause de la couche de traduction des instructions. Les containers offrent plus de performance mais oblige la présence d'un noyau linux sur la machine hôte, le container quand à lui tournent automatiquement sur un noyau linux.
