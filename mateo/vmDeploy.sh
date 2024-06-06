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
  --location="http://ftp.fr.debian.org/debian/dists/Debian12.5/main/installer-amd64/" \
  --graphics spice \
  --disk size=5,path=/var/lib/libvirt/images/linuxconfig-vm.qcow2 \
  --os-variant=debian12 \
  --initrd-inject=preseed.cfg \
  --initrd-inject=postinst.sh \
  --noautoconsole \
  --wait -1

virsh start linuxconfig-vm