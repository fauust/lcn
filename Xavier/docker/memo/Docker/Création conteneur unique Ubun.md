# Création conteneur unique Ubuntu+Apache+MySql+Wordpress+PHPMyAdmin
Installer ubuntu server 22.04 nommé WEB :

```text-x-sh
docker pull ubuntu:22.04
docker volume create web_volume
docker run -dit --name WEB -v web_volume ubuntu:22.04
```

S'y connecter :

```text-plain
docker exec -it WEB bash
```

Installer Apache :

```text-plain
apt update
apt install systemctl
apt install apache2

systemctl enable apache2
```

Vérifier : [http://172.17.0.2](http://172.17.0.2) 

Installer MySQL :

```text-plain
apt install mysql-server
```

Installer PHPMyAdmin :

```text-plain
apt install phpmyadmin

==> Là c'est pénible car il demande plusieurs trucs
```