# Run Alpsdrive backend from Docker on VPS
Installer Docker-Engine sur le VPS
----------------------------------

```text-x-sh
 sudo apt install ca-certificates curl
 sudo install -m 0755 -d /etc/apt/keyrings
 sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
 ll
 sudo chmod a+r /etc/apt/keyrings/docker.asc
 echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
 $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
 sudo apt update
 sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
 sudo docker run hello-world
```

Installer les images docker
---------------------------

Se mettre dans le groupe Docker :

```text-x-sh
 sudo groupadd docker
 groups
 sudo usermod -aG docker $USER
 newgrp docker
```

Installer l'image :

```text-x-sh
 docker pull xavcampus/alpsdrive
 docker run --name drive -p 3000:3000 xavcampus/alpsdrive:latest
 docker run -p 3000:3000 xavcampus/alpsdrive:latest
 sudo docker run -p 3000:3000 xavcampus/alpsdrive:latest
```

Installer Nginx :

```text-plain
sudo apt install nginx
```

Edit nginx config file :

```text-plain
 cd /etc/nginx/sites-available/
 sudo vim alpsdrive.conf
```

```text-x-nginx-conf
server {
        listen 80 default_server;
        listen [::]:80 default_server;
        location /api/drive {
                proxy_pass http://127.0.0.1:3000$request_uri;
        }
}
```

```text-plain
 sudo systemctl start nginx
 journalctl -xeu nginx.service
 sudo systemctl status apache2.service
 sudo systemctl stop apache2.service
 sudo systemctl start nginx

 journalctl -xeu nginx.service

 sudo service docker restart

 sudo docker run -p 3000:3000 -d xavcampus/alpsdrive:latest

 sudo systemctl reload nginx

 docker logs 6d

 less /var/log/nginx/access.log
 less /var/log/nginx/error.log
 cat /etc/resolv.conf
```