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

# Loop until the port is available
while true; do
  #Use nc to check port availability
  nc -zv -w $TIMEOUT "$HOST" "$PORT" &> /dev/null

  #Checking the order return code
  if mycmd; then
    echo "Le port $PORT sur l'hôte $HOST est maintenant ouvert."
    break
  else
    echo "Le port $PORT sur l'hôte $HOST est fermé. Nouvelle tentative dans $INTERVAL secondes..."
  fi

  #Wait for the next attempt
  sleep $INTERVAL
done
exit 0
