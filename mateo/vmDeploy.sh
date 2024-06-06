#!/bin/bash

# détruire la VM existante
function destroy {
  echo "Destroying existing VM..."
  # Supprimer toutes les snapshots de la VM
  snapshots=$(virsh snapshot-list --name linuxconfig-vm)
  for snap in $snapshots; do
    virsh snapshot-delete --domain linuxconfig-vm "$snap"
  done
  # Détruire la VM
  virsh destroy linuxconfig-vm
  virsh undefine linuxconfig-vm --nvram
  rm -rf /var/lib/libvirt/images/linuxconfig-vm.qcow2
  echo "Existing VM destroyed and disk image removed."
}

# Vérifier si la VM existe déjà
if virsh dominfo linuxconfig-vm &> /dev/null; then
  echo "VM 'linuxconfig-vm' already exists. Destroying it..."
  destroy
else
  echo "No existing VM found. Proceeding with creation."
fi

# Créer et démarrer la nouvelle VM
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

sleep 40
