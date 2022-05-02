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
		sudo apt update                                
		sudo apt install -y wireshark
        ;;
    fedora)
        echo "Determined platform: Fedora"
		sudo dnf --setopt=install_weak_deps=False --best -y install wireshark
        ;;
    arch | manjaro)
        echo "Determined platform: Arch or Manjaro"
		sudo pacman -S --needed wireshark-qt
        ;;
    *)
        echo "Undetermined platform"
		exit 1
        ;;
esac

echo "Adding user to wireshark group..."
sudo usermod -a -G wireshark $USER

echo "Done"