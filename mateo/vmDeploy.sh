#!/bin/bash

function destroy {
  virsh destroy linuxconfig-vm
  virsh undefine linuxconfig-vm
  rm -rf /nfswheel/kvm/linuxconfig-vm.qcow2
  rm -rf /var/lib/libvirt/images/linuxconfig-vm.qcow2
}

if [ -f /var/lib/libvirt/images/linuxconfig-vm.qcow2 ]; then
  destroy
fi

virt-install --name=linuxconfig-vm \
  --vcpus=3 \
  --memory=1024 \
  --location=/home/mateo-nicoud/Documents/infraVm/debian-12.5.0-amd64-netinst.iso \
  --graphics spice \
  --disk size=5,path=/var/lib/libvirt/images/linuxconfig-vm.qcow2 \
  --os-variant=debian12 \
  --initrd-inject=preseed.cfg \
  --noautoconsole \
  --wait -1 \
  --check all=off

virsh start linuxconfig-vm