#!/usr/bin/env bash
# shellcheck disable=SC1091
. ./function_post_install.sh

#install useful stuff
apt install -y vim git curl
#install apache
# Install web server packages
print_color "green" "Installing Web Server Packages .."
apt install -y apache2
systemctl start apache2
systemctl enable apache2

#check apache is working ?
check_service_status apache2
# check siteweb working
web_page=$(curl http://localhost)
item="apache"
check_item "$web_page" "$item"