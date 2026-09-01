#!/usr/bin/env bash

# shellcheck disable=SC2016

# VM
export VM_NAME="vm-deb"

# log
export USER="florent"
export USER_PWD='$6$CkK7NLwJM/SWpTIC$BIQkdyspd9JKTDkEinijkHaF0knWtzQr1WCYX9PAsNMK7jziJjPXHHmUBAGapnEaSquIRmACSfRXz8f6FH6aB.'
export IP="192.168.122.66"
export NC="nc -vz $IP 22"

# db
export DB_NAME="db_vm"
export DB_PWD="0000"