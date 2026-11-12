#!/bin/bash

cat /etc/hosts | while read ip name rest; do
    [[ -z "$ip" || "$ip" == \#* ]] && continue
    [[ "$ip" == *:* ]] && continue

    resolved_ip=$(nslookup "$name" 2>/dev/null | awk '/^Address: / { print $2 }' | tail -n1)
    if [[ -n "$resolved_ip" && "$resolved_ip" != "$ip" ]]; then
        echo "Bogus IP for $name in /etc/hosts! (Local: $ip, DNS: $resolved_ip)"
    fi
done
