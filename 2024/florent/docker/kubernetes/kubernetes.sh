#!/usr/bin/env bash

if ! minikube status | grep -q "host: Running"; then
    echo -e "\n"
    echo "Minikube is not running"
    echo "Launching Minikube..."
    echo -e "\n"
    minikube delete --all
    minikube start
fi

get_dashboard_url() {
    local output
    output=$(minikube dashboard --url 2>/dev/null)

    echo "$output" | grep -oP 'http://[0-9.]+:[0-9]+' || echo ""
}

URL=$(get_dashboard_url)

while true; do
    if [ -n "$URL" ]; then
        echo "OKAY !"
        break
    else
        echo "Waiting..."
        sleep 1
    fi
done

# echo -e "\n"
# echo "Launching Minikube Dashboard..."
# echo -e "\n"
# minikube dashboard

# while true; do
#     if minikube dashboard; then
#         kubectl delete configmaps --all
#         kubectl delete secrets --all
#         kubectl delete pvc --all
#         kubectl delete ingress --all

#         kubectl apply -f app.yml

#         firefox --new-tab "http://$IP:30024"
#         firefox --new-tab "http://$IP:30081"
#         break
#     else
#         echo "Waiting..."
#         sleep 1
#     fi
# done