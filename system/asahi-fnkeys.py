#!/usr/bin/env python3
"""
Fn key handler for MacBook Air M2 — Fedora Asahi Remix
Grabs the Apple keyboard, handles media keys (brightness, volume, mute, kbd backlight),
and forwards all other keys through a virtual uinput keyboard.
"""

import evdev
from evdev import ecodes, UInput, InputEvent
import subprocess
import os
import time

KEYBOARD_NAME = "Apple MTP keyboard"
BL_PATH = "/sys/class/backlight/apple-panel-bl"
KBD_PATH = "/sys/class/leds/kbd_backlight"
BEEP_FILE = "/usr/local/share/tui-magic/beep.wav"
USER = "justin"

BL_STEP = 50
BL_MIN = 1
KBD_STEP = 25

MEDIA_KEYS = {
    ecodes.KEY_BRIGHTNESSDOWN,
    ecodes.KEY_BRIGHTNESSUP,
    ecodes.KEY_VOLUMEDOWN,
    ecodes.KEY_VOLUMEUP,
    ecodes.KEY_MUTE,
    ecodes.KEY_KBDILLUMDOWN,
    ecodes.KEY_KBDILLUMUP,
    ecodes.KEY_KBDILLUMTOGGLE,
}


def read_int(path):
    try:
        with open(path) as f:
            return int(f.read().strip())
    except:
        return 0


def write_int(path, val):
    try:
        with open(path, "w") as f:
            f.write(str(val))
    except:
        pass


def set_brightness(delta):
    bl_max = read_int(f"{BL_PATH}/max_brightness")
    cur = read_int(f"{BL_PATH}/brightness")
    new = max(BL_MIN, min(bl_max, cur + delta))
    write_int(f"{BL_PATH}/brightness", new)


def set_kbd_backlight(delta):
    kbd_max = read_int(f"{KBD_PATH}/max_brightness")
    cur = read_int(f"{KBD_PATH}/brightness")
    new = max(0, min(kbd_max, cur + delta))
    write_int(f"{KBD_PATH}/brightness", new)


def toggle_kbd_backlight():
    kbd_max = read_int(f"{KBD_PATH}/max_brightness")
    cur = read_int(f"{KBD_PATH}/brightness")
    write_int(f"{KBD_PATH}/brightness", 0 if cur > 0 else kbd_max // 2)


def run_as_user(cmd):
    uid = subprocess.getoutput(f"id -u {USER}")
    env = f"XDG_RUNTIME_DIR=/run/user/{uid}"
    subprocess.Popen(
        ["su", "-", USER, "-c", f"{env} {cmd}"],
        stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
    )


def unmute_if_muted():
    run_as_user("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0")


def volume_up():
    unmute_if_muted()
    run_as_user("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+")
    beep()


def volume_down():
    unmute_if_muted()
    run_as_user("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
    beep()


def mute_toggle():
    run_as_user("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
    beep()


def beep():
    if os.path.exists(BEEP_FILE):
        run_as_user(f"aplay -q '{BEEP_FILE}'")


def refresh_tmux():
    run_as_user("tmux refresh-client -S")


def handle_media_key(code):
    if code == ecodes.KEY_BRIGHTNESSDOWN:
        set_brightness(-BL_STEP)
    elif code == ecodes.KEY_BRIGHTNESSUP:
        set_brightness(BL_STEP)
    elif code == ecodes.KEY_VOLUMEDOWN:
        volume_down()
    elif code == ecodes.KEY_VOLUMEUP:
        volume_up()
    elif code == ecodes.KEY_MUTE:
        mute_toggle()
    elif code == ecodes.KEY_KBDILLUMDOWN:
        set_kbd_backlight(-KBD_STEP)
    elif code == ecodes.KEY_KBDILLUMUP:
        set_kbd_backlight(KBD_STEP)
    elif code == ecodes.KEY_KBDILLUMTOGGLE:
        toggle_kbd_backlight()
    refresh_tmux()


def find_keyboard():
    devices = [evdev.InputDevice(path) for path in evdev.list_devices()]
    for dev in devices:
        if KEYBOARD_NAME in dev.name:
            return dev
    return None


def main():
    while True:
        kbd = find_keyboard()
        if kbd is None:
            time.sleep(2)
            continue

        # Create virtual keyboard with same capabilities
        ui = UInput.from_device(kbd, name="TUI Magic Virtual Keyboard")

        try:
            kbd.grab()
            for event in kbd.read_loop():
                if event.type == ecodes.EV_KEY and event.code in MEDIA_KEYS:
                    # Only act on key press (value=1), not release or repeat
                    if event.value == 1:
                        handle_media_key(event.code)
                    # Don't forward media keys
                else:
                    # Forward everything else to virtual keyboard
                    ui.write_event(event)
                    ui.syn()
        except OSError:
            # Device disconnected
            pass
        finally:
            try:
                kbd.ungrab()
            except:
                pass
            ui.close()
            time.sleep(2)


if __name__ == "__main__":
    main()
