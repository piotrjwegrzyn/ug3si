# ug3si
Ultimate GNS3 server installer for Linux host machines

## Info
This repository was created as a sample configuration for GNS3 server setup.
Currently `config.sh` supports only Ubuntu (22.04).

All scripts are 'self-descriptive' so you can check and modify to run it on another Linux platform.

### Files
* `config.sh` – downloading tools and configuring virtual network bridge for GNS3 server
* `gns3bridge.xml` – virtual network bridge configuration file for **virsh** 
* `startup.sh` – startup script to run GNS3 server

## Configuration
### Step 1 - collect all files
Download this repository and move all files to `~/GNS3` folder.

Next download [GNS.VM.KVM zip archive](https://github.com/GNS3/gns3-gui/releases) and extract all `.qcow2` files to `~/GNS3`.

### Step 2 - configure host machine
Open `config.sh` file and execute commands.

### Step 3 - run GNS3 server
If previous steps executed correctly `startup.sh` will start GNS3 server with 10.10.10.10 ip address. You can move this file and `.qcow2` files to another location and create desktop shortcut.