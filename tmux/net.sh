#!/bin/bash
# Network status for tmux status bar — Fedora Asahi / MacBook Air M2
WIFI=$(cat /sys/class/net/wlp1s0f0/operstate 2>/dev/null)

if [ "$WIFI" = "up" ]; then
    SSID=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes' | cut -d: -f2)
    echo "W:${SSID:-on}"
else
    echo "W:off"
fi
