#!/usr/bin/env bash
#######################################
# Print a message in a given color.
# Arguments:
#   Color. eg: green, red
#######################################
function print_color(){
  NC='\033[0m' # No Color
  case $1 in
    "green") COLOR='\033[0;32m' ;;
    "red") COLOR='\033[0;31m' ;;
    "*") COLOR='\033[0m' ;;
  esac

  echo -e "${COLOR} $2 ${NC}"
}


#######################################
# Check the status of a given service. If not active exit script
# Arguments:
#   Service Name. eg: firewalld, mariadb
#######################################
function check_service_status(){
  service_is_active=$(sudo systemctl is-active "$1")

  if [ "$service_is_active" = "active" ]
  then
    echo "$1 is active and running"
  else
    echo "$1 is not active/running"
    exit 1
  fi
}

#######################################
# Check if a given item is present in an output
# Arguments:
#   1 - Output
#   2 - Item
#######################################
function check_item(){
  if [[ $1 = *$2* ]]
  then
    print_color "green" "Item $2 is present on the web page"
  else
    print_color "red" "Item $2 is not present on the web page"
  fi
}



################################################################
