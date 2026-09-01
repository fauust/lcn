
---

# Dockerfile for an Apache Container with Custom Home Page

1. **Create a Dockerfile:**

   Create a file named `Dockerfile` with the following content. This file will:

   - Use the official Apache base image.
   - Copy a custom home page into the Apache web server directory.
   - Configure Apache to use this home page.

   ```dockerfile
   # Use the official Apache base image
   FROM httpd:latest

   # Copy the custom home page into the Apache web server directory
   COPY ./index.html /usr/local/apache2/htdocs/

   # Expose port 80 for the web server
   EXPOSE 80
   ```

2. **Create the `index.html` File:**

   Create a file named `index.html` in the same directory as the Dockerfile with the following content:

   ```html
   <!DOCTYPE html>
   <html>
   <head>
       <title>Apache Docker Container</title>
   </head>
   <body>
       <h1>HELLO! I AM A RUNNING CONTAINER!</h1>
   </body>
   </html>
   ```

3. **Build the Docker Image:**

   Open a terminal in the directory containing the Dockerfile and the `index.html` file, and run the following command to build the Docker image:

   ```bash
   docker build -t my-apache-image-hello .
   ```

   - **-t my-apache-image-hello**: Tags the image with the name `my-apache-image-hello`.

4. **Run a Container from the Image:**

   Run the container using the image you just created:

   ```bash
   docker run -d -p 8080:80 --name my-apache-container-hello my-apache-image-hello
   ```

   - **-d**: Runs the container in the background.
   - **-p 8080:80**: Maps port 8080 on the host to port 80 on the container.
   - **--name my-apache-container-hello**: Gives the container a name for easier management.

5. **Verify the Operation:**

   - Open a browser and go to `http://localhost:8080`. You should see the home page displaying "HELLO! I AM A RUNNING CONTAINER!".

6. **Modify and Test the Container:**

   - **Connect to the container:**

     ```bash
     docker exec -it my-apache-container-hello /bin/bash
     ```

     This command connects you to the container interactively.

   - **Modify the home page:**

     Inside the container, edit the `index.html` file to change its content:

     ```bash
     echo "<h1>Page modified from the container!</h1>" > /usr/local/apache2/htdocs/index.html
     ```

   - **Verify the changes:**

     Go back to your browser and refresh the page to see the changes.

7. **Stop and Remove the Container:**

   - **Stop the container:**

     ```bash
     docker stop my-apache-container-hello
     ```

   - **Remove the container:**

     ```bash
     docker rm my-apache-container-hello
     ```

   - **Check that the page is no longer accessible:**

     Try accessing `http://localhost:8080` to confirm that the home page is no longer working.

8. **Recreate the Container:**

   - **Recreate the container with the previously built image:**

     ```bash
     docker run -d -p 8080:80 --name my-apache-container-hello my-apache-image-hello
     ```

   - **Check in the browser:**

     Go to `http://localhost:8080`. You will find that the modified home page is no longer present, and the original home page is restored.

---

## Memo: Comparison of Docker Containers vs. Virtual Machines (VMs)

### Advantages of Docker Containers

1. **Lightweight and Fast:**
   - Docker containers are lighter than VMs and start more quickly. They share the host system's kernel, reducing overhead.

2. **Resource Consumption:**
   - Containers use fewer resources because they don’t require a full operating system like VMs. This allows running more services on the same hardware.

3. **Portability:**
   - Docker containers are portable across different environments, making deployment across various systems easier.

4. **Application Isolation:**
   - Containers provide isolation between applications while allowing efficient resource sharing.

#### Disadvantages of Docker Containers

1. **Security:**
   - Containers share the host operating system's kernel, which can pose security risks if the kernel is compromised.

2. **Data Management:**
   - Data within a container can be volatile. Managing data persistence requires volumes or external storage solutions.

#### Advantages of Virtual Machines (VMs)

1. **Complete Isolation:**
   - VMs offer complete isolation of the operating system and hardware resources, which can improve security and environment management.

2. **Environment Flexibility:**
   - VMs can run different operating systems and configurations, providing great flexibility for various needs.

3. **Advanced Management:**
   - VM management tools provide advanced features for resource management, backup, and recovery.

#### Disadvantages of Virtual Machines (VMs)

1. **Resource Consumption:**
   - VMs are more resource-intensive, as each VM requires its own full operating system. This can lead to less efficient use of hardware resources.

2. **Slow Startup and Shutdown:**
   - VMs take longer to start and stop compared to containers, which can slow down development and deployment cycles.

3. **Configuration Complexity:**
   - Configuring networks and resources for multiple VMs can be more complex compared to containers.

---
