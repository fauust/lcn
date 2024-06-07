#!/usr/bin/env bash

# Copy php files to /var/www/testapp
# ========================
set -x

vm_IP="192.168.122.51"
vm_user="xav"
vm_host=$vm_user@$vm_IP
html_root="/var/www/testapp"

ssh_opts="-o StrictHostKeyChecking=no -i ~/.ssh/id_ed25519_deb"
php_files=(hello.php hello_config.php)

for file in "${php_files[@]}"; do
  eval scp "$ssh_opts" "$file" $vm_host:  # &> /dev/null
done

eval ssh "$ssh_opts" $vm_host "sudo mv *.php $html_root"  # &> /dev/null
