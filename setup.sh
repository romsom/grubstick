TARGET="$1"
DEVICE=$(grep "$TARGET" /proc/mounts | cut -d' ' -f1)
LABEL=$(lsblk "$DEVICE" -n --output LABEL)
echo "Install config file in device \"$DEVICE\" with label \"$LABEL\" mounted at \"$TARGET\""
# TODO check 0-length target
echo "Copy files"
cp -avr boot "$TARGET/"
mkdir -p "$TARGET/boot/iso"
echo "Patch files"
sed -e"s/__FS_LABEL__/$LABEL/g" "$TARGET/boot/grub/grub.cfg.in" > "$TARGET/boot/grub/grub.cfg"
echo "Done"
echo ""
echo "Put your ISOs in \"$TARGET/boot/iso\" and edit \"$TARGET/boot/grub/grub.cfg\" accordingly"
echo "Have fun booting :)"
