#!/bin/bash
# Fn key handler for MacBook Air M2 — Fedora Asahi Remix
# Handles: F1/F2 brightness, F10 mute, F11/F12 volume (with audio feedback)
#          F5/F6 kbd backlight
# Uses evtest to capture Apple MTP keyboard events

KEYBOARD="/dev/input/event1"
BL="/sys/class/backlight/apple-panel-bl"
KBD="/sys/class/leds/kbd_backlight"
BEEP_FILE="/usr/local/share/tui-magic/beep.wav"

# Brightness step (10% of max 500 = 50)
BL_STEP=50
BL_MAX=$(cat "$BL/max_brightness")

# Kbd backlight step (25 of max 255)
KBD_STEP=25
KBD_MAX=$(cat "$KBD/max_brightness")

set_brightness() {
    local cur=$(cat "$BL/brightness")
    local new=$((cur + $1))
    [ $new -lt 0 ] && new=0
    [ $new -gt $BL_MAX ] && new=$BL_MAX
    echo "$new" > "$BL/brightness"
}

set_kbd() {
    local cur=$(cat "$KBD/brightness")
    local new=$((cur + $1))
    [ $new -lt 0 ] && new=0
    [ $new -gt $KBD_MAX ] && new=$KBD_MAX
    echo "$new" > "$KBD/brightness"
}

# Volume feedback beep (short click)
beep() {
    if [ -f "$BEEP_FILE" ]; then
        # Play beep as the user (not root) via pipewire
        su - justin -c "XDG_RUNTIME_DIR=/run/user/$(id -u justin) aplay -q '$BEEP_FILE'" &
    fi
}

# Refresh tmux status bar after any hw change
refresh_tmux() {
    su - justin -c "tmux refresh-client -S" 2>/dev/null &
}

evtest --grab "$KEYBOARD" 2>/dev/null | while read line; do
    # Only act on key press events (value 1), not release (0) or repeat (2)
    echo "$line" | grep -q "EV_KEY.*value 1" || continue

    if echo "$line" | grep -q "KEY_BRIGHTNESSDOWN"; then
        set_brightness -$BL_STEP
        refresh_tmux
    elif echo "$line" | grep -q "KEY_BRIGHTNESSUP"; then
        set_brightness $BL_STEP
        refresh_tmux
    elif echo "$line" | grep -q "KEY_VOLUMEDOWN"; then
        su - justin -c "XDG_RUNTIME_DIR=/run/user/$(id -u justin) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        beep
        refresh_tmux
    elif echo "$line" | grep -q "KEY_VOLUMEUP"; then
        su - justin -c "XDG_RUNTIME_DIR=/run/user/$(id -u justin) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        beep
        refresh_tmux
    elif echo "$line" | grep -q "KEY_MUTE"; then
        su - justin -c "XDG_RUNTIME_DIR=/run/user/$(id -u justin) wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        beep
        refresh_tmux
    elif echo "$line" | grep -q "KEY_KBDILLUMUP"; then
        set_kbd $KBD_STEP
        refresh_tmux
    elif echo "$line" | grep -q "KEY_KBDILLUMDOWN"; then
        set_kbd -$KBD_STEP
        refresh_tmux
    elif echo "$line" | grep -q "KEY_KBDILLUMTOGGLE"; then
        cur=$(cat "$KBD/brightness")
        if [ "$cur" -gt 0 ]; then
            echo 0 > "$KBD/brightness"
        else
            echo $((KBD_MAX / 2)) > "$KBD/brightness"
        fi
        refresh_tmux
    fi
done
