#!/bin/bash

# Detect the distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
    else
        echo "Unsupported distribution"
        exit 1
    fi
}

# Function to display the menu
show_menu() {
    echo "Choose components to install:"
    echo "1) Upgrade system"
    echo "2) Install Fedora workstation repositories"
    echo "3) Install RPM Fusion repositories"
    echo "4) Update core, multimedia, and sound-and-video groups"
    echo "5) Install additional packages"
    echo "6) Install Microsoft repositories and packages"
    echo "7) Install Flatpak and Spotify"
    echo "8) Set default target to graphical and reboot"
    echo "9) Install MS Edge"
    echo "10) Exit"
    echo "11) Install Steam"
    echo "12) Install Google Chrome"
    echo "13) Install NVtop"
    echo "14) Install btop"
    echo "15) Install Wine"
    echo "16) Install Nvidia drivers and CUDA"
    echo "17) Exit"
}

# Function to install selected components
install_components() {
    case $1 in
        1)
            if [ "$DISTRO" = "fedora" ]; then
                sudo dnf upgrade -y
            elif [ "$DISTRO" = "ubuntu" ]; then
                sudo apt update && sudo apt upgrade -y
            elif [ "$DISTRO" = "arch" ]; then
                sudo pacman -Syu
            fi
            ;;
        2)
            if [ "$DISTRO" = "fedora" ]; then
                sudo dnf install fedora-workstation-repositories -y
            elif [ "$DISTRO" = "ubuntu" ]; then
                sudo add-apt-repository universe -y
            elif [ "$DISTRO" = "arch" ]; then
                echo "No equivalent package for Arch Linux"
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
            fi
            ;;
        10)
            exit 0
            ;;
        11)
            if [ "$DISTRO" = "fedora" ]; then
                sudo dnf install steam -y
            elif [ "$DISTRO" = "ubuntu" ]; then
                sudo apt install steam -y
            elif [ "$DISTRO" = "arch" ]; then
                sudo pacman -S steam --noconfirm
            fi
            ;;
        12)
            if [ "$DISTRO" = "fedora" ]; then
                sudo dnf install fedora-workstation-repositories -y
                sudo dnf config-manager --set-enabled google-chrome
                sudo dnf install google-chrome-stable -y
            elif [ "$DISTRO" = "ubuntu" ]; then
                wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
                sudo apt install ./google-chrome-stable_current_amd64.deb -y
            elif [ "$DISTRO" = "arch" ]; then
                yay -S google-chrome --noconfirm
            fi
            ;;
        13)
            if [ "$DISTRO" = "fedora" ]; then
                sudo dnf install nvtop -y
            elif [ "$DISTRO" = "ubuntu" ]; then
                sudo apt install nvtop -y
            elif [ "$DISTRO" = "arch" ]; then
                sudo pacman -S nvtop --noconfirm
            fi
            ;;
        14)
            if [ "$DISTRO" = "fedora" ]; then
                sudo dnf install btop -y
            elif [ "$DISTRO" = "ubuntu" ]; then
                sudo apt install btop -y
            elif [ "$DISTRO" = "arch" ]; then
                sudo pacman -S btop --noconfirm
            fi
            ;;
        15)
            if [ "$DISTRO" = "fedora" ]; then
                sudo dnf install wine -y
            elif [ "$DISTRO" = "ubuntu" ]; then
                sudo apt install wine -y
            elif [ "$DISTRO" = "arch" ]; then
                sudo pacman -S wine --noconfirm
            fi
            ;;
        16)
            if [ "$DISTRO" = "fedora" ]; then
                sudo dnf install akmod-nvidia -y
                sudo dnf install xorg-x11-drv-nvidia-cuda -y
            elif [ "$DISTRO" = "ubuntu" ]; then
                sudo apt install nvidia-driver-460 -y
                sudo apt install nvidia-cuda-toolkit -y
            elif [ "$DISTRO" = "arch" ]; then
                sudo pacman -S nvidia nvidia-utils cuda --noconfirm
            fi
            ;;
        17)
            exit 0
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
}

# Main script
detect_distro
while true; do
    show_menu
    read -p "Enter your choice [1-17]: " choice
    install_components $choice
done
