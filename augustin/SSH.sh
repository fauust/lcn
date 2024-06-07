#! /bin/bash
#! /usr/bin/env bash
password=$1
userName=$2
name=$3

function ipVM {
  sleep 1
  macVM=$(virsh dumpxml "$name" | grep "mac address" | awk -F\' '{print $2}')
  ipVM=$(arp -an | grep "$macVM" | awk -F'(' '{print $2}' | awk -F')' '{print $1}')
  echo "VM's IP = " "$ipVM"
}
function addSshPubKey {
  echo "Adding the ssh key to the VM..."
  while !  nc -z "$ipVM" 22 ; do
    echo "Trying to connect to $userName@$ipVM"
    echo "Waiting for the VM to be ready..."
    ipVM
    sleep 1
  done
  SSHPASS="$password" sshpass -e ssh-copy-id -o StrictHostKeyChecking=no -i /home/augustin/.ssh/id_dsa.pub "$userName"@"$ipVM"
}
function sendScript {
  echo "Sending the scripts to the VM..."
  SSHPASS="$password" sshpass -e scp -o StrictHostKeyChecking=no ./scripts/installApache2.sh "$userName"@"$ipVM":/tmp/
  #SSHPASS="$password" sshpass -e scp -o StrictHostKeyChecking=no ./scripts/installPhpFPM8.3.sh "$userName"@"$ipVM":/tmp/
}
function runScript {
  SSHPASS="$password" sshpass -e ssh -o StrictHostKeyChecking=no "$userName"@"$ipVM" 'chmod 755 /tmp/install*.sh'
  echo "Running the scripts on the VM..."
  SSHPASS="$password" sshpass -e ssh -o StrictHostKeyChecking=no "$userName"@"$ipVM" 'bash /tmp/installApache2.sh'
  #SSHPASS="$password" sshpass -e ssh -o StrictHostKeyChecking=no "$userName"@"$ipVM" 'bash /tmp/installPhpFPM8.3.sh'
}
ipVM
# add the sshkey.pub to the VM
addSshPubKey
sendScript
runScript