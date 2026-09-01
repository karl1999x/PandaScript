#!/bin/bash

rm -f /tmp/* &>/dev/null

[[ -e /bin/ejecutar/msg ]] && source /bin/ejecutar/msg || source <(curl -sSL https://raw.githubusercontent.com/ChumoGH/ADMcgh/main/Plugins/system/styles.cpp)
dir_user="./userDIR"
if [[ -e /etc/openvpn/server.conf ]]; then
 if [[ -e /etc/openvpn/openvpn-status.log ]]; then
OPENVPN="on"
 fi
fi

meu_ip () {
  if [[ -e /bin/ejecutar/IPcgh ]]; then
    IP="$(cat /bin/ejecutar/IPcgh)"
  else
    MEU_IP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
    MEU_IP2=$(wget -qO- ipv4.icanhazip.com)
    [[ "$MEU_IP" != "$MEU_IP2" ]] && IP="$MEU_IP2" && echo "$MEU_IP2" || IP="$MEU_IP" && echo "$MEU_IP"
    echo "$MEU_IP2" > /bin/ejecutar/IPcgh
	IP="$MEU_IP2"
  fi
}

paygen () {
meu_ip
valor1="$1" #Entrada Host 
valor2="$IP" #Entrada IP
valor3="$2" #Metodo Requisicao
valor4="$3" #Metodo Conexao
[[ "$valor2" = "" ]] && valor2="127.0.0.1"
#VERIFICA VALOR3
if [ "$valor3" = "1" ]; then
req="GET"
elif [ "$valor3" = "2" ]; then
req="CONNECT"
elif [ "$valor3" = "3" ]; then
req="PUT"
elif [ "$valor3" = "4" ]; then
req="OPTIONS"
elif [ "$valor3" = "5" ]; then
req="DELETE"
elif [ "$valor3" = "6" ]; then
req="HEAD"
elif [ "$valor3" = "7" ]; then
req="TRACE"
elif [ "$valor3" = "8" ]; then
req="PROPATCH"
elif [ "$valor3" = "9" ]; then
req="PATCH"
else
req="GET"
fi
#VERIFICA VALOR4
if [ "$valor4" = "1" ]; then
in="realData"
elif [ "$valor4" = "2" ]; then
in="netData"
elif [ "$valor4" = "3" ]; then
in="raw"
else
in="netData"
fi

name=$(echo $valor1 | awk -F "/" '{print $2'})
[[ "$name" = "" ]] && name=$(echo $valor1 | awk -F "/" '{print $1'})
esquelet="/etc/adm-lite/payloads"
sed -s "s;realData;abc;g" $esquelet > $HOME/$name.txt
sed -i "s;netData;abc;g" $HOME/$name.txt
sed -i "s;raw;abc;g" $HOME/$name.txt
sed -i "s;abc;$in;g" $HOME/$name.txt
sed -i "s;get;$req;g" $HOME/$name.txt
sed -i "s;mhost;$valor1;g" $HOME/$name.txt
sed -i "s;mip;$valor2;g" $HOME/$name.txt
if [[ "$(cat $HOME/$name.txt | egrep -o "$valor1")" = "" ]]; then
rm $HOME/$name.txt
return 1
else
mv -f $HOME/$name.txt $HOME/payloads.txt
return 0
fi
}

ports_ () {
rm -f ./textoports 
unset puertos texto texto_ svcs porta
local texto
local texto_
local puertos
local svcs
local PT=$(lsof -V -i tcp -P -n | grep -v "ESTABLISHED" |grep -v "COMMAND" | grep "LISTEN")
local _ps="$(ps x)"
x=1
for porta in `echo -e "$PT" | cut -d: -f2 | cut -d' ' -f1 | uniq`; do
	[[ -z $porta ]] && continue
	porta[$x]="$porta"
	#echo "$porta - $(echo -e "$PT" | grep -w "$porta" | awk '{print $1}' | uniq | tail -1)"
	svcs[$x]="$(echo -e "$PT" | grep -w "$porta" | awk '{print $1}' | uniq | tail -1)"
	let x++;
done

for((i=1; i<$x; i++)); do
[[ ! -z ${svcs[$i]} ]] && texto=" ${pPIniT} ${svcs[$i]}:  ${porta[$i]}" || texto=''
[[ ${svcs[$i]} = "apache2" ]] && texto=" ${pPIniT} APACHE:  ${porta[$i]}"
[[ ${svcs[$i]} = "nginx" ]] && texto=" ${pPIniT} WEB-NGinx:  ${porta[$i]}"
[[ ${svcs[$i]} = "node" ]] && texto=" ${pPIniT} WebSocket:  ${porta[$i]}"
[[ ${svcs[$i]} = "clash" ]] && texto=" ${pPIniT} Clash:  ${porta[$i]}"
[[ ${svcs[$i]} = "psiphond" ]] && texto=" ${pPIniT} PSIPHON:  ${porta[$i]}"
[[ ${svcs[$i]} = "xray-v2-u" ]] && texto=" ${pPIniT} XRAY/UI:  ${porta[$i]}"
[[ ${svcs[$i]} = "v2-ui" ]] && texto=" ${pPIniT} V2-UI/WEB:  ${porta[$i]}"
[[ ${svcs[$i]} = "xray-linu" ]] && texto=" ${pPIniT} XRAY/UI:  ${porta[$i]}"
[[ ${svcs[$i]} = "x-ui" ]] && texto=" ${pPIniT} XUI/WEB:  ${porta[$i]}"
[[ ${svcs[$i]} = "openvpn" ]] && texto=" ${pPIniT} OPENVPN-TCP:  ${porta[$i]}"
[[ ${svcs[$i]} = "squid" ]] && texto=" ${pPIniT} SQUID:  ${porta[$i]}"
[[ ${svcs[$i]} = "squid3" ]] && texto=" ${pPIniT} SQUID:  ${porta[$i]}"
[[ ${svcs[$i]} = "dropbear" ]] && texto=" ${pPIniT} DROPBEAR:  ${porta[$i]}"
[[ ${svcs[$i]} = "python3" ]] && texto=" ${pPIniT} SOCKS/PYTHON3:  ${porta[$i]}"
[[ ${svcs[$i]} = "python" ]] && texto=" ${pPIniT} SOCKS/PYTHON:  ${porta[$i]}"
[[ ${svcs[$i]} = "obfs-serv" ]] && texto=" ${pPIniT} SSR (OBFS):  ${porta[$i]}"
[[ ${svcs[$i]} = "ss-server" ]] && texto=" ${pPIniT} SSR (LIV):  ${porta[$i]}"
[[ ${svcs[$i]} = "sshd" ]] && texto=" ${pPIniT} SSH: ${porta[$i]}"
[[ ${svcs[$i]} = "ssh" ]] && texto=" ${pPIniT} SSH: ${porta[$i]}"
[[ ${svcs[$i]} = "systemd-r" ]] && texto=" ${pPIniT} System-DNS:  ${porta[$i]}"
[[ ${svcs[$i]} = "stunnel4" ]] && texto=" ${pPIniT} SSL:  ${porta[$i]}"
[[ ${svcs[$i]} = "stunnel" ]] && texto=" ${pPIniT} SSL:  ${porta[$i]}"
[[ ${svcs[$i]} = "v2ray" ]] && texto=" ${pPIniT} V2RAY:  ${porta[$i]}"
[[ ${svcs[$i]} = "xray" ]] && texto=" ${pPIniT} XRAY:  ${porta[$i]}"
[[ ${svcs[$i]} = "badvpn-ud" ]] && texto=" ${pPIniT} BadVPN:  ${porta[$i]}"
[[ ${svcs[$i]} = "trojan" ]] && texto=" ${pPIniT} Trojan-GO:  ${porta[$i]}"
[[ ${svcs[$i]} = "sslh" ]] && texto=" ${pPIniT} SSLH:  ${porta[$i]}"
[[ ${svcs[$i]} = "nc.tradit" ]] && texto=" ${pPIniT} GenADM-Keys: \033[1;33m✔️"
[[ ${svcs[$i]} = "filebrows" ]] && texto=" ${pPIniT} FileBrowser:  ${porta[$i]}"
[[ ${svcs[$i]} = "rpcbind" ]] && texto=" ${pPIniT} RPCBind:  ${porta[$i]}"
[[ ${svcs[$i]} = "snell-ser" ]] && texto=" ${pPIniT} SNell:  ${porta[$i]}"
[[ ${svcs[$i]} = "dns-serve" ]] && texto=" ${pPIniT} SlowDNS:  ${porta[$i]}"
[[ ${svcs[$i]} = "openvpn" ]] && texto=" ${pPIniT} OPENVPN-UDP:  ${porta[$i]}"
[[ ${svcs[$i]} = "udpServer" ]] && texto=" ${pPIniT} UDPServer:  ${porta[$i]}"
[[ ${svcs[$i]} = "hysteria" ]] && texto=" ${pPIniT} HysteriaUDP:  ${porta[$i]}"
[[ ${svcs[$i]} = "UDP-Custo" ]] && texto=" ${pPIniT} UDP-Custom:  ${porta[$i]}"
[[ ${svcs[$i]} = "php" ]] && texto=" ${pPIniT} AToken:  ${porta[$i]}"
    i=$(($i+1))
[[ ! -z ${svcs[$i]} ]] && texto_=" ${pPIniT} ${svcs[$i]}: ${porta[$i]}" || texto_=''
[[ ${svcs[$i]} = "apache2" ]] && texto_=" ${pPIniT} Apache-WEB: ${porta[$i]}"
[[ ${svcs[$i]} = "nginx" ]] && texto_=" ${pPIniT} WEB-NGinx: ${porta[$i]}"
[[ ${svcs[$i]} = "node" ]] && texto_=" ${pPIniT} WebSocket: ${porta[$i]}"
[[ ${svcs[$i]} = "clash" ]] && texto_=" ${pPIniT} Clash: ${porta[$i]}"
[[ ${svcs[$i]} = "psiphond" ]] && texto_=" ${pPIniT} PSIPHON: ${porta[$i]}"
[[ ${svcs[$i]} = "xray-v2-u" ]] && texto_=" ${pPIniT} XRAY/UI: ${porta[$i]}"
[[ ${svcs[$i]} = "v2-ui" ]] && texto_=" ${pPIniT} V2-UI/WEB: ${porta[$i]}"
[[ ${svcs[$i]} = "xray-linu" ]] && texto_=" ${pPIniT} XRAY/UI: ${porta[$i]}"
[[ ${svcs[$i]} = "x-ui" ]] && texto_=" ${pPIniT} XUI/WEB: ${porta[$i]}"
[[ ${svcs[$i]} = "openvpn" ]] && texto_=" ${pPIniT} OPENVPN-TCP: ${porta[$i]}"
[[ ${svcs[$i]} = "squid" ]] && texto_=" ${pPIniT} SQUID: ${porta[$i]}"
[[ ${svcs[$i]} = "squid3" ]] && texto_=" ${pPIniT} SQUID: ${porta[$i]}"
[[ ${svcs[$i]} = "dropbear" ]] && texto_=" ${pPIniT} DROPBEAR: ${porta[$i]}"
[[ ${svcs[$i]} = "python3" ]] && texto_=" ${pPIniT} SOCKS/PYTHON3: ${porta[$i]}"
[[ ${svcs[$i]} = "python" ]] && texto_=" ${pPIniT} SOCKS/PYTHON: ${porta[$i]}"
[[ ${svcs[$i]} = "obfs-serv" ]] && texto_=" ${pPIniT} SSR (OBFS): ${porta[$i]}"
[[ ${svcs[$i]} = "ss-server" ]] && texto_=" ${pPIniT} SSR (LIV): ${porta[$i]}"
[[ ${svcs[$i]} = "sshd" ]] && texto_=" ${pPIniT} SSH: ${porta[$i]}"
[[ ${svcs[$i]} = "ssh" ]] && texto_=" ${pPIniT} SSH: ${porta[$i]}"
[[ ${svcs[$i]} = "systemd-r" ]] && texto_=" ${pPIniT} System-DNS: ${porta[$i]}"
[[ ${svcs[$i]} = "stunnel4" ]] && texto_=" ${pPIniT} SSL: ${porta[$i]}"
[[ ${svcs[$i]} = "stunnel" ]] && texto_=" ${pPIniT} SSL: ${porta[$i]}"
[[ ${svcs[$i]} = "v2ray" ]] && texto_=" ${pPIniT} V2RAY: ${porta[$i]}"
[[ ${svcs[$i]} = "xray" ]] && texto_=" ${pPIniT} XRAY: ${porta[$i]}"
[[ ${svcs[$i]} = "badvpn-ud" ]] && texto_=" ${pPIniT} BadVPN: ${porta[$i]}"
[[ ${svcs[$i]} = "trojan" ]] && texto_=" ${pPIniT} Trojan-GO: ${porta[$i]}"
[[ ${svcs[$i]} = "sslh" ]] && texto_=" ${pPIniT} SSLH: ${porta[$i]}"
[[ ${svcs[$i]} = "nc.tradit" ]] && texto_=" ${pPIniT} GenADM-Keys: \033[1;33m✔️"
[[ ${svcs[$i]} = "filebrows" ]] && texto_=" ${pPIniT} FileBrowser: ${porta[$i]}"
[[ ${svcs[$i]} = "rpcbind" ]] && texto_=" ${pPIniT} RPCBind: ${porta[$i]}"
[[ ${svcs[$i]} = "snell-ser" ]] && texto_=" ${pPIniT} SNell: ${porta[$i]}"
[[ ${svcs[$i]} = "dns-serve" ]] && texto_=" ${pPIniT} SlowDNS: ${porta[$i]}"
[[ ${svcs[$i]} = "openvpn" ]] && texto_=" ${pPIniT} OPENVPN-UDP: ${porta[$i]}"
[[ ${svcs[$i]} = "udpServer" ]] && texto_=" ${pPIniT} UDPServer: ${porta[$i]}"
[[ ${svcs[$i]} = "hysteria" ]] && texto_=" ${pPIniT} HysteriaUDP: ${porta[$i]}"
[[ ${svcs[$i]} = "UDP-Custo" ]] && texto_=" ${pPIniT} UDP-Custom: ${porta[$i]}"
[[ ${svcs[$i]} = "php" ]] && texto_=" ${pPIniT} AToken: ${porta[$i]}"
echo -e "$texto $texto_"  >> ./textoports 
done 
local _PT=$(lsof -V -i UDP -P -n | grep -v "ESTABLISHED" |grep -v "COMMAND"|grep -E 'openvpn|dns-serve|udpServer')
x=1
for porta in `echo -e "$_PT" | cut -d: -f2 | cut -d' ' -f1 | uniq`; do
	[[ -z $porta ]] && continue
	_porta[$x]="$porta"
	_svcs[$x]="$(echo -e "$_PT" | grep -w "$porta" | awk '{print $1}' | uniq | tail -1)"
	let x++;
done
for((i=1; i<$x; i++)); do
[[ ! -z ${_svcs[$i]} ]] && texto=" ${pPIniT} ${_svcs[$i]}: ${_porta[$i]}" || texto=''
[[ ${_svcs[$i]} = "dns-serve" ]] && texto=" ${pPIniT} mSlowDNS: ${_porta[$i]}"
[[ ${_svcs[$i]} = "openvpn" ]] && texto=" ${pPIniT} OPENVPN-UDP: ${_porta[$i]}"
[[ ${_svcs[$i]} = "udpServer" ]] && texto=" ${pPIniT} UDPServer: ${_porta[$i]}"
[[ ${_svcs[$i]} = "hysteria" ]] && texto=" ${pPIniT} HysteriaUDP: ${_porta[$i]}"
[[ ${_svcs[$i]} = "UDP-Custo" ]] && texto=" ${pPIniT} UDP-Custom: ${_porta[$i]}"
i=$(($i+1))
[[ ! -z ${_svcs[$i]} ]] && texto_=" ${pPIniT} ${_svcs[$i]}: ${_porta[$i]}" || texto_=''
[[ ${_svcs[$i]} = "dns-serve" ]] && texto_=" ${pPIniT} SlowDNS: ${_porta[$i]}"
[[ ${_svcs[$i]} = "openvpn" ]] && texto_=" ${pPIniT} OPENVPN-UDP: ${_porta[$i]}"
[[ ${_svcs[$i]} = "udpServer" ]] && texto_=" ${pPIniT} UDPServer: ${_porta[$i]}"
[[ ${_svcs[$i]} = "hysteria" ]] && texto_=" ${pPIniT} HysteriaUDP: ${_porta[$i]}"
[[ ${_svcs[$i]} = "UDP-Custo" ]] && texto_=" ${pPIniT} UDP-Custom: ${_porta[$i]}"
export -f msg+="$texto $texto_\n"
#echo -e "$texto $texto_"  >> ./textoports 
done
}



infovps () {
msg1='•••••••••••••••••••••••••••••••••••••••••••••••••'
meu_ip
ports_
echo -e "Host/IP-Address : $IP\n $msg \n" > ./infovps-txt
echo -e $(cat < ./textoports) >> ./infovps-txt
#echo -e $(cat < ./textoports) >> ./infovps-txt
}

fun_sem () {
sed -e "s;auth-user-pass;<auth-user-pass>\n$1\n$2\n</auth-user-pass>;g" $HOME/$1.ovpn > $HOME/teste.ovpn && mv -f $HOME/teste.ovpn $HOME/$1.ovpn
zip $HOME/$1.zip $HOME/$1.ovpn
rm $HOME/$1.ovpn
}

newclient () {
# Generates the custom client.ovpn
cp /etc/openvpn/client-common.txt ~/$1.ovpn
echo "<ca>" >> ~/$1.ovpn
cat /etc/openvpn/easy-rsa/pki/ca.crt >> ~/$1.ovpn
echo "</ca>" >> ~/$1.ovpn
echo "<cert>" >> ~/$1.ovpn
cat /etc/openvpn/easy-rsa/pki/issued/$1.crt >> ~/$1.ovpn
echo "</cert>" >> ~/$1.ovpn
echo "<key>" >> ~/$1.ovpn
cat /etc/openvpn/easy-rsa/pki/private/$1.key >> ~/$1.ovpn
echo "</key>" >> ~/$1.ovpn
echo "<tls-auth>" >> ~/$1.ovpn
cat /etc/openvpn/ta.key >> ~/$1.ovpn
echo "</tls-auth>" >> ~/$1.ovpn
}

open_1 () {
CLIENT="$1"
senha="$2"
daysrnf="$3"
limit="$4"
sen="$5"
cd /etc/openvpn/easy-rsa/
./easyrsa build-client-full $CLIENT nopass
newclient "$CLIENT"
echo ""
echo "$CLIENT KEY" ~/"$CLIENT.ovpn"
valid=$(date '+%C%y-%m-%d' -d " +$daysrnf days")
datexp=$(date "+%d/%m/%Y" -d "+ $daysrnf days")
useradd -M -s /bin/false -d /home/ovpn/ $CLIENT -e $valid
usermod -p $(openssl passwd -1 $senha) $CLIENT
if [[ "$sen" = "s" || "$sen" = "S" ]]; then
fun_sem $CLIENT $senha 
fi
cd /etc/adm-lite
echo "senha: $senha" > $dir_user/$CLIENT
echo "limite: $limit" >> $dir_user/$CLIENT
echo "data: $valid" >> $dir_user/$CLIENT
}

open_2 () {
CLIENT="$1"
cd /etc/openvpn/easy-rsa/
./easyrsa --batch revoke $CLIENT
./easyrsa gen-crl
rm -rf pki/reqs/$CLIENT.req
rm -rf pki/private/$CLIENT.key
rm -rf pki/issued/$CLIENT.crt
rm -rf /etc/openvpn/crl.pem
cp /etc/openvpn/easy-rsa/pki/crl.pem /etc/openvpn/crl.pem
chown nobody:$GROUPNAME /etc/openvpn/crl.pem
echo ""
userdel --force $CLIENT
cd /etc/adm-lite
if [ -e $dir_user/$CLIENT ]; then
rm $dir_user/$CLIENT
fi
}

function_dropb () {
  if which tput >/dev/null 2>&1; then
      ncolors=$(tput colors)
  fi
  if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    BOLD="$(tput bold)"
    NORMAL="$(tput sgr0)"
  else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    NORMAL=""
  fi
port_dropbear=`ps aux | grep dropbear | awk NR==1 | awk '{print $17;}'`
log=/var/log/auth.log
loginsukses='Password auth succeeded'
clear
printf "${BLUE}${BOLD}"
echo ' '
printf "${NORMAL}"
printf "${BLUE}${BOLD}"
pids=`ps ax |grep dropbear |grep  " $port_dropbear" |awk -F" " '{print $1}'`
for pid in $pids
do
    pidlogs=`grep $pid $log |grep "$loginsukses" |awk -F" " '{print $3}'`
    i=0
    for pidend in $pidlogs
    do
      let i=i+1
    done
    if [ $pidend ];then
       login=`grep $pid $log |grep "$pidend" |grep "$loginsukses"`
       PID=$pid
       user=`echo $login |awk -F" " '{print $10}' | sed -r "s/'/ /g"`
       waktu=`echo $login |awk -F" " '{print $2"-"$1,$3}'`
       while [ ${#waktu} -lt 13 ]; do
           waktu=$waktu" "
       done
       while [ ${#user} -lt 16 ]; do
           user=$user" "
       done
       while [ ${#PID} -lt 8 ]; do
           PID=$PID" "
       done
		printf "${YELLOW}${BOLD}"
       echo "$user $PID $waktu"
		printf "${BLUE}${BOLD}"
    fi
done
echo ""
printf "${NORMAL}"
return
}

fun_ovpn_onl () {
for userovpn in `cat /etc/passwd | grep ovpn | awk -F: '{print $1}'`; do
us=$(cat /etc/openvpn/openvpn-status.log | grep $userovpn | wc -l)
if [ "$us" != "0" ]; then
echo "$userovpn"
fi
done
}



renew () {
local _user="$1"
local _time="$2"
[[ -z $_user ]] && return 1
if cat /etc/passwd |grep -w "${_user}": |grep -vi [a-z]${_user} |grep -v [0-9]${_user} > /dev/null; then
local data=$(cat $dir_user/$_user | grep "data" | awk '{print $2}')
local data_sec=$(date +%s) 
local data_user=$(chage -l "$_user" |grep -i co |awk -F ":" '{print $2}')
# INICIO DE VERIFICACION
local fecha_expiracion=$(chage -l $_user | grep "Password expires" | cut -d: -f2)
local expiracion=$(date -d "$fecha_expiracion" +%s)
local hoy=$(date +%s)
dias_restantes=$(( (expiracion - hoy) / 86400 ))
# FIN NUEVA VERIFICACION
local data_user_sec=$(date +%s --date="$data_user")
local variavel_soma=$((data_user_sec - data_sec))
local dias_use=$(($variavel_soma / 86400)) 

if [[ "$fecha_expiracion" == " never" ]]; then
  echo "La contraseña del usuario $usuario nunca caduca."
  exit 0
fi

[[ $dias_use -ge 0 ]] && {
_time=$(($dias_use + $_time))
}
local limite=$(cat $dir_user/${_user} | grep "limite" | awk '{print $2}')
[[ -z "$limite" ]] && limite="null"
[[ $(passwd --status ${_user}|cut -d ' ' -f2) = "L" ]] && usermod -U ${_user}
local datexp=$(date "+%d/%m/%Y" -d " + ${_time} days")
local valid=$(date '+%C%y-%m-%d' -d " + ${_time} days")
local localtiempo=$((_time + 1))
if chage -E ${valid} ${_user} ; then 
	chage -d ${valid} -M ${localtiempo} ${_user}
fi

local usr_var=$(cat $dir_user/${_user} | grep -v "data")
echo -e "${usr_var}" > $dir_user/${_user}
echo -e "data: $valid" >> $dir_user/${_user}
pkill -u ${_user}
echo -e "${_user} ******** $datexp ${limite}" > /tmp/${_user}.txt
else
return 1
fi
return 0
}

online_fun () {
	local msg="✨━━━━━━━━━━━━━━━━━━━━━✨\n"
		for user in $(grep '/home' /etc/passwd | grep 'false' | grep -v 'syslog' | cut -d: -f1); do
        # conexiones SSH
        local ssh_open=$(pgrep -u "$user" -f "sshd: $user*" | wc -l)
        # conexiones Dropbear
        [[ -e /etc/default/dropbear ]] && ssh_drop=$(function_dropb | grep "$user" | wc -l) || ssh_drop=0
        # conexiones OpenVPN
        [[ -e /etc/openvpn/openvpn-status.log ]] && ssh_ovpn=$(fun_ovpn_onl | grep "$user" | wc -l) || ssh_ovpn=0

        local user_pid=$((ssh_open + ssh_drop + ssh_ovpn))

        if [ "$user_pid" -gt 0 ]; then
            # Validación de HWID o TOKEN
            if [[ ${_limit} =~ ^(HWID|TOKEN)$ ]]; then
			linea=$(cat /etc/passwd | grep -w ${user})
			limite="$(cat /etc/passwd | grep -w ${user} | awk -F ':' '{split($5, a, ","); print a[1]}')"
			if [[ "${linea}" =~ ,([^:]+): ]]; then
					NameTKID="${BASH_REMATCH[1]}"
			fi
                nameFX=${NameTKID}
            else
                nameFX="$user"
            fi

            # Enviar mensaje individual por usuario

			msg+="<b>👤 Usuario: *$nameFX*</code>\n"
			msg+="<b>🔌 Conexiones:_$user_pid_\n"
			msg+="<b>🆔 ID Interno: *$user*\n"
			msg+="✨━━━━━━━━━━━━━━━━━━━━━✨\n"
		fi
    done
	echo -e "${msg}"
}

call.Chat_long_inv () {
ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action typing
    local msg="$1"
    ShellBot.sendMessage --chat_id "${message_chat_id[$id]}" \
						 --reply_to_message_id "${message_message_id[$id]}" \
                         --text "<i>$(echo -e "$msg")</i>" \
                         --parse_mode html
    return 0
}


renew_add () {
local _user="$1"
local _time="$2"
[[ -z $_user ]] && return 1
if cat /etc/passwd |grep -w "${_user}": |grep -vi [a-z]${_user} |grep -v [0-9]${_user} > /dev/null; then
local data=$(cat $dir_user/$_user | grep "data" | awk '{print $2}')
local data_sec=$(date +%s) 
local data_user=$(chage -l "$_user" |grep -i co |awk -F ":" '{print $2}')
# INICIO DE VERIFICACION
local fecha_expiracion=$(chage -l $_user | grep "Password expires" | cut -d: -f2)
local expiracion=$(date -d "$fecha_expiracion" +%s)
local hoy=$(date +%s)
dias_restantes=$(( (expiracion - hoy) / 86400 ))
# FIN NUEVA VERIFICACION
local data_user_sec=$(date +%s --date="$data_user")
local variavel_soma=$((data_user_sec - data_sec))
local dias_use=$(($variavel_soma / 86400)) 

if [[ "$fecha_expiracion" == " never" ]]; then
  echo "La contraseña del usuario $usuario nunca caduca."
  exit 0
fi

[[ $dias_use -ge 0 ]] && {
_time=$(($dias_use + $_time))
}
local limite=$(cat $dir_user/${_user} | grep "limite" | awk '{print $2}')
[[ -z "$limite" ]] && limite="null"
[[ $(passwd --status ${_user}|cut -d ' ' -f2) = "L" ]] && usermod -U ${_user}
local datexp=$(date "+%d/%m/%Y" -d " + ${_time} days")
local valid=$(date '+%C%y-%m-%d' -d " + ${_time} days")
local localtiempo=$((_time + 1))
if chage -E ${valid} ${_user} ; then 
	chage -d ${valid} -M ${localtiempo} ${_user}
fi

local usr_var=$(cat $dir_user/${_user} | grep -v "data")
echo -e "${usr_var}" > $dir_user/${_user}
echo -e "data: $valid" >> $dir_user/${_user}
pkill -u ${_user}
echo -e "${_user} ******** $datexp ${limite}" > /tmp/${_user}.txt
else
return 1
fi
return 0
}

renew () {
local _user="$1"
local _time="$2"
[[ -z $_user ]] && return 1
if cat /etc/passwd |grep -w "${_user}": |grep -vi [a-z]${_user} |grep -v [0-9]${_user} > /dev/null; then
local data=$(cat $dir_user/$_user | grep "data" | awk '{print $2}')
local data_sec=$(date +%s) 
local data_user=$(chage -l "$_user" |grep -i co |awk -F ":" '{print $2}')
# INICIO DE VERIFICACION
local fecha_expiracion=$(chage -l $_user | grep "Password expires" | cut -d: -f2)
local expiracion=$(date -d "$fecha_expiracion" +%s)
local hoy=$(date +%s)
dias_restantes=$(( (expiracion - hoy) / 86400 ))
# FIN NUEVA VERIFICACION
local data_user_sec=$(date +%s --date="$data_user")
local variavel_soma=$((data_user_sec - data_sec))
local dias_use=$(($variavel_soma / 86400)) 

if [[ "$fecha_expiracion" == " never" ]]; then
  echo "La contraseña del usuario $usuario nunca caduca."
fi

[[ $dias_use -ge 0 ]] && {
_time=$(($dias_use + $_time))
}
local limite=$(cat $dir_user/${_user} | grep "limite" | awk '{print $2}')
[[ -z "$limite" ]] && limite="null"
[[ $(passwd --status ${_user}|cut -d ' ' -f2) = "L" ]] && usermod -U ${_user}
local datexp=$(date "+%d/%m/%Y" -d " + ${_time} days")
local valid=$(date '+%C%y-%m-%d' -d " + ${_time} days")
local localtiempo=$((_time + 1))
if chage -E ${valid} ${_user} ; then 
	chage -d ${valid} -M ${localtiempo} ${_user}
fi

local usr_var=$(cat $dir_user/${_user} | grep -v "data")
echo -e "${usr_var}" > $dir_user/${_user}
echo -e "data: $valid" >> $dir_user/${_user}
pkill -u ${_user}
echo -e "${_user} ******** $datexp ${limite}" > /tmp/${_user}.txt
else
return 1
fi
return 0
}

criarusrTK () {
[[ -e /bin/ejecutar/token ]] && passTOKEN=$(less /bin/ejecutar/token) || passTOKEN="ChumoGHPlus"
#[[ -e /etc/adm-lite/liberados ]] && _limC=$(cat /etc/adm-lite/liberados | cut -d '|' -f2)
_name="$1"
_token="$2"
_tiempo="$3"
if cat /etc/passwd |grep ${_token}: |grep -vi [a-z]${_token} |grep -v [0-9]${_token} > /dev/null; then
return 1
fi
if [ "$OPENVPN" = "on" ]; then
open_1 ${_token} ${passTOKEN} $_tiempo 1 s
return 0
else
[[ -z ${newfile} ]] && newfile='n'
[[ -z ${ovpnauth} ]] && ovpnauth='n'
fi
valid=$(date '+%C%y-%m-%d' -d " +${_tiempo} days")
datexp=$(date "+%d/%m/%Y" -d " +${_tiempo} days")
local d_reg=$(( _tiempo + 1 ))
add_new_user "${_token}" "${passTOKEN}" "${d_reg}" "TOKEN" "${newfile}" "${ovpnauth}" "${_name}" &>/dev/null
#if [ $? = 1 ]; then
if [ $(cat /etc/passwd | grep -w ${name}) ]; then
echo "senha: ${_name}" > $dir_user/${_token}
echo "limite: TOKEN" >> $dir_user/${_token}
echo "data: $valid" >> $dir_user/${_token}
echo "${_name} ${_token} ${datexp}" > ./criarusr-txt
fi
return 0
}

_userDEMO () {
[[ -d /etc/usuariosteste ]] || mkdir /etc/usuariosteste
[[ -e /bin/ejecutar/token ]] && passTOKEN=$(less /bin/ejecutar/token) || passTOKEN="ChumoGHPlus"
#[[ -e /etc/adm-lite/liberados ]] && _limC=$(cat /etc/adm-lite/liberados | cut -d '|' -f2)
[[ -z $1 ]] && {
_name="demo-$(date | md5sum | head -c10)"
pass="$(date | md5sum | head -c10)"
} || {
_name=$1
pass=${passTOKEN}
}
_tiempo='2'
if cat /etc/passwd |grep ${_name}: |grep -vi [a-z]${_name} |grep -v [0-9]${_name} > /dev/null; then
return 1
fi
if [ "$OPENVPN" = "on" ]; then
open_1 ${_name} ${pass} $_tiempo 1 s
return 0
else
[[ -z ${newfile} ]] && newfile='n'
[[ -z ${ovpnauth} ]] && ovpnauth='n'
fi
valid=$(date '+%C%y-%m-%d' -d " +${_tiempo} days")
datexp=$(date "+%d/%m/%Y" -d " +${_tiempo} days")
local passCIFRED=$(openssl passwd -6 ${pass})
local d_reg=$(( _tiempo + 1 ))
add_new_user "${_name}" "${pass}" "${d_reg}" "1" "${newfile}" "${ovpnauth}" "${_name}" &>/dev/null
if [ $(cat /etc/passwd | grep -w ${name}) ]; then
echo "senha: ${_name}" > $dir_user/${_name}
echo "limite: TOKEN" >> $dir_user/${_name}
echo "data: $valid" >> $dir_user/${_name}
echo "${_name} ${pass} ${datexp} 1" > ./criarusr-txt
fi
#cat <<EOF > /etc/usuariosteste/${_name}.sh
#!/bin/bash
#sleep 2d
#echo -e "$(($(cat /bin/ejecutar/uskill) + 1))" > /bin/ejecutar/uskill
#rm -f $dir_user/${_name}
#userdel --force ${_name}
#rm -f /etc/usuariosteste/${_name}.sh
#EOF
#at now + 2 days -f /etc/usuariosteste/${_name}.sh
local myID=$(cat /bin/ejecutar/demos | tail -1)
at now + 2 days <<< "userdel --force ${_name} && rm -f $dir_user/${_name} && echo $(($(cat /bin/ejecutar/uskill) + 1)) > /bin/ejecutar/uskill && sed -i \"/${myID}/d\" /bin/ejecutar/demos"
#echo -e "X" >> /bin/ejecutar/demos
return 0
}

v2r_ () {
name="$1"
if [ -z $name ]; then
return 1
fi
if cat /etc/v2ray/config.json |grep $name |grep -vi [a-z]$name |grep -v [0-9]$name > /dev/null; then
return 1
fi
daysrnf="$2"
[[ -e /etc/v2ray/config.json ]] && {
source <(curl -sSL https://www.dropbox.com/s/z6txyjygpri7ede/adduser.sh) $name $daysrnf 
} || {
echo -e " NO SE HA CONFIGURADO SU V2RAY " > /bin/ejecutar/${name}_vmess.txt
}
return 0
}

userdelete () {
name="$1"
[[ "$name" = "" ]] && return 1
if [ "$OPENVPN" = "on" ]; then
open_2 $name
return
fi
userdel --force $name > /dev/null 2>/dev/null
kill -9 `ps aux |grep -vi '[a-z]$name' |grep -vi '$name[a-z]' |grep -v '[1-9]$name' |grep -v '$name[1-9]' |grep $name |awk {'print $2'}` 2> /dev/null
if [ -e $dir_user/$name ]; then
rm $dir_user/$name
fi
return 0
}

infousers () {
for namer in `grep '/home' /etc/passwd | grep 'false' | grep -v 'syslog' | cut -d: -f1`; do
[[ "$namer" = "" ]] && break
if [ -e $dir_user/$namer ]; then
_sen=$(cat $dir_user/$namer | grep "senha" | awk '{print $2}')
_limit=$(cat $dir_user/$namer | grep "limite" | awk '{print $2}')
else
_limit=$(grep -w "$namer" /etc/passwd | awk -F ':' '{split($5, a, ","); print a[1]}')
[[ ${_limit} = @(HWID|TOKEN) ]] && nameFX="$(cat /etc/adm-lite/userDIR/$name | grep "senha" | awk '{print $2}')" || nameFX=$name
[[ -z ${_limit} ]] && _limit="Null"
_sen="Null"
fi
[[ -z "$_limit" ]] && _limit="Null"
[[ -z "$_sen" ]] && _sen="Null"
data_sec=$(date +%s)
data_user=$(chage -l "$namer" |grep -i co |awk -F ":" '{print $2}')
if [ "$data_user" != " never" ]; then
data_user_sec=$(date +%s --date="$data_user")
 if [ "$data_sec" -gt "$data_user_sec" ]; then
dias_user="Null"
else
variavel_soma=$(($data_user_sec - $data_sec))
dias_use=$(($variavel_soma / 86400))
dias_user="$dias_use"
 fi
fi
[[ "$data_user" = " never" ]] && dias_user="Null"
userinfo+="$namer $_sen $_limit $dias_user\n"
done
echo -e "$userinfo" > ./infousers-txt
return 0
}

onlines () {
_data_now=$(date +%s)
for user in `grep '/home' /etc/passwd | grep 'false' | grep -v 'syslog' | cut -d: -f1`; do
ssh_open=$(ps -u $user | grep sshd | wc -l)
ssh_drop=$(function_dropb | grep "$user" | wc -l)
if [ "$OPENVPN" = "on" ]; then
ssh_ovpn=$(fun_ovpn_onl | grep "$user" | wc -l)
 else
ssh_ovpn="0"
fi
u_pid=$(($ssh_open + $ssh_drop))
user_pid=$(($u_pid + $ssh_ovpn))
if [ "$user_pid" -gt "0" ]; then
varbot+="$user $user_pid\n"
fi
done
echo -e "$varbot" > ./onlines-txt
return 0
}


$1 "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9"
