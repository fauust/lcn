#!/usr/bin/env bash

USER=jon
IP=192.168.122.42

#installation vm
bash -x ./create-vm.sh

#wait for vm install
./wait_for_port.sh "$IP" 22


#installation apache
scp -o "StrictHostKeyChecking no" /home/jon/Workspace/autommates/create_vm/lcn_infra_vm/jonathan/install_apache.sh "$USER"@"$IP":/home/jon/
ssh -o "StrictHostKeyChecking no" "$USER"@"$IP" 'bash /home/jon/install_apache.sh'

#installation laravel
scp -o "StrictHostKeyChecking no" /home/jon/Workspace/autommates/create_vm/lcn_infra_vm/jonathan/install_laravel.sh "$USER"@"$IP":/home/jon/
scp -o "StrictHostKeyChecking no" /home/jon/Workspace/autommates/create_vm/lcn_infra_vm/jonathan/vm_app.local.conf "$USER"@"$IP":/home/jon/
ssh -o "StrictHostKeyChecking no" "$USER"@"$IP" 'bash /home/jon/install_laravel.sh'

#installation mariadb
scp -o "StrictHostKeyChecking no" /home/jon/Workspace/autommates/create_vm/lcn_infra_vm/jonathan/install_mariadb.sh "$USER"@"$IP":/home/jon/
scp -o "StrictHostKeyChecking no" /home/jon/Workspace/autommates/create_vm/lcn_infra_vm/jonathan/mariadb_user.sql "$USER"@"$IP":/home/jon/
scp -o "StrictHostKeyChecking no" /home/jon/Workspace/autommates/create_vm/lcn_infra_vm/jonathan/.env "$USER"@"$IP":/home/jon/
ssh -o "StrictHostKeyChecking no" "$USER"@"$IP" 'bash /home/jon/install_mariadb.sh'
