#! /usr/bin/env bash

function askName {
 echo "Enter the name of the VM: "
 read -r name
 echo "$name"
}
function dropExistingVM {
 virsh destroy $name
 virsh undefine $name
 rm -f /var/lib/libvirt/images/debian*.qcow2
 rm -f /var/lib/libvirt/images/*test*.qcow2
 rm -f /var/lib/libvirt/images/$name.qcow2
} 
function createVM {
 virt-install \
  --name=$name \
  --autoconsole none \
  --initrd-inject=first_preseed.cfg \
  --extra-args="auto=true priority=critical preseed/file=/first_preseed.cfg" \
  --os-variant=debian12 \
  --disk size=10 --vcpu=2 --ram=2048 --graphics spice \
  --location=/var/lib/libvirt/images/debian-12.5.0-amd64-netinst.iso \
  --network bridge:virbr0
}
function shutdownVM {
 virsh shutdown $name
}
function startVM {
 virsh start $name
}

# may ask for name here
#name=$(askName)
name=VMtest

# drop the existing $name
# if exists
if [ -f /var/lib/libvirt/images/VMtest.qcow2 ];
then
# if is runnig, shutdown it
 if ! virsh list --all | grep $name
 then
  shutdownVM
 fi

# uncomment the following line on production
# shutdownVM 
 dropExistingVM
fi

# create a new $name
createVM

# start the $name
startVM
# comment the following line on production
# shutdownVM 