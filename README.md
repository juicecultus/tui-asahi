# 🟢 TUI Magic — Asahi

**A beautiful, lightweight TUI (Text User Interface) environment for Apple Silicon Macs running Linux.**

Built for an Apple MacBook Air 15" M2 2023 (8-core Apple M2, 16GB RAM, 234GB NVMe) running Fedora Asahi Remix 42 — a full matrix-green terminal workflow with zero GUI overhead.

![Matrix Green Theme](https://img.shields.io/badge/theme-matrix%20green-00ff41?style=flat-square&labelColor=0a0a0a)
![Fedora Asahi 42](https://img.shields.io/badge/fedora%20asahi-42-51A2DA?style=flat-square&logo=fedora)
![Apple M2](https://img.shields.io/badge/apple%20silicon-M2-999999?style=flat-square&logo=apple)
![RAM Usage](https://img.shields.io/badge/idle%20RAM-~400MB-00ff41?style=flat-square&labelColor=0a0a0a)

```
    _    _        __  __ ____  
   / \  (_)_ __  |  \/  |___ \ 
  / _ \ | | '__| | |\/| | __) |
 / ___ \| | |    | |  | |/ __/ 
/_/   \_\_|_|    |_|  |_|_____|
```

---

## What You Get

A complete terminal-only desktop replacement with **50+ TUI tools**, all themed in a cohesive **matrix-green-on-black** aesthetic. Everything runs inside **tmux** with quick-launch keybindings — no mouse, no GUI, no wasted resources.

### Tools by Category

| Category | Tools | Description |
|----------|-------|-------------|
| **Tiling/Session** | `tmux` | Terminal multiplexer — your "window manager" |
| **System Monitor** | `btop` `htop` `fastfetch` | CPU, RAM, disk, network, temps |
| **File Manager** | `ranger` `nnn` | Visual file browsing with previews |
| **Git** | `tig` | Full git TUI — log, diff, blame, staging |
| **Network** | `iftop` `nethogs` `mtr` `speedtest-cli` `nmtui` | Traffic, bandwidth, WiFi config |
| **Audio Visualizer** | `cava` | Real-time audio spectrum with green gradient |
| **Music Player** | `cmus` `mpv` | Terminal music players |
| **Text Editor** | `micro` | Beginner-friendly terminal editor |
| **Web Browser** | `w3m` | Terminal web browsing |
| **IRC/Chat** | `irssi` | IRC client |
| **RSS Reader** | `newsboat` | RSS/Atom feed reader (pre-configured feeds) |
| **Calendar/Tasks** | `calcurse` | Scheduling and task management |
| **Search** | `fzf` `ripgrep` `fd-find` `bat` | Fuzzy find, fast grep, better cat |
| **Disk Usage** | `gdu` `duf` `ncdu` | Visual disk analysis |
| **Archives** | `atool` `p7zip` `zip` `unzip` | Universal archive handling |
| **Media** | `mpv` `chafa` | Video player, terminal image viewer |
| **Utilities** | `jq` `colordiff` `bc` | JSON, diffs, calculator |
| **Eye Candy** | `cmatrix` `tty-clock` `cbonsai` `figlet` | Matrix rain, clocks, ASCII art |

---

## Hardware Status Bar

The tmux status bar shows real-time hardware info specific to the MacBook Air M2:

```
┃ main ┃ asahi-air ┃  1:bash  2:files  ┃ DISP:29% VOL:49% KBD:0% │ W:heero │ CPU:4% │ RAM:573M(4%) │ BAT:=97% ┃ 14:30 ┃
```

| Indicator | Source | Description |
|-----------|--------|-------------|
| `DISP:29%` | `apple-panel-bl` | Liquid Retina display brightness (0–500) |
| `VOL:49%` | `wpctl` (pipewire) | System volume via wireplumber |
| `KBD:0%` | `kbd_backlight` | Keyboard backlight (0–255) |
| `W:heero` | `nmcli` / `wlp1s0f0` | WiFi SSID |
| `CPU:4%` | `/proc/stat` | CPU usage percentage |
| `RAM:573M(4%)` | `free` | Memory usage |
| `BAT:=97%` | `macsmc-battery` | Battery % with status (+charging, -discharging, =full) |

All values use **existing kernel drivers** — no custom modules needed. Asahi Linux's `macsmc` driver provides full battery, thermal, and power management.

---

## Login Banner (MOTD)

```
    _    _        __  __ ____  
   / \  (_)_ __  |  \/  |___ \ 
  / _ \ | | '__| | |\/| | __) |
 / ___ \| | |    | |  | |/ __/ 
/_/   \_\_|_|    |_|  |_|_____|

System

  Uptime     2 hours, 15 minutes
  Load       0.12
  Temp       27°C
  Memory     400M / 15620M
  Disk /     11G/111G
  Battery    =91% (1 cycles)
  IP         192.168.7.38

Quick Launch  (Ctrl-a, then key)

  m matrix    b btop      n ranger    t tig       D dashboard
  v cava      M cmus      c calcurse  R rss       W web
  T clock     B bonsai    g disk      w wifi

  Ctrl-a then H  full cheatsheet
```

---

## Installation

### Prerequisites

- MacBook Air M2 (or any Apple Silicon Mac)
- Fedora Asahi Remix 42 minimal install
- SSH access or local terminal
- `sudo` privileges

### Quick Install

```bash
git clone https://github.com/juicecultus/tui-asahi.git
cd tui-asahi
chmod +x install.sh
./install.sh
```

Log out and back in. tmux starts automatically.

### What the Installer Does

1. **System update** via `dnf upgrade`
2. **Installs 50+ TUI packages** (tmux, btop, ranger, tig, cava, fzf, bat, etc.)
3. **Enables pipewire audio** (wireplumber + pipewire-pulse)
4. **Deploys all config files** (.bashrc, .tmux.conf, status scripts, app configs)
5. **Sets up keyboard backlight** permissions via udev rule

---

## Tmux Keybindings

The prefix key is **`Ctrl-a`** (press Ctrl+a, release, then press the shortcut key).

### Window Management

| Key | Action |
|-----|--------|
| `Ctrl-a \|` | Split pane horizontally |
| `Ctrl-a -` | Split pane vertically |
| `Ctrl-a h/j/k/l` | Navigate panes (vim-style) |
| `Ctrl-a H/J/K/L` | Resize panes |
| `Ctrl-a c` | New window |
| `Ctrl-a 1-9` | Switch to window N |
| `Ctrl-a x` | Close current pane |
| `Ctrl-a d` | Detach (session keeps running) |
| `Ctrl-a r` | Reload tmux config |

### Quick Launch Apps

| Key | App | Description |
|-----|-----|-------------|
| `Ctrl-a m` | `cmatrix` | Matrix digital rain |
| `Ctrl-a T` | `tty-clock` | Terminal clock |
| `Ctrl-a B` | `cbonsai` | Animated bonsai tree |
| `Ctrl-a D` | Dashboard | Split layout: fastfetch + btop |
| `Ctrl-a b` | `btop` | System monitor (matrix themed) |
| `Ctrl-a g` | `gdu` | Disk usage analyzer |
| `Ctrl-a n` | `ranger` | File manager |
| `Ctrl-a N` | `nnn` | Lightweight file manager |
| `Ctrl-a t` | `tig` | Git TUI |
| `Ctrl-a i` | `iftop` | Network traffic monitor |
| `Ctrl-a w` | `nmtui` | WiFi network manager |
| `Ctrl-a v` | `cava` | Audio spectrum visualizer |
| `Ctrl-a M` | `cmus` | Music player |
| `Ctrl-a c` | `calcurse` | Calendar & scheduling |
| `Ctrl-a R` | `newsboat` | RSS feed reader |
| `Ctrl-a W` | `w3m` | Web browser (DuckDuckGo) |
| `Ctrl-a H` | Cheatsheet | Full keybinding reference |

---

## Shell Aliases

### Core

| Alias | Command | Description |
|-------|---------|-------------|
| `ll` | `ls -lah` | Long listing |
| `la` | `ls -A` | Show hidden files |
| `cat` | `bat` | Syntax-highlighted cat |
| `find` | `fd` | Fast file finder |
| `rg` | `ripgrep` | Fast grep |
| `diff` | `colordiff` | Colorized diffs |
| `df` | `duf` | Beautiful disk free |
| `du` | `gdu` | Interactive disk usage |

### System

| Alias | Description |
|-------|-------------|
| `mon` / `top` | btop system monitor |
| `nf` | fastfetch system info |
| `temps` | All thermal sensor readings |
| `psmem` | Top processes by RAM |
| `pscpu` | Top processes by CPU |

### Hardware Controls

| Alias | Description |
|-------|-------------|
| `bri+` / `bri-` | Display brightness ±10% |
| `kbd+` / `kbd-` | Keyboard backlight ±25/255 |
| `vol+` / `vol-` | Volume ±5% (pipewire) |
| `mute` | Toggle mute (pipewire) |

### Git

| Alias | Description |
|-------|-------------|
| `g` | git |
| `gs` | git status (short) |
| `gl` | git log (oneline, last 20) |
| `gd` | git diff |
| `ga` / `gc` / `gp` | add / commit / push |
| `gt` | tig (git TUI) |

---

## Dashboard Mode

Press `Ctrl-a D` for a 2-pane dashboard optimized for the Liquid Retina display:

```
┌─────────────────────────┬─────────────────────────────┐
│                         │                             │
│      fastfetch          │          btop               │
│    (system info)        │      (live monitor)         │
│                         │                             │
│         then            │                             │
│                         │                             │
│      cmatrix            │                             │
│    (eye candy)          │                             │
│                         │                             │
└─────────────────────────┴─────────────────────────────┘
```

---

## Matrix Screensaver

Automatic idle lock using `cmatrix`:

| Power State | Timeout | 
|-------------|---------|
| **Battery** | 2 minutes |
| **AC / Full** | 5 minutes |

Dynamically adjusts based on charge status. Any keypress exits back to your session.

---

## File Structure

```
tui-asahi/
├── .bashrc              # Shell config — prompt, aliases, env vars
├── .bash_profile        # Login shell → sources .bashrc
├── .tmux.conf           # tmux config, theme, keybindings, screensaver
├── .gitignore
├── install.sh           # Full installer (dnf packages + config deploy)
│
├── bin/
│   ├── motd             # Login banner (system info, battery, temps)
│   ├── screensaver      # Standalone matrix screensaver (backup)
│   └── view             # Universal file viewer (images, PDF, video)
│
├── tmux/
│   ├── hw.sh            # Status bar: brightness, volume, kbd backlight
│   ├── net.sh           # Status bar: WiFi SSID
│   ├── bat.sh           # Status bar: battery %, status, time remaining
│   ├── cpu.sh           # Status bar: CPU usage
│   ├── mem.sh           # Status bar: RAM usage
│   ├── dashboard.sh     # Split-pane dashboard layout
│   └── cheatsheet.txt   # Full shortcut reference
│
├── btop/
│   ├── btop.conf        # btop config
│   └── themes/
│       └── matrix.theme # Custom matrix-green btop theme
│
├── cava/config          # Audio visualizer — green gradient
├── tig/.tigrc           # Git TUI — green-on-black theme
├── newsboat/            # RSS reader config + starter feeds
├── calcurse/conf        # Calendar config
└── micro/settings.json  # Micro editor settings
```

---

## Theme

Everything uses a cohesive **Matrix Green** palette:

| Element | Color | Hex |
|---------|-------|-----|
| Primary (text, borders) | Bright green | `#00ff41` |
| Secondary | Medium green | `#00aa22` |
| Accent | Dark green | `#0d2b0d` |
| Background | Near-black | `#0a0a0a` |
| Inactive | Dim gray | `#555555` |
| Alert | Red | `#e94560` |

---

## Target Hardware

| Spec | Value |
|------|-------|
| **Machine** | Apple MacBook Air 15" (M2, 2023) |
| **CPU** | Apple M2 (4x Blizzard + 4x Avalanche, 8 cores) |
| **RAM** | 16GB unified memory |
| **Storage** | 234GB NVMe SSD (btrfs + zstd) |
| **Display** | 15.3" 2880x1800 Liquid Retina |
| **WiFi** | Broadcom (wlp1s0f0 via brcmfmac) |
| **Battery** | ~66Wh (macsmc-battery driver) |
| **Kernel** | 6.14.2-401.asahi.fc42.aarch64+16k |
| **OS** | Fedora Linux Asahi Remix 42 |

**Idle resource usage**: ~400MB RAM, 0% swap — leaving over 15GB free.

---

## Driver Map

All hardware is managed by **existing Asahi Linux kernel drivers** — no custom modules:

| Hardware | Driver | Sysfs Path |
|----------|--------|------------|
| Display backlight | `apple-panel-bl` | `/sys/class/backlight/apple-panel-bl/` |
| Battery & power | `macsmc-battery` | `/sys/class/power_supply/macsmc-battery/` |
| AC adapter | `macsmc-ac` | `/sys/class/power_supply/macsmc-ac/` |
| Thermals | `macsmc_hwmon` | `/sys/class/hwmon/hwmon1/` |
| Kbd backlight | `kbd_backlight` | `/sys/class/leds/kbd_backlight/` |
| WiFi | `brcmfmac` | `wlp1s0f0` via NetworkManager |
| Audio | `pipewire` + `asahi-ucm` | `wpctl` / `pw-cli` |
| NVMe | `nvme` | `/dev/nvme0n1` |

---

## Related Projects

- [tui-magic](https://github.com/juicecultus/tui-magic) — Debian version for IBM ThinkPad X40
- [tui-magic-arch](https://github.com/juicecultus/tui-magic-arch) — Arch Linux version for MacBook 12" 2017

---

## License

MIT — do whatever you want with it.

---

*"There is no spoon."*
