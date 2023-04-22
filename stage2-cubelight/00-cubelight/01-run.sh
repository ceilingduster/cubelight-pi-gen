#!/bin/bash -e

install -v -d                                   "${ROOTFS_DIR}/etc/wpa_supplicant"
install -v -m 600 files/wpa_supplicant.conf     "${ROOTFS_DIR}/etc/wpa_supplicant/"

. "${BASE_DIR}/config"
on_chroot << EOF
echo -n "${FIRST_USER_NAME:='cubelight'}:" > /boot/userconf.txt
openssl passwd -5 "${FIRST_USER_PASS:='cubelight'}" >> /boot/userconf.txt
touch /boot/ssh

echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
export DEBIAN_FRONTEND=noninteractive
EOF

install -m 644 files/config.txt "${ROOTFS_DIR}/boot/"
install -m 644 files/cmdline.txt "${ROOTFS_DIR}/boot/"
install -m 644 files/udhcpd.conf "${ROOTFS_DIR}/etc/"
install -m 644 files/interfaces "${ROOTFS_DIR}/etc/network/"
install -m 755 files/start.sh "${ROOTFS_DIR}/"
install -m 755 files/boot.sh "${ROOTFS_DIR}/usr/local/bin"
install -m 755 files/demo "${ROOTFS_DIR}/usr/local/bin"
install -m 755 files/display-text.sh "${ROOTFS_DIR}/usr/local/bin"
install -m 755 files/runscript.sh "${ROOTFS_DIR}/usr/local/bin"
install -m 755 files/scroll-text "${ROOTFS_DIR}/usr/local/bin"
install -m 755 files/firstboot.sh "${ROOTFS_DIR}/"
install -m 755 files/set-time.sh "${ROOTFS_DIR}/"
install -m 755 files/udhcpc.script "${ROOTFS_DIR}/etc/"

git clone https://github.com/ceilingduster/cubelight-python "${ROOTFS_DIR}/cubelight-python"

touch "${ROOTFS_DIR}/var/lib/misc/udhcpd.leases"

cp files/sudoers "${ROOTFS_DIR}/etc/sudoers"

cat >> "${ROOTFS_DIR}/etc/wpa_supplicant/wpa_supplicant.conf" << EOL

network={
        ssid="${WPA_ESSID}"
        mode=2
        key_mgmt=NONE
}
EOL
