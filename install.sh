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
gns3path=~/.gns3runtime/
gns3bridge=gns3bridge

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

# install tools and programs
./toolssetup.sh

# configure virtual network
./networksetup.sh $gns3bridge

# configure runtime location for GNS3 server
./filessetup.sh $gns3path $gns3bridge

echo "Installation completed"
echo "Please reboot your system"
