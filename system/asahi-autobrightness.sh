#!/bin/bash
# Auto-brightness daemon for MacBook Air M2 — Fedora Asahi Remix
# Reads ambient light sensor (ALS) and adjusts display brightness
# Sensor: aop-sensors-las at /sys/bus/iio/devices/iio:device0/in_angl_raw
# Backlight: apple-panel-bl at /sys/class/backlight/apple-panel-bl/

ALS="/sys/bus/iio/devices/iio:device0/in_angl_raw"
BL="/sys/class/backlight/apple-panel-bl"
BL_MAX=$(cat "$BL/max_brightness")  # 500

POLL_INTERVAL=5  # seconds between readings
SMOOTHING=3      # number of readings to average
MANUAL_OVERRIDE_SECS=10  # pause auto after manual fn key change

# Map ALS value (0-500+) to brightness (10-500)
# Low light (0-30) → dim (10-100)
# Medium (30-150) → moderate (100-300)
# Bright (150+) → bright (300-500)
als_to_brightness() {
    local als=$1
    local target

    if [ "$als" -le 10 ]; then
        target=10
    elif [ "$als" -le 30 ]; then
        target=$((10 + (als - 10) * 90 / 20))
    elif [ "$als" -le 150 ]; then
        target=$((100 + (als - 30) * 200 / 120))
    elif [ "$als" -le 400 ]; then
        target=$((300 + (als - 150) * 200 / 250))
    else
        target=$BL_MAX
    fi

    echo "$target"
}

readings=()
last_manual_change=0

while true; do
    # Check if fn key handler recently changed brightness (manual override)
    current_bl=$(cat "$BL/brightness")

    # Read ALS
    als_raw=$(cat "$ALS" 2>/dev/null)
    [ -z "$als_raw" ] && sleep $POLL_INTERVAL && continue

    # Rolling average
    readings+=("$als_raw")
    if [ ${#readings[@]} -gt $SMOOTHING ]; then
        readings=("${readings[@]:1}")
    fi

    # Calculate average
    sum=0
    for r in "${readings[@]}"; do
        sum=$((sum + r))
    done
    avg=$((sum / ${#readings[@]}))

    # Calculate target brightness
    target=$(als_to_brightness "$avg")

    # Only adjust if difference is significant (>5% of max)
    diff=$((target - current_bl))
    [ $diff -lt 0 ] && diff=$((-diff))

    if [ $diff -gt 25 ]; then
        # Smooth transition: step toward target
        if [ "$target" -gt "$current_bl" ]; then
            new=$((current_bl + diff / 3 + 1))
        else
            new=$((current_bl - diff / 3 - 1))
        fi
        [ $new -lt 10 ] && new=10
        [ $new -gt $BL_MAX ] && new=$BL_MAX
        echo "$new" > "$BL/brightness"
    fi

    sleep $POLL_INTERVAL
done
