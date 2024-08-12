# Docker 2.6 - Swarm

## Docker swarn init

```
docker swarm init
```

## Build and deploy

```
docker stack deploy -c docker-stack.yml [name-app]
```

## Check statue of service

```
docker service ls
```

## Logs

```
docker service logs -f [name-app]
```

## Delete the stack

```
docker stack rm [name-app]
```

## Ip node

```
docker node inspect [id-nope] --format '{{ .Status.Addr }}'  
```
