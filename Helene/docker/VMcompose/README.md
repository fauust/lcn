# Using Docker Compose in a Virtual Machine

## Introduction

This README provides a step-by-step guide for setting up and using Docker Compose within a virtual machine (VM). It includes instructions for creating a directory for your project, preparing the `docker-compose.yml` file, launching Docker Compose, and accessing the services.

## Prerequisites

- A virtual machine (VM) created using an Ansible Playbook.
- Docker and Docker Compose installed on the VM.
- Sudo privileges.

## Steps

### Step 1: Update Packages

Before proceeding, ensure your packages are up to date:
`sudo apt-get update`
`sudo apt-get upgrade`


### Step 2: Install Docker and Docker Compose

If Docker and Docker Compose are not already installed, install them using the following commands:

```
sudo apt-get install docker.io
sudo apt-get install docker-compose
```


### Step 3: Prepare the docker-compose.yml File

Create a directory for your project:

```
mkdir ~/docker-project
cd ~/docker-project
```


Create or transfer your docker-compose.yml file:


```
nano docker-compose.yml
```


### Step 4: Launch Docker Compose

Start the Docker Compose services:

```
docker compose up -d
```
The -d flag allows you to run the containers in the background (detached mode).


Verify that the containers are running:

```
docker ps
```


### Step 5: Access the Services

Access the services hosted on your VM:

    WordPress: Open a web browser on your local machine and visit http://localhost:9000.
    phpMyAdmin: Visit http://localhost:8081.
    Netdata: Visit http://localhost:19999.

Note on Local and External Access

With the current port configuration (127.0.0.1), access is limited to the local host only. If you wish to access these services from other machines on the local network, you need to modify the ports to listen on all network interfaces (0.0.0.0 or simply omit 127.0.0.1:):

```
services:
  wordpress:
    ports:
      - "9000:80"
  phpmyadmin:
    ports:
      - "8081:80"
```
After modifying the docker-compose.yml file, restart the containers to apply the changes:

```
docker compose down
docker compose up -d
```


Now, you can access the services via:

    http://<IP-VM>:9000
    http://<IP-VM>:8081
    http://<IP-VM>:19999

### Step 6: Manage the Containers

Stop the containers:



docker compose down

Check the logs of the containers:

```
docker compose logs
```

Restart the containers:

```
docker compose restart
```
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Copyright

© 2024 Hélène Finot. All rights reserved.
