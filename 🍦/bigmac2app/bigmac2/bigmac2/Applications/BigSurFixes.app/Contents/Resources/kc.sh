#/bin/sh

mount -uw /
mount -P 1
mount -P 2
chown -R 0:0 /System/Library/Extensions/
chmod -R 755 /System/Library/Extensions/
chown -R 0:0 /Library/Extensions/
chmod -R 755 /Library/Extensions/
echo "Rebuilding new BigSur kernel caches..."
kextcache -i /
kmutil install --update-all
kcditto
echo "Done, you can type reboot"
