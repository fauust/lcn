# 1.1 Pour installer docker

```
- sudo apt update
- sudo apt install apt-transport-https ca-certificates curl software-properties-common
- curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
 sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
- curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
 sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
- sudo apt update
- apt-cache policy docker-ce
- sudo apt install docker-ce
- sudo systemctl status docker
```

## 1.2 Pour lancer un conteneur simple

On télécharge une image:

- docker image pull [OPTIONS] NAME[:TAG|@DIGEST]

Ensuite on la build:

- docker build -t [nomImage]:[version] [pathToDockerFile]

Ensuite on lance le conteneur( -it pour un terminal qui donne sur la machine docker):

docker run [OPTIONS] --name NOMCONTENEUR

## 1.3 Persistence des services

Avec docker on peut utiliser des volumes.
Ces volumes serve à garder des données même si l'ont vient à supprimer la machine

Création d'un Volume:

- docker volume create [nom_du_volume]

Ensuite, pour l'utiliser, on précise dans la commande du run l'option '-v NomVolume:EndroitDuVolume'

Une commande plus complète donnerait donc

```
- docker run --name [nom_du_conteneur] -v [lien_de_la_source]:
  [lien_de_destination] [nom_de_l_image]
```

## 1.4 POur prendre le contrôle d'un conteneur docker, on peut préciser -it

- `-it` dans la commande du run, va démarrer le conteneur et nous mettre dedans
- Sinon on le fait après l'avoir démarré et nous fessons `exec -it`
  qui permet de rentrer dans un conteneur déjà lancés.

## 1.5 Création de volumes

On oublie pas la commande pouir créer un volume
On l'utilise au run avec un -v (cf ci-dessus)
Ne pas déplacer son volume si on casse son conteneur pour en refaire un.
Sinon on perd toutes les data de sauvegardés.

## 1.6 Multi Containers

On veut plusieurs conteneurs qui parlent tous ensemble sur un même réseau.
Alors on met un network en place.

Seuls les network crée par un utilisateur,
dispose de la reconnaissance automatique d'IP.
À savoir que le nom du conteneur devient un alias pour son address IP.

`docker network create <network_name> --driver bridge`
---> Sert à crée un network

`docker network connect <network_name> <conteneur_name>`
---> Sert à connecter un network à un conteneur

## 1.7 créer ses propres images

Pour créer ses propres images, le dockerfile est la !

C'est un fichier qui peut créer une image personnalisée,
pour ce faire tu devras lui donner certaines informations :

- FROM [image]
  ---> Défini de quel image tu pars (voir définition pour image)
- RUN [command]
  ---> Execute les commandes qui lui sont passés (voir définition pour les commandes)
- WORKDIR [directory]
  ---> Défini le working directory
- COPY [src] [dest]
  ---> une copier classique
- CMD [command]
  ---> Définit les commandes qui se lanceront au démarrage du conteneur.

Grâce à ses informations,
tu peux modifier ton image à ta guise pour avoir la plus performante ou la plus légère.
