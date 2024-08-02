# Mémo Docker itération 1

## 1.1 install docker

```bash
sudo apt update

sudo apt install apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update

# To verify that docker will be installed from docker repo
apt-cache policy docker-ce

sudo apt install docker-ce
```

### executing command without sudo

```bash
sudo usermod -aG docker ${USER}

su - ${USER}
```

## 1.2 container simple & datas

```bash
# install apache container and launch it
docker run -d --name apache httpd:latest

# connect to the container & modify homepage
docker exec -it apache bash
```

ensuite dans le docker :
```bash
cd /usr/local/apache2/htdocs
vim index.html
# modify file

# useless here but writen to remember
apachectl restart

# stop the container
docker stop apache

# remove the container
docker rm apache
```

### docker/vm avantages et inconvénients

le docker est plus léger et plus rapide à réaliser que la vm mais il repose sur l'architecture de l'hote et ne permet pas toutes les configurations. il permet la persistence des données grâce aux volumes.

## 1.3 Conteneur debian/ubuntu apache et persistance du service et datas

```bash
docker run -d -v .:/var/www --name apache httpd:latest
```

## 1.4 Manipulations dans un seul container

```bash
docker run -d -v .:/var/www --name WEB

# connect to the container
docker exec -it WEB
```