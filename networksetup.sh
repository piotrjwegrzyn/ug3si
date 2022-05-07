#!/bin/bash -i
#
# Ultimate GNS3 server installer for Linux host machines
#
# Virtual network setup script
# Gets:
# * $1 = bridge interface name
#
# Author: Piotr J. Węgrzyn
# GitHub: https://github.com/piotrjwegrzyn/ug3si

set -e

# Environment params
gns3bridge=$1

echo "Setting up virtual network..."
# adding user to libvirt group (if not added)
sudo usermod -a -G libvirt $USER
# marking libvirtd as autostart after reboot
sudo systemctl enable libvirtd
sudo systemctl start libvirtd
# configuring virtual bridge interface from file
sudo virsh net-define --file $gns3bridge.xml
# marking as autostart (after reboot)
sudo virsh net-autostart $gns3bridge
sudo virsh net-start $gns3bridge

if [ $? -ne 0 ];
then
    echo "Error while setting up virtual network"
    exit 1
fi
