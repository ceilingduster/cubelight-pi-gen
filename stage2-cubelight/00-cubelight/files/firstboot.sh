#!/bin/sh
cat /dev/urandom > /dev/fb0
mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -o rw /dev/mmcblk0p1 /boot

ROOT_PART_DEV=$(findmnt / -o source -n)
ROOT_PART_NAME=$(echo "$ROOT_PART_DEV" | cut -d "/" -f 3)
ROOT_DEV_NAME=$(echo /sys/block/*/"${ROOT_PART_NAME}" | cut -d "/" -f 4)
ROOT_DEV="/dev/${ROOT_DEV_NAME}"
ROOT_PART_NUM=$(cat "/sys/block/${ROOT_DEV_NAME}/${ROOT_PART_NAME}/partition")
ROOT_DEV_SIZE=$(cat "/sys/block/${ROOT_DEV_NAME}/size")
TARGET_END=$((ROOT_DEV_SIZE - 1))

echo "Resizing root filesystem ... $ROOT_DEV $ROOT_PART_NAME $ROOT_DEV_SIZE"
if ! parted -m "$ROOT_DEV" u s resizepart "$ROOT_PART_NUM" "$TARGET_END"; then
  FAIL_REASON="Partition table resize of the root partition ($ROOT_PART_DEV) failed\n$FAIL_REASON"
  return 1
fi

mount -o remount,rw /
resize2fs "$ROOT_PART_DEV" > /dev/null 2>&1
RET="$?"
if [ "$RET" -ne 0 ]; then
  FAIL_REASON="Root partition resize failed\n$FAIL_REASON"
fi
mount -o remount,rw /
mount /boot -o remount,rw

sed -i 's|init=/firstboot.sh|init=/start.sh|' /boot/cmdline.txt
sync
reboot -f
