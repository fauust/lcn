#!/usr/bin/env bash

kubectl delete all --all
kubectl get namespaces --no-headers | awk '{print $1}' | grep -vE "$(IFS=\|; echo "${NAMESPACES_TO_KEEP[*]}")" | xargs -r -I {} kubectl delete namespace {}