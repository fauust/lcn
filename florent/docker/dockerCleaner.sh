#!/usr/bin/env bash
# shellcheck disable=SC2046

# Cleaning docker container and images except hadolint
HADOLINT=$(docker images hadolint/hadolint -q)
docker stop $(docker ps -aq) && docker rm $(docker ps -aq) && EXCEPT=$HADOLINT
docker images -q | grep -v "$EXCEPT" | xargs -r docker rmi
docker compose up