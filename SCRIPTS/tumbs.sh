#!/bin/bash
#Autor: Henry Chumo 
#Alias : ChumoGH
# -*- ENCODING: UTF-8 -*-

# verificacion primarias

rm -f /tmp/*

echo " ====================================== "
echo " ======== ENTRANDO EN $1 ========= "
echo " ====================================== "
#[[ -z $(cat /etc/crontab | grep ejecutar) ]] && {


fun_limpram() {
	sync
	echo 3 >/proc/sys/vm/drop_caches
	sync && sysctl -w vm.drop_caches=3
	sysctl -w vm.drop_caches=0
	swapoff -a
	swapon -a
	[[ -e /etc/v2ray/config.json ]] && v2ray clean >/dev/null 2>&1 &
	[[ -e /etc/xray/config.json ]] && v2ray clean >/dev/null 2>&1 &
	killall kswapd0 >/dev/null 2>&1 &
	killall tcpdump >/dev/null 2>&1 &
	killall ksoftirqd >/dev/null 2>&1 &
	#apt purge rsyslog -y > /dev/null 2>&1
	rm -f /var/log/*.log.* 
	[[ -e /var/log/auth.log ]] && echo "@ChumoGH "> /var/log/auth.log
	rm -f /var/log/*.1
	systemctl restart rsyslog.service
	systemctl restart systemd-journald.service
	service dropbear stop > /dev/null 2>&1
	service sshd restart > /dev/null 2>&1
	service dropbear restart > /dev/null 2>&1
	#killall systemd-journald
[[ -e /etc/fipv6 ]] || {
sed -i "/net.ipv6.conf/d" /etc/sysctl.conf
touch /etc/fipv6
}
[[ -z $(grep -w "net.ipv6.conf" /etc/sysctl.conf) ]] && {
echo -e 'net.ipv6.conf.all.disable_ipv6=1
net.ipv6.conf.default.disable_ipv6=1' >> /etc/sysctl.conf
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1 
sysctl -w net.ipv6.conf.lo.disable_ipv6=1
} || {
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1 
sysctl -w net.ipv6.conf.lo.disable_ipv6=1
}
sysctl -p /etc/sysctl.conf &>/dev/null
	echo "DONE" > /etc/fixrsyslog
}
function aguarde() {
	sleep 1
	helice() {
		fun_limpram >/dev/null 2>&1 &
		tput civis
		while [ -d /proc/$! ]; do
			for i in / - \\ \|; do
				sleep .1
				echo -ne "\e[1D$i"
			done
		done
		tput cnorm
	}
	echo -ne "\033[1;37m Reconstruyendo \033[1;32mLOGS de \033[1;37me \033[1;32m USERS\033[1;32m.\033[1;33m.\033[1;31m. \033[1;33m"
	helice
	echo -e "\e[1DOk"
}

function task_exists() {
    local task="$1"
    grep -qF "$task" /etc/crontab
}

function checkON () {
clear&&clear
tittle
read -rp "INTERVALO DE EJECUCION EN HORAS (6, 12 o 24): " interval
msg -bar3
echo -ne "VALIDANDO EXISTENCIAS DE DUMMPERS"
awk '!a[$0]++' /etc/crontab > /etc/crontab.temp
mv /etc/crontab.temp /etc/crontab
echo -e "\033[1;32m DONE \n" && msg -bar3
sed -i "/automatizar.sh/d" /etc/crontab && sed -i "/gnula.sh/d" /etc/crontab

case $interval in
    6|12|24)
echo -ne " COMPILANDO BINARIO DE AUTOPTIMIZACIONES "
if wget https://raw.githubusercontent.com/ChumoGH/ADMcgh/main/Plugins/Extras/$(uname -m)/killram.sh &>/dev/null -O /etc/ADMcgh/bin/CleanCache &>/dev/null ; then
echo -e "\033[1;32m DONE \n" && msg -bar3 
chmod +x /etc/ADMcgh/bin/CleanCache
[[ -e /bin/automatizar.sh  ]] && rm -f /bin/automatizar.sh
ln -s /etc/ADMcgh/bin/CleanCache /bin/automatizar.sh &>/dev/null
if ! task_exists "/bin/automatizar.sh"; then
    echo "0 */$interval * * *	root	bash /bin/automatizar.sh" | sudo tee -a /etc/crontab
fi
tput cuu1 && tput dl1
else
echo -e "\033[1;31m FAIL \n" && msg -bar3 
rm -f /bin/automatizar.sh
sleep 2s
return
fi

echo -ne " COMPILANDO BINARIO DE AUTOPLIMPIEZAS "
if wget https://www.dropbox.com/s/x6fp9f14ob1i5ez/gnula.sh &>/dev/null -O /etc/ADMcgh/bin/ServiceRestart &>/dev/null ; then
echo -e " \033[1;32m DONE \n" && msg -bar3 
chmod +x /etc/ADMcgh/bin/ServiceRestart &>/dev/null
[[ -e /bin/gnula.sh ]] && rm -f /bin/gnula.sh
ln -s /etc/ADMcgh/bin/ServiceRestart /bin/gnula.sh &>/dev/null
if ! task_exists "/bin/gnula.sh"; then
    echo "0 */$interval * * *	root bash /bin/gnula.sh" | sudo tee -a /etc/crontab
fi
tput cuu1 && tput dl1
else
echo -e " \033[1;31m FAIL \n" && msg -bar3 
rm -f /bin/gnula.sh
sleep 2s
return
fi


echo -ne "COMPILANDO LIBERACIONES DE LOGS Y BUGS"
if wget https://www.dropbox.com/scl/fi/hz5po9qozo8k91gr8vz5k/cleanup-logs.sh?rlkey=dayb0x5dvwrobvobizasterqc &>/dev/null -O /etc/ADMcgh/bin/cleanup-logs.sh &>/dev/null ; then
echo -e " \033[1;32m DONE \n" && msg -bar3 
chmod +x /etc/ADMcgh/bin/cleanup-logs.sh &>/dev/null
[[ -e /usr/local/bin/cleanup-logs.sh ]] && rm -f /usr/local/bin/cleanup-logs.sh
ln -s /etc/ADMcgh/bin/cleanup-logs.sh /usr/local/bin/cleanup-logs.sh &>/dev/null
echo -e '[Unit]
Description=Cleanup journals, logs and /etc/http-shell

[Service]
Type=oneshot
ExecStart=/usr/local/bin/cleanup-logs.sh
' > /etc/systemd/system/cleanup-logs.service

echo -e '[Unit]
Description=Run cleanup-logs every 12 hours

[Timer]
OnBootSec=10min
OnUnitActiveSec=12h
Persistent=true

[Install]
WantedBy=timers.target
' > /etc/systemd/system/cleanup-logs.timer

sudo systemctl enable --now cleanup-logs.timer
tput cuu1 && tput dl1
else
echo -e " \033[1;31m FAIL \n" && msg -bar3 
rm -f /etc/ADMcgh/bin/cleanup-logs.sh /usr/local/bin/cleanup-logs.sh
sleep 2s
return
fi

    ;;
    *)
	interval='24'
echo -ne " COMPILANDO BINARIO DE AUTOPTIMIZACIONES "
if wget https://raw.githubusercontent.com/ChumoGH/ADMcgh/main/Plugins/Extras/$(uname -m)/killram.sh &>/dev/null -O /etc/ADMcgh/bin/CleanCache &>/dev/null ; then
echo -e "\033[1;32m DONE \n" && msg -bar3 
chmod +x /etc/ADMcgh/bin/CleanCache
[[ -e /bin/automatizar.sh  ]] && rm -f /bin/automatizar.sh
ln -s /etc/ADMcgh/bin/CleanCache /bin/automatizar.sh &>/dev/null
if ! task_exists "/bin/automatizar.sh"; then
    echo "0 */$interval * * *	root	bash /bin/automatizar.sh" | sudo tee -a /etc/crontab
fi
tput cuu1 && tput dl1
else
echo -e "\033[1;31m FAIL \n" && msg -bar3 
rm -f /bin/automatizar.sh
sleep 2s
return
fi

echo -ne " COMPILANDO BINARIO DE AUTOPLIMPIEZAS "
if wget https://www.dropbox.com/s/x6fp9f14ob1i5ez/gnula.sh &>/dev/null -O /etc/ADMcgh/bin/ServiceRestart &>/dev/null ; then
echo -e " \033[1;32m DONE \n" && msg -bar3 
chmod +x /etc/ADMcgh/bin/ServiceRestart &>/dev/null
[[ -e /bin/gnula.sh ]] && rm -f /bin/gnula.sh
ln -s /etc/ADMcgh/bin/ServiceRestart /bin/gnula.sh &>/dev/null
if ! task_exists "/bin/gnula.sh"; then
    echo "0 */$interval * * *	root bash /bin/gnula.sh" | sudo tee -a /etc/crontab
fi
tput cuu1 && tput dl1
else
echo -e " \033[1;31m FAIL \n" && msg -bar3 
rm -f /bin/gnula.sh
sleep 2s
return
fi

echo -ne "COMPILANDO LIBERACIONES DE LOGS Y BUGS"
if wget https://www.dropbox.com/scl/fi/hz5po9qozo8k91gr8vz5k/cleanup-logs.sh?rlkey=dayb0x5dvwrobvobizasterqc &>/dev/null -O /etc/ADMcgh/bin/cleanup-logs.sh &>/dev/null ; then
echo -e " \033[1;32m DONE \n" && msg -bar3 
chmod +x /etc/ADMcgh/bin/cleanup-logs.sh &>/dev/null
[[ -e /usr/local/bin/cleanup-logs.sh ]] && rm -f /usr/local/bin/cleanup-logs.sh
ln -s /etc/ADMcgh/bin/cleanup-logs.sh /usr/local/bin/cleanup-logs.sh &>/dev/null
echo -e '[Unit]
Description=Cleanup journals, logs and /etc/http-shell

[Service]
Type=oneshot
ExecStart=/usr/local/bin/cleanup-logs.sh
' > /etc/systemd/system/cleanup-logs.service

echo -e '[Unit]
Description=Run cleanup-logs every 12 hours

[Timer]
OnBootSec=10min
OnUnitActiveSec=12h
Persistent=true

[Install]
WantedBy=timers.target
' > /etc/systemd/system/cleanup-logs.timer

sudo systemctl enable --now cleanup-logs.timer
tput cuu1 && tput dl1
else
echo -e " \033[1;31m FAIL \n" && msg -bar3 
rm -f /etc/ADMcgh/bin/cleanup-logs.sh /usr/local/bin/cleanup-logs.sh
sleep 2s
return
fi
;;
esac

# Añadir tarea autoboot si no existe (solo una vez)
autoboot_task="* * * * * root bash /bin/autoboot"
if ! task_exists "$autoboot_task"; then
    echo "$autoboot_task" | sudo tee -a /etc/crontab
fi

service cron restart >/dev/null 2>&1
systemctl enable cron &>/dev/null
systemctl start cron &>/dev/null
#cat /etc/crontab | tail -n5
rm -f /root/cron
#msg -azu " Tarea programada cada $(msg -verd "[ $(crontab -l|grep 'ejecutar'|awk '{print $2}'|sed $'s/[^[:alnum:]\t]//g')HS ]")"
msg -azu " Tarea programada cada $(msg -verd "$interval HORAS")"
sudo journalctl --vacuum-size=100M &>/dev/null
#[[ -e /etc/systemd/system/autoStart.service ]] && echo -e " TAREA DE LOOP DE AUTOREACTIVACION CREADA "
[[ -e /bin/autoboot ]] && chmod +x /bin/autoboot
}

function checkOFF () {
rm -f /bin/automatizar.sh
rm -f /bin/ejecutar/automatizar.sh
rm -f /bin/gnula.sh
rm -f /bin/ejecutar/gnula.sh
#rm -f /bin/autoboot
sed -i "/automatizar.sh/d" /etc/crontab && sed -i "/gnula.sh/d" /etc/crontab
#sed -i "/autoboot/d" /etc/crontab
service cron restart
unset _opti
echo -e " DESACTIVADA DEL SISTEMA CORRECTAMENTE"
#rm -f /etc/fixrsyslog
}

 [[ "$1" = '--start' ]] && {
    checkON
    exit 0
    }
	
 [[ "$1" = '--stop' ]] && {
    checkOFF
    exit 0
    }
rm -rf /usr/.work