#!/usr/bin/env bash
#
# build-hyprlock-patched.sh — Build patched Hyprlock with random Unicode password dots
#
# This script:
#   1. Checks for required build dependencies
#   2. Clones the upstream Hyprlock source at a compatible commit
#   3. Applies the random kanji password-dot patch
#   4. Builds Hyprlock from source
#   5. Backs up the existing Hyprlock binary and config
#   6. Installs the patched binary, config, and wallpaper
#
# Usage:
#   chmod +x build-hyprlock-patched.sh
#   ./build-hyprlock-patched.sh
#
# Options:
#   --build-only    Build but do not install
#   --no-config     Skip installing hyprlock.conf and wallpaper
#   --help          Show usage
#

set -euo pipefail

# ─── Colors ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
DIM='\033[2m'
BOLD='\033[1m'
RESET='\033[0m'

# ─── Config ──────────────────────────────────────────────────────────────────
UPSTREAM_REPO="https://github.com/hyprwm/hyprlock.git"
# The patch was authored against this commit (upstream tag v0.9.2 lineage).
# Using the exact commit the patch was developed on for maximum compatibility.
UPSTREAM_COMMIT="v0.9.6"
PATCH_FILE="patches/hyprlock-random-kanji.patch"
BUILD_DIR="/tmp/hyprlock-samurai-build"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WALLPAPER_SRC="wallhaven-1qrwv9.png"
CONFIG_SRC="hyprlock.conf"

BUILD_ONLY=false
NO_CONFIG=false

# ─── Parse args ──────────────────────────────────────────────────────────────
for arg in "$@"; do
    case "$arg" in
        --build-only) BUILD_ONLY=true ;;
        --no-config)  NO_CONFIG=true ;;
        --help)
            echo "Usage: $0 [--build-only] [--no-config] [--help]"
            echo ""
            echo "  --build-only   Build but do not install"
            echo "  --no-config    Skip installing hyprlock.conf and wallpaper"
            echo "  --help         Show this help"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $arg${RESET}"
            exit 1
            ;;
    esac
done

echo -e "${BOLD}刀 hyprlock-samurai — patched build${RESET}"
echo -e "${DIM}Building Hyprlock with random Unicode password dots${RESET}"
echo ""

# ─── Step 1: Check build dependencies ────────────────────────────────────────
echo -e "${BOLD}[1/6] Checking build dependencies...${RESET}"

# Required tools
REQUIRED_TOOLS=(git cmake make pkg-config gcc)
missing_tools=()
for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" &>/dev/null; then
        missing_tools+=("$tool")
    fi
done

if [ ${#missing_tools[@]} -gt 0 ]; then
    echo -e "${RED}Missing tools: ${missing_tools[*]}${RESET}"
    echo "Please install them first."
    exit 1
fi

# Arch-specific: check for required -devel / library packages
ARCH_DEPS=(
    wayland
    wayland-protocols
    cairo
    pango
    libdrm
    mesa
    pam
    libxkbcommon
    hyprlang
    hyprutils
    hyprwayland-scanner
    sdbus-cpp
    hyprgraphics
    noto-fonts-cjk
    noto-fonts
)

if command -v pacman &>/dev/null; then
    missing_pkgs=()
    for pkg in "${ARCH_DEPS[@]}"; do
        if ! pacman -Qi "$pkg" &>/dev/null 2>&1; then
            missing_pkgs+=("$pkg")
        fi
    done

    if [ ${#missing_pkgs[@]} -gt 0 ]; then
        echo -e "${YELLOW}Missing packages: ${missing_pkgs[*]}${RESET}"
        echo -e "${DIM}Installing via pacman...${RESET}"
        sudo pacman -S --needed --noconfirm "${missing_pkgs[@]}"
    fi
    echo -e "  ${GREEN}✓${RESET} All Arch dependencies satisfied"
else
    echo -e "${YELLOW}⚠ Not on Arch Linux — skipping automatic dependency install.${RESET}"
    echo -e "  Ensure you have: wayland, wayland-protocols, cairo, pango, libdrm,"
    echo -e "  mesa (EGL/GLES), pam, libxkbcommon, hyprlang, hyprutils,"
    echo -e "  hyprwayland-scanner, sdbus-cpp, hyprgraphics, Noto Sans CJK JP, Noto Sans"
    echo ""
fi

# ─── Step 2: Check that the patch file exists ────────────────────────────────
echo -e "${BOLD}[2/6] Verifying patch file...${RESET}"

PATCH_PATH="$SCRIPT_DIR/$PATCH_FILE"
if [ ! -f "$PATCH_PATH" ]; then
    echo -e "${RED}Patch not found at: $PATCH_PATH${RESET}"
    echo "Ensure you are running this script from the hyprlock-samurai repo root."
    exit 1
fi
echo -e "  ${GREEN}✓${RESET} $PATCH_FILE"

# ─── Step 3: Clone upstream Hyprlock ──────────────────────────────────────────
echo -e "${BOLD}[3/6] Cloning upstream Hyprlock...${RESET}"

# Clean previous build
if [ -d "$BUILD_DIR" ]; then
    echo -e "  ${DIM}Removing previous build directory...${RESET}"
    rm -rf "$BUILD_DIR"
fi

git clone "$UPSTREAM_REPO" "$BUILD_DIR" 2>&1 | tail -1
cd "$BUILD_DIR"

echo -e "  ${DIM}Checking out compatible commit ($UPSTREAM_COMMIT)...${RESET}"
git checkout "$UPSTREAM_COMMIT" --quiet 2>/dev/null

echo -e "  ${GREEN}✓${RESET} Cloned and checked out $UPSTREAM_COMMIT"

# ─── Step 4: Apply the patch ─────────────────────────────────────────────────
echo -e "${BOLD}[4/6] Applying random kanji patch...${RESET}"

if ! git apply --check "$PATCH_PATH" 2>/dev/null; then
    echo ""
    echo -e "${RED}╔══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${RED}║  PATCH FAILED TO APPLY                                      ║${RESET}"
    echo -e "${RED}║                                                              ║${RESET}"
    echo -e "${RED}║  The upstream Hyprlock source has changed in a way that      ║${RESET}"
    echo -e "${RED}║  makes this patch incompatible. This usually happens when    ║${RESET}"
    echo -e "${RED}║  the PasswordInputField code has been refactored upstream.   ║${RESET}"
    echo -e "${RED}║                                                              ║${RESET}"
    echo -e "${RED}║  Possible fixes:                                             ║${RESET}"
    echo -e "${RED}║  1. Check if PR #919 has been merged upstream                ║${RESET}"
    echo -e "${RED}║  2. Manually rebase the patch against the new source         ║${RESET}"
    echo -e "${RED}║  3. File an issue at the hyprlock-samurai repository         ║${RESET}"
    echo -e "${RED}╚══════════════════════════════════════════════════════════════╝${RESET}"
    echo ""
    echo -e "${DIM}Patch file: $PATCH_PATH${RESET}"
    echo -e "${DIM}Target commit: $UPSTREAM_COMMIT${RESET}"

    # Show what went wrong
    echo ""
    echo -e "${DIM}Detailed error:${RESET}"
    git apply --check "$PATCH_PATH" 2>&1 || true

    # Cleanup
    rm -rf "$BUILD_DIR"
    exit 1
fi

git apply "$PATCH_PATH"
echo -e "  ${GREEN}✓${RESET} Patch applied cleanly"

# ─── Step 5: Build ───────────────────────────────────────────────────────────
echo -e "${BOLD}[5/6] Building Hyprlock...${RESET}"

cmake -B build -S . \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    2>&1 | tail -5

NPROC=$(nproc 2>/dev/null || echo 4)
cmake --build build -j"$NPROC" 2>&1 | tail -5

if [ ! -f build/hyprlock ]; then
    echo -e "${RED}Build failed — hyprlock binary not produced.${RESET}"
    echo "Check the build output above for errors."
    exit 1
fi

echo -e "  ${GREEN}✓${RESET} Build successful"

if $BUILD_ONLY; then
    echo ""
    echo -e "${GREEN}${BOLD}Build complete!${RESET}"
    echo -e "Binary at: ${BOLD}$BUILD_DIR/build/hyprlock${RESET}"
    echo -e "To install manually: ${DIM}sudo cp $BUILD_DIR/build/hyprlock /usr/bin/hyprlock${RESET}"
    exit 0
fi

# ─── Step 6: Install ─────────────────────────────────────────────────────────
echo -e "${BOLD}[6/6] Installing...${RESET}"

# Backup existing hyprlock binary
HYPRLOCK_BIN="$(which hyprlock 2>/dev/null || true)"
if [ -n "$HYPRLOCK_BIN" ] && [ -f "$HYPRLOCK_BIN" ]; then
    BACKUP_BIN="${HYPRLOCK_BIN}.bak.$(date +%s)"
    sudo cp "$HYPRLOCK_BIN" "$BACKUP_BIN"
    echo -e "  ${GREEN}✓${RESET} Backed up binary → ${DIM}$BACKUP_BIN${RESET}"
fi

# Install the patched binary
sudo cp build/hyprlock /usr/bin/hyprlock
echo -e "  ${GREEN}✓${RESET} Installed patched hyprlock → /usr/bin/hyprlock"

if ! $NO_CONFIG; then
    # Install wallpaper
    mkdir -p "$HOME/Pictures"
    cp "$SCRIPT_DIR/$WALLPAPER_SRC" "$HOME/Pictures/"
    echo -e "  ${GREEN}✓${RESET} Wallpaper → ~/Pictures/$WALLPAPER_SRC"

    # Backup and install config
    CONFIG_DEST="$HOME/.config/hypr/hyprlock.conf"
    mkdir -p "$(dirname "$CONFIG_DEST")"

    if [ -f "$CONFIG_DEST" ]; then
        BACKUP_CONF="${CONFIG_DEST}.bak.$(date +%s)"
        cp "$CONFIG_DEST" "$BACKUP_CONF"
        echo -e "  ${GREEN}✓${RESET} Backed up config → ${DIM}$BACKUP_CONF${RESET}"
    fi

    # Patch the home directory path in config
    sed "s|/home/basant/Pictures|$HOME/Pictures|g" "$SCRIPT_DIR/$CONFIG_SRC" > "$CONFIG_DEST"
    echo -e "  ${GREEN}✓${RESET} Config → $CONFIG_DEST"
fi

# ─── Cleanup ──────────────────────────────────────────────────────────────────
rm -rf "$BUILD_DIR"

echo ""
echo -e "${GREEN}${BOLD}Done!${RESET} Run ${BOLD}hyprlock${RESET} to try it out."
echo ""
echo -e "${DIM}This is a patched build of Hyprlock with random Unicode password dots.${RESET}"
echo -e "${DIM}Stock Hyprlock from your package manager does NOT support this feature.${RESET}"
echo -e "${DIM}If you update Hyprlock via pacman, you will lose the patch. Re-run this script.${RESET}"
