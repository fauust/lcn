#!/usr/bin/env bash

set -o pipefail
set -o posix

typeset -r SERVER=$1
typeset RETVAL=0

if [[ -z $1 ]]; then
  echo "Usage: $0 <URL> <PORT> (if not 443)"
  exit 1
fi

if [[ -z $2 ]]; then
  typeset -r PORT=443
else
  typeset -r PORT=$2
fi

command -v openssl >/dev/null || {
  echo "openssl: command not found"
  exit 1
}

if ((PORT == 21)); then
  EXPIRE_DATE=$(echo | openssl s_client -connect "${SERVER}:${PORT}" -starttls ftp 2>/dev/null | openssl x509 -noout -enddate | grep notAfter | cut -d'=' -f2)
  typeset -r EXPIRE_DATE
else
  EXPIRE_DATE=$(echo | openssl s_client -connect "${SERVER}:${PORT}" 2>/dev/null | openssl x509 -noout -enddate | grep notAfter | cut -d'=' -f2)
  typeset -r EXPIRE_DATE
fi
EXPIRE_SECS=$(date -d "${EXPIRE_DATE}" +%s)
typeset -r EXPIRE_SECS
typeset -r EXPIRE_TIME=$((EXPIRE_SECS - $(date +%s)))

if ((EXPIRE_TIME < 0)); then
  RETVAL=0
else
  RETVAL=$((EXPIRE_TIME / 24 / 3600))
fi

echo ${RETVAL}
