#!/bin/bash -i

# Environment params
gns3ip=10.10.10.10
gns3path=/home/$USER/GNS3/

# bridge interface name
gns3bridge=gns3bridge

# VM params
gns3mem=8G		# RAM size
gns3maxmem=16G	# maximum size of RAM+swap
gns3cores=4		# CPU cores


echo "GNS3 server startup"

if [[ ! $(ip link show tap-gns3vm) ]]
then
	echo "Creating TAP interface..."
 	sudo ip tuntap add dev tap-gns3vm mode tap user $(whoami)
	echo "Done."
	echo "Setting up TAP interface..."
	sudo ip link set tap-gns3vm up
	echo "Done"
 	echo "Adding TAP interface to bridge..."
 	sudo brctl addif $gns3bridge tap-gns3vm
	echo "Done"
else
	echo "TAP interface detected. Removing from bridge..."
	sudo brctl delif $gns3bridge tap-gns3vm
	sleep 1
	echo "Done"
	echo "Resetting up TAP interface..."
	sudo ip link set tap-gns3vm down
	sleep 1
	sudo ip link set tap-gns3vm up
	echo "Done"
 	echo "Adding TAP interface to bridge..."
 	sudo brctl addif $gns3bridge tap-gns3vm
	echo "Done"
fi

ps aux | grep "GNS3" | grep -v "grep" > /dev/null
if [[ $? -eq 0 ]]
then
	echo "GNS3 server is detected as running"
else
	echo "Starting GNS3 server..."
	sleep 1

	qemu-system-x86_64 -name "GNS3 server" -m $gns3mem,maxmem=$gns3maxmem -cpu host \
	-smp cores=$gns3cores -enable-kvm -machine smm=off -boot order=c \
	-drive file=$gns3path"GNS3 VM-disk001.qcow2",if=virtio,index=0,media=disk \
	-drive file=$gns3path"GNS3 VM-disk002.qcow2",if=virtio,index=1,media=disk \
	-device virtio-net-pci,netdev=nic0 \
	-netdev tap,id=nic0,ifname=tap-gns3vm,script=no,downscript=no \
	-display none -daemonize ;

fi

sleep 1
echo "Checking reachability..."
i=8
while :
do
	sleep 1
	echo "."
	((i--))
	ping -q -c 1 $gns3ip > /dev/null
	if [[ $? -eq 0 ]]
	then
		break
	fi
	if [[ $i -eq 0 ]]
	then
		echo "GNS3 server is unreachable"
		exit 1
	fi
done

echo "Done"
echo "Login to GNS3 server via ssh..."
ssh -A gns3@$gns3ip

