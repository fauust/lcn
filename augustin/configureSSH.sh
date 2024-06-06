#! /bin/bash
#! /usr/bin/env bash
name=$1
password=$2
userName=$3
function ipVM {
  var1=$(virsh dumpxml "$name" | grep "mac address" | awk -F\' '{print $2}')
  ipVM=$(arp -an | grep "$var1" | awk -F'(' '{print $2}' | awk -F')' '{print $1}')
}
function addSshPubKey {
  SSHPASS="$password" sshpass -e ssh-copy-id -i ~/.ssh/id_dsa.pub "$userName"@"$ipVM"
}

# ask the dhcp for the ip of the given VM
ipVM
# add the sshkey.pub to the VM
addSshPubKey
# display the good news
echo "Now you can do 'ssh ""$userName"@"$ipVM""'"
