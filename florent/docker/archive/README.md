# DOCKER

### LAUNCH DOCKERFILE (archive folder)

In `/lcn/florent/docker/archive` directory:

`$ ./init.sh` or `$ bash init.sh`

### USE *DIVE*

`$ docker run -v /var/run/docker.sock:/var/run/docker.sock -it wagoodman/dive:latest <DOCKER_IMAGE>`