#!/bin/bash

# shellcheck disable=SC2155

is_deleting_pods_complete() {
  while true; do
    local CMD=$(kubectl get pods --all-namespaces --no-headers -o custom-columns=":metadata.namespace,:metadata.name" | grep -vE "$(IFS=\|; echo "${NAMESPACES_TO_KEEP[*]}")")
    local RES=$CMD

    if [[ -z "$RES" ]]; then
      echo "All pods have been deleted!"
      return 0
    else
      echo "The following pods are still present:"
      echo "$RES"
      sleep 5
    fi
  done
}

get_pod_name(){
  local POD_PREFIX=$1
  local CMD=$(kubectl get pods --no-headers --sort-by=.metadata.creationTimestamp -o custom-columns=":metadata.name" | grep "^$POD_PREFIX-" | tail -n 1)
  local GET_POD_NAME=$CMD
  echo "$GET_POD_NAME"
}

is_pod_running() {
  local POD_NAME=$1

  while true; do
    local CMD=$(kubectl get pod "$POD_NAME" -o jsonpath='{.status.phase}')
    local POD_STATUS=$CMD

    if [[ "$POD_STATUS" == "Running" ]]; then
      echo "The pod [ $POD_NAME ] is running!"
      return 0
    else
      echo "The pod [ $POD_NAME ] is not yet running"
      echo "Status: $POD_STATUS..."
      sleep 5
    fi
  done
}

is_dashboard_ready() {
    local POD_PREFIX=$1
    local POD_NAME=$(get_pod_name "$POD_PREFIX")

    is_pod_running "$POD_NAME"

    while true; do
      local CMD=$(kubectl exec "$POD_NAME" -- wget --server-response --quiet --output-document=/dev/null "$DASHBOARD_URL" 2>&1 | grep "HTTP/" | awk '{print $2}')
      local DASHBOARD_STATUS=$CMD

      if [[ "$DASHBOARD_STATUS" == "200" ]]; then
        echo "The Zabbix dashboard is now ready!"
        return 0
      else
        echo "Waiting for the Zabbix dashboard to be ready..."
        sleep 5
      fi
    done
}

init_zabbix_dashboard(){
  is_dashboard_ready "$SERVER_POD_PREFIX"

  echo "Zabbix dashboard launched..."

  firefox --new-window "$DASHBOARD_URL" --silent
}