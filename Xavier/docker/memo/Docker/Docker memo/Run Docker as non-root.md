# Run Docker as non-root
If you want to run docker as non-root user then you need to add the user to the docker group.

1.  Create the docker group if it does not exist

```text-plain
$ sudo groupadd docker
```

1.  Add your user to the docker group.

```text-plain
$ sudo usermod -aG docker $USER
```

1.  Log in to the new `docker` group (to avoid having to log out / log in again; but if not enough, try to reboot):

```text-x-sh
$ newgrp docker
--OR--
$ su - ${USER}

# Check you are in the docker group :
$ groups
```

1.  Check if docker can be run without root

```text-plain
$ docker run hello-world
```

Reboot if you still get an error

```text-plain
$ reboot
```

**Warning**

> The docker group grants privileges equivalent to the root user. For details on how this impacts security in your system, see [Docker Daemon Attack Surface.](https://docs.docker.com/engine/security/#docker-daemon-attack-surface).

Taken from the docker official documentation: [manage-docker-as-a-non-root-user](https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user)