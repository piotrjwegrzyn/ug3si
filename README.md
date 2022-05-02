# ug3si
Ultimate GNS3 serverinstaller for Linux host machines (Ubuntu/Mint, Fedora and Arch/Manjaro)

Installation is based on QEMU-KVM virtualisation and virsh virtual network.

**KVM is required to complete an installation.**

All scripts are 'self-descriptive' so you can check and modify to run it on another Linux platform.

### Files
* `install.sh` – install script
* `uninstall.sh` – uninstall script (files-and-shortcut-only remover)
* `gns3bridge.xml` – virtual network bridge configuration file for **libvirt**
* `networksetup.sh` – libvirt configuration script
* `runtime.sh` – runtime script to run GNS3 server
* `wiresharkinstaller.sh` – additional app installer for GNS3

## Installation

***IMPORTANT!*** – to adjust server capabilities you have to modify gns3mem,gns3maxmem and gns3cores values at beginning of `runtime.sh` script before an installation (you can modify it later in `~/.gns/` location).

To install GNS3 server just run `install.sh` in terminal – script will automaticly download required files from [GNS3 repository](https://github.com/GNS3/gns3-gui/releases) and create menu shortcut.

### Defaults
* location is in `~/.gns3/` folder
* IP address is `10.10.10.10`
* username/password: `gns3/gns3`

## Usage
After successfull server startup you can open GNS3 GUI app and connect to "remote server" (IP address: `10.10.10.10`, TCP port 80).

Also, you can open browser and just type `10.10.10.10`.

## Uninstall script
Run `uninstall.sh` script to remove server files and menu shortcut.
Packages such as gns3-gui, bride-utils and others will not be uninstaled.

## Additionals
To extend GNS3 functionalities you can install Wireshark (i.e. by using `wiresharkinstaller.sh`)

Moreover, to fasten login to server you can generate ssh-keys and paste it to `~/.ssh/authorized_keys` on GNS3 server (in shell).