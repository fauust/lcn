# DOCKER

## SWARM (via AZURE)

### in ***for_azure*** folder

- launch playbook `azureVmManager` and `azureVmWorker` for create the VMs

```bash
$ ansible-playbook azureVmManager.yml
$ ansible-playbook azureVmWorker.yml
```

- after VMs created, connect to VMs with ssh

```bash
$ ssh <username>@<azureVmManager_ip>
```

- in each VMs, install docker [https://docs.docker.com/engine/install/debian/#install-using-the-repository]

- and add user in docker group in `azureVmManager` (optional: `azureVmWorker`)

```bash
$ sudo usermod -aG docker <username>
$ logout # to take changes into account

# and reconnect !
```

- launch SWARM in `azureVmManager`

```bash
$ docker swarm init

# OUTPUT

# Swarm initialized: current node (o5hydmdkjp4hddf2w0hi09ii8) is now a manager.

# To add a worker to this swarm, run the following command:

# docker swarm join --token <token generated> <azureVmManager_ip>:2377

# To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

- copy, the following code, in `azureVmWorker`

```bash
$ docker swarm join --token <token generated> <azureVmManager_ip>:2377
```

- create wordpress volume in `azureVmWorker`

```bash
$ sudo mkdir /srv/wordpress
```

### in ***for_swarm*** folder

- create `.env` in `lib` folder (create folder if doesn't exists) and define environment variables:

```bash
# .env
NETDATA_CLAIM_TOKEN=<token_value>
NETDATA_CLAIM_URL=<url_value>
NETDATA_CLAIM_ROOMS=<rooms_value>
```

<br>

- copy `compose.yml`and `lib` folder to `azureVmManager`

```bash
$ scp for_swarm/compose.yml <username>@<azureVmManager_ip>:compose.yml
$ scp -r for_swarm/lib <username>@<azureVmManager_ip>:
```

- create wordpress docker network

```bash
$ docker network create --driver overlay <network_name>

# <network_name>: see compose.yml, section networks
```

- launch docker SWARM

```bash
$ docker stack deploy -c <yaml_file> <stack_name> # --detach=false for verbose option

# for delete stack
$ docker stack rm <stack_name>
```