#!/bin/bash -i
#
# Ultimate GNS3 server installer for Linux host machines
#
# Tools and programs installer
#
# Author: Piotr J. Węgrzyn
# GitHub: https://github.com/piotrjwegrzyn/ug3si


set -e

# installing required tools for runtime
echo "Installing runtime tools..."
platform=$(hostnamectl | grep -ioE "ubuntu|mint|fedora|arch|manjaro" | head -1 | awk '{ print tolower($0) }')
case $platform in
    ubuntu | mint)
        echo "Determined platform: $platform"
		sudo add-apt-repository --yes ppa:gns3/ppa
		sudo apt update                                
		sudo apt install -y curl qemu-kvm bridge-utils libvirt-daemon-system gns3-gui telnetd
        ;;
    fedora)
        echo "Determined platform: $platform"
		sudo dnf --setopt=install_weak_deps=False --best -y install curl qemu-kvm bridge-utils libvirt gns3-gui telnet xterm
        ;;
    arch | manjaro)
        echo "Determined platform: $platform"
		sudo pacman -S --noconfirm --needed curl qemu bridge-utils libvirt base-devel wget yajl
		git clone https://aur.archlinux.org/gns3-gui.git
		cd gns3-gui
		makepkg -si
		cd ..
        ;;
    *)
        echo "Undetermined platform"
		echo "To finish installation install qemu-kvm, gns3-gui, bridge-utils, libvirt-daemon-system and telnet"
		echo "After installation run networksetup.sh and filessetup.sh"
		exit 1
        ;;
esac
