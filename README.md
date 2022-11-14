# ug3si
Ultimate GNS3 server installer for Linux host machines (Ubuntu/Mint, Fedora and Arch/Manjaro).

Installation is based on QEMU-KVM virtualization and libvirt virtual network.

**KVM is required to complete an installation.**

All scripts are 'self-descriptive' so you can easily check and modify to run for your purpose.

### Files
* `install.sh` – main script, defines runtime path and bridge interface name
* `uninstall.sh $gns3path $gns3bridge` – uninstall script; gets runtime path and bridge name
* `toolssetup.sh` – tools and programs installer
* `networksetup.sh $gns3bridge` – libvirt configuration script; gets bridge interface name
* `gns3bridge.xml` – virtual network bridge interface name (also name of bridge configuration file) for **libvirt**
* `filessetup.sh $gns3path $gns3bridge` – files setup (configures runtime location); gets runtime path and bridge interface name
* `runtime.sh $gns3path $gns3bridge` – runtime script; gets runtime path and bridge interface name
* `wiresharkinstaller.sh` – Wireshark installer (manual run)

## Installation

***IMPORTANT!*** – before installation you should adjust server capabilities (RAM, RAM+swap and CPU cores). To do that modify *gns3mem*, *gns3maxmem* and *gns3cores* values at beginning of `runtime.sh` 

To install GNS3 server just run `install.sh` in terminal – script will automatically download required files from [GNS3 repository](https://github.com/GNS3/gns3-gui/releases), install and create menu shortcut.

In case you are asked if non-super users should be able to do something always choose "Yes".

### Defaults and modifications
* Location: `~/.gns3runtime/` folder
* IP address: `10.10.10.10`
* SSH username/password: `gns3/gns3`

To change default location edit file `install.sh` (it is defined at the beginning).

To modify IP address (what **is not recommended**) you have to modify `gns3bridge.xml` file ([more about libvirt configuration files](https://libvirt.org/formatdomain.html)), determine which IP will be leased to GNS3 server and put it to `runtime.sh` (it is defined at the beginning).

## Usage
To start GNS3 server open menu and find *GNS3 Server* shortcut. While starting it will configure virtual network environment and login via ssh to it (which is not necessary to cooperate with server).
In case you have lost server window you can just relogin by SSH:
```
ssh gns3@10.10.10.10
```

After startup you can open GNS3 app and connect to "remote server" (Host: 10.10.10.10, Port: 80 TCP, Authentication: disabled).

Also, you can open browser and just type `10.10.10.10`.

***IMPORTANT!*** – server will work in a background until you shutdown it manually from server menu or reboot your host system.

## Uninstall script
To remove server files and menu shortcut run:
```
uninstall.sh <RUNTIME_PATH>
```

Packages such as gns3-gui, bride-utils and others will not be uninstalled. You can find packages' names in `toolssetup.sh` if you want to uninstall them manually.

## Additionals
To extend GNS3 functionalities you can install Wireshark (i.e. by using `wiresharkinstaller.sh`).

Moreover, to fasten login to server you can generate ssh-keys and paste it to `~/.ssh/authorized_keys` on GNS3 server (by *Shell* in a server menu).
