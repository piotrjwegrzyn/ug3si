#!/bin/bash -i
#
# Ultimate GNS3 server installer for Linux host machines
#
# Install script
#
# Author: Piotr J. Węgrzyn
# GitHub: https://github.com/piotrjwegrzyn/ug3si


set -e

# Environment params
gns3repository=https://github.com/GNS3/gns3-gui/releases/latest
gns3path=/home/$USER/.gns3runtime/
gns3shortcut=~/.local/share/applications/gns3server.desktop

echo "GNS3 server installer"

# check KVM support
kvm_support=$(grep -E "vmx|svm|0xc0f" /proc/cpuinfo | wc -l)
if [ $kvm_support -ne 0 ];
then
	echo "KVM supported"
else
	echo "KVM not supported, installation will not work correctly"
fi

# check internet connection
ping -q -c 1 1.1.1.1 > /dev/null
if [ $? -ne 0 ];
then
	echo "Connection error"
	exit 1
fi

# installing required tools for runtime
echo "Installing runtime tools..."
platform=$(hostnamectl | grep -ioE "ubuntu|mint|fedora|arch|manjaro" | head -1 | awk '{ print tolower($0) }')
case $platform in
    ubuntu | mint)
        echo "Determined platform: Ubuntu or Linux Mint"
		sudo add-apt-repository --yes ppa:gns3/ppa
		sudo apt update                                
		sudo apt install -y curl qemu-kvm bridge-utils libvirt-daemon-system gns3-gui telnetd
        ;;
    fedora)
        echo "Determined platform: Fedora"
		sudo dnf --setopt=install_weak_deps=False --best -y install curl qemu-kvm bridge-utils libvirt gns3-gui telnet
        ;;
    arch | manjaro)
        echo "Determined platform: Arch or Manjaro"
		sudo pacman -S --needed curl qemu bridge-utils libvirt base-devel git wget yajl
		git clone https://aur.archlinux.org/gns3-gui.git
		cd gns3-gui
		makepkg -si
		cd ..
        ;;
    *)
        echo "Undetermined platform"
		echo "To finish installation install qemu-kvm, gns3-gui, bridge-utils, libvirt-daemon-system and telnetd"
		echo "After installation run networksetup.sh script"
		exit 1
        ;;
esac

# configure virtual network
./networksetup.sh

# find current version of GNS3
gns3version=$(curl -L -s -H 'Accept: application/json' $gns3repository | sed -e 's/.*"tag_name":"v\([^"]*\)".*/\1/')
echo "Current verision of GNS3 server is $gns3version"
gns3url="https://github.com/GNS3/gns3-gui/releases/download/v$gns3version/GNS3.VM.KVM.$gns3version.zip"

# download
echo "Downloading..."
curl -L -o $gns3version.zip $gns3url
if [ $? -ne 0 ];
then
	echo "Error while downloading"
	exit 1
fi

# move files to runtime location
mkdir -p $gns3path
chmod +x ./runtime.sh
cp ./runtime.sh $gns3path

# extract server files
echo "Extracting server files (that may takes a while)..."
unzip -d $gns3path $gns3version.zip "*.qcow2"
if [ $? -ne 0 ];
then
	echo "Error while extracting server files"
	exit 1
else
	rm $gns3version.zip
fi

# create shortcut
echo "Creating menu shortcut..."
touch $gns3shortcut
chmod +x $gns3shortcut
echo $'#!/usr/bin/env xdg-open
[Desktop Entry]
version=1.1
Type=Application
Name=GNS3 Server
Comment=GNS3 server
Icon=application-x-gns3project
Exec= sh '"$gns3path"'runtime.sh
Path='"$gns3path"'
Terminal=true
Actions=
Categories=Education;
Keywords=simulator;network;netsim;' >> $gns3shortcut

echo "Done, reboot your system"