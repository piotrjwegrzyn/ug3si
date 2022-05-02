#!/bin/bash -i
#
# Ultimate GNS3 server installer for Linux host machines
#
# Uninstall script
# Gets:
# * $1 = runtime location path
# * $2 = bridge interface name
#
# Author: Piotr J. Węgrzyn
# GitHub: https://github.com/piotrjwegrzyn/ug3si


set -e

# Environment params
gns3path=$1
gns3bridge=$2
gns3shortcut=~/.local/share/applications/gns3server.desktop

echo "GNS3 server uninstaller"

echo "Removing associate files and shortcut..."
rm -rf $gns3path
rm $gns3shortcut

echo "Removing network..."
sudo virsh net-destroy --network $gns3bridge
sudo virsh net-undefine --network $gns3bridge

echo "Uninstalled successfully"
