<h1 align="center">
  <br>
  刀 hyprlock-samurai
  <br>
</h1>

<p align="center">
  <b>A samurai-themed lock screen for <a href="https://github.com/hyprwm/hyprlock">Hyprlock</a></b>
  <br>
  <sub>Kanji password glyphs · dark katana aesthetic · minimal &amp; clean</sub>
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

- **Kanji password dots** — each keypress renders a specific Japanese kanji character (`斬`) instead of boring circles
- **Dark samurai wallpaper** — katana with engraved kanji on a deep green/black background
- **Large clock overlay** — clean time display with muted green tones
- **Japanese date format** — date rendered as `2024年08月14日`
- **Fully transparent input field** — no borders, no outlines, just floating kanji
- **Immediate render** — no lag, cursor hidden for immersion

---

## 📦 Dependencies

| Package | Purpose |
|---|---|
| [hyprlock](https://github.com/hyprwm/hyprlock) | Lock screen for Hyprland |
| [noto-fonts-cjk](https://archlinux.org/packages/extra/any/noto-fonts-cjk/) | Japanese kanji rendering |
| [noto-fonts](https://archlinux.org/packages/extra/any/noto-fonts/) | Clock label font |

### Arch Linux

```bash
sudo pacman -S hyprlock noto-fonts-cjk noto-fonts
```

### Other distros

Install `hyprlock`, `Noto Sans CJK JP`, and `Noto Sans` via your package manager.

---

## 🚀 Installation

### One-liner (recommended)

```bash
git clone https://github.com/basantbansal/hyprlock-samurai.git
cd hyprlock-samurai
chmod +x install.sh
./install.sh
```

### Manual

```bash
# Clone the repo
git clone https://github.com/basantbansal/hyprlock-samurai.git
cd hyprlock-samurai

# Copy the wallpaper
mkdir -p ~/Pictures
cp wallhaven-1qrwv9.png ~/Pictures/

# Copy the config (backup existing first)
[ -f ~/.config/hypr/hyprlock.conf ] && cp ~/.config/hypr/hyprlock.conf ~/.config/hypr/hyprlock.conf.bak
mkdir -p ~/.config/hypr
cp hyprlock.conf ~/.config/hypr/hyprlock.conf
```

### Test it

```bash
hyprlock
```

---

## ⚙️ Customization

### Change the wallpaper

Replace `~/Pictures/wallhaven-1qrwv9.png` with your own image and update the path in `hyprlock.conf`:

```ini
background {
    path = /your/path/to/wallpaper.png
}
```

### Change the kanji set

Edit the `dots_text_format` in `hyprlock.conf`:

```ini
dots_text_format = 斬
```

Replace with any Unicode characters you like — try katakana, runes, or emoji.

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
├── hyprlock.conf          # Main hyprlock configuration
├── wallhaven-1qrwv9.png   # Samurai katana wallpaper
├── install.sh             # Automated install script
├── LICENSE                # MIT License
└── README.md              # You are here
```

---

## 🤝 Credits

- Wallpaper sourced from [Wallhaven](https://wallhaven.cc/)
- Built for [Hyprland](https://hyprland.org/) / [Hyprlock](https://github.com/hyprwm/hyprlock)

---

<p align="center">
  <sub>If you like this rice, drop a ⭐ — it helps others find it.</sub>
</p>
