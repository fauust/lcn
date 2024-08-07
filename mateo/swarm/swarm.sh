#!/bin/bash

echo "Enter your username : "
read -r username
echo "Enter sudo password : "
read -rs sudo_password
read -rp "Enter the base name for the VMs: " vmName
read -rp "Enter the number of VMs to deploy: " vmCount

current_dir=$(pwd)
firstVmNumber=1
for ((i=firstVmNumber; i<=vmCount; i++)); do
  currentVmName="${vmName}-${i}"
  # Exécuter setup.yml
  ansible-playbook --extra-vars "ansible_become_password=${sudo_password} vm_name=${currentVmName} ansible_user=${username} user_vm_swarm=${username} current_dir=${current_dir}" ansible/setup.yml

  # Créer les machines virtuelles
  ansible-playbook --extra-vars "ansible_become_password=${sudo_password} vm_name=${currentVmName} ansible_user=${username} user_vm_swarm=${username} current_dir=${current_dir}" ansible/infra_swarm.yml

  # Installer les middleware
  ansible-playbook --extra-vars "ansible_become_password=${sudo_password} vm_name=${currentVmName} ansible_user=${username} user_vm_swarm=${username} current_dir=${current_dir}" ansible/plateform_swarm.yml

  # Déployer les applications
  ansible-playbook --extra-vars "ansible_become_password=${sudo_password} vm_name=${currentVmName} ansible_user=${username} user_vm_swarm=${username} current_dir=${current_dir} number=${i} number_max=${vmCount} node_manager_vm=${vmName}-${firstVmNumber}" ansible/software_swarm.yml

done
