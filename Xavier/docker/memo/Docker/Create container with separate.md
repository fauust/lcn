# Create container with separate volumes
Pull image

```text-x-sh
docker pull ubuntu:22.04
```

Create volumes :

```text-x-sh
docker volume create web_mysql
docker volume create web_apache
```

Puis lancer le container :

```text-x-sh
docker run -dit --name WEB  \
		--mount  type=volume,src=web_mysql,target=/var/lib/mysql \
		--mount  type=volume,src=web_apache,target=/var/www \
		ubuntu:22.04
```

Autre syntaxe :

```text-x-sh
docker run -dit --name WEB2  \
		-v web_mysql:/var/lib/mysql \
		-v web_apache:/var/www \
		ubuntu:22.04
```

> \==> La syntaxe `--mount` est plus explicite, mais les deux syntaxes fonctionnent. `--mount` permet de spécifier le type (volume, bind, etc).