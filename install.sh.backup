#!/bin/bash

# ============================================
# JustAGuy Linux - Openbox Automated Setup Script
# https://github.com/drewgrif/openbox-setup
# ============================================

LOG_FILE="$HOME/justaguylinux-openbox-install.log"
exec > >(tee -a "$LOG_FILE") 2>&1

CLONED_DIR="$HOME/openbox-setup"
CONFIG_DIR="$HOME/.config/openbox"
INSTALL_DIR="$HOME/installation"
BUTTERSCRIPTS_REPO="https://github.com/drewgrif/butterscripts"

# Create a unique base temporary directory for this run
MAIN_TEMP_DIR="/tmp/justaguylinux_$(date +%s)_$$"
mkdir -p "$MAIN_TEMP_DIR"

command_exists() {
    command -v "$1" &>/dev/null
}

# ============================================
# Error Handling
# ============================================
die() {
    echo "ERROR: $*" >&2
    exit 1
}

# ============================================
# Temporary Directory Management
# ============================================
create_temp_dir() {
    local name="$1"
    local temp_dir="$MAIN_TEMP_DIR/$name"
    mkdir -p "$temp_dir"
    echo "$temp_dir"
}

# Clean up all temporary directories on exit (success or failure)
cleanup() {
    echo "Cleaning up temporary files..."
    rm -rf "$MAIN_TEMP_DIR"
    rm -rf "$INSTALL_DIR"
    echo "Cleanup completed."
}
trap cleanup EXIT

# ============================================
# Script Fetching Functions
# ============================================
get_butterscript() {
    local script_path="$1"
    local script_name=$(basename "$script_path")
    local temp_script="$MAIN_TEMP_DIR/scripts/$script_name"
    
    # Create directory for downloaded scripts
    mkdir -p "$MAIN_TEMP_DIR/scripts"
    
    echo "Fetching script: $script_path from butterscripts repository..."
    
    # Quietly download the script
    wget -q -O "$temp_script" "https://raw.githubusercontent.com/drewgrif/butterscripts/main/$script_path"
    local wget_status=$?
    
    # Check if the download was successful
    if [ $wget_status -ne 0 ] || [ ! -f "$temp_script" ] || [ ! -s "$temp_script" ]; then
        echo "ERROR: Failed to download script: $script_path (wget status: $wget_status)"
        return 1
    fi
    
    # Fix line endings
    sed -i 's/\r$//' "$temp_script" 2>/dev/null
    
    # Make executable
    chmod +x "$temp_script"
    
    # Success - return 0 instead of the path
    return 0
}

run_butterscript() {
    local script_path="$1"
    local script_name=$(basename "$script_path" .sh)
    local script_file="$MAIN_TEMP_DIR/scripts/$(basename "$script_path")"
    
    echo "Preparing to run: $script_path"
    
    # Download the script
    get_butterscript "$script_path"
    local get_status=$?
    
    if [ $get_status -ne 0 ]; then
        echo "ERROR: Failed to download script: $script_path"
        return 1
    fi
    
    # Check that the file exists directly
    if [ ! -f "$script_file" ]; then
        echo "ERROR: Script file does not exist: $script_file"
        return 1
    fi
    
    # Create a temporary directory for the script to use
    local script_temp_dir="$MAIN_TEMP_DIR/${script_name}_workdir"
    mkdir -p "$script_temp_dir"
    
    echo "Running script: $script_path"
    echo "Script file: $script_file"
    echo "Work directory: $script_temp_dir"
    
    # Run the script
    SCRIPT_TEMP_DIR="$script_temp_dir" bash "$script_file"
    local run_status=$?
    
    if [ $run_status -ne 0 ]; then
        echo "ERROR: Script execution failed with status: $run_status"
        return 1
    fi
    
    echo "Script execution completed successfully."
    return 0
}

# ============================================
# Confirm User Intention
# ============================================
clear
echo "
 +-+-+-+-+-+-+-+-+-+-+-+-+-+ 
 |j|u|s|t|a|g|u|y|l|i|n|u|x| 
 +-+-+-+-+-+-+-+-+-+-+-+-+-+ 
 |o|p|e|n|b|o|x| |s|e|t|u|p|  
 +-+-+-+-+-+-+-+-+-+-+-+-+-+                                                                             
"

echo "This script will install and configure Openbox on your Debian system."
read -p "Do you want to continue? (y/n) " confirm
[[ ! "$confirm" =~ ^[Yy]$ ]] && die "Installation aborted."

sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get clean

# ============================================
# Initialize Installation Directory
# ============================================
mkdir -p "$INSTALL_DIR" || die "Failed to create installation directory."

# ============================================
# Install Required Packages
# ============================================
install_packages() {
    echo "Installing required packages..."
    sudo apt-get install -y openbox tint2 polybar xorg xorg-dev xbacklight xbindkeys xvkbd xinput build-essential network-manager-gnome pamixer thunar thunar-archive-plugin thunar-volman lxappearance dialog mtools smbclient cifs-utils avahi-daemon acpi acpid gvfs-backends xfce4-power-manager xfce4-appfinder pavucontrol pulsemixer tilix feh fonts-recommended fonts-font-awesome fonts-terminus exa flameshot qimgv rofi dunst libnotify-bin xdotool unzip libnotify-dev firefox-esr pipewire-audio nala micro xdg-user-dirs-gtk || echo "Warning: Package installation failed."
    echo "Package installation completed."
}

install_reqs() {
    echo "Installing required dev packages..."
    sudo apt-get install -y cmake meson ninja-build curl pkg-config || die "Package installation failed."
}

# ============================================
# Enable System Services
# ============================================
enable_services() {
    echo "Enabling required services..."
    sudo systemctl enable avahi-daemon || echo "Warning: Failed to enable avahi-daemon."
    sudo systemctl enable acpid || echo "Warning: Failed to enable acpid."
}

# ============================================
# Set Up User Directories
# ============================================
setup_user_dirs() {
    echo "Updating user directories..."
    xdg-user-dirs-update || echo "Warning: Failed to update user directories."
    mkdir -p ~/Screenshots/ || echo "Warning: Failed to create Screenshots directory."
    echo "User directories updated."
}

# ============================================
# Check for Existing Openbox Config
# ============================================
check_openbox() {
    if [ -d "$CONFIG_DIR" ]; then
        echo "An existing ~/.config/openbox directory was found."
        read -p "Would you like to back it up before proceeding? (y/n) " response
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

# ============================================
# Move Config Files to ~/.config/openbox
# ============================================
setup_openbox_config() {
    echo "Moving Openbox configuration files..."
    mkdir -p "$CONFIG_DIR"
    cp -a "$CLONED_DIR/config/." "$CONFIG_DIR/" || echo "Warning: Failed to copy Openbox config contents."
    echo "Openbox configuration files copied successfully."
}

# ============================================
# Install ft-picom
# ============================================
install_ftlabs_picom() {
    echo "Installing picom..."
    run_butterscript "setup/install_picom.sh"
}

# ============================================
# Install Wezterm
# ============================================
install_wezterm() {
    echo "Installing Wezterm..."
    run_butterscript "wezterm/install_wezterm.sh"
}

# ============================================
# Install Fonts
# ============================================
install_fonts() {
    echo "Installing fonts..."
    run_butterscript "theming/install_nerdfonts.sh"
}

# ============================================
# Install GTK Theme & Icons
# ============================================
install_theming() {
    echo "Installing GTK themes and icons..."
    run_butterscript "theming/install_theme.sh"
}

# ============================================
# Install Obmenu Generator
# ============================================
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

# ============================================
# Install Openbox Theme
# ============================================
install_openbox_theme() {
    echo "Installing custom Openbox theme..."
    mkdir -p ~/.themes
    cp -r "$CLONED_DIR/config/themes/Simply_Circles_Dark" ~/.themes/
}

# ============================================
# Create LXAppearance Launcher
# ============================================
install_lxappearance_launcher() {
    echo "[*] Creating lxappearance desktop launcher..."

    local desktop_file="$HOME/.local/share/applications/lxappearance.desktop"

    mkdir -p "$(dirname "$desktop_file")"

    cat > "$desktop_file" <<EOF
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

# ============================================
# Install Login Manager
# ============================================
install_displaymanager() {
    echo "Installing display manager..."
    run_butterscript "system/install_lightdm.sh"
}

# ============================================
# Replace .bashrc
# ============================================
replace_bashrc() {
    run_butterscript "system/add_bashrc.sh"
}

# ============================================
# Install Optional Tools
# ============================================
install_optionals() {
    echo "Installing optional tools..."
    run_butterscript "setup/optional_tools.sh"
}

# ============================================
# Main Script Execution
# ============================================
echo "Starting Openbox setup..."

install_packages
install_reqs
enable_services
setup_user_dirs
check_openbox
setup_openbox_config
install_ftlabs_picom
install_wezterm
install_fonts
install_theming
install_obmenu_generator
install_openbox_theme
install_lxappearance_launcher
install_displaymanager
replace_bashrc
install_optionals

echo "All installations completed successfully!"
echo "Installation log saved to: $LOG_FILE"
echo "Please log out and select Openbox from your display manager to start using your new desktop environment."
