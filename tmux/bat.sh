#!/bin/sh
# Battery status for tmux — MacBook Air M2 (macsmc-battery)
BAT_PATH="/sys/class/power_supply/macsmc-battery"
if [ -d "$BAT_PATH" ]; then
    status=$(cat "$BAT_PATH/status")
    cap=$(cat "$BAT_PATH/capacity")
    case "$status" in
        Charging)    icon="+" ;;
        Discharging) icon="-" ;;
        Full)        icon="=" ;;
        *)           icon="=" ;;
    esac
    # Estimate time remaining (kernel provides time_to_empty/full in seconds)
    TIME=""
    if [ "$status" = "Discharging" ]; then
        tte=$(cat "$BAT_PATH/time_to_empty_now" 2>/dev/null)
        if [ -n "$tte" ] && [ "$tte" -gt 0 ]; then
            h=$((tte / 3600))
            m=$(( (tte % 3600) / 60 ))
            TIME="${h}h$(printf '%02d' $m)"
        fi
    elif [ "$status" = "Charging" ]; then
        ttf=$(cat "$BAT_PATH/time_to_full_now" 2>/dev/null)
        if [ -n "$ttf" ] && [ "$ttf" -gt 0 ]; then
            h=$((ttf / 3600))
            m=$(( (ttf % 3600) / 60 ))
            TIME="${h}h$(printf '%02d' $m)"
        fi
    fi
    if [ -n "$TIME" ]; then
        echo "BAT:${icon}${cap}%(${TIME})"
    else
        echo "BAT:${icon}${cap}%"
    fi
else
    echo "AC"
fi
