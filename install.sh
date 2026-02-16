#!/bin/bash
# ══════════════════════════════════════════════════════════════
#  TUI Magic — Fedora Asahi Installer (MacBook Air M2)
# ══════════════════════════════════════════════════════════════

set -e
GREEN='\e[32m'
BOLD='\e[1m'
RESET='\e[0m'

echo -e "${BOLD}${GREEN}╔═══════════════════════════════════════════╗${RESET}"
echo -e "${BOLD}${GREEN}║  TUI Magic — Fedora Asahi Remix Installer  ║${RESET}"
echo -e "${BOLD}${GREEN}╚═══════════════════════════════════════════╝${RESET}"
echo ""

# --- 1. System update ---
echo -e "${GREEN}[1/7] Updating system...${RESET}"
sudo dnf upgrade -y --refresh

# --- 2. Install packages ---
echo -e "${GREEN}[2/7] Installing TUI tools...${RESET}"
sudo dnf install -y \
    tmux htop btop ranger nnn tig newsboat calcurse w3m \
    cmatrix figlet cava fzf bat fd-find ripgrep tree ncdu \
    git micro alsa-utils brightnessctl inetutils \
    pipewire pipewire-pulseaudio wireplumber \
    less wget curl fastfetch \
    gdu duf colordiff mtr speedtest-cli \
    chafa mediainfo atool p7zip unzip zip \
    cmus mpv bc jq irssi \
    NetworkManager-wifi iftop nethogs

# --- 3. Install from COPR / extras ---
echo -e "${GREEN}[3/7] Installing extras...${RESET}"
# cbonsai and tty-clock may need COPR or build from source
sudo dnf install -y cbonsai 2>/dev/null || echo "cbonsai not in repos — install manually"
sudo dnf install -y tty-clock 2>/dev/null || echo "tty-clock not in repos — install manually"
sudo dnf install -y lolcat 2>/dev/null || echo "lolcat not in repos"

# --- 4. Create directories ---
echo -e "${GREEN}[4/7] Creating config directories...${RESET}"
mkdir -p ~/bin ~/.tmux ~/.config/btop/themes ~/.config/cava \
    ~/.config/tig ~/.config/newsboat ~/.config/calcurse \
    ~/.config/micro

# --- 5. Deploy config files ---
echo -e "${GREEN}[5/7] Deploying config files...${RESET}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

cp "$SCRIPT_DIR/.bashrc"             ~/.bashrc
cp "$SCRIPT_DIR/.bash_profile"       ~/.bash_profile
cp "$SCRIPT_DIR/.tmux.conf"          ~/.tmux.conf
cp "$SCRIPT_DIR/bin/motd"            ~/bin/motd
cp "$SCRIPT_DIR/bin/screensaver"     ~/bin/screensaver
cp "$SCRIPT_DIR/bin/view"            ~/bin/view
cp "$SCRIPT_DIR/tmux/hw.sh"          ~/.tmux/hw.sh
cp "$SCRIPT_DIR/tmux/net.sh"         ~/.tmux/net.sh
cp "$SCRIPT_DIR/tmux/cpu.sh"         ~/.tmux/cpu.sh
cp "$SCRIPT_DIR/tmux/mem.sh"         ~/.tmux/mem.sh
cp "$SCRIPT_DIR/tmux/bat.sh"         ~/.tmux/bat.sh
cp "$SCRIPT_DIR/tmux/dashboard.sh"   ~/.tmux/dashboard.sh
cp "$SCRIPT_DIR/tmux/cheatsheet.txt" ~/.tmux/cheatsheet.txt
cp "$SCRIPT_DIR/btop/btop.conf"      ~/.config/btop/btop.conf
cp "$SCRIPT_DIR/btop/themes/matrix.theme" ~/.config/btop/themes/matrix.theme
cp "$SCRIPT_DIR/cava/config"         ~/.config/cava/config
cp "$SCRIPT_DIR/tig/.tigrc"          ~/.tigrc
cp "$SCRIPT_DIR/newsboat/config"     ~/.config/newsboat/config
cp "$SCRIPT_DIR/newsboat/urls"       ~/.config/newsboat/urls
cp "$SCRIPT_DIR/calcurse/conf"       ~/.config/calcurse/conf
cp "$SCRIPT_DIR/micro/settings.json" ~/.config/micro/settings.json

# Permissions
chmod +x ~/bin/* ~/.tmux/*.sh

# --- 6. Enable pipewire audio ---
echo -e "${GREEN}[6/7] Enabling audio (pipewire)...${RESET}"
systemctl --user enable --now pipewire pipewire-pulse wireplumber 2>/dev/null || true

# --- 7. Keyboard backlight permissions ---
echo -e "${GREEN}[7/7] Setting up keyboard backlight access...${RESET}"
# Allow user to control kbd backlight without sudo
if [ ! -f /etc/udev/rules.d/90-kbd-backlight.rules ]; then
    echo 'ACTION=="add", SUBSYSTEM=="leds", KERNEL=="kbd_backlight", RUN+="/bin/chmod 0666 /sys/class/leds/kbd_backlight/brightness"' | sudo tee /etc/udev/rules.d/90-kbd-backlight.rules >/dev/null
    echo "Kbd backlight udev rule installed (takes effect on next boot)"
fi

echo ""
echo -e "${BOLD}${GREEN}╔═══════════════════════════════════════════╗${RESET}"
echo -e "${BOLD}${GREEN}║          Installation Complete!            ║${RESET}"
echo -e "${BOLD}${GREEN}╚═══════════════════════════════════════════╝${RESET}"
echo ""
echo -e "${GREEN}Log out and back in to start using TUI Magic.${RESET}"
echo -e "${GREEN}Use Ctrl-a (then key) for tmux shortcuts.${RESET}"
echo -e "${GREEN}Press Ctrl-a then H for the full cheatsheet.${RESET}"
