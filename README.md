
![Logo](https://i.postimg.cc/VN7xP0c7/woodeploy-Cropped-1.jpg)







╔╦═╦╗───╔══╗
║║║║╠═╦═╬╗╗╠═╦═╦╗╔═╦╦╗
║║║║║╬║╬╠╩╝║╩╣╬║╚╣╬║║║
╚═╩═╩═╩═╩══╩═╣╔╩═╩═╬╗║
─────────────╚╝────╚═╝
### Description
This project deploys a WordPress environment with integrated WooCommerce, ready to use with pre-imported product data and initialized database.

### Deployment
To deploy this project:
1. Make sure Docker is installed on your machine.
2. Clone this directory and navigate to the project folder.
3. Follow the installation instructions


### Installation Instructions

To launch the deployment, run the `deploy.sh` script.

### Setup for Windows Users
If you are on Windows and need to deploy the project within an Ubuntu environment, follow these steps to set up Ubuntu using VirtualBox:

#### Step 1: Download and Install VirtualBox

Open the powershell terminal with admin rights

Execute the PowerShell script below to download and install VirtualBox on your Windows machine. This will allow you to create a virtual machine (VM) to run Ubuntu.

```powershell
# Download VirtualBox
Write-Output "Downloading VirtualBox..."
Invoke-WebRequest -Uri "https://download.virtualbox.org/virtualbox/6.1.34/VirtualBox-6.1.34-150636-Win.exe" -OutFile "$env:TEMP\VirtualBoxInstaller.exe"

# Install VirtualBox
Write-Output "Installing VirtualBox..."
Start-Process -FilePath "$env:TEMP\VirtualBoxInstaller.exe" -Args "/S" -Wait

```

#### Step 2: Download the Ubuntu 20.04 ISO

Download the ISO image for Ubuntu 20.04 LTS to be used for the virtual machine.

```powershell
Write-Output "Downloading Ubuntu 20.04 LTS ISO image..."
Invoke-WebRequest -Uri "https://releases.ubuntu.com/20.04/ubuntu-20.04.4-live-server-amd64.iso" -OutFile "$env:TEMP\ubuntu-20.04.4-live-server-amd64.iso"
```

####  Step 3: Create and Configure the Virtual Machine

Set up a new virtual machine in VirtualBox and configure it to use the downloaded Ubuntu ISO.

```powershell
# Create a new VM
Write-Output "Creating the virtual machine..."
$vmPath = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
& $vmPath createvm --name "Ubuntu20VM" --ostype Ubuntu_64 --register

# Configure VM resources
& $vmPath modifyvm "Ubuntu20VM" --memory 2048 --vram 128 --cpus 2
& $vmPath storagectl "Ubuntu20VM" --name "SATA Controller" --add sata --controller IntelAHCI

# Set up a virtual hard drive
$vmDiskPath = "$env:USERPROFILE\VirtualBox VMs\Ubuntu20VM\Ubuntu20VM.vdi"
& $vmPath createmedium disk --filename $vmDiskPath --size 20480 --format VDI
& $vmPath storageattach "Ubuntu20VM" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $vmDiskPath

# Attach the Ubuntu ISO
& $vmPath storageattach "Ubuntu20VM" --storagectl "SATA Controller" --port 1 --device 0 --type dvddrive --medium "$env:TEMP\ubuntu-20.04.4-live-server-amd64.iso"

```

####  Step 4: Create and Configure the Virtual Machine

Set up a new virtual machine in VirtualBox and configure it to use the downloaded Ubuntu ISO.

```powershell

# Create a new VM
Write-Output "Creating the virtual machine..."
$vmPath = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
& $vmPath createvm --name "Ubuntu20VM" --ostype Ubuntu_64 --register

# Configure VM resources
& $vmPath modifyvm "Ubuntu20VM" --memory 2048 --vram 128 --cpus 2
& $vmPath storagectl "Ubuntu20VM" --name "SATA Controller" --add sata --controller IntelAHCI

# Set up a virtual hard drive
$vmDiskPath = "$env:USERPROFILE\VirtualBox VMs\Ubuntu20VM\Ubuntu20VM.vdi"
& $vmPath createmedium disk --filename $vmDiskPath --size 20480 --format VDI
& $vmPath storageattach "Ubuntu20VM" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $vmDiskPath

# Attach the Ubuntu ISO
& $vmPath storageattach "Ubuntu20VM" --storagectl "SATA Controller" --port 1 --device 0 --type dvddrive --medium "$env:TEMP\ubuntu-20.04.4-live-server-amd64.iso"

``` 
####  Step 4: Start the VM and Install Ubuntu

Finally, start the virtual machine to begin the installation of Ubuntu.

```powerShell
Write-Output "Starting the virtual machine and beginning the installation of Ubuntu..."
& $vmPath startvm "Ubuntu20VM"
```
