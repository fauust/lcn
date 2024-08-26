#!/usr/bin/env bash

kubectl delete all --all

kubectl apply -f zabbix/zabbix-mysql.yml
kubectl apply -f zabbix/zabbix-server.yml
kubectl apply -f zabbix/zabbix-web.yml