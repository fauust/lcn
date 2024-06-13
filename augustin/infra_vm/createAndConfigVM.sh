#! /usr/bin/env bash

sudo chmod 755 ./scripts/*.sh

function askName {
  echo "Enter the name of the VM: "
  read -r name
  echo "$name"
}
function askUserName {
  echo "Enter the userName you want : "
  read -r userName
  echo "$userName"
}
function askPassword {
  echo "Enter the password for the user $1 : "
  read -r password
  echo "$password"
}
function readFile {
  while IFS=':' read -r key value; do
    if [ "$key" == "name" ]; then
      name="$value"
    elif [ "$key" == "password" ]; then
      password="$value"
    elif [ "$key" == "userName" ]; then
      userName="$value"
    else
      echo "Invalid Line"
    fi
  done </home/augustin/Desktop/infra_VM/.venv/secret.txt
}
# may ask for input here
# for now i read theme from a static file
readFile &&
bash "$(pwd)"/scripts/sed_preseed.sh "$name" "$password" "$userName" &&
bash "$(pwd)"/scripts/createVM.sh "$name" "$userName" &&
bash "$(pwd)"/scripts/SSH.sh  "$userName" "$name"