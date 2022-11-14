#!/bin/bash -i
#
# Ultimate GNS3 server installer for Linux host machines
#
# Wireshark installation script
#
# Author: Piotr J. Węgrzyn
# GitHub: https://github.com/piotrjwegrzyn/ug3si


set -e

echo "Installing Wireshark..."
platform=$(hostnamectl | grep -ioE "ubuntu|mint|fedora|arch|manjaro" | head -1 | awk '{ print tolower($0) }')
case $platform in
    ubuntu | mint)
        echo "Determined platform: Ubuntu or Linux Mint"
		echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections
		sudo apt update
		sudo DEBIAN_FRONTEND=noninteractive apt install -y wireshark
		yes yes | sudo DEBIAN_FRONTEND=teletype dpkg-reconfigure wireshark-common
        ;;
    fedora)
        echo "Determined platform: Fedora"
		sudo dnf --setopt=install_weak_deps=False --best -y install wireshark
        ;;
    arch | manjaro)
        echo "Determined platform: Arch or Manjaro"
		sudo pacman -S --noconfirm --needed wireshark-qt
        ;;
    *)
        echo "Undetermined platform"
		exit 1
        ;;
esac

echo "Adding user to Wireshark group..."
sudo usermod -a -G wireshark $USER
echo "Please re-login to your system to apply changes"
