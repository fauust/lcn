#! /usr/bin/env bash
userName=$1
name=$2

function ipVM {
  sleep 1
  macVM=$(virsh dumpxml "$name" | grep "mac address" | awk -F\' '{print $2}')
  ipVM=$(arp -an | grep "$macVM" | awk -F'(' '{print $2}' | awk -F')' '{print $1}')
  echo "VM's IP = " "$ipVM"
}
function SSHConnectReady {
  echo "Trying to connect to $userName@$ipVM"
  while !  nc -z "$ipVM" 22 ; do
    echo "Waiting for the VM to be ready..."
    ipVM
    sleep 5
  done
  # SSHPASS="$password" sshpass -e ssh-copy-id -o StrictHostKeyChecking=no -i /home/augustin/.ssh/id_ed25519.pub "$userName"@"$ipVM"
}
function sendScript {
  echo "Sending the scripts to the VM..."
  scp -o StrictHostKeyChecking=no ./scripts/installApache2.sh "$userName"@"$ipVM":/tmp/
  scp -o StrictHostKeyChecking=no ./scripts/installPhpFPM8.3.sh "$userName"@"$ipVM":/tmp/
  scp -o StrictHostKeyChecking=no ./scripts/installMariaDB.sh "$userName"@"$ipVM":/tmp/
  scp -o StrictHostKeyChecking=no ./scripts/initVhost.sh "$userName"@"$ipVM":/tmp/
}
function runScript {
  ssh -o StrictHostKeyChecking=no "$userName"@"$ipVM" 'chmod 755 /tmp/install*.sh'
  echo "Running the scripts on the VM..."
  ssh -o StrictHostKeyChecking=no "$userName"@"$ipVM" 'bash /tmp/installApache2.sh'
  ssh -o StrictHostKeyChecking=no "$userName"@"$ipVM" 'bash /tmp/installPhpFPM8.3.sh'
  ssh -o StrictHostKeyChecking=no "$userName"@"$ipVM" 'bash /tmp/installMariaDB.sh'
  ssh -o StrictHostKeyChecking=no "$userName"@"$ipVM" 'bash /tmp/initVhost.sh'
}
function sendFiles {
  echo "Sending the files to the VM..."
  scp -o StrictHostKeyChecking=no /home/augustin/Desktop/infra_VM/scripts/sources/index.php "$userName"@"$ipVM":/var/www/TestingBasics/
}
# add the sshkey.pub to the VM
SSHConnectReady
sendScript
runScript
sendFiles
echo "You can connect by ssh to ""$userName"@"$ipVM"
