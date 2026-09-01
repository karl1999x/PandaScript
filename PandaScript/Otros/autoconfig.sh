#!/bin/bash
#-----------------------------------------------------------------------

[[ -e /bin/ejecutar/msg ]] && source /bin/ejecutar/msg
[[ -e /etc/adm-lite/cabecalho ]] && source /etc/adm-lite/cabecalho
msg -bar
ADM_inst="/etc/adm-lite" && [[ ! -d ${ADM_inst} ]] && exit
system=$(cat -n /etc/issue |grep 1 |cut -d ' ' -f6,7,8 |sed 's/1//' |sed 's/      //')
vercion=$(echo $system|awk '{print $2}'|cut -d '.' -f1,2)
echo -e "ESPERE UN MOMENTO MIENTRAS FIXEAMOS SU SISTEMA "

fun_upgrade() {
	sync
	echo 3 >/proc/sys/vm/drop_caches
	sync && sysctl -w vm.drop_caches=3
	sysctl -w vm.drop_caches=0
	swapoff -a
	swapon -a
sudo apt install software-properties-common -y &> /dev/null
apt install python2 -y &> /dev/null
	rm -rf /tmp/* > /dev/null 2>&1
	killall kswapd0 > /dev/null 2>&1
	killall tcpdump > /dev/null 2>&1
	killall ksoftirqd > /dev/null 2>&1
	echo > /etc/fixpython
}

function aguarde() {
	sleep .1
	echo -e "SU VERSION DE UBUNTU ${vercion} ES SUPERIOR A 18.04 "
	helice() {
		fun_upgrade >/dev/null 2>&1 &
		tput civis
		while [ -d /proc/$! ]; do
			for i in / - \\ \|; do
				sleep .1
				echo -ne "\e[1D$i"
			done
		done
		tput cnorm
	}
	echo -ne "\033[1;37m OPTIMIZANDO Y \033[1;32mFIXEANDO \033[1;37mPYTHON \033[1;32m.\033[1;32m.\033[1;33m.\033[1;31m. \033[1;33m"
	helice
	echo -e "\e[1DOk"
}

[[ "${vercion}" > "20" ]] && {
echo -e ""
msg -bar
[[ -e /etc/fixpython ]] || aguarde
} || {
echo
	[[ -e /etc/fixpython ]] || { 
	echo -e "	SU VERSION DE UBUNTU ${vercion} ES INFERIOR O 18.04 "
	apt-get install python -y &>/dev/null
	apt-get install python3 -y &>/dev/null
	touch /etc/fixpython
	}
}
clear


#-----------------------------------------------------------------------



blanco(){
	[[ !  $2 = 0 ]] && {
		echo -e "\033[1;37m$1\033[0m"
	} || {
		echo -ne " \033[1;37m$1:\033[0m "
	}
}

col(){

	nom=$(printf '%-55s' "\033[0;92m${1} \033[0;31m>> \033[1;37m${2}")
	echo -e "	$nom\033[0;31m${3}   \033[0;92m${4}\033[0m"
}


vacio(){

	blanco "\n no se puede ingresar campos vacios..."
}

cancelar(){

	echo -e "\n \033[3;49;31minstalacion cancelada...\033[0m"
}

continuar(){

	echo -e " \033[3;49;32mEnter para continuar...\033[0m"
}

fun_bar () {
          comando[0]="$1"
          comando[1]="$2"
          (
          [[ -e $HOME/fim ]] && rm $HOME/fim
          ${comando[0]} > /dev/null 2>&1
          ${comando[1]} > /dev/null 2>&1
          touch $HOME/fim
          ) > /dev/null 2>&1 &
          tput civis
		  echo -e "${col1}---------------------------------------------------${col0}"
          echo -ne "${col7}    ESPERE..${col5}["
          while true; do
          for((i=0; i<18; i++)); do
          echo -ne "${col4}#"
          sleep 0.2s
          done
         [[ -e $HOME/fim ]] && rm $HOME/fim && break
         echo -e "${col5}"
         sleep 1s
         tput cuu1
         tput dl1
         echo -ne "${col7}    ESPERE..${col5}["
         done
         echo -e "${col5}]${col7} -${col2} INSTALADO !${col7}"
         tput cnorm
		 echo -e "${col1}---------------------------------------------------${col0}"
        }
        


function fix_ssl() {
	helice() {
		inst_ssl >/dev/null 2>&1 &
		tput civis
		while [ -d /proc/$! ]; do
			for i in / - \\ \|; do
				sleep .1
				echo -ne "\e[1D$i"
			done
		done
		tput cnorm
	}
	echo -ne "\033[1;37m INSTALANDO  \033[1;32mSTUNNEL (\033[1;37mS\033[1;32mS\033[1;32mL\033[1;33m)\033[1;31m. \033[1;33m"
	helice
	echo -e "\e[1DOk"
}

function fix_py() {
	helice() {
		inst_py >/dev/null 2>&1 &
		tput civis
		while [ -d /proc/$! ]; do
			for i in / - \\ \|; do
				sleep .1
				echo -ne "\e[1D$i"
			done
		done
		tput cnorm
	}
	echo -ne "\033[1;37m INSTALANDO  \033[1;32m PYTHON (\033[1;37mS\033[1;32mO\033[1;32mC\033[1;33mK\033[1;31mS\033[1;33m)\033[1;32m . \033[1;33m"
	helice
	echo -e "\e[1DOk"
}


inst_ssl () {
pkill -f stunnel4
apt purge stunnel4 -y > /dev/null 2>&1
apt install stunnel4 -y > /dev/null 2>&1
echo -e "cert = /etc/stunnel/stunnel.pem\nclient = no\nsocket = a:SO_REUSEADDR=1\nsocket = l:TCP_NODELAY=1\nsocket = r:TCP_NODELAY=1\n\n[stunnel]\naccept = 443\nconnect = 127.0.0.1:80\n" > /etc/stunnel/stunnel.conf
openssl genrsa -out key.pem 2048 > /dev/null 2>&1
(echo "$(curl -sSL ipinfo.io > info && cat info | grep country | awk '{print $2}' | sed -e 's/[^a-z0-9 -]//ig')" ; echo "" ; echo "$(cat < /bin/ejecutar/IPcgh):81" ; echo "" ; echo "" ; echo "" ; echo "@cloudflare" )|openssl req -new -x509 -key key.pem -out cert.pem -days 1095 > /dev/null 2>&1
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
service stunnel4 restart > /dev/null 2>&1
rm -f info key.pem cert.pem
}


inst_py () {
sed -i '/PDirect80.py/d' /bin/autoboot
#msg -bar
	#msg -nama '        Descargando binario Compilado !! '
wget -O $HOME/PDirect80.py 'https://raw.githubusercontent.com/karl1999x/PandaScript/main/PandaScript/Otros/autoconfig-sh/PDirect.py'
screen -dmS "ws80" python2 $HOME/PDirect80.py & > /root/proxy.log 
}

menuintro() {
clear&&clear
msg -bar #echo -e "\033[1;31m———————————————————————————————————————————————————\033[1;37m"
echo -e "\033[1;32m    SSL + ( Payload / Directo )  | by: @ChumoGH "
msg -bar #echo -e "\033[1;31m———————————————————————————————————————————————————\033[1;37m"
echo -e "\033[1;36m        SCRIPT REESTRUCTURA y AUTOCONFIGURACION "
msg -bar #echo -e "\033[1;31m———————————————————————————————————————————————————\033[1;37m"
echo -e "\033[1;37m      Requiere tener el puerto libre 443 y el 80"
msg -bar
echo -e "\033[1;32m  Visita https://t.me/ChumoGH_ADM , para detalles " 
msg -bar
	while :
	do
		#col "5)" "\033[1;33mCONFIGURAR Trojan"
col "1)" "\033[1;33mSSL + (Payload/Directo) - AUTO INSTALL"
		#msg -bar
col "2)" "\033[1;33mCONFIGURAR PYTHON (RESPONSE STATUS 200)"

col "3)" "\033[1;33mRemover AUTOCONFIG (Payload+SSL)"
		msg -bar
		col "0)" "SALIR \033[0;31m"
		msg -bar
		blanco "opcion" 0
		read opcion
		case $opcion in
			1)
			clear&&clear
			source /etc/adm-lite/cabecalho
			msg -nama '        RECONFIGURANDO STUNNEL (SSL) !! '
			echo ''
			fix_ssl
			msg -nama '       RECONFIGURANDO PYTHON SOCKS 80 !! '
			echo ''
			fix_py
			#-------------------------------------------------------------------
			print_center -verd " ${aLerT} VERIFICANDO ACTIVIDAD DE SOCK PYTHON ${aLerT} \n        ${aLerT}  PORVAFOR ESPERE !! ${aLerT} "
autoboot &> /dev/null			
sleep 2s && tput cuu1 && tput dl1
sleep 1s && tput cuu1 && tput dl1

[[ $(ps x | grep "ws80 python2" |grep -v grep ) ]] && {
msg -bar
print_center -verd " REACTIVADOR DE SOCK Python 80 ENCENDIDO "
[[ $(grep -wc "ws80" /bin/autoboot) = '0' ]] && {
						echo -e "netstat -tlpn | grep -w 80 > /dev/null || {  screen -r -S 'ws80' -X quit;  screen -dmS ws80 python2 $HOME/PDirect80.py & >> /root/proxy.log ; }" >>/bin/autoboot
					} || {
						sed -i '/ws80/d' /bin/autoboot
						echo -e "netstat -tlpn | grep -w 80 > /dev/null || {  screen -r -S 'ws80' -X quit;  screen -dmS ws80 python2 $HOME/PDirect80.py & >> /root/proxy.log ; }" >>/bin/autoboot
					}
crontab -l > /root/cron
[[ -z $(cat < /root/cron | grep 'autoboot') ]] && echo "@reboot /bin/autoboot" >> /root/cron || {
	[[ $(grep -wc "autoboot" /root/cron) > "1" ]] && {
			sed -i '/autoboot/d' /root/cron
			echo "@reboot /bin/autoboot" >> /root/cron
		}
}

crontab /root/cron
service cron restart			
sleep 2s && tput cuu1 && tput dl1
} || {
print_center -azu " FALTA ALGUN PARAMETRO PARA INICIAR REACTIVADOR "
sleep 2s && tput cuu1 && tput dl1
return
}
tput cuu1 && tput dl1
msg -bar
[[ $(ps x | grep -w  "PDirect80.py" | grep -v "grep" | awk -F "pts" '{print $1}') ]] && print_center -verd "PYTHON INICIADO CON EXITO!!!" || print_center -ama " ERROR AL INICIAR PYTHON!!!"
msg -bar
sleep 1
			echo -e "                 INSTALACIÓN TERMINADA"
			msg -bar
			echo -e "Solucionado el error de conectividad mediante el puerto $porta con SNI"
			break
			;;
			2)
			source <(curl -sSL https://raw.githubusercontent.com/karl1999x/PandaScript/main/PandaScript/Otros/autoconfig-sh/Proxy.sh)
			;;			
			3)
			kill  $(ps x | grep -w "PDirect80" | grep -v grep | cut -d ' ' -f1) &>/dev/null
			sed -i '/PDirect80/d' /bin/autoboot
			screen -wipe &>/dev/null
			autoboot &>/dev/null
			;;
			0) break;;
			*) blanco "\n selecione una opcion del 0 al 2" && sleep 1;;
		esac
	done
continuar
}
#chekKEY &> /dev/null 2>&1
menuintro

