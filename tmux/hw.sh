#!/bin/bash
# Hardware status for tmux status bar — MacBook Air M2 Fedora Asahi
# Shows: display brightness, volume, keyboard backlight

# Display brightness (0-500 → percentage)
BRI=$(cat /sys/class/backlight/apple-panel-bl/actual_brightness 2>/dev/null)
MAX_BRI=$(cat /sys/class/backlight/apple-panel-bl/max_brightness 2>/dev/null)
if [ -n "$BRI" ] && [ -n "$MAX_BRI" ] && [ "$MAX_BRI" -gt 0 ]; then
    BRI_PCT=$((BRI * 100 / MAX_BRI))
    D="DISP:${BRI_PCT}%"
else
    D="DISP:?"
fi

# Volume (pipewire/wireplumber via wpctl)
VOL_INFO=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)
if [ -n "$VOL_INFO" ]; then
    VOL_RAW=$(echo "$VOL_INFO" | awk '{printf "%.0f", $2 * 100}')
    if echo "$VOL_INFO" | grep -q MUTED; then
        V="VOL:M"
    else
        V="VOL:${VOL_RAW}%"
    fi
else
    V="VOL:?"
fi

# Keyboard backlight (0-255 → percentage)
KBD=$(cat /sys/class/leds/kbd_backlight/brightness 2>/dev/null)
MAX_KBD=$(cat /sys/class/leds/kbd_backlight/max_brightness 2>/dev/null)
if [ -n "$KBD" ] && [ -n "$MAX_KBD" ] && [ "$MAX_KBD" -gt 0 ]; then
    KBD_PCT=$((KBD * 100 / MAX_KBD))
    K="KBD:${KBD_PCT}%"
else
    K=""
fi

echo "$D $V $K"
