#!/bin/bash -i

sudo add-apt-repository ppa:gns3/ppa
sudo apt update                                
sudo apt install cpu-checker qemu-kvm bridge-utils libvirt-daemon-system gns3-gui telnetd
sudo ufw allow 23/tcp
sudo adduser $USER libvirt
sudo virsh net-define --file gns3bridge.xml --validate
sudo virsh net-autostart gns3bridge
sudo virsh net-start gns3bridge
sudo reboot
