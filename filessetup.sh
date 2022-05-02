#!/bin/bash -i
#
# Ultimate GNS3 server installer for Linux host machines
#
# Files setup script
# Gets:
# * $1 = runtime location path
# * $2 = bridge interface name
#
# Author: Piotr J. Węgrzyn
# GitHub: https://github.com/piotrjwegrzyn/ug3si


set -e

# Environment params
gns3repository=https://github.com/GNS3/gns3-gui/releases/latest
gns3shortcut=~/.local/share/applications/gns3server.desktop
gns3path=$1
gns3bridge=$2

# find current version of GNS3
gns3version=$(curl -L -s -H 'Accept: application/json' $gns3repository | sed -e 's/.*"tag_name":"v\([^"]*\)".*/\1/')
gns3url="https://github.com/GNS3/gns3-gui/releases/download/v$gns3version/GNS3.VM.KVM.$gns3version.zip"
echo "The latest version of GNS3 server is v$gns3version"

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

# unzip disk files
echo "Unpacking disk files... (that may takes a while)"
unzip -d $gns3path $gns3version.zip "*.qcow2"
if [ $? -ne 0 ];
then
	echo "Error while unpacking disk files"
	exit 1
else
	rm $gns3version.zip
fi

# create menu shortcut
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
Exec= sh '"$gns3path"'runtime.sh '"$gns3path $gns3bridge"'
Path='"$gns3path"'
Terminal=true
Actions=
Categories=Education;
Keywords=simulator;network;netsim;' > $gns3shortcut
