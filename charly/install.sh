#!/bin/bash

# Variables
VM_NAME="regnilo-debian12"
SNAPSHOT_NAME="regnilo-debian12-snapshot"
VM_IP="192.168.122.42"
SSH_USER="regnilo"

# Restoration of the snapshot
echo "Restoring snapshot $SNAPSHOT_NAME for VM $VM_NAME..."
if virsh snapshot-revert $VM_NAME $SNAPSHOT_NAME; then
    echo "Snapshot restored successfully."

    # Execute the vm if it is not running
    VM_STATE=$(virsh domstate $VM_NAME)
    if [[ "$VM_STATE" != "running" ]]; then
        echo "Starting VM $VM_NAME..."
        virsh start $VM_NAME
    fi

    # Stay in the loop until the VM is up and SSH is available
    echo "Waiting for VM to boot up and SSH to be available..."
    while ! nc -z $VM_IP 22; do
        sleep 1
    done
    echo "VM is up and SSH is available."

    # Execution via SSH
    echo "Executing installation commands..."
    if ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $SSH_USER@$VM_IP "sudo apt-get update && sudo apt-get install -y apache2"; then
        echo "Installation completed successfully."
    else
        echo "Installation failed."
    fi
else
    echo "Failed to restore snapshot."
fi
