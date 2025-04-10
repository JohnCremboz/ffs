#!/bin/bash

# Enable debug mode
set -x

# Make the script executable
chmod +x "$0"

# Detect the distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
        echo "Detected distribution: $DISTRO"
    else
        echo "Unsupported distribution"
        exit 1
    fi
}

# Function to display the menu using dialog
show_menu() {
    dialog --clear --title "Choose components to install" \
    --menu "Select an option:" 15 50 17 \
    1 "Upgrade system" \
    2 "Install Fedora workstation repositories" \
    3 "Install RPM Fusion repositories" \
    4 "Update core, multimedia, and sound-and-video groups" \
    5 "Install additional packages" \
    6 "Install Microsoft repositories and packages" \
    7 "Install Flatpak and Spotify" \
    8 "Set default target to graphical and reboot" \
    9 "Install MS Edge" \
    10 "Install Steam" \
    11 "Install Google Chrome" \
    12 "Install NVtop" \
    13 "Install btop" \
    14 "Install Wine" \
    15 "Install Nvidia drivers and CUDA" \
    16 "Install Desktop Environment" \
    17 "Exit" 2>tempfile

    choice=$(<tempfile)
    echo "User selected option: $choice"
    rm -f tempfile
}

# Function to disable any existing desktop manager
disable_existing_dm() {
    if systemctl is-active --quiet gdm; then
        sudo systemctl disable gdm
    elif systemctl is-active --quiet gdm3; then
        sudo systemctl disable gdm3
    elif systemctl is-active --quiet sddm; then
        sudo systemctl disable sddm
    elif systemctl is-active --quiet lightdm; then
        sudo systemctl disable lightdm
    fi
}

# Function to install selected components
install_components() {
    echo "Installing components for option: $1"
    case $1 in
        1)
            if [ "$DISTRO" = "fedora" ]; then
                sudo dnf upgrade -y
            elif [ "$DISTRO" = "ubuntu" ]; then
                sudo apt update && sudo apt upgrade -y
            elif [ "$DISTRO" = "arch" ]; then
                sudo pacman -Syu
            elif [ "$DISTRO" = "opensuse" ]; then
                sudo zypper update -y
            fi
            ;;
        2)
            if [ "$DISTRO" = "fedora" ]; then
                sudo dnf install fedora-workstation-repositories -y
            elif [ "$DISTRO" = "ubuntu" ]; then
                sudo add-apt-repository universe -y
            elif [ "$DISTRO" = "arch" ]; then
                echo "No equivalent package for Arch Linux"
            elif [ "$DISTRO" = "opensuse" ]; then
                echo "No equivalent package for OpenSUSE"
            fi
            ;;
        3)
            if [ "$DISTRO" = "fedora" ]; then
                sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
            elif [ "$DISTRO" = "ubuntu" ]; then
                sudo add-apt-repository ppa:graphics-drivers/ppa -y
            elif [ "$DISTRO" = "arch" ]; then
                sudo pacman -Syu
                sudo pacman -S --needed base-devel
            elif [ "$DISTRO" = "opensuse" ]; then
                sudo zypper addrepo -f https://download.opensuse.org/repositories/multimedia:/apps/openSUSE_Tumbleweed/ multimedia
                sudo zypper refresh
            fi
            ;;
        4)
            if [ "$DISTRO" = "fedora" ]; then
                sudo dnf groupupdate core -y
                sudo dnf groupupdate multimedia -y
                sudo dnf groupupdate sound-and-video -y
            elif [ "$DISTRO" = "ubuntu" ]; then
                sudo apt install ubuntu-restricted-extras -y
            elif [ "$DISTRO" = "arch" ]; then
                echo "No equivalent package for Arch Linux"
            elif [ "$DISTRO" = "opensuse" ]; then
                sudo zypper install patterns-openSUSE-enhanced_base patterns-openSUSE-multimedia patterns-openSUSE-multimedia_opt
            fi
            ;;
        5)
            if [ "$DISTRO" = "fedora" ]; then
                sudo dnf install rpmfusion-free-release-tainted -y
                sudo dnf install rpmfusion-nonfree-release-tainted -y
                sudo dnf install \*-firmware -y
                sudo dnf install terminator firefox celluloid libreoffice btop gnome-shell f33-backgrounds gnome-tweaks gnome-extensions-app gnome-shell-extension-appindicator gnome-shell-extension-freon gnome-disk-utility gnome-software nemo wine steam variety blender solaar -y
            elif [ "$DISTRO" = "ubuntu" ]; then
                sudo apt install terminator firefox celluloid libreoffice btop gnome-shell gnome-tweaks gnome-extensions-app gnome-shell-extension-appindicator gnome-disk-utility gnome-software nemo wine steam variety blender solaar -y
            elif [ "$DISTRO" = "arch" ]; then
                sudo pacman -S terminator firefox celluloid libreoffice-fresh btop gnome-shell gnome-tweaks gnome-extensions-app gnome-shell-extension-appindicator gnome-disk-utility gnome-software nemo wine steam variety blender solaar --noconfirm
            elif [ "$DISTRO" = "opensuse" ]; then
                sudo zypper install terminator firefox celluloid libreoffice btop gnome-shell gnome-tweaks gnome-extensions-app gnome-shell-extension-appindicator gnome-disk-utility gnome-software nemo wine steam variety blender solaar -y
            fi
            ;;
        6)
            if [ "$DISTRO" = "fedora" ]; then
                sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
                sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
                sudo sh -c 'echo -e "[teams]\nname=teams\nbaseurl=https://packages.microsoft.com/yumrepos/ms-teams\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/teams.repo'
                sudo dnf check-update
                sudo dnf install code teams libcxx kdenlive gimp -y
            elif [ "$DISTRO" = "ubuntu" ]; then
                sudo apt install wget gpg -y
                wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
                sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
                sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
                sudo apt update
                sudo apt install code teams libcxx kdenlive gimp -y
            elif [ "$DISTRO" = "arch" ]; then
                sudo pacman -S code teams libcxx kdenlive gimp --noconfirm
            elif [ "$DISTRO" = "opensuse" ]; then
                sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
                sudo zypper addrepo https://packages.microsoft.com/yumrepos/vscode vscode
                sudo zypper addrepo https://packages.microsoft.com/yumrepos/ms-teams teams
                sudo zypper refresh
                sudo zypper install code teams libcxx kdenlive gimp -y
            fi
            ;;
        7)
            if [ "$DISTRO" = "fedora" ]; then
                flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
                flatpak update
                flatpak install spotify
            elif [ "$DISTRO" = "ubuntu" ]; then
                sudo apt install flatpak -y
                flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
                flatpak update
                flatpak install spotify
            elif [ "$DISTRO" = "arch" ]; then
                sudo pacman -S flatpak --noconfirm
                flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
                flatpak update
                flatpak install spotify
            elif [ "$DISTRO" = "opensuse" ]; then
                sudo zypper install flatpak -y
                flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
                flatpak update
                flatpak install spotify
            fi
            ;;
        8)
            if [ "$DISTRO" = "fedora" ]; then
                sudo systemctl set-default graphical.target
                sudo reboot
            elif [ "$DISTRO" = "ubuntu" ]; then
                sudo systemctl set-default graphical.target
                sudo reboot
            elif [ "$DISTRO" = "arch" ]; then
                sudo systemctl set-default graphical.target
                sudo reboot
            elif [ "$DISTRO" = "opensuse" ]; then
                sudo systemctl set-default graphical.target
                sudo reboot
            fi
            ;;
        9)
            if [ "$DISTRO" = "fedora" ]; then
                sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
                sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge
                sudo dnf install microsoft-edge-stable -y
            elif [ "$DISTRO" = "ubuntu" ]; then
                sudo apt install wget gpg -y
                wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
                sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
                sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/edge.list'
                sudo apt update
                sudo apt install microsoft-edge-stable -y
            elif [ "$DISTRO" = "arch" ]; then
                yay -S microsoft-edge-stable-bin --noconfirm
            elif [ "$DISTRO" = "opensuse" ]; then
                sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
                sudo zypper addrepo https://packages.microsoft.com/yumrepos/edge edge
                sudo zypper refresh
                sudo zypper install microsoft-edge-stable -y
            fi
            ;;
        10)
            if [ "$DISTRO" = "fedora" ]; then
                sudo dnf install steam -y
            elif [ "$DISTRO" = "ubuntu" ]; then
                sudo apt install steam -y
            elif [ "$DISTRO" = "arch" ]; then
                sudo pacman -S steam --noconfirm
            elif [ "$DISTRO" = "opensuse" ]; then
                sudo zypper install steam -y
            fi
            ;;
        11)
            if [ "$DISTRO" = "fedora" ]; then
                sudo dnf install fedora-workstation-repositories -y
                sudo dnf config-manager --set-enabled google-chrome
                sudo dnf install google-chrome-stable -y
            elif [ "$DISTRO" = "ubuntu" ]; then
                wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
                sudo apt install ./google-chrome-stable_current_amd64.deb -y
            elif [ "$DISTRO" = "arch" ]; then
                yay -S google-chrome --noconfirm
            elif [ "$DISTRO" = "opensuse" ]; then
                sudo zypper addrepo https://dl.google.com/linux/direct/google-chrome.repo
                sudo zypper refresh
                sudo zypper install google-chrome-stable -y
            fi
            ;;
        12)
            if [ "$DISTRO" = "fedora" ]; then
                sudo dnf install nvtop -y
            elif [ "$DISTRO" = "ubuntu" ]; then
                sudo apt install nvtop -y
            elif [ "$DISTRO" = "arch" ]; then
                sudo pacman -S nvtop --noconfirm
            elif [ "$DISTRO" = "opensuse" ]; then
                sudo zypper install nvtop -y
            fi
            ;;
        13)
            if [ "$DISTRO" = "fedora" ]; then
                sudo dnf install btop -y
            elif [ "$DISTRO" = "ubuntu" ]; then
                sudo apt install btop -y
            elif [ "$DISTRO" = "arch" ]; then
                sudo pacman -S btop --noconfirm
            elif [ "$DISTRO" = "opensuse" ]; then
                sudo zypper install btop -y
            fi
            ;;
        14)
            if [ "$DISTRO" = "fedora" ]; then
                sudo dnf install wine -y
            elif [ "$DISTRO" = "ubuntu" ]; then
                sudo apt install wine -y
            elif [ "$DISTRO" = "arch" ]; then
                sudo pacman -S wine --noconfirm
            elif [ "$DISTRO" = "opensuse" ]; then
                sudo zypper install wine -y
            fi
            ;;
        15)
            if [ "$DISTRO" = "fedora" ]; then
                sudo dnf install akmod-nvidia -y
                sudo dnf install xorg-x11-drv-nvidia-cuda -y
            elif [ "$DISTRO" = "ubuntu" ]; then
                sudo apt install nvidia-driver-460 -y
                sudo apt install nvidia-cuda-toolkit -y
            elif [ "$DISTRO" = "arch" ]; then
                sudo pacman -S nvidia nvidia-utils cuda --noconfirm
            elif [ "$DISTRO" = "opensuse" ]; then
                sudo zypper install nvidia-computeG05 nvidia-gfxG05-kmp-default nvidia-glG05 nvidia-settings nvidia-xconfig cuda -y
            fi
            ;;
        16)
            dialog --clear --title "Choose a desktop environment" \
            --menu "Select an option:" 15 50 5 \
            1 "Gnome" \
            2 "KDE" \
            3 "Cinnamon" \
            4 "COSMIC" \
            5 "XFCE" 2>tempfile

            de_choice=$(<tempfile)
            echo "User selected desktop environment: $de_choice"
            rm -f tempfile

            disable_existing_dm

            case $de_choice in
                1)
                    if [ "$DISTRO" = "fedora" ]; then
                        sudo dnf groupinstall "GNOME Desktop Environment" -y
                        sudo systemctl enable gdm
                        sudo systemctl set-default graphical.target
                    elif [ "$DISTRO" = "ubuntu" ]; then
                        sudo apt install ubuntu-gnome-desktop -y
                        sudo systemctl enable gdm3
                        sudo systemctl set-default graphical.target
                    elif [ "$DISTRO" = "arch" ]; then
                        sudo pacman -S gnome gnome-extra --noconfirm
                        sudo systemctl enable gdm
                        sudo systemctl set-default graphical.target
                    elif [ "$DISTRO" = "opensuse" ]; then
                        sudo zypper install -t pattern gnome gnome_basic
                        sudo systemctl enable gdm
                        sudo systemctl set-default graphical.target
                    fi
                    ;;
                2)
                    if [ "$DISTRO" = "fedora" ]; then
                        install_desktop_environment "kde" \
                            "dnf groupinstall 'KDE Plasma Workspaces' -y" \
                            "sddm"
                    elif [ "$DISTRO" = "ubuntu" ]; then
                        install_desktop_environment "kde" \
                            "apt install kubuntu-desktop -y" \
                            "sddm"
                    elif [ "$DISTRO" = "arch" ]; then
                        install_desktop_environment "kde" \
                            "pacman -S plasma kde-applications --noconfirm" \
                            "sddm"
                    elif [ "$DISTRO" = "opensuse" ]; then
                        install_desktop_environment "kde" \
                            "zypper install -t pattern kde kde_plasma" \
                            "sddm"
                    fi
                    ;;
                3)
                    if [ "$DISTRO" = "fedora" ]; then
                        install_desktop_environment "cinnamon" \
                            "dnf groupinstall 'Cinnamon Desktop' -y" \
                            "lightdm"
                    elif [ "$DISTRO" = "ubuntu" ]; then
                        install_desktop_environment "cinnamon" \
                            "apt install cinnamon-desktop-environment -y" \
                            "lightdm"
                    elif [ "$DISTRO" = "arch" ]; then
                        install_desktop_environment "cinnamon" \
                            "pacman -S cinnamon --noconfirm" \
                            "lightdm"
                    elif [ "$DISTRO" = "opensuse" ]; then
                        install_desktop_environment "cinnamon" \
                            "zypper install cinnamon" \
                            "lightdm"
                    fi
                    ;;
                4)
                    if [ "$DISTRO" = "arch" ]; then
                        # Check if yay is installed for AUR access
                        if ! command -v yay >/dev/null 2>&1; then
                            echo "Installing yay AUR helper..."
                            sudo pacman -S --needed git base-devel
                            git clone https://aur.archlinux.org/yay.git
                            cd yay && makepkg -si --noconfirm
                            cd .. && rm -rf yay
                        fi
                        install_desktop_environment "cosmic" \
                            "yay -S cosmic-desktop --noconfirm" \
                            "gdm"
                    else
                        echo "COSMIC is only available for Arch Linux"
                        logger "Attempted COSMIC installation on unsupported distro: $DISTRO"
                        sleep 2
                    fi
                    ;;
                5)
                    if [ "$DISTRO" = "fedora" ]; then
                        install_desktop_environment "xfce" \
                            "dnf groupinstall 'Xfce Desktop' -y" \
                            "lightdm"
                    elif [ "$DISTRO" = "ubuntu" ]; then
                        install_desktop_environment "xfce" \
                            "apt install xubuntu-desktop -y" \
                            "lightdm"
                    elif [ "$DISTRO" = "arch" ]; then
                        install_desktop_environment "xfce" \
                            "pacman -S xfce4 xfce4-goodies --noconfirm" \
                            "lightdm"
                    elif [ "$DISTRO" = "opensuse" ]; then
                        install_desktop_environment "xfce" \
                            "zypper install -t pattern xfce xfce_basis" \
                            "lightdm"
                    fi
                    ;;
                *)
                    echo "Invalid option"
                    ;;
            esac
            ;;
        17)
            exit 0
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
}

# Add this function near the top of the file, after detect_distro()
install_desktop_environment() {
    local de_name=$1
    local install_cmd=$2
    local display_manager=$3

    # Log installation start
    logger "Starting installation of $de_name desktop environment"
    echo "Installing $de_name desktop environment..."

    # Install display manager package if needed
    if [ "$display_manager" = "lightdm" ]; then
        echo "Installing LightDM display manager..."
        case "$DISTRO" in
            fedora) sudo dnf install lightdm -y ;;
            ubuntu) sudo apt install lightdm -y ;;
            arch) sudo pacman -S lightdm lightdm-gtk-greeter --noconfirm ;;
            opensuse) sudo zypper install lightdm -y ;;
        esac
    fi

    # Install desktop environment
    if ! eval "sudo $install_cmd"; then
        logger "Failed to install $de_name"
        echo "Failed to install $de_name"
        return 1
    fi

    echo "Configuring display manager..."
    disable_existing_dm
    if ! sudo systemctl enable "$display_manager"; then
        logger "Failed to enable $display_manager"
        echo "Failed to enable $display_manager"
        return 1
    fi

    # Verify installation
    if ! command -v "$de_name" >/dev/null 2>&1; then
        logger "Warning: $de_name binary not found in PATH"
        echo "Warning: Installation completed but $de_name not found in PATH"
    fi

    echo "Setting default target..."
    if ! sudo systemctl set-default graphical.target; then
        logger "Failed to set graphical target"
        echo "Failed to set graphical target"
        return 1
    fi

    logger "$de_name installation completed successfully"
    echo "$de_name installation completed successfully"
    sleep 2
    return 0
}

# Main script
detect_distro
while true; do
    show_menu
    install_components $choice
done

# Clear the screen on exit
clear
