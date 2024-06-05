#!/bin/bash

PASSWORD=$(echo password)
export SSHPASS="${PASSWORD}"

USER=mateo-nicoud
HOST=192.168.122.240


sshpass -e ssh "$USER@$HOST"
