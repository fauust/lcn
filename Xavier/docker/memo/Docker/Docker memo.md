# Docker memo
Glossaire
---------

| Concept | Définition |
| --- | --- |
| Image | Sorte de “VM” préconfigurée avec un OS, du soft… prête à être instanciée. Contient :<br><br>*   un OS<br>*   tout ce qu'il faut pour lancer une application : librairies, dépendances, scripts, config…<br><br>Une image ne peut pas être modifiée - elle est statique. C'est une sorte de template. |
| Container | C'est un process = Instance d'image, configurée avec certains paramètres :  <br>`docker run <parameters> <image_name>`<br><br>Les paramètres peuvent être :<br><br>*   le nom<br>*   les ports <br>*   les “volumes” à utiliser<br>*   etc<br><br>Caractéristiques :<br><br>*   on peut avoir plusieurs containers par image<br>*   un container peut être stoppé, démarré, détruit, bougé…<br>*   il est par essence volatile, sauf si on lui attache un “volume”<br>*   il est portable (peut être lancé sur n'importe quelle machine/OS)<br>*   on peut le lancer sur une VM, sur le cloud, en local<br>*   il est indépendant / **isolé** du reste des containers et du host |
| volume | Disque “externe” qui permet de stocker des données persistantes. On l'attache à un ou plusieurs containers. |
|     |     |
|     |     |

Cheat sheet
-----------

| Action | Commande |
| --- | --- |
| ### Docker Hub : pull / push images |     |
| Search an image on Docker Hub | `docker search ubuntu` |
| **Pull** an image from Docker Hub | `docker pull ubuntu` |
| **Push** an image on Docker Hub | *   compte<br>*   lister les images pour les identifier : `docker images`<br>*   mettre un tag sur celle qu'on veut push : `docker tag alpsdrive:latest xavcampus/alpsdrive:latest`<br>*   se connecter : `docker login`<br>*   push : `docker push xavcampus/alpsdrive:latest` |
| ### Manage images |     |
| List images | `docker images`  <br>`docker images -a` : list all images, including intermediate images (with no tag)  <br>`docker images -a -q` : print only images ID |
| List dangling images | `docker images -f dangling=true`<br><br>Remove them : `docker image prune` |
| Remove some images | `docker rmi <image1> <image2>`  <br>the `docker rmi` command, the `-f` or `--force` flag can also be used to remove images with no tags.  <br>  <br>Grep :  <br>`docker images -a \| grep "pattern" \| awk '{print $1":"$2}' \| xargs docker rmi` |
| Remove all images | List :  <br>`docker images -a`  <br>Remove :  <br>`docker rmi $(docker images -a -q)` |
| Prune (remove) everything | `docker system prune` : remove dangling (not tagged, or not associated with a container)  <br>`docker system prune -a` : including stopped containers and unused images |
| ### Manage containers |     |
| _List_ running containers | `docker ps`  <br>`docker ps -a` : list all containers (active _**and**_ inactive)  <br>`docker ps -l` : list last container created<br><br>`docker container ls` |
| _Run_ a container | ```text-x-dockerfile<br>docker run <image_name><br>```<br><br>options : <br><br>*   `--rm` : Automatically remove the container when it exits. The default is false.  <br>             --rm flag can work together with -d, and auto-removal will be done  on  daemon  side.  <br>          Note that it's incompatible with any restart policy other than none.<br>*   `-it` : interactive terminal<br>*   `--name <imagename>` : pour pouvoir s'y référer ensuite (stop)<br>*   `-p 8089:80` : port 8089 côté client/host, port 80 côté conteneur (qui écoute en HTTP)<br>*   `-v volume_name:/path/in/container`: This form specifies a named volume that has been previously created using the `docker volume create` command. The volume will be mounted at the specified path inside the container.<br>*   `-v /host/path:/path/in/container`: This form specifies a bind mount, which mounts a directory or file from the host machine at the specified path inside the container. The path on the host machine can be an absolute or relative path.<br><br>Exemples :<br><br>*   démarrer `thilaire/alps-drive-frontend`, l'effacer en sortie, map port 8089 (client) to port 80 (server docker)  <br>    `docker run --rm -p 8089:80 thilaire/alps-drive-frontend`<br>*   démarrer l'instance en “interactif” (i) sur un “terminal” (t) en lui donnant un nom :  <br>    `docker run -it --name <imagename> -p 3000:3000 alpsdrive:latest` |
| _Connect_ to an existing container | Se connecter en interactif sur un terminal :  <br>`docker exec -it <container_id_or_name> sh` |
| _Start_ a stopped container | `docker start <container_id_or_name>` |
| _Stop_ a running container | `docker stop <container_id_or_name>` |
| _Remove_ | Remove a single container :  <br>`docker rm <container_id_or_name>`  <br>Remove a single running container (force to stop) :  <br>`docker rm` `-f` `<container_id_or_name>`  <br> <br><br>Remove all exited containers :  <br>`docker ps -a -f status=exited`  <br>`docker rm $(docker ps -a -f status=exited -q)`  <br>Remove all _created_ OR _exited_ containers :  <br>`docker ps -a -f status=exited -f status=created`  <br>`docker rm $(docker ps -a -f status=exited -f status=created -q)` |
| ### Docker volumes |     |
| Mount volume when creating container | `-v OR --volume`  <br>`docker create --name toto -v “$PWD”:/var/www/mysite` |
| Create volume | `docker **volume create** my-volume`  <br>  <br>The `-v` option in `docker run` can be used in two forms to mount a volume inside a container:<br><br>1.  `-v volume_name:/path/in/container`: This form specifies a named volume that has been previously created using the `docker volume create` command. The volume will be mounted at the specified path inside the container.<br>2.  `-v /host/path:/path/in/container`: This form specifies a bind mount, which mounts a directory or file from the host machine at the specified path inside the container. The path on the host machine can be an absolute or relative path.<br><br>Both forms of the `-v` option allow you to mount a volume inside a container, but they differ in how the volume is created and managed. Named volumes are created and managed by Docker, and can be used across multiple containers. Bind mounts, on the other hand, use a directory or file from the host machine, and are specific to a single container.<br><br>In the example, `-v "$PWD":/usr/local/apache2/htdocs/`, the `$PWD` variable is used to specify the current working directory on the host machine, which is then mounted as a bind mount at the `/usr/local/apache2/htdocs/` path inside the container. This allows any files in the current working directory to be served by the Apache web server running inside the container. |
| List volumes | `docker volume ls` |
| Remove volume | `docker volume rm volume_name volume_name` |
| Dangling volumes | List :  <br>`docker volume ls -f dangling=true`  <br>Remove :   <br>`docker volume prune` |
| Remove container + volume | `docker rm` `**-v**` `container_name` |
|     |     |
|     |     |