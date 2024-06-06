#!/bin/bash

USER="mateo-nicoud"
HOST="192.168.122.240"
KEY_PATH="/home/mateo-nicoud/.ssh/vb"

scp -i "$KEY_PATH" -o StrictHostKeyChecking=no password $USER@$HOST:
scp -i "$KEY_PATH" -o StrictHostKeyChecking=no mariadb.sh $USER@$HOST:
ssh -i "$KEY_PATH" -o StrictHostKeyChecking=no $USER@$HOST "sudo bash ./mariadb.sh"