TARGET="$1"
if [[ "n$TARGET" = "n" ]]; then
    echo "Usage: $0 PATH_TO_USB_MOUNT_POINT"
    exit 1
fi

DEVICE=$(grep "$TARGET " /proc/mounts | cut -d' ' -f1) # "$TARGET " incl. space to avoid false positives
if [[ "n$DEVICE" = "n" ]]; then
    echo "Not a valid mount point: \"$TARGET\""
    echo "Usage: $0 PATH_TO_USB_MOUNT_POINT"
    exit 1
fi

lsblk $DEVICE > /dev/null
if [[ $? -ne 0 ]]; then
    echo "Directory must be mounted to a block device"
    exit 1
fi

DEVICE_NAME=$(basename "$DEVICE")
DEVICE_PATH=$(dirname "$DEVICE")

PARENT_DEVICE="$DEVICE_PATH/"$(lsblk --tree --output NAME --json | jq -r '{"children": .["blockdevices"]} | recurse(.children[]; .children != null) | if (.children | any(.["name"] == "'$DEVICE_NAME'")) then .["name"] else null end' | grep -v null)
if [[ "n$PARENT_DEVICE" = "n" ]]; then
    PARENT_DEVICE="$DEVICE" # use device itself if it has no parent
fi
LABEL=$(lsblk "$DEVICE" -n --output LABEL)
if [[ "n$DEVICE" = "n" ]]; then
    echo "Device \"$DEVICE\" doesn't have a label, please give it one first."
    exit 1
fi

# Sanity check before performing any action
echo "Install config file in device \"$DEVICE\" with label \"$LABEL\" mounted at \"$TARGET\""
echo "Install grub-i386 to device \"$PARENT_DEVICE\" and grub-x86_64 to \"$TARGET/EFI\""

read -p "Do you want to continue? [yN]" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then

echo "Copy files"
cp -avr boot "$TARGET/"
mkdir -p "$TARGET/boot/iso"
echo "Patch files"
sed -e"s/__FS_LABEL__/$LABEL/g" "$TARGET/boot/grub/grub.cfg.in" > "$TARGET/boot/grub/grub.cfg"
echo "Install GRUB"
sudo grub-install --target=x86_64-efi --boot-directory="$TARGET" --efi-directory="$TARGET" --no-floppy --recheck --removable
sudo grub-install --target=i386-pc --boot-directory="$TARGET" --no-floppy --recheck "$PARENT_DEVICE"

echo "Done"
echo ""
# TODO remove edit instruction when grub config discovers images itself
echo "Now put your ISOs in \"$TARGET/boot/iso\" and then edit \"$TARGET/boot/grub/grub.cfg\" accordingly"
echo "Have fun booting :)"

fi
