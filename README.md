# 🪟 openbox-setup

Minimal Openbox setup for Debian-based systems, crafted by [JustAGuy Linux](https://www.youtube.com/@JustAGuyLinux).  
This repo provides a clean, themed, and user-friendly Openbox experience using custom scripts, Rofi integration, and other handpicked tools.

## 📦 What's Included

- 🔧 `install.sh` — automated setup for Openbox, configs, packages, theming, and utilities
- 🎨 GTK + icon themes (Orchis + Colloid with Everforest tweaks)
- 🖼️ Wallpapers, compositor (Picom), panel (Polybar), notifications (Dunst), and Rofi
- 📄 Keybinds cheat sheet (`keybinds.rasi`) for Rofi
- 🧪 Optional `.bashrc` replacement
- 🧰 Scripts for volume, redshift, screenshot, etc.

## 🗂️ Repo Structure

```
openbox-setup/
├── install.sh       # Main setup script
├── README.md        # This file
└── config/          # Openbox config and assets
    ├── rc.xml
    ├── autostart
    ├── environment
    ├── menu.xml
    ├── dunst/
    ├── picom/
    ├── polybar/
    ├── rofi/
    ├── scripts/
    └── wallpaper/
```

## 🚀 Installation

```bash
git clone https://github.com/drewgrif/openbox-setup.git
cd openbox-setup
chmod +x install.sh
./install.sh
```

You will be prompted before making any system changes. The script backs up your existing Openbox config if found.

## ✅ Dependencies (installed automatically)

This setup installs packages including but not limited to:

- `openbox`, `rofi`, `polybar`, `dunst`, `picom`, `thunar`
- `xfce4-appfinder`, `pavucontrol`, `pulsemixer`, `ranger`
- `redshift`, `flameshot`, `geany`, `fastfetch`, `wezterm`
- GTK and icon themes: Orchis, Colloid
- Nerd Fonts: FiraCode, Hack, JetBrainsMono, and more

## 🎛️ Notes

- Terminal is set to **WezTerm**
- Screenshots use **maim** and **flameshot**
- `keybinds.rasi` is used with Rofi to show your shortcuts (`Super + H`)
- Wallpapers live in `~/.config/openbox/wallpaper`
- Scripts live in `~/.config/openbox/scripts`

## 📺 Watch It

> Want to see it in action? Check out [JustAGuy Linux on YouTube](https://www.youtube.com/@JustAGuyLinux)

---
