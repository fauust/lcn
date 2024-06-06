#!/usr/bin/env bash
# shellcheck disable=SC1091
. ./function_post_install.sh
# shellcheck disable=SC2209




# Install and configure Maria-DB
print_color "green" "Installing MariaDB Server.."
apt install -y mariadb-server

print_color "green" "Starting MariaDB Server.."
service mariadb start
systemctl enable mariadb
check_service_status mariadb
