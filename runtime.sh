#!/bin/bash -i
#
# Ultimate GNS3 server installer for Linux host machines
#
# Runtime script
# Gets:
# * $1 = runtime location path
# * $2 = bridge interface name
#
# Author: Piotr J. Węgrzyn
# GitHub: https://github.com/piotrjwegrzyn/ug3si


# Environment params:
# * gns3ip = ip address
# * gns3path = location of runtime files
# * gns3bridge = bridge interface (libvirt interface)
# * gns3tap = tap interface (attached to bridge)
gns3ip=10.10.10.10
gns3path=$1
gns3bridge=$2
gns3tap=gns3tap

# VM params:
# * gns3mem = RAM size
# * gns3maxmem = maximum size of RAM+swap (gns3maxmem >= gns3mem)
# * gns3cores = CPU cores
gns3mem=8G
gns3maxmem=16G
gns3cores=4

echo "GNS3 server runner"

ps aux | grep "GNS3" | grep -v "grep" > /dev/null
if [ $? -eq 0 ];
then
	echo "GNS3 server is detected as running"
else
	echo "Starting libvirtd..."
	sudo systemctl start libvirtd

	ip link show $gns3tap > /dev/null
	if [ $? -ne 0 ];
	then
		echo "Configuring virtual network..."
		# creating tap interface
		sudo ip tuntap add dev $gns3tap mode tap user $(whoami)
		# setting up tap interface
		sudo ip link set $gns3tap up
		# adding tap interface to bridge
		sudo brctl addif $gns3bridge $gns3tap
	else
		echo "Recovering virtual network..."
		# removing tap interface from bridge
		sudo brctl delif $gns3bridge $gns3tap
		sleep 1
		# setting down and up tap interface
		sudo ip link set $gns3tap down
		sleep 1
		sudo ip link set $gns3tap up
		# adding tap interface to bridge
		sudo brctl addif $gns3bridge $gns3tap
	fi

	echo "Starting GNS3 server..."

	qemu-system-x86_64 -name "GNS3 server" -m $gns3mem,maxmem=$gns3maxmem -cpu host \
	-smp cores=$gns3cores -enable-kvm -machine smm=off -boot order=c \
	-drive file=$gns3path"GNS3 VM-disk001.qcow2",if=virtio,index=0,media=disk \
	-drive file=$gns3path"GNS3 VM-disk002.qcow2",if=virtio,index=1,media=disk \
	-device virtio-net-pci,netdev=nic0 \
	-netdev tap,id=nic0,ifname=$gns3tap,script=no,downscript=no \
	-display none -daemonize ; sleep 1

fi

echo "Checking reachability..."
i=8
while :
do
	sleep 1
	echo "."
	i=$((i--))
	ping -q -c 1 $gns3ip > /dev/null
	if [ $? -eq 0 ];
	then
		break
	fi
	if [ $i -eq 0 ];
	then
		echo "GNS3 server is unreachable"
		exit 1
	fi
done

echo "Login to GNS3 server via ssh..."
ssh -A gns3@$gns3ip
