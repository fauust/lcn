#!/bin/bash

COLOR='\033[0;31m'
NC='\033[0m' # No Color

print_title() {
  msg=$1
  line="${msg//?/=}"
  # shellcheck disable=SC2059
  printf "\n${COLOR}${line}\n${msg}\n${line}${NC}\n"
}


# Print choices
print_choices() {
  echo ""
  print_title "Setup VM"
  echo ""
  echo "0. Exit"
  echo "1. Create VM"
  echo ""
}

# Get user input
get_user_input() {
  print_choices
  choice=100
  until [[ "$choice" =~ ^[0-1]$ ]]; do
    read -r -p "Your choice: " choice
    if [[ -z "$choice" ]]; then
        echo "Error: choice cannot be empty"
    fi
    if ! [[ "$choice" =~ ^[0-1]$ ]]; then
        echo "Error: Invalid choice."
    fi
  done
  echo
}

# ------------
# Ansible playbooks
# ------------
install_requirements() {
  print_title "Install requirements..."
  ansible-galaxy install -r requirements.yml
}
create_vm() {
  print_title "Create VM..."
  ansible-playbook build_vm.yml
}

# Main program
# ------------

get_user_input

case $choice in
  0)
    echo "Exiting..."
    exit 0
    ;;
  1)
    create_vm
    ;;
  *)
    echo "Wrong choice"
    exit 1
    ;;
esac

