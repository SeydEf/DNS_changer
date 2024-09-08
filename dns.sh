#!/bin/bash

dns_servers_name=(
    "Default"
    "Shecan"
    "Electro"
    "Begzar"
    "403"
    "Radar"
    "Google"
    "CloudFlare"
)
dns_servers=(
    ""
    "178.22.122.100 185.51.200.2"
    "78.157.42.101 78.157.42.101"
    "185.55.226.26 185.55.225.25"
    "10.202.10.202 10.202.10.102"
    "10.202.10.10 10.202.10.11"
    "8.8.8.8 8.8.4.4"
    "1.1.1.1 1.0.0.1"
)


RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[33;1m'
NC='\033[0m'

connection_name=$(nmcli -t -f NAME,TYPE,DEVICE connection show --active | grep wireless | cut -d':' -f1)
default_dns=$(nmcli -g ipv4.dns connection show "${connection_name}")

display_menu() {
    clear
    echo -e "Connection name: ${YELLOW}${connection_name}${NC}"

    if [ -z "${default_dns}" ]; then
        echo -e "${RED}DNS is not set!${NC}"
    else
        echo -e "DNS set: ${YELLOW}${default_dns}${NC}"
    fi

    echo
    echo "Select a DNS server using UP/DOWN arrows and press ENTER:"
    for i in "${!dns_servers_name[@]}"; do
        if [[ $i -eq $selected ]]; then
            echo -e "${GREEN}> ${dns_servers_name[$i]}${NC}"
        else
            echo "  ${dns_servers_name[$i]}"
        fi
    done
}

selected=0

while true; do
    display_menu

    read -rsn1 key
    if [[ $key == $'\x1b' ]]; then
        read -rsn2 key
        case $key in
            '[A') # Up arrow
                ((selected--))
                [[ $selected -lt 0 ]] && selected=$((${#dns_servers_name[@]}-1))
                ;;
            '[B') # Down arrow
                ((selected++))
                [[ $selected -ge ${#dns_servers_name[@]} ]] && selected=0
                ;;
        esac
    elif [[ $key == "" ]]; then
        break
    fi
done

IFS=':' read -ra selected_dns <<< "${dns_servers_name[$selected]}"
dns_name="${selected_dns}"
dns_ips="${dns_servers[$selected]}"

echo

if [ -z "$dns_ips" ]; then
    echo -e "You selected: ${RED}No DNS${NC}"
    nmcli connection modify "${connection_name}" ipv4.dns ""
else
    echo "You selected: $dns_name"
    echo "DNS IPs: $dns_ips"
    nmcli connection modify "${connection_name}" ipv4.dns "$dns_ips"
fi
nmcli connection down "${connection_name}" && nmcli --ask connection up "${connection_name}"
echo -e "${GREEN}Operation Was Successful."

