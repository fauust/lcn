#!/bin/bash

# Variables
VM_NAME="regnilo-debian12"
SNAPSHOT_NAME="regnilo-debian12-snapshot"
VM_IP="192.168.122.42"
SSH_USER="regnilo"

# Function to execute commands via SSH
execute_ssh() {
    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $SSH_USER@$VM_IP "$@"
}

# Restoration of the snapshot
echo "Restoring snapshot $SNAPSHOT_NAME for VM $VM_NAME..."
if virsh snapshot-revert $VM_NAME $SNAPSHOT_NAME; then
    echo "Snapshot restored successfully."

    # Execute the VM if it is not running
    VM_STATE=$(virsh domstate $VM_NAME)
    if [[ "$VM_STATE" != "running" ]]; then
        echo "Starting VM $VM_NAME..."
        virsh start $VM_NAME
    fi

    # Wait for VM to boot up and SSH to be available
    echo "Waiting for VM to boot up and SSH to be available..."
    while ! nc -z $VM_IP 22; do
        sleep 1
    done
    echo "VM is up and SSH is available."

    # Installation steps
    echo "Installing necessary dependencies..."

    # Install Apache2
    execute_ssh "sudo apt-get install -y apache2"

    # Install necessary dependencies
    execute_ssh "sudo apt-get install -y apt-transport-https lsb-release ca-certificates curl"

    # Add PHP 8.3 repository
    execute_ssh "sudo curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg"
    execute_ssh "sudo sh -c 'echo \"deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ \$(lsb_release -sc) main\" > /etc/apt/sources.list.d/php.list'"
    execute_ssh "sudo apt-get update"

    # Install PHP 8.3 and its extensions
    execute_ssh "sudo apt-get install -y php8.3 php8.3-cli php8.3-{sqlite3,bz2,curl,mbstring,intl} php8.3-fpm php8.3-curl php8.3-xml php8.3-dom php8.3-zip"

    # Enable PHP 8.3 FPM on Apache
    execute_ssh "sudo a2enconf php8.3-fpm"

    # Restart Apache service
    execute_ssh "sudo systemctl restart apache2"

    echo "Installation completed successfully."
else
    echo "Failed to restore snapshot."
fi
