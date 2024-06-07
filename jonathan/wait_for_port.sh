#!/usr/bin/env bash


#check arguments
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <host> <port>"
  exit 1
fi

#Address ip or domain name
HOST="$1"


#Port to check
PORT="$2"

# Interval between attempt
INTERVAL=1

#Timeout for the connection (second)
TIMEOUT=4

#Check for nc command
if ! command -v nc >/dev/null; then
  echo "Install nc command"
  exit 1
fi

# Loop until the port is available
while true; do
  #Checking the order return code
  if nc -zv -w $TIMEOUT "$HOST" "$PORT" &> /dev/null; then
    echo "Le port $PORT sur l'hôte $HOST est maintenant ouvert."
    break
  else
    echo "Le port $PORT sur l'hôte $HOST est fermé. Nouvelle tentative dans $INTERVAL secondes..."
  fi

  #Wait for the next attempt
  sleep $INTERVAL
done
exit 0
