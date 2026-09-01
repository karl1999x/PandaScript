#!/bin/sh
ip -s -s neigh flush all &> /dev/null
ip neigh flush dev $(ip route | grep default | awk '{print $5}' | head -1) &> /dev/null
echo 3 > /proc/sys/vm/drop_caches
echo > /var/log/messages
echo > /var/log/kern.log
echo > /var/log/daemon.log
echo > /var/log/kern.log
echo > /var/log/dpkg.log
echo > /var/log/syslog
echo 3 > /proc/sys/vm/drop_caches 1> /dev/null 2> /dev/null
swapoff -a && swapon -a 1> /dev/null 2> /dev/null
killall usercodes > /dev/null 2>&1
killall menu_inst > /dev/null 2>&1
killall kswapd0 > /dev/null 2>&1
echo $(free -h | grep Mem | sed 's/\s\+/,/g' | cut -d , -f4) > /bin/ejecutar/raml