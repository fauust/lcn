# Create docker image
### Create Dockerfile

```text-x-dockerfile
FROM node:alpine
COPY . /app/
WORKDIR /app/
RUN <<EOF
./create_tmp.sh 2>~/err.txt
npm install
EOF
CMD npm run dev
```

Explication :

```text-x-dockerfile
FROM node:alpine   	: utiliser l'image Node Alpine latest (distri Linux avec Node installé dessus)
COPY src /app/		: copier le dossier src dans /app sur l'image
WORKDIR /app/		: définir le dossier d'exécution
RUN <<EOF			: lancer plusieurs commandes lors du build
./create_tmp.sh 2>~/err.txt
npm install
EOF
CMD npm run dev		: lancer la commande npm run dev au démarrage de l'instance
```

### Build image

```text-x-dockerfile
docker build -t alpsdrive:latest .
# -t <image_name>:<tag> : le tag est facultatif mais fortement recommandé
# . : dossier où se trouve le Dockerfile
```

### Run instance

docker run : 

```text-x-dockerfile
docker run -it --name drive -p 3000:3000 alpsdrive:latest
```

options : 

*   `-it` : interactive terminal
*   `--name drive` : pour pouvoir s'y référer ensuite (stop)
*   `-p 3000:3000` : port 3000 côté client/host, port 3000 côté conteneur

De l'autre côté, lancer le serveur Front avec :

```text-x-dockerfile
docker run --rm -p 8089:80 thilaire/alps-drive-frontend
```

options : 

*   `--rm` : Automatically remove the container when it exits. The default is false.  
             --rm flag can work together with -d, and auto-removal will be done  on  daemon  side.  
          Note that it's incompatible with any restart policy other than none.  
     
*   `-p 8089:80` : port 8089 côté client/host, port 80 côté conteneur (qui écoute en HTTP)

Et s'y connecter sur le navigateur avec : 

[http://localhost:8089/](http://localhost:8089/)