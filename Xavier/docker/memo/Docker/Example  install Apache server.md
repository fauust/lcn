# Example : install Apache server
Without a Dockerfile
--------------------

Run the httpd image :

*   `-d` : in the background 
*   `-it` : interactive terminal available
*   `-p 8085:80` : map host port 8085 to container port 80

```text-x-sh
docker run -dit --name my-apache-app -p 8085:80 httpd:2.4
```

Connect to the Docker image :

```text-x-sh
❯ docker ps -a
CONTAINER ID   IMAGE       COMMAND              CREATED          STATUS          PORTS                                   NAMES
ddcd6f5641c4   httpd:2.4   "httpd-foreground"   20 minutes ago   Up 20 minutes   0.0.0.0:8085->80/tcp, :::8085->80/tcp   my-apache-app

docker exec -iy my-apache-app 
```