#!/bin/bash
set -e

# Check if chronyd is running, only start if not
#if ! pgrep -x "chronyd" > /dev/null; then
#    chronyd
#else
#    echo "Chrony is already running, skipping startup"
#fi

# Start MariaDB
exec docker-entrypoint.sh "$@"
