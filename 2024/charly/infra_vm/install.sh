#!/usr/bin/env bash

# Variables
VM_NAME="regnilo-debian12"
SNAPSHOT_NAME="regnilo-debian12-snapshot"
VM_IP="192.168.122.42"
SSH_USER="regnilo"

# Function to execute commands via SSH
execute_ssh() {
    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $SSH_USER@$VM_IP
}

# Restoration of the snapshot
echo "Restoring snapshot $SNAPSHOT_NAME for VM $VM_NAME..."
if virsh snapshot-revert $VM_NAME $SNAPSHOT_NAME; then
    echo "Snapshot restored successfully."

    # Start the VM if it is not running
    VM_STATE=$(virsh domstate $VM_NAME)
    if [[ "$VM_STATE" != "running" ]]; then
        echo "Starting VM $VM_NAME..."
        virsh start $VM_NAME
    fi

wait_for_ssh() {
    echo "Waiting for VM to boot up and SSH to be available..."
    while ! nc -z $VM_IP 22; do
        sleep 1
    done
    echo "VM is up and SSH is available."
}

wait_for_ssh

scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null apache.sh laravel.sh regnilo@192.168.122.42:.

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null regnilo@192.168.122.42 chmod +x /home/regnilo/apache.sh
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null regnilo@192.168.122.42 chmod +x /home/regnilo/laravel.sh

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null regnilo@192.168.122.42 sudo ./apache.sh
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null regnilo@192.168.122.42 sudo ./laravel.sh



else
    echo "Failed to restore snapshot $SNAPSHOT_NAME for VM $VM_NAME."
fi