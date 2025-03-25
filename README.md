# 🪟 openbox-setup

A simple, minimal, and highly functional Openbox window manager setup created by [JustAGuy Linux](https://www.youtube.com/@JustAGuyLinux).  
Perfect for lightweight desktop environments, especially when paired with tools like `rofi`, `polybar`, `xfce4-appfinder`, and custom scripts.

![Openbox Screenshot](https://raw.githubusercontent.com/drewgrif/openbox-setup/main/screenshots/desktop.png)

## 📦 What’s Included

- 🧠 Thoughtful `rc.xml` with full workspace and window management keybindings
- 🎨 Custom theme: `Simply_Circles_Dark`
- 🔤 Rofi keybind helper (`keybinds.rasi`) + launchable with `Super + H`
- 🧰 Useful scripts: `redshift-on`, `redshift-off`, `changevolume`, `help`
- 🎧 Multimedia and brightness key support
- 🖼️ Autostart-ready layout and wallpaper support
- 🧹 Clean margins, centered smart window placement, and snap functionality

## 🚀 Installation

Clone the repo and run the installer:

```bash
git clone https://github.com/drewgrif/openbox-setup.git
cd openbox-setup
chmod +x install.sh
./install.sh
```

> 💡 This will copy Openbox config files to `~/.config/openbox`, install necessary dependencies, and set up your environment.

## 🧷 Key Features

| Keybinding       | Action                        |
|------------------|-------------------------------|
| `Super + Return` | Launch terminal (`wezterm`)     |
| `Super + B`      | Launch browser (`firefox-esr`)|
| `Super + Space`  | Launch appfinder (`xfce4-appfinder`) |
| `Super + H`      | Launch keybind helper         |
| `Print`          | Screenshot full screen (`flameshot`) |
| `Super + Print`  | Screenshot selection          |
| `Alt + Print`    | Launch Flameshot              |
| `Super + Arrow`  | Aero snap window positions    |
| `Super + [0-9]`  | Switch workspaces             |
| `Super + Shift + [0-9]` | Send window to workspace |
| `Super + M`      | Mute / adjust volume          |

## 📁 File Layout

```
openbox-setup/
├── config/
│   └── openbox/
│       ├── rc.xml                  # Main Openbox configuration
│       ├── autostart               # Startup applications
│       ├── environment             # X session env variables
│       ├── menu.xml                # Right-click menu
│       ├── keybinds.rasi           # Rofi keybind cheatsheet
│       ├── wallpaper/              # Collection of wallpapers (default included)
│       │   ├── default.png
│       │   └── other-wallpapers.jpg
│       ├── dunst/                  # Dunst config
│       │   └── dunstrc
│       ├── picom/                  # Picom compositor config
│       │   └── picom.conf
│       ├── polybar/                # Polybar setup (optional)
│       │   ├── config.ini
│       │   └── launch.sh
│       ├── rofi/                   # Rofi theme and config
│       │   ├── config.rasi
│       │   └── keybinds.rasi
│       └── scripts/                # Openbox helper scripts
│           ├── changevolume
│           ├── redshift-on
│           ├── redshift-off
│           └── keyhelper.sh
├── install.sh                      # Main installer
├── README.md                       # Project overview
└── screenshots/
    └── desktop.png                 # Preview screenshot
```


## 🛠 Requirements

- `openbox`
- `rofi`
- `tilix`
- `wezterm`
- `flameshot`
- `xfce4-appfinder`
- `feh`
- `xbacklight`
- `notify-send`
- `redshift`
- `pulseaudio` or `pipewire`

## 📺 YouTube

Watch it in action on [JustAGuy Linux](https://www.youtube.com/@JustAGuyLinux)!
