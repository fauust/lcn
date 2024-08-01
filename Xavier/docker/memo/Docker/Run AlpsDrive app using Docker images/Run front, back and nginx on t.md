# Run front, back and nginx on the VPS
Avec docker compose :

```text-x-yaml
version: 3.8

services:

  nginx:
    image: nginx
    ports:
      - 80:80
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro

  alps-api:
    image: xavcampus/alpsdrive
    ports:
      - 3000

  frontend:
    image: thilaire/alps-drive-frontend
    ports:
      - 80
```

Puis :

```text-x-yaml
docker-compose up 
```

Inspecter le réseau :

```text-x-yaml
docker network ls
docker network inspect fa2a34275464
```