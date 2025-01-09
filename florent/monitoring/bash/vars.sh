#!/bin/bash

# shellcheck disable=SC2155

export NAMESPACES_TO_KEEP=("default" "kube-node-lease" "kube-public" "kube-system" "kubernetes-dashboard")

export DASHBOARD_URL=http://192.168.49.2:30080

export MYSQL_POD_PREFIX=zabbix-mysql
export SERVER_POD_PREFIX=zabbix-server

export MYSQL_USER=zabbix
export MYSQL_PASSWORD=root
export MYSQL_DB=zabbix
export MYSQL_TABLE=dbversion

export RETRY_INTERVAL=1
export MAX_RETRIES=60
export ATTEMPT=0