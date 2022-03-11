grubstick
=========

Grub configfile and instructions to turn any USB drive into a multiboot drive.

The goal is to preserve the the filesystem of the usb drive as it is, to that you can still carry your data and less advanced pieces of software (e.g. Windows) is still able to access it.

# Instructions
## Disclaimer
Be sure to always check what the setup script says it will do.
There is no warranty. Even if the script says it will write to the correct block device, it might still delete your data.
(But I highly doubt it.)
**You are solely responsible for your actions, not me, nor anyone else!**


Note: You need a recent Linux distribution with the following tools installed:
    - grub2 (grub-install) for x86 and x86_64
	- jq
	- sed
	- lsblk

## Give your USB drive a label
Give it a unique label so grub can find it when booting.
If there is another partition with the same label as grub looks for in your computer, grub will pick a random one and will try to read its config from it.
Sarcastic bonus points if there is a grub config on the other device. ;)
Under Linux you can use the following command:
`sudo dosfslabel PATH_TO_DEVICE LABEL_FOR_DEVICE`

## Mount the USB drive

## Run the setup script
`./setup.sh PATH_TO_USB_MOUNT_POINT`
The script will try to find all the needed information to copy the config file and install grub.
It will ask you to confirm the directories and block devices it figured out.
Check if they are correct and only press "y" if they are correct.
If all went well it'll wish you a fun booting time, if it didn't it'll try to give you hints on what went wrong.
