<h1 align="center">
  <br>
  刀 hyprlock-samurai
  <br>
</h1>

<p align="center">
  <b>A samurai-themed lock screen for <a href="https://github.com/hyprwm/hyprlock">Hyprlock</a></b>
  <br>
  <sub>Random kanji password glyphs · dark katana aesthetic · minimal &amp; clean</sub>
</p>

<p align="center">
  <a href="#-preview"><img src="https://img.shields.io/badge/hyprland-lock_screen-88c070?style=flat-square&logo=wayland&logoColor=white" alt="Hyprland"></a>
  <a href="LICENSE"><img src="https://img.shields.io/github/license/basantbansal/hyprlock-samurai?style=flat-square&color=88c070" alt="License"></a>
  <a href="https://github.com/basantbansal/hyprlock-samurai/stargazers"><img src="https://img.shields.io/github/stars/basantbansal/hyprlock-samurai?style=flat-square&color=88c070" alt="Stars"></a>
  <a href="https://archlinux.org"><img src="https://img.shields.io/badge/arch-btw-88c070?style=flat-square&logo=archlinux&logoColor=white" alt="Arch btw"></a>
</p>

---

## 🗡️ Preview

<!-- Add your screenshot here -->
<!-- ![preview](./preview.png) -->
<img width="1920" height="1080" alt="Screenshot_14-Aug_00-19-48_28053" src="https://github.com/user-attachments/assets/5a5babd2-6519-4e22-9027-2efe71e358f1" />
<img width="1920" height="1080" alt="Screenshot_14-Aug_00-19-11_23721" src="https://github.com/user-attachments/assets/ed2c49f0-d239-4a1c-a463-544709e8ce37" />


---

## ✨ Features

- **Random kanji password dots** — each keypress renders a randomly selected Japanese kanji (`力火影斬剣空龍闇神心道武魂夢月天風雷`) instead of boring circles
- **Stable randomization** — once a character is displayed for a position, it stays fixed (no chaotic reshuffling on each keypress)
- **Dark samurai wallpaper** — katana with engraved kanji on a deep green/black background
- **Large clock overlay** — clean time display with muted green tones
- **Japanese date format** — date rendered as `2024年08月14日`
- **Fully transparent input field** — no borders, no outlines, just floating kanji
- **Immediate render** — no lag, cursor hidden for immersion

---

> [!IMPORTANT]
> **This theme requires a patched build of Hyprlock.** The random Unicode password-dot feature (`dots_text_format = [chars]` with `dots_text_change`) is **not available** in stock Hyprlock from your package manager. This repo includes the patch and a build script that handles everything automatically.

---

## 📦 How It Works

The random kanji feature comes from a patch by [@fuzzy-one](https://github.com/fuzzy-one/hyprlock/tree/feature) (based on [Hyprlock PR #919](https://github.com/hyprwm/hyprlock/pull/919)) that adds:

| Config Option | Description |
|---|---|
| `dots_text_format = [chars]` | When wrapped in `[]`, each keypress picks a **random character** from the set |
| `dots_text_change = false` | `false` = stable (characters stay fixed per position), `true` = chaotic (all reshuffle on each keypress) |

The patch also adds proper UTF-8 multibyte parsing so kanji, katakana, emoji, and other Unicode characters render correctly.

---

## 🚀 Installation

### Full install (recommended)

This clones the upstream Hyprlock source, applies the patch, builds from source, and installs everything:

```bash
git clone https://github.com/basantbansal/hyprlock-samurai.git
cd hyprlock-samurai
chmod +x build-hyprlock-patched.sh
./build-hyprlock-patched.sh
```

The script will:
- ✅ Check and install build dependencies (Arch Linux)
- ✅ Clone Hyprlock at a known-compatible commit (`v0.9.6`)
- ✅ Apply the random kanji patch
- ✅ Build from source
- ✅ **Back up** your existing Hyprlock binary and config before overwriting
- ✅ Install the patched binary, config, and wallpaper

### Build only (don't install)

```bash
./build-hyprlock-patched.sh --build-only
```

### Config only (already have patched Hyprlock)

If you've already built the patched Hyprlock or it's been merged upstream:

```bash
chmod +x install.sh
./install.sh
```

### Manual

```bash
# Clone the repo
git clone https://github.com/basantbansal/hyprlock-samurai.git
cd hyprlock-samurai

# Build patched Hyprlock (see build-hyprlock-patched.sh for details)
# Or apply patches/hyprlock-random-kanji.patch to upstream Hyprlock manually:
#   cd /path/to/hyprlock-source
#   git checkout v0.9.6
#   git apply /path/to/hyprlock-samurai/patches/hyprlock-random-kanji.patch
#   cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
#   cmake --build build -j$(nproc)
#   sudo cp build/hyprlock /usr/bin/hyprlock

# Copy the wallpaper
mkdir -p ~/Pictures
cp wallhaven-1qrwv9.png ~/Pictures/

# Copy the config (backup existing first)
[ -f ~/.config/hypr/hyprlock.conf ] && cp ~/.config/hypr/hyprlock.conf ~/.config/hypr/hyprlock.conf.bak
mkdir -p ~/.config/hypr
cp hyprlock.conf ~/.config/hypr/hyprlock.conf

# Edit the wallpaper path if your username differs
sed -i "s|/home/basant/Pictures|$HOME/Pictures|g" ~/.config/hypr/hyprlock.conf
```

### Test it

```bash
hyprlock
```

---

## 📦 Build Dependencies

### Arch Linux

```bash
sudo pacman -S --needed \
    wayland wayland-protocols cairo pango libdrm mesa pam libxkbcommon \
    hyprlang hyprutils hyprwayland-scanner sdbus-cpp hyprgraphics \
    noto-fonts-cjk noto-fonts \
    cmake gcc git pkg-config
```

### Runtime only

| Package | Purpose |
|---|---|
| [hyprlock](https://github.com/hyprwm/hyprlock) (patched) | Lock screen for Hyprland |
| [noto-fonts-cjk](https://archlinux.org/packages/extra/any/noto-fonts-cjk/) | Japanese kanji rendering |
| [noto-fonts](https://archlinux.org/packages/extra/any/noto-fonts/) | Clock label font |

---

## ⚙️ Customization

### Change the wallpaper

Replace `~/Pictures/wallhaven-1qrwv9.png` with your own image and update the path in `hyprlock.conf`:

```ini
image {
    path = /your/path/to/wallpaper.png
}
```

### Change the kanji set

Edit the `dots_text_format` in `hyprlock.conf`. The `[...]` bracket syntax enables random selection:

```ini
# Random kanji per keypress (requires patched Hyprlock)
dots_text_format = [力火影斬剣空龍闇神心道武魂夢月天風雷]

# Set to false for stable chars, true for chaotic reshuffling
dots_text_change = false
```

Replace with any Unicode characters — try katakana, runes, emoji, or mix scripts:

```ini
# Katakana
dots_text_format = [アイウエオカキクケコ]

# Mixed symbols
dots_text_format = [☠️🗡️⚔️🏯🌸🎌⛩️🐉]

# Single static character (works with stock Hyprlock too)
dots_text_format = ★
```

### Adjust colors

The theme uses muted greens. Key color values:

| Element | Value | Description |
|---|---|---|
| Background | `rgba(8,8,12,1.0)` | Near-black with blue tint |
| Clock | `rgba(180,220,180,0.85)` | Muted green, 85% opacity |
| Date | `rgba(180,220,180,0.45)` | Same green, more transparent |
| Input text | `rgba(255,255,255,0.92)` | Near-white kanji |

---

## 🗂️ File Structure

```
hyprlock-samurai/
├── hyprlock.conf                          # Hyprlock config (samurai theme)
├── wallhaven-1qrwv9.png                   # Samurai katana wallpaper
├── build-hyprlock-patched.sh              # Full build + install script
├── install.sh                             # Config-only install script
├── patches/
│   └── hyprlock-random-kanji.patch        # Minimal patch for random Unicode dots
├── LICENSE                                # MIT License
└── README.md                              # You are here
```

---

## ⚠️ Updating Hyprlock

If you update Hyprlock through your package manager (`pacman -Syu`), the stock binary will **overwrite the patched one** and you'll lose the random kanji feature. To restore it:

```bash
cd hyprlock-samurai
./build-hyprlock-patched.sh
```

---

## 🔧 Troubleshooting

| Issue | Fix |
|---|---|
| Password shows dots instead of kanji | You're running stock Hyprlock. Run `build-hyprlock-patched.sh` |
| Kanji don't render / show boxes | Install `noto-fonts-cjk`: `sudo pacman -S noto-fonts-cjk` |
| Patch fails to apply | Upstream Hyprlock changed. Check if PR #919 was merged, or open an issue |
| Build fails with missing deps | Run: `sudo pacman -S --needed wayland wayland-protocols cairo pango libdrm mesa pam libxkbcommon hyprlang hyprutils hyprwayland-scanner sdbus-cpp hyprgraphics` |

---

## 🤝 Credits

- Random Unicode password dots patch by [@fuzzy-one](https://github.com/fuzzy-one) ([PR #919](https://github.com/hyprwm/hyprlock/pull/919))
- Wallpaper sourced from [Wallhaven](https://wallhaven.cc/)
- Built for [Hyprland](https://hyprland.org/) / [Hyprlock](https://github.com/hyprwm/hyprlock)

---

<p align="center">
  <sub>If you like this rice, drop a ⭐ — it helps others find it.</sub>
</p>
