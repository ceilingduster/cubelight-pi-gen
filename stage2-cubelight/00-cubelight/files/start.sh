#!/bin/sh
cat /dev/urandom > /dev/fb0
modprobe i2c_bcm2835
modprobe rtc_ds1307
modprobe brcmfmac

mkdir -p /dev/pts
mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -o rw /dev/mmcblk0p1 /boot
mount -o remount,rw /
mount -t devpts devpts /dev/pts

/usr/local/bin/boot.sh &
dropbear -p 0.0.0.0:22 -j -k -g -w -R -c /bin/sh
/sbin/agetty tty1 115200 -a root
