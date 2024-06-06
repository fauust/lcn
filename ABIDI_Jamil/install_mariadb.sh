#!/usr/bin/env bash
# shellcheck disable=SC1091
. ./function_post_install.sh
# shellcheck disable=SC2209
DEFAULTPASSWD=test
MARIADB_ROOT_PWD="${1:-$DEFAULTPASSWD}"



# Install and configure Maria-DB
print_color "green" "Installing MariaDB Server.."
apt install -y mariadb-server
#OK that one sucks but we're on the clock
#TODO: making a less horrible syntax
sudo mariadb-secure-installation <<-EOF
$MARIADB_ROOT_PWD
n
n
Y
Y
Y
Y
EOF

print_color "green" "Starting MariaDB Server.."
sudo service mariadb start
sudo systemctl enable mariadb
check_service_status mariadb
