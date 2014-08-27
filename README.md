grubstick
=========

Grub configfile and instructions to turn any USB drive into a multiboot drive.

The goal is to preserve the the filesystem of the usb drive as it is, to that you can still carry your data and less advanced pieces of software (e.g. Windows) is still able to access it.

#Instructions

Be always sure to use the correct device files and mountpoints.
The commands used below are meant to install the grub bootloader onto your usb drive, but can also install it on your hard drive, if told to do so, and overwrite your old bootloader. In that case your PC probably won't boot up anymore.
**You are yourself responsible for your actions, not me, nor anyone else!**


Note: You need a recent Linux distribution with grub2 installed (e.g. Arch or Manjaro LIVE CDs)

#####Copy the directory "boot" from this repo to you USB Drive
#####Edit boot/grub/grub.cfg:
     set the value of "partition_label" to your drives label
#####Install grub
######(as root, hence the "#". You can also use sudo)
	# grub-install --target=i386-pc --boot-directory=/*mountpoint of your usb drive*/ --no-floppy --recheck /dev/*device file of your usb drive*/
######Note: the device file to be specified must be like /dev/sdx and NOT /dev/sdx1.
        # grub-install --target=x86_64-efi --boot-directory==/*mountpoint of your usb drive*/ --efi-directory==/*mountpoint of your usb drive*/ --no-floppy --removable --recheck

####Hints:
#####To find your drives device file you can use following tools:
 * lsblk
 * blkid
 * mount
...

Compare attributes like size, label and partition layout to find the drive you want.

#####To find the mountpoint you can either open it in your graphical File Manager, or use one of the following commands:
 * mount
 * mount | grep *device file*

It will probably be like /media/... or /run/media/*username*/...