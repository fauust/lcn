#!/usr/bin/env bash

#set -x
incremental=true # If true, the script will not launch create_vm.sh, but use an existing VM snapshot

# ===========================
# General installation script
# ===========================

vm_IP=192.168.122.51
vm_user="xav"
vm_host=$vm_user@$vm_IP

ssh_opts="-o StrictHostKeyChecking=no -i ~/.ssh/id_ed25519_deb"

# Create Debian virtual machine
# ==============================

if ($incremental); then
    snapshot_name="VM_ssh_sudonopasswd"
    echo "---------------------------------------------"
    echo "Using existing VM snapshot $snapshot_name"
    echo "---------------------------------------------"
    sudo virsh snapshot-revert deb $snapshot_name
else
    echo "---------------------------------------------"
    echo "Creating VM"
    echo "---------------------------------------------"
    eval ./create_vm.sh
fi

# Wait for the VM to reboot (otherwise following scp and ssh commands will fail)
while ! nc -nz $vm_IP 22; do
    sleep 1
done

# Install software
# ================
echo "---------------------------------------------"
echo "Installing software"
echo "---------------------------------------------"
scripts=("install_apache.sh" "install_php.sh" "install_mariadb.sh")
for script in "${scripts[@]}"; do
    echo "$script ..."
    eval scp "$ssh_opts" "$script" $vm_host:  &> /dev/null
    eval ssh "$ssh_opts" $vm_host "sudo ./$script"  # &> /dev/null
done

# Note : I need to put "eval" before scp and ssh otherwise $ssh_opts is not expanded correctly (it keeps the quotes)
