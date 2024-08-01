#!/usr/bin/env bash

#####
handle_error() {
  read -r -n 1 -s
}

trap 'handle_error' ERR EXIT
#####



# -t: allows you to name your Docker image
# .: the directory where the Dockerfile is located
docker build -t sebflo_container .

# -d (detached mode): tells Docker to run the container in the background (detached)
# -p (port mapping): maps a host machine port to a container port
docker run --name=sebflo -d -p 666:80 sebflo_container 



#####
trap - ERR EXIT
#####