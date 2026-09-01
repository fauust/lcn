
---

# Dockerfile for an Apache Container on Ubuntu with Persistent Data

```dockerfile
# Use the official Ubuntu base image
FROM ubuntu:latest

# Install Apache and clean up temporary files
RUN apt-get update \
    && apt-get install -y apache2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy a default homepage into the Apache web server directory
COPY ./index.html /var/www/html/index.html

# Expose port 80 for the web server
EXPOSE 80

# Set the entrypoint to start Apache in the foreground
ENTRYPOINT ["apachectl", "-D", "FOREGROUND"]
```

## Explanation of Dockerfile Instructions

1. **`FROM ubuntu:latest`** :
   - Uses the latest stable version of Ubuntu as the base for the Docker image.
   (In practice, I would use version 24.04 to avoid issues with updates to `ubuntu:latest`.)

2. **`RUN apt-get update && apt-get install -y apache2 && apt-get clean && rm -rf /var/lib/apt/lists/*`** :
   - Updates the package lists.
   - Installs Apache2.
   - Cleans up temporary files to reduce the Docker image size.

3. **`COPY ./index.html /var/www/html/index.html`** :
   - Copies the `index.html` file from the local directory into the Apache web server directory. Make sure this file exists in the same directory as your Dockerfile.

4. **`EXPOSE 80`** :
   - Exposes port 80 to allow access to the web server through this port.

5. **`ENTRYPOINT ["apachectl", "-D", "FOREGROUND"]`** :
   - Defines the command to run when the container starts. Here, it starts Apache in the foreground so that the Apache process stays active.

### Build and Run the Container

1. **Build the Docker Image:**

   Make sure your `index.html` is present in the same directory as your Dockerfile. Then, run the following command to build the Docker image:

   ```bash
   docker build -t my-ubuntu-apache-image-persistence .
   ```

   This command creates a Docker image named `my-ubuntu-apache-image-persistence`.

2. **Run the Container with a Persistent Volume:**

   Create a Docker volume to persist the data and run the container with this volume:

   ```bash
   docker volume create apache_data_persistence
   docker run -d --name my-apache-container-persistence -p 8080:80 -v apache_data_persistence:/var/www/html my-ubuntu-apache-image-persistence
   ```

   - **-d** : Runs the container in the background.
   - **--name my-apache-container-persistence** : Names the container.
   - **-p 8080:80** : Maps port 8080 on the host to port 80 in the container.
   - **-v apache_data_persistence:/var/www/html** : Mounts the `apache_data_persistence` volume to the `/var/www/html` directory in the container.

---
