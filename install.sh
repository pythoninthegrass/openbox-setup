#!/usr/bin/env bash

# shellcheck disable=SC2164

# ========================================
# Script Banner and Intro
# ========================================
clear
echo "
 +-+-+-+-+-+-+-+-+-+-+-+-+-+
 |j|u|s|t|a|g|u|y|l|i|n|u|x|
 +-+-+-+-+-+-+-+-+-+-+-+-+-+
 |o|p|e|n|b|o|x| |s|e|t|u|p|
 +-+-+-+-+-+-+-+-+-+-+-+-+-+
"

CLONED_DIR="$HOME/openbox-setup"
CONFIG_DIR="$HOME/.config/openbox"
INSTALL_DIR="$HOME/installation"
GTK_THEME="https://github.com/vinceliuice/Orchis-theme.git"
ICON_THEME="https://github.com/vinceliuice/Colloid-icon-theme.git"

# ========================================
# User Confirmation Before Proceeding
# ========================================
# echo "This script will install and configure Openbox on your Debian system."
# read -rp "Do you want to continue? (y/n) " confirm
# if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
# 	echo "Installation aborted."
# 	exit 1
# fi

sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get clean

# ========================================
# Initialization
# ========================================
mkdir -p "$INSTALL_DIR" || {
	echo "Failed to create installation directory."
	exit 1
}

cleanup() {
	rm -rf "$INSTALL_DIR"
	echo "Installation directory removed."
}
trap cleanup EXIT

# ========================================
# Check for Existing Openbox Configuration
# ========================================
check_openbox() {
	if [ -d "$CONFIG_DIR" ]; then
		echo "An existing ~/.config/openbox directory was found."
		read -rp "Would you like to back it up before proceeding? (y/n) " response
		if [[ "$response" =~ ^[Yy]$ ]]; then
			timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
			backup_dir="$HOME/.config/openbox_backup_$timestamp"
			mv "$CONFIG_DIR" "$backup_dir"
			echo "Backup created at $backup_dir"
		else
			echo "Skipping backup. Your existing config will be overwritten."
		fi
	fi
}

# ========================================
# Move Config Files to ~/.config/openbox
# ========================================
setup_openbox_config() {
	echo "Moving Openbox configuration files..."
	mkdir -p "$CONFIG_DIR"
	cp -a "$CLONED_DIR/config/." "$CONFIG_DIR/" || echo "Warning: Failed to copy Openbox config contents."
	echo "Openbox configuration files copied successfully."
}

# ========================================
# Install Packages
# ========================================
install_packages() {
	echo "Installing required packages..."
	sudo apt-get install -y \
		acpi \
		acpid \
		avahi-daemon \
		build-essential \
		dialog \
		dunst \
		exa \
		feh \
		firefox-esr \
		fonts-font-awesome \
		fonts-recommended \
		fonts-terminus \
		geany \
		geany-plugin-addons \
		geany-plugin-automark \
		geany-plugin-git-changebar \
		geany-plugin-insertnum \
		geany-plugin-lineoperations \
		geany-plugin-markdown \
		geany-plugin-spellcheck \
		geany-plugin-treebrowser \
		gvfs-backends \
		lightdm \
		libnotify-bin \
		libnotify-dev \
		lxappearance \
		micro \
		mtools \
		nala \
		network-manager-gnome \
		pamixer \
		pavucontrol \
		pipewire-audio \
		polybar \
		pulsemixer \
		qimgv \
		ranger \
		redshift \
		rofi \
		suckless-tools \
		thunar \
		thunar-archive-plugin \
		thunar-volman \
		tilix \
		tint2 \
		unzip \
		xbacklight \
		xbindkeys \
		xdg-user-dirs-gtk \
		xdotool \
		xfce4-appfinder \
		xinput \
		xfce4-power-manager \
		xorg \
		xorg-dev \
		xvkbd
	echo "Package installation completed."
}

enable_services() {
	echo "Enabling required services..."
	sudo systemctl enable avahi-daemon || echo "Warning: Failed to enable avahi-daemon."
	sudo systemctl enable acpid || echo "Warning: Failed to enable acpid."
	echo "Services enabled."
}

setup_user_dirs() {
	echo "Updating user directories..."
	xdg-user-dirs-update || echo "Warning: Failed to update user directories."
	mkdir -p ~/Screenshots/ || echo "Warning: Failed to create Screenshots directory."
	echo "User directories updated."
}

command_exists() {
	command -v "$1" &>/dev/null
}

install_reqs() {
	echo "Installing required dev packages..."
	sudo apt-get install -y cmake meson ninja-build curl pkg-config || {
		echo "Package installation failed."
		exit 1
	}
}

install_ftlabs_picom() {
	if command_exists picom; then
		echo "Picom is already installed. Skipping."
		return
	fi
	sudo apt-get install -y libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev libepoxy-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev libxcb1-dev libxcb-composite0-dev libxcb-damage0-dev libxcb-dpms0-dev libxcb-glx0-dev libxcb-image0-dev libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev libxcb-xfixes0-dev libxext-dev meson ninja-build uthash-dev
	git clone https://github.com/FT-Labs/picom "$INSTALL_DIR/picom" || return
	cd "$INSTALL_DIR/picom"
	meson setup --buildtype=release build
	ninja -C build
	sudo ninja -C build install
}

install_fastfetch() {
	if command_exists fastfetch; then
		echo "Fastfetch is already installed. Skipping."
	else
		echo "Installing Fastfetch..."
		git clone https://github.com/fastfetch-cli/fastfetch "$INSTALL_DIR/fastfetch" || return
		cd "$INSTALL_DIR/fastfetch"
		cmake -S . -B build && cmake --build build && sudo mv build/fastfetch /usr/local/bin/
	fi

	echo "Setting up Fastfetch config..."
	mkdir -p "$HOME/.config/fastfetch"
	wget -O "$HOME/.config/fastfetch/config.jsonc" "https://raw.githubusercontent.com/drewgrif/jag_dots/main/.config/fastfetch/config.jsonc" || echo "Warning: Failed to download config.jsonc"
}

install_wezterm() {
	if command_exists wezterm; then
		echo "Wezterm is already installed. Skipping."
		return
	fi
	WEZTERM_URL="https://github.com/wezterm/wezterm/releases/download/20240203-110809-5046fc22/wezterm-20240203-110809-5046fc22.Debian12.deb"
	TMP_DEB="/tmp/wezterm.deb"
	wget -O "$TMP_DEB" "$WEZTERM_URL" && sudo apt install -y "$TMP_DEB" && rm -f "$TMP_DEB"
	mkdir -p "$HOME/.config/wezterm"
	wget -O "$HOME/.config/wezterm/wezterm.lua" "https://raw.githubusercontent.com/drewgrif/jag_dots/main/.config/wezterm/wezterm.lua" || die "Failed to download wezterm config."
}

install_fonts() {
	echo "Installing fonts..."
	mkdir -p ~/.local/share/fonts
	fonts=("FiraCode" "Hack" "JetBrainsMono" "RobotoMono" "SourceCodePro" "UbuntuMono")
	for font in "${fonts[@]}"; do
		if ! ls ~/.local/share/fonts/$font/*.ttf &>/dev/null; then
			wget -q "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/$font.zip" -P /tmp && unzip -q /tmp/$font.zip -d ~/.local/share/fonts/$font/ && rm /tmp/$font.zip
		fi
	done
	fc-cache -f
	echo "Fonts installed."
}

install_theming() {
	GTK_THEME_NAME="Orchis-Grey-Dark"
	ICON_THEME_NAME="Colloid-Grey-Dracula-Dark"
	if [ ! -d "$HOME/.themes/$GTK_THEME_NAME" ]; then
		git clone "$GTK_THEME" "$INSTALL_DIR/Orchis-theme"
		cd "$INSTALL_DIR/Orchis-theme"
		yes | ./install.sh -c dark -t teal grey default --tweaks black
	fi
	if [ ! -d "$HOME/.icons/$ICON_THEME_NAME" ]; then
		git clone "$ICON_THEME" "$INSTALL_DIR/Colloid-icon-theme"
		cd "$INSTALL_DIR/Colloid-icon-theme"
		./install.sh -t teal orange grey -s default gruvbox dracula
	fi
}

change_theming() {
	mkdir -p ~/.config/gtk-3.0
	cat <<EOF >~/.config/gtk-3.0/settings.ini
[Settings]
gtk-theme-name=Orchis-Grey-Dark
gtk-icon-theme-name=Colloid-Grey-Dracula-Dark
gtk-font-name=Sans 10
gtk-cursor-theme-name=Adwaita
gtk-cursor-theme-size=0
EOF
	cat <<EOF >~/.gtkrc-2.0
gtk-theme-name="Orchis-Grey-Dark"
gtk-icon-theme-name="Colloid-Grey-Dracula-Dark"
gtk-font-name="Sans 10"
gtk-cursor-theme-name="Adwaita"
gtk-cursor-theme-size=0
EOF
	echo "GTK theming applied."
}

install_obmenu_generator() {
	echo "Installing obmenu-generator dependencies..."
	sudo apt install -y libgtk3-perl libmodule-build-perl

	echo "Installing Linux-DesktopFiles..."
	git clone https://github.com/trizen/Linux-DesktopFiles.git "$INSTALL_DIR/Linux-DesktopFiles"
	cd "$INSTALL_DIR/Linux-DesktopFiles"
	perl Build.PL
	./Build
	./Build test
	sudo ./Build install

	echo "Setting up obmenu-generator..."
	mkdir -p ~/.local/bin/
	mkdir -p ~/.config/obmenu-generator

	git clone https://github.com/trizen/obmenu-generator.git "$INSTALL_DIR/obmenu-generator"
	cp "$INSTALL_DIR/obmenu-generator/obmenu-generator" ~/.local/bin/

	# Use schema.pl from your repo
	cp "$CLONED_DIR/config/obmenu/schema.pl" ~/.config/obmenu-generator/

	echo "Generating Openbox menu..."
	obmenu-generator -p -i
}

install_openbox_theme() {
	echo "Installing custom Openbox theme..."
	mkdir -p ~/.themes
	cp -r "$CLONED_DIR/config/themes/Simply_Circles_Dark" ~/.themes/
}

install_lxappearance_launcher() {
	echo "[*] Creating lxappearance desktop launcher..."

	local desktop_file="$HOME/.local/share/applications/lxappearance.desktop"

	mkdir -p "$(dirname "$desktop_file")"

	cat >"$desktop_file" <<EOF
[Desktop Entry]
Name=Appearance
Comment=Customize the look of your desktop
Exec=lxappearance
Icon=preferences-desktop-theme
Terminal=false
Type=Application
Categories=Settings;GTK;X-XFCE;
EOF

	chmod +x "$desktop_file"

	echo "[✓] lxappearance launcher created at $desktop_file"
}

replace_bashrc() {
	echo "Replace your .bashrc with justaguylinux version? (y/n)"
	read -rp response
	if [[ "$response" =~ ^[Yy]$ ]]; then
		[ -f ~/.bashrc ] && mv ~/.bashrc ~/.bashrc.bak
		wget -O ~/.bashrc https://raw.githubusercontent.com/drewgrif/jag_dots/main/.bashrc && source ~/.bashrc
	fi
}

# ========================================
# Main Script Execution
# ========================================
main() {
	echo "Starting Openbox setup..."
	check_openbox
	setup_openbox_config
	install_packages
	enable_services
	setup_user_dirs
	install_reqs
	install_ftlabs_picom
	install_fastfetch
	install_wezterm
	install_fonts
	install_theming
	install_obmenu_generator
	install_openbox_theme
	install_lxappearance_launcher
	change_theming
	# replace_bashrc
	echo "All installations completed successfully!"
}

main
