# DOCKER

### LAUNCH DOCKERFILE (archive folder)

In `/lcn/florent/docker/archive` directory:

`$ ./init.sh` or `$ bash init.sh`

### USE *DIVE*

`$ docker run -v /var/run/docker.sock:/var/run/docker.sock -it wagoodman/dive:latest <DOCKER_IMAGE>`

---

### DOCKER SWARM (via AZURE)

- launch playbook "azureVmManager" and "azureVmWorker" for create the VMs in project directory

```bash
$ ansible-playbook azureVmManager.yml
$ ansible-playbook azureVmWorker.yml
```

- after VM created, connection to VMs with ssh

- in each VM, install docker [https://docs.docker.com/engine/install/debian/#install-using-the-repository]

- launch SWARM in "azureVmManager"

```bash
$ docker swarm init

# Output

# Swarm initialized: current node (o5hydmdkjp4hddf2w0hi09ii8) is now a manager.

# To add a worker to this swarm, run the following command:

# docker swarm join --token <token generated> <azureVmManager_ip>:2377

# To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

- in "azureVmWorker"

```bash
$ docker swarm join --token <token generated> <azureVmManager_ip>:2377
```

- in AZURE
- - in VIRTUALS MACHINES section
- - - click on "azureVmManager" VM
- - - in tab "networking" > "network parameter"
- - - - click on "create a port rule" > "entry port rule"
- - - - - in "destination port ranges" > paste the port indicated in the previous command (here 2377)
- - - - - protocol > TCP