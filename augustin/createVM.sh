#! /usr/bin/env bash
name=$1
userName=$2

function shutdownVM {
  sleep 1
  echo "Shutting down $name..."
  ! virsh list --all | grep "$name" && virsh shutdown "$name"
  sleep 1
}
function dropExistingVM {
  virsh destroy "$name"
  virsh undefine "$name"
  # dangerous but useful if the *.qcow2 are stacking up in the memory
  # sudo rm -f /var/lib/libvirt/images/*.qcow2
  # sudo rm -f /var/lib/libvirt/images/*test*.qcow2
  [[ -f /var/lib/libvirt/images/"$name".qcow2 ]] && sudo rm -f /var/lib/libvirt/images/"$name".qcow2 # tofix : need to find a way to remove the sudo
}
function createVM {
  if [[ -f /var/lib/libvirt/images/debian-12.5.0-amd64-netinst.iso ]]; then
    virt-install \
      --name="$name" \
      --autoconsole none \
      --initrd-inject=/home/augustin/Desktop/infra_VM/scripts/"$userName"_preseed.cfg \
      --initrd-inject=/home/augustin/Desktop/infra_VM/scripts/postinst.sh \
      --initrd-inject=/home/augustin/.ssh/id_ed25519.pub \
      --extra-args="auto=true priority=critical preseed/file=/""$userName""_preseed.cfg" \
      --os-variant=debian12 \
      --disk size=10 --vcpu=4 --ram=2048 --graphics spice \
      --location=/var/lib/libvirt/images/debian-12.5.0-amd64-netinst.iso \
      --wait -1 \
      --network bridge:virbr0
  else
    printf "\nERROR : could not find the file 'debian-12.5.0-amd64-netinst.iso'\nPlease check the directory '/var/lib/libvirt/images/'\nYou may always download debian iso on 'https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.5.0-amd64-netinst.iso'"
  fi
}
function startVM {
  sleep 1
  echo "Starting $name..."
  virsh start "$name"
  sleep 1
}

# if is running, shutdown
shutdownVM

# if exists, drop
dropExistingVM

# create a new "$name"
if [ -f /home/augustin/Desktop/infra_VM/scripts/"$userName"_preseed.cfg ]; then
  createVM
else
  echo "error"
fi
# VM restarts on its own after the installation
# reboot time can be an issue