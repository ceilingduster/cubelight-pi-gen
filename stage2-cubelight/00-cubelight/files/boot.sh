#!/bin/sh
ifconfig lo 127.0.0.1 up
wpa_supplicant -Dnl80211 -iwlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf -B

# if mode=2 in wpa_supplicant, run AP, otherwise run client script
if grep -q mode=2 "/etc/wpa_supplicant/wpa_supplicant.conf"; then
	ifconfig wlan0 192.168.0.1 netmask 255.255.255.0
	busybox udhcpd -I 192.168.0.1 /etc/udhcpd.conf
else
        /usr/local/bin/display-text.sh "`iwgetid`"
	busybox udhcpc -i wlan0 -s /etc/udhcpc.script
	ntpdate ca.pool.ntp.org
fi
/usr/local/bin/display-text.sh "`ip addr show dev wlan0 | sed -nr 's/.*inet ([^ ]+).*/\1/p'`"
/usr/local/bin/runscript.sh
cd /cubelight-python/
python3 non-threading-main.py
