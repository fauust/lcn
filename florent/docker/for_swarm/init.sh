#!/usr/bin/env bash

# shellcheck source=/dev/null
source lib/vars.sh

docker compose down
docker compose up -d