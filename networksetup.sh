#!/bin/bash -i
#
# Ultimate GNS3 server installer for Linux host machines
#
# Virtual network setup script
#
# Author: Piotr J. Węgrzyn
# GitHub: https://github.com/piotrjwegrzyn/ug3si

set -e

# Environment params
gns3bridge=gns3bridge

echo "Setting up virtual network..."
sudo usermod -a -G libvirt $USER
sudo virsh net-define --file $gns3bridge.xml
sudo virsh net-autostart $gns3bridge
sudo virsh net-start $gns3bridge

if [[ $? -ne 0 ]]
then
    echo "Error while setting up virtual network"
    exit 1
fi
