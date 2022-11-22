#!/bin/bash
#Starting from a Fedora Minimal install
sudo dnf upgrade
sudo dnf install fedora-workstation-repositories -y
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
sudo dnf groupupdate core -y
sudo dnf groupupdate multimedia -y
sudo dnf groupupdate sound-and-video -y
sudo dnf install rpmfusion-free-release-tainted -y
sudo dnf install rpmfusion-nonfree-release-tainted -y
sudo dnf install \*-firmware -y
sudo dnf install terminator -y
sudo dnf install firefox -y
sudo dnf install celluloid -y
sudo dnf install libreoffice -y
sudo dnf install btop -y
sudo dnf install gnome-shell gnome-tweaks gnome-shell-extension gnome-shell extension-appindicator gnome-shell-theme-selene -y
sudo dnf install gnome-shell-extention-freon gnome-disk-utility gnome-software -y
sudo dnf install nemo -y
sudo dnf install wine -y
sudo dnf install steam -y
sudo dnf install variety -y
sudo dnf install blender -y
sudo dnf install solaar -y
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo sh -c 'echo -e "[teams]\nname=teams\nbaseurl=https://packages.microsoft.com/yumrepos/ms-teams\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/teams.repo'
dnf check-update
sudo dnf install code -y
sudo dnf install teams -y
sudo dnf install libcxx kdenlive gimp -y 
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak update
flatpak install spotify
sudo systemctl set-default graphical.target
sudo reboot
