#!/usr/bin/env bash
#
# install.sh — hyprlock-samurai installer
# Copies the config and wallpaper to the right locations.
#

set -euo pipefail

GREEN='\033[0;32m'
DIM='\033[2m'
BOLD='\033[1m'
RESET='\033[0m'

WALLPAPER_SRC="wallhaven-1qrwv9.png"
WALLPAPER_DEST="$HOME/Pictures/$WALLPAPER_SRC"
CONFIG_SRC="hyprlock.conf"
CONFIG_DEST="$HOME/.config/hypr/hyprlock.conf"

echo -e "${BOLD}刀 hyprlock-samurai installer${RESET}"
echo ""

# --- Check dependencies ---
missing=()
if ! command -v hyprlock &>/dev/null; then
    missing+=("hyprlock")
fi
if ! fc-list | grep -qi "Noto Sans CJK JP"; then
    missing+=("noto-fonts-cjk")
fi
if ! fc-list | grep -qi "Noto Sans"; then
    missing+=("noto-fonts")
fi

if [ ${#missing[@]} -gt 0 ]; then
    echo -e "${DIM}Missing dependencies: ${missing[*]}${RESET}"
    if command -v pacman &>/dev/null; then
        echo -e "${DIM}Installing via pacman...${RESET}"
        sudo pacman -S --needed --noconfirm "${missing[@]}"
    else
        echo "Please install the following packages manually: ${missing[*]}"
        exit 1
    fi
fi

# --- Copy wallpaper ---
echo -e "${DIM}Copying wallpaper...${RESET}"
mkdir -p "$HOME/Pictures"
cp "$WALLPAPER_SRC" "$WALLPAPER_DEST"
echo -e "  ${GREEN}✓${RESET} $WALLPAPER_DEST"

# --- Patch config with correct home path ---
echo -e "${DIM}Preparing config...${RESET}"
sed "s|/home/basant/Pictures|$HOME/Pictures|g" "$CONFIG_SRC" > /tmp/hyprlock-samurai.conf

# --- Backup existing config ---
mkdir -p "$(dirname "$CONFIG_DEST")"
if [ -f "$CONFIG_DEST" ]; then
    backup="${CONFIG_DEST}.bak.$(date +%s)"
    cp "$CONFIG_DEST" "$backup"
    echo -e "  ${GREEN}✓${RESET} Backed up existing config → ${DIM}$backup${RESET}"
fi

# --- Install config ---
cp /tmp/hyprlock-samurai.conf "$CONFIG_DEST"
rm -f /tmp/hyprlock-samurai.conf
echo -e "  ${GREEN}✓${RESET} $CONFIG_DEST"

echo ""
echo -e "${GREEN}${BOLD}Done!${RESET} Run ${BOLD}hyprlock${RESET} to try it out."
