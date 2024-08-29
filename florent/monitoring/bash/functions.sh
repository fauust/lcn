#!/bin/bash

# shellcheck disable=SC2155

get_pod_name(){
  local POD_PREFIX=$1
  local CMD=$(kubectl get pods --no-headers --sort-by=.metadata.creationTimestamp -o custom-columns=":metadata.name" | grep "^$POD_PREFIX-" | tail -n 1)
  local GET_POD_NAME=$CMD
  echo "$GET_POD_NAME"
}

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

is_sql_table_complete() {
  local POD_NAME=$1

  while true; do
    RES=$(kubectl exec "$POD_NAME" -- mysql -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" -D "$MYSQL_DB" -e "SHOW TABLES LIKE '$MYSQL_TABLE';" 2>/dev/null)

    if [[ "$RES" == *"$MYSQL_TABLE"* ]]; then
      echo "The [ $MYSQL_TABLE ] table is configured!"
      return 0
    else
      echo "The [ $MYSQL_TABLE ] table was not found..."
      sleep 5
    fi
  done
}

is_database_ready() {
    local POD_PREFIX=$1
    local POD_NAME=$(get_pod_name "$POD_PREFIX")

    is_sql_table_complete "$POD_NAME"

    ### WARNING
    # Database error
    # Unable to select configuration.
}

init_zabbix_dashboard(){
  is_database_ready "$MYSQL_POD_PREFIX"
  echo "Zabbix dashboard launched..."
  firefox --new-tab "$DASHBOARD_URL" --silent
}
