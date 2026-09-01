# Docker and Docker Compose Setup

## Introduction

This README provides a detailed guide for installing Docker and Docker Compose on a Debian 12 system. It also includes instructions for setting up a Docker Compose file to run WordPress, phpMyAdmin, MariaDB, and Netdata services. Ensure you customize the provided `docker-compose.yml` file according to your specific requirements.

## Prerequisites

- A system running Debian 12.
- Sudo privileges.

## Installation Steps

### Step 1: Install Docker

1. **Update package information and install dependencies:**
    ```bash
    sudo apt-get update
    sudo apt-get install ca-certificates curl gnupg
    ```

2. **Add Docker's official GPG key:**
    ```bash
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    ```

3. **Add Docker repository to Apt sources:**
    ```bash
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    ```

4. **Install Docker:**
    ```bash
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    ```

5. **Check Docker service status:**
    ```bash
    sudo service docker status
    ```

### Step 2: Install Docker Compose Plugin

1. **Ensure Docker Compose Plugin is installed:**
    ```bash
    sudo apt-get install docker-compose-plugin
    ```

### Step 3: Add User to Docker Group (Optional but Recommended)

1. **Add your user to the Docker group:**
    ```bash
    sudo usermod -aG docker $USER
    ```

2. **Log out and log back in to apply the changes.**

## Docker Compose Setup

Create a `docker-compose.yml` file to define and run multi-container Docker applications. Below is a sample `docker-compose.yml` file for setting up WordPress, phpMyAdmin, MariaDB, and Netdata.

Important Customization

    WordPress Environment Variables:
        WORDPRESS_DB_USER
        WORDPRESS_DB_PASSWORD
        WORDPRESS_DB_NAME
    phpMyAdmin Environment Variables:
        PMA_USER
        PMA_PASSWORD
    MariaDB Environment Variables:
        MYSQL_ROOT_PASSWORD
        MYSQL_DATABASE
        MYSQL_USER
        MYSQL_PASSWORD
    Netdata Environment Variables:
        NETDATA_CLAIM_TOKEN
        NETDATA_CLAIM_URL
        NETDATA_CLAIM_ROOMS


#### Starting the Docker Compose Setup

Navigate to the directory containing docker-compose.yml:

`cd /path/to/your/docker-compose-file`



### Start the services:

`docker-compose up -d`

### Verify the services are running:

 `docker-compose ps`

### Stopping the Docker Compose Setup

Stop the services:

`docker-compose down`

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Copyright

© 2024 Hélène Finot. All rights reserved.
