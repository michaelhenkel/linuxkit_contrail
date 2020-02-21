#!/bin/sh
function failed {
	printf "Kernel module test suite FAILED\n"
	/sbin/poweroff -f
}

uname -a
modinfo /tmp/vrouter.ko || failed
insmod /tmp/vrouter.ko || failed
[ -n "$(dmesg | grep -o 'vrouter')" ] || failed
#rmmod vrouter || failed
mac=$(cat /sys/class/net/eth0/address)
/usr/bin/vif --create vhost0 --mac $mac
/usr/bin/vif --add eth0 --mac $mac --vrf 0 --vhost-phys --type physical
/usr/bin/vif --add vhost0 --mac $mac --vrf 0 --type vhost --xconnect eth0
ip link set dev vhost0 up
printf "Kernel module test suite PASSED\n"

#/sbin/poweroff -f
