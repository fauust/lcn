#!/usr/bin/env bash

# shellcheck disable=SC1091

source bash/vars.sh
source bash/functions.sh
source bash/purge.sh

is_deleting_pods_complete

kubectl apply -f zabbix/zabbix-mysql.yml
kubectl apply -f zabbix/zabbix-server.yml
kubectl apply -f zabbix/zabbix-agent.yml
kubectl apply -f zabbix/zabbix-web.yml

init_zabbix_dashboard

# kubectl apply -f vm_to_monitored/vm1.yml
# kubectl apply -f vm_to_monitored/vm2.yml
