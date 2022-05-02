#!/bin/bash -i
#
# Ultimate GNS3 server installer for Linux host machines
#
# Uninstall script
#
# Author: Piotr J. Węgrzyn
# GitHub: https://github.com/piotrjwegrzyn/ug3si


set -e

# Environment params
gns3path=/home/$USER/.gns3runtime/
gns3shortcut=~/.local/share/applications/gns3server.desktop
gns3bridge=gns3bridge

echo "GNS3 server uninstaller"

echo "Removing associate files and shortcut..."
rm -rf $gns3path
rm $gns3shortcut

echo "Removing network..."
sudo virsh net-destroy --network $gns3bridge
sudo virsh net-undefine --network $gns3bridge

echo "Done"