#!/bin/bash

verificare_ip() {
    local host="$1"
    local ip="$2"
    local dns_server="$3"

    local resolved_ip
    resolved_ip=$(nslookup "$host" "$dns_server" 2>/dev/null | awk '/^Address: / { print $2 }' | tail -n1)

    if [[ -n "$resolved_ip" && "$resolved_ip" != "$ip" ]]; then
        echo "Bogus IP for $host in /etc/hosts! (Local: $ip, DNS [$dns_server]: $resolved_ip)"
    fi
}

DNS_SERVER="${1:-8.8.8.8}"

while read -r ip name rest; do
    [[ -z "$ip" || "$ip" == \#* ]] && continue
    [[ "$ip" == *:* ]] && continue

    verificare_ip "$name" "$ip" "$DNS_SERVER"
done < /etc/hosts
