#!/bin/bash
# This script shows ip address as genmon plugin in xfce4-panel. It lets user copy the ip with xclip.

# Identify VPN interface (looks for tun, wg, or tap)
VPN_IF=$(ip link show | awk -F': ' '/(tun|wg|tap)/ {print $2; exit}')

if [[ -n "$VPN_IF" ]]; then
    # Get VPN IP
    VPN_IP=$(ip -4 addr show "$VPN_IF" | awk '/inet / {print $2}' | cut -d/ -f1)
    TXT="🔐 $VPN_IP"
    COLOR="#4CAF50"
    COPY_IP="$VPN_IP"
else
    # Get Primary LAN/WLAN IP
    IP=$(ip -4 route get 1.1.1.1 2>/dev/null | awk '{print $7; exit}')
    
    if [[ -z "$IP" ]]; then
        TXT="⛓️‍💥 Offline"
        COLOR="#F44336" # Red for offline
        COPY_IP="127.0.0.1"
    else
        TXT="🌐 $IP"
        COLOR="#03A9F4"
        COPY_IP="$IP"
    fi
fi

# Output for the bar (Pango markup)
echo "<txt><span foreground='$COLOR'>$TXT</span></txt>"
if command -v xclip; then
	printf "<iconclick>sh -c 'printf ${COPY_IP} | xclip -selection clipboard'</iconclick>"
	printf "<txtclick>sh -c 'printf ${COPY_IP} | xclip -selection clipboard'</txtclick>"
	echo "<tool>Click to copy: $COPY_IP</tool>"
else
	printf "<tool>VPN IP (install xclip to copy to clipboard)</tool>"
fi
