#!/bin/bash
ipRange=$1

is_up() {
    local ip=$1
    local port=$2
    local result
    result=$(nmap -p "$port" "$ip" | grep -oP "$port/tcp\s+open")
    if [[ $result ]]; then
        return 0
    else
        return 1
    fi
}

get_service_name() {
    local ip=$1
    local port=$2
    local service_name
    service_name=$(nmap -p "$port" "$ip" | grep -oP "open\s+\K\S+")
    echo "$service_name"
}

rm -f addresses.txt
nmap -sn "$ipRange" -oG - | grep 'Up' | awk '{print $2}' > addresses.txt

rm -f addresses_with_ports.txt
rm -f addresses_ports_service.txt

while IFS= read -r ip; do
        while IFS= read -r port ; do
            if is_up "$ip" "$port"; then
                echo "${ip}:${port}" >> addresses_with_ports.txt
                echo "${ip}:${port} -- $(get_service_name "$ip" "$port")" >> addresses_ports_service.txt
            else
                echo "${ip}: port ${port} is not responding"
            fi
        done < port.txt
done < addresses.txt

# while IFS= read -r ip; do
#     google-chrome "$ip"
# done < addresses_with_ports.txt