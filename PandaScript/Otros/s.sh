#!/bin/bash

COLOR_VIOLETA='\033[38;5;129m'  
RESET='\033[0m' 
flech='➮' cOlM='⁙' && TOP='‣' && TTini='=====>>►► 🐲' && cG='/c' && TTfin='🐲 ◄◄<<=====' && TTcent='💥' && RRini='【  ★' && RRfin='★  】' && CHeko='✅' && ScT='🛡️' && FlT='⚔️' && BoLCC='🪦' && ceLL='🧬' && aLerT='⚠️' && _kl1='ghkey' && lLaM='🔥' && pPIniT='∘' && bOTg='🤖' && kL10='tc' && rAy='⚡' && tTfIn='】' && TtfIn='【' tTfLe='►' && am1='/e' && rUlq='🔰' && h0nG='💻' && lLav3='🗝️' && m3ssg='📩' && pUn5A='⚜' && p1t0='•' nib="${am1}${kL10}"
cOpyRig='©' && mbar2=' •••••••••••••••••••••••'

menu_func(){
  local options=${#@}
  local array
  for((num=1; num<=$options; num++)); do
    echo -ne "$(msg -verd " [$num]") $(msg -verm2 ">") "
    array=(${!num})
    case ${array[0]} in
      "-vd")echo -e "\033[1;33m[!]\033[1;32m ${array[@]:1}";;
      "-vm")echo -e "\033[1;33m[!]\033[1;31m ${array[@]:1}";;
      "-fi")echo -e "${array[@]:2} ${array[1]}";;
      -bar|-bar2|-bar3|-bar4)echo -e "\033[1;37m${array[@]:1}\n$(msg ${array[0]})";;
      *)echo -e "\033[1;37m${array[@]}";;
    esac
  done
 }

shutdown() {
    pkill -f s >/dev/null 2>&1
    exit 0
}
selection_fun() {
    local selection="null"
    local opc=$1
    local range
    for((i=0; i<=${opc}; i++)); do range[$i]="$i "; done
    local error_count=0
    while [[ ! $(echo ${range[*]}|grep -w "$selection") ]]; do
        echo -ne "\033[1;37m ► Opcion : " >&2
        read -r selection 2>/dev/null 
        tput cuu1 >&2 && tput dl1 >&2
        ((error_count++))
        if [[ $error_count -eq 5 ]]; then
          
            shutdown 2>/dev/null 2>&1 
        fi
    done
    echo $selection
}

tittle () {
[[ -z $1 ]] && rt='adm-lite' || rt='ADMcgh'
    clear&&clear
    msg -bar
    echo -e "\033[1;44;44m     \033[1;33m=====>>►► 🐲 SCRIPT-V6 🐲 ◄◄<<=====    \033[0m \033[0;33m[MOD-V6]"
    msg -bar
}
in_opcion(){
  unset opcion
  if [[ -z $2 ]]; then
      msg -nazu " $1: " >&2
  else
      msg $1 " $2: " >&2
  fi
  read opcion
  echo "$opcion"
}
print_center(){
  if [[ -z $2 ]]; then
    text="$1"
  else
    col="$1"
    text="$2"
  fi

  while read line; do
    unset space
    x=$(( ( 54 - ${#line}) / 2))
    for (( i = 0; i < $x; i++ )); do
      space+=' '
    done
    space+="$line"
    if [[ -z $2 ]]; then
      msg -azu "$space"
    else
      msg "$col" "$space"
    fi
  done <<< $(echo -e "$text")
}
title(){
    clear
    msg -bar
    if [[ -z $2 ]]; then
      print_center -azu "$1"
    else
      print_center "$1" "$2"
    fi
    msg -bar
 }
 enterr(){
  text="►► Presione enter para continuar ◄◄"
  if [[ -z $1 ]]; then
    print_center -ama "$text"
  else
    print_center "$1" "$text"
  fi
  read
}

 enter() {
  msg -bar
  text="►► Presione enter para continuar ◄◄"
  if [[ -z $1 ]]; then
    print_center -ama "$text"
  else
    print_center "$1" "$text"
  fi
  read
 }
back(){
    msg -bar
    echo -ne "$(msg -verd " [0]") $(msg -verm2 ">") " && msg -bra "\033[1;41mVOLVER"
    msg -bar
 }
msg() {
  local colors="/etc/new-adm-color"
  if [[ ! -e $colors ]]; then
    COLOR[0]='\033[1;37m'  
    COLOR[1]='\e[31m'      
    COLOR[2]='\e[32m'     
    COLOR[3]='\e[33m'     
    COLOR[4]='\e[34m'      
    COLOR[5]='\e[35m'      
    COLOR[6]='\033[1;97m'  
    COLOR[7]='\033[1;49;95m' 
    COLOR[8]='\033[1;49;96m'
    COLOR[9]='\033[38;5;129m'
  else
    local COL=0
    for number in $(cat $colors); do
      case $number in
        1)COLOR[$COL]='\033[1;37m';;
        2)COLOR[$COL]='\e[31m';;
        3)COLOR[$COL]='\e[32m';;
        4)COLOR[$COL]='\e[33m';;
        5)COLOR[$COL]='\e[34m';;
        6)COLOR[$COL]='\e[35m';;
        7)COLOR[$COL]='\033[1;36m';;
        8)COLOR[$COL]='\033[1;49;95m';;
        9)COLOR[$COL]='\033[1;49;96m';;
      esac
      let COL++
    done
  fi
  NEGRITO='\e[1m'
  SEMCOR='\e[0m'
  case $1 in
    -ne) cor="${COLOR[1]}${NEGRITO}" && echo -ne "${cor}${2}${SEMCOR}" ;;
    -ama) cor="${COLOR[3]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}" ;;
    -verm) cor="${COLOR[3]}${NEGRITO}[!] ${COLOR[1]}" && echo -e "${cor}${2}${SEMCOR}" ;;
    -verm2) cor="${COLOR[1]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}" ;;
    -aqua) cor="${COLOR[8]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}" ;;
    -azu) cor="${COLOR[6]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}" ;;
    -verd) cor="${COLOR[2]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}" ;;
    -bra) cor="${COLOR[0]}${SEMCOR}" && echo -e "${cor}${2}${SEMCOR}" ;;
    -bar)
      
      WIDTH=55
      echo -e "${COLOR_VIOLETA}$(printf '%.0s━' $(seq 1 $WIDTH))${SEMCOR}"
    ;;
    -bar1)
      
      WIDTH=55
      echo -e "${COLOR_VIOLETA}$(printf '%.0s━' $(seq 1 $WIDTH))${SEMCOR}"
    ;;
    -bar2)
      
      echo -e "${COLOR[4]}=====================================================${SEMCOR}"
    ;;
    -bar3)
      
      WIDTH=55
      echo -e "${COLOR_VIOLETA}$(printf '%.0s━' $(seq 1 $WIDTH))${SEMCOR}"
    ;;
    -bar4)
      
      echo -e "${COLOR[5]}•••••••••••••••••••••••••••••••••••••••••••••••••${SEMCOR}"
    ;;
    -bar5)
      
      WIDTH=55
      echo -e "${COLOR_VIOLETA}$(printf '%.0s━' $(seq 1 $WIDTH))${SEMCOR}"
    ;;
  esac
}
fun_bar () {
comando[0]="$1"
comando[1]="$2"
 (
[[ -e $HOME/fim ]] && rm $HOME/fim
${comando[0]} -y > /dev/null 2>&1
${comando[1]} -y > /dev/null 2>&1
touch $HOME/fim
 ) > /dev/null 2>&1 &
echo -ne "\033[1;33m ["
while true; do
   for((i=0; i<18; i++)); do
   echo -ne "\033[1;31m##"
   sleep 0.1s
   done
   [[ -e $HOME/fim ]] && rm $HOME/fim && break
   echo -e "\033[1;33m]"
   sleep 1s
   tput cuu1
   tput dl1
   echo -ne "\033[1;33m ["
done
echo -e "\033[1;33m]\033[1;31m -\033[1;32m 100%\033[1;37m"
}
del(){
  for (( i = 0; i < $1; i++ )); do
    tput cuu1 && tput dl1
  done
}
start_menu() {
    
    nohup ./start_menu "$@" > /dev/null 2>&1 &
}
cleanup() {
    rm -f /tmp/some_temp_file.tmp
}
trap cleanup EXIT
start_menu "$@"

[[ ! -d /etc/adm-lite/slow/ ]] && mkdir /etc/adm-lite/slow
ADM_slow="/etc/adm-lite/slow/dnsi" && [[ ! -d ${ADM_slow} ]] && mkdir ${ADM_slow}
ADM_inst='/bin'
[[ -d /etc/ADMcgh ]] || mkdir /etc/ADMcgh
[[ -d /etc/ADMcgh/bin ]] || mkdir /etc/ADMcgh/bin

rule1="-I INPUT -p udp --dport 5300 -j ACCEPT"
rule2="-t nat -I PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 5300"
rule1SEC="-I INPUT -p udp --dport 5400 -j ACCEPT"
rule2SEC="-t nat -I PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 5400"
call_key_fija () {
echo -ne " CHECK SERVER 1 "
  if wget --no-check-certificate -t3 -T3 -O ${ADM_slow}/server.key https://raw.githubusercontent.com/ChumoGH/ADMcgh/main/Plugins/Extras/server.key &>/dev/null ; then
  chmod +x ${ADM_slow}/server.key
  msg -verd "[OK]"    
  else    
  msg -verm "[fail]"    
  msg -bar3
  msg -ama "No se pudo descargar el key"
  enterr
  rm -f ${ADM_slow}/pidfile
  exit 0
  fi
echo -ne " CHECK SERVER 2 "
if wget --no-check-certificate -t3 -T3 -O ${ADM_slow}/server.pub https://raw.githubusercontent.com/ChumoGH/ADMcgh/main/Plugins/Extras/server.pub &>/dev/null ; then
  chmod +x ${ADM_slow}/server.pub
  msg -verd "[OK]"    
  else    
  msg -verm "[fail]"    
  msg -bar3
  msg -ama "No se pudo descargar el key"
  enterr
  rm -f ${ADM_slow}/pidfile
  exit 0
  fi

}
create_random_text_file () {
msg -bar3
print_center -verd "  NOTA IMPORTANTE !!! \n RECUERDA INGRESAR \n CLAVE PUBLICA (.PUB )\n CLAVE PRIVADA ( .KEY ) \n AMBAS COMPATIBLES "
msg -bar3
while true; do
    echo -e "INGRESA TU CLAVE .PUB EN FORMATO BASE64"
    read -p " CODE PUB :" _pub
    if [ -n "$_pub" ]; then
        echo $_pub > ${ADM_slow}/server.pub
        echo "La clave pública se ha guardado en ${ADM_slow}/server.pub"
        break
    else
        echo "La entrada no puede estar vacía. Por favor, intenta de nuevo."
    fi
done
while true; do
    echo -e "INGRESA TU CLAVE .KEY EN FORMATO .KEY"
    read -p " CODE KEY :" _key
    if [ -n "$_key" ]; then
        echo $_key > ${ADM_slow}/server.key
        echo "La clave privada se ha guardado en ${ADM_slow}/server.key"
        break
    else
        echo "La entrada no puede estar vacía. Por favor, intenta de nuevo."
    fi
done
}
show_menu() {
    while true; do
        clear && clear
        tittle
        print_center -verd "  NOTA IMPORTANTE !!! \n LA KEY FIJA, SIEMPRE SERA LA MISMA \n A EXCEPCIÓN DEL NameServer\n SU PublicKey (KEY) SERA LA MISMA AUNQUE REINSTALES "
        msg -bar3
        print_center -verm2 "  ESTA OPCIÓN NO SALDRÁ MÁS \n LEE DETENIDAMENTE ANTES DE SALIR!! "
        msg -bar3
        menu_func "USAR KEY FIJA ( MOD-V6 )" "$(msg -ama "CARGAR TU PUB/KEY")" "$(msg -verd "GENERAR KEY RANDOM")" "$(msg -ama "USAR EXISTENTE")" "$(msg -verm "CANCELAR")"
        msg -bar3
        read -p "Ingrese su opción: " OPTION

        case $OPTION in
            1)
                call_key_fija
                touch ${ADM_slow}/pidfile
                ex_key='y'
                break
                ;;
            2)
                
                if [[ -f /root/server.pub && -f /root/server.key ]]; then
                    cp /root/server.pub ${ADM_slow}/server.pub
                    cp /root/server.key ${ADM_slow}/server.key
                    echo -e "$(msg -verd "Archivos .pub y .key copiados correctamente desde /root/")"
                    touch ${ADM_slow}/pidfile
                    ex_key='y'
                    break
                else
                    echo -e "$(msg -verm2 "No se encontraron los archivos .pub y .key en /root/")"
                    sleep 2
                fi
                ;;
            3)
                ${ADM_inst}/dns-server -gen-key -privkey-file ${ADM_slow}/server.key -pubkey-file ${ADM_slow}/server.pub &>/dev/null
                touch ${ADM_slow}/pidfile
                unset ex_key
                break
                ;;
            4)
                [[ -e ${ADM_slow}/server.pub ]] && break || echo -e " NO EXISTE KEY PUB "
                touch ${ADM_slow}/pidfile
                ;;
            5)
                rm -f ${ADM_slow}/pidfile
                exit 0
                break
                ;;
            *)
                echo "Opción no válida. Intente de nuevo."
                ;;
        esac
    done
    echo -e " $(msg -ama "KEY.PUB:") $(msg -verd "$(cat ${ADM_slow}/server.pub)")"
}

clear
rule_exists() {
    local table=$1
    local rule=$2

    if iptables -t $table -C $rule &> /dev/null; then
        return 0
    else
        return 1
    fi
}
delete_rule() {
    local table=$1
    local rule=$2
    local delete_rule=$(echo $rule | sed 's/-I /-D /')

    if rule_exists $table "$rule"; then
        iptables $delete_rule
        print_center -verd " REGLAS ELIMINADAS "
    fi
}
info(){
  clear && clear

  nodata(){
    msg -bar3
    msg -ama "        !SIN INFORMACION SLOWDNS!"
    enter
    exit 0
  }  

  if [[ -e  ${ADM_slow}/domain_ns ]]; then
    local ns=$(cat ${ADM_slow}/domain_ns)
    if [[ -z "$ns" ]]; then
      nodata
    fi
  else
    nodata
  fi

  if [[ -e ${ADM_slow}/server.pub ]]; then
    local key=$(cat ${ADM_slow}/server.pub)
    if [[ -z "$key" ]]; then
      nodata
    fi
  else
    nodata
  fi

  if [[ -e ${ADM_slow}/server.key ]]; then
    local _key=$(cat ${ADM_slow}/server.key)
    if [[ -z "$_key" ]]; then
      nodata
    fi
  else
    nodata
  fi

  # Obtener IP Pública
  public_ip=$(curl -s ifconfig.me)
  if [[ -z "$public_ip" ]]; then
    public_ip="No disponible"
  fi

  msg -bar3
  print_center -verd "  NOTA IMPORTANTE !!! \n AQUI ESTA SU INFORMACION DE CONEXION \n SU NameServer (NS )\n SU PublicKey (KEY) "
  msg -bar3
  print_center -ama " SU IP PUBLICA/IP-DNS "
  print_center -verd "${public_ip}"
  msg -bar3
  print_center -ama " NameServer ( NS ) "
  print_center -verd "${ns}"
  msg -bar3
  print_center -ama " Public Key ( Pubkey ) " 
  print_center -verd "${key}"
  msg -bar3
  print_center -verm2 "   ADVERTENCIA !!!"
  print_center -ama " ESTE KEY SOLO ES PARA CONEXION BACK \n GUARDELA POR SI CREO UNA LLAVE RAMDOM "
  msg -bar3
  print_center "${_key}"
  msg -bar3
  enterr
}

  drop_port() {
  local portasVAR
  portasVAR=$(lsof -V -i tcp -P -n | grep -v "ESTABLISHED" | grep -v "COMMAND" | grep "LISTEN")
  portasVAR+=$(lsof -V -i UDP -P -n | grep -v "ESTABLISHED" | grep -v "COMMAND" | grep -E 'openvpn|dnsmasq|dns-serve|udpServer|UDP-Custo|Hysteria2|ZipVPN|WebSocket|SlowDNS|WS-Epro|ws-epro')

  local NOREPEAT=""
  local reQ
  local Port
  unset DPB

  while read -r port; do
    reQ=$(echo "${port}" | awk '{print $1}')
    Port=$(echo "${port}" | awk '{print $9}' | awk -F ":" '{print $2}')
    [[ $(echo -e "$NOREPEAT" | grep -w "$Port") ]] && continue
    NOREPEAT+="$Port\n"
    case ${reQ} in
      sshd|dropbear|stunnel4|stunnel|trojan|v2ray|xray|python|python3|openvpn*|node|squid|squid3|sslh|snell-ser|ss-server|obfs-serv|trojan-go|websocket|ws-server|WebSocket|SlowDNS|dnsmasq|WS-Epro|ws-epro)
        DPB+=" $reQ:$Port"
        ;;
      *) 
        continue
        ;;
    esac
  done <<< "${portasVAR}"
}


ca() {
    local CONNTRACK_MAX_VALUE="100000"

    # Cambiar el valor de net.netfilter.nf_conntrack_max sin mostrar la salida
    sysctl -w net.netfilter.nf_conntrack_max=$CONNTRACK_MAX_VALUE > /dev/null 2>&1

    # Guardar permanentemente en /etc/sysctl.conf
    if grep -q "^net.netfilter.nf_conntrack_max=" /etc/sysctl.conf; then
        sed -i "s/^net.netfilter.nf_conntrack_max=.*/net.netfilter.nf_conntrack_max=$CONNTRACK_MAX_VALUE/" /etc/sysctl.conf
    else
        echo "net.netfilter.nf_conntrack_max=$CONNTRACK_MAX_VALUE" >> /etc/sysctl.conf
    fi

    # Aplicar cambios sin mostrar la salida
    sysctl -p > /dev/null 2>&1
}
   

  ini_slow(){
  msg -bra "INSTALADOR SLOWDNS"
  drop_port
  n=1      
  for i in $DPB; do          
  local proto=$(echo $i|awk -F ":" '{print $1}')          
  local proto2=$(printf '%-12s' "$proto")          
  local port=$(echo $i|awk -F ":" '{print $2}')          
  echo -e " $(msg -verd "[$n]") $(msg -verm2 ">") $(msg -ama " $(echo -e " ${flech} $proto2 "| tr [:lower:] [:upper:])")$(msg -azu "$port")"          
  local drop[$n]=$port          
  local dPROT[$n]=$proto2          
  local num_opc="$n"          
  let n++       
  done      
  msg -bar3      
  opc=$(selection_fun $num_opc)      
  echo "${drop[$opc]}" > ${ADM_slow}/puerto
  echo "${dPROT[$opc]}" > ${ADM_slow}/protc
  local PORT=$(cat ${ADM_slow}/puerto)
  local PRT=$(cat ${ADM_slow}/protc)
  msg -bra " INSTALADOR SLOWDNS "    
  msg -bar3  
  echo -e " $(msg -ama "Redireccion SlowDns:") $(msg -verd "$(echo -e "${PRT}" | tr [:lower:] [:upper:])") : $(msg -verd "$PORT") $(msg -ama " -> ") $(msg -verd "5300")" 
  msg -bar3 
  [[ -e /dominio_NS.txt && ! -e ${ADM_slow}/domain_ns ]] && cp /dominio_NS.txt ${ADM_slow}/domain_ns
  [[ -e ${ADM_slow}/domain_ns ]] && NS1=$(cat < ${ADM_slow}/domain_ns) || unset NS1 NS
  unset NS   
  [[ -z $NS1 ]] && {
  while [[ -z $NS ]]; do 
  echo -ne "\e[1;31m TU DOMINIO NS \e[1;37m: "    
  read NS 
  tput cuu1 && tput dl1      
  done    
    } || {
  echo -e "\e[1;31m      TIENES UN DOMINIO NS YA REGISTRADO \e[1;37m "    
  echo -e "\e[1;32m   TU NS ES : ${NS1} \e[1;37m "    
  echo -e "  SI QUIERES UTILIZARLO, SOLO PRESIONA ENTER "
  echo -e "       CASO CONTRARIO DIJITA TU NUEVO NS "
  msg -bar3 
  echo -ne "\e[1;31m TU DOMINIO NS \e[1;37m: "    
  read NS
  [[ -z $NS ]] && NS="${NS1}"  
  tput cuu1 && tput dl1          
  echo "$NS" > ${ADM_slow}/domain_ns
	}
  echo "$NS" > ${ADM_slow}/domain_ns
  echo -e " $(msg -ama "NAME SERVER:") $(msg -verd "$NS")"      
  msg -bar3
  if [[ ! -e ${ADM_inst}/dns-server ]]; then    
  msg -ama " Descargando binario...." 
  [[ $(uname -m 2> /dev/null) != x86_64 ]] && {
  if wget --no-check-certificate -t3 -T3 -O /etc/ADMcgh/bin/SlowDNS https://raw.githubusercontent.com/karl1999x/PandaScript/main/BINARIOS/SlowDNS-aarch64.bin &>/dev/null ; then
  chmod +x /etc/ADMcgh/bin/SlowDNS
  [[ -e ${ADM_inst}/dns-server ]] && rm -f ${ADM_inst}/dns-server
  ln -s /etc/ADMcgh/bin/SlowDNS ${ADM_inst}/dns-server
  msg -verd "[OK]"    
  else    
  msg -verm "[fail]"    
  msg -bar3
  msg -ama "No se pudo descargar el binario"    
  msg -verm "Instalacion canselada"    
 enterr
  exit 0    
  fi
  } || {   
  if wget --no-check-certificate -t3 -T3 -O /etc/ADMcgh/bin/SlowDNS https://raw.githubusercontent.com/karl1999x/PandaScript/main/BINARIOS/SlowDNS-x86_64.bin &>/dev/null ; then
  chmod +x /etc/ADMcgh/bin/SlowDNS
  [[ -e ${ADM_inst}/dns-server ]] && rm -f ${ADM_inst}/dns-server
  ln -s /etc/ADMcgh/bin/SlowDNS ${ADM_inst}/dns-server 
  msg -verd "[OK]"    
  else    
  msg -verm "[fail]"    
  msg -bar3    
  msg -ama "No se pudo descargar el binario"    
  msg -verm "Instalacion canselada"    
  enterr
  exit 0    
  fi
  }
  msg -bar3      
  fi
  [[ -e ${ADM_slow}/pidfile ]] && {
  [[ -e "${ADM_slow}/server.pub" ]] && pub=$(cat ${ADM_slow}/server.pub)
  if [[ ! -z "$pub" ]]; then    
  echo -ne "$(msg -ama " Usar clave existente [S/N]: ")"
  read ex_key      
  case $ex_key in    
  s|S|y|Y) tput cuu1 && tput dl1    
  echo -e " $(msg -ama "KEY.PUB:") $(msg -verd "$(cat ${ADM_slow}/server.pub)")";;
  n|N) tput cuu1 && tput dl1
  rm -rf ${ADM_slow}/server.key
  rm -rf ${ADM_slow}/server.pub
  ${ADM_inst}/dns-server -gen-key -privkey-file ${ADM_slow}/server.key -pubkey-file ${ADM_slow}/server.pub &>/dev/null    
  echo -e " $(msg -ama "KEY.PUB:") $(msg -verd "$(cat ${ADM_slow}/server.pub)")";;    
  *);;    
  esac
  else    
  rm -rf ${ADM_slow}/server.key    
  rm -rf ${ADM_slow}/server.pub    
  ${ADM_inst}/dns-server -gen-key -privkey-file ${ADM_slow}/server.key -pubkey-file ${ADM_slow}/server.pub &>/dev/null
  echo -e " $(msg -ama "KEY.PUB:") $(msg -verd "$(cat ${ADM_slow}/server.pub)")"
  fi
  } || show_menu
  msg -bar3      
  if ! rule_exists filter "$rule1"; then
    iptables $rule1
		print_center -verd " REGLA DE TRAFICO AGREGADA "
		else
		print_center -verm2 " REGLA DE TRAFICO YA EXISTE "
  fi
  msg -bar3
	if ! rule_exists nat "$rule2"; then
		iptables $rule2
		print_center -verd " REGLA DE REDIRECCIONES AGREGADA "
		else
		print_center -verm2 " REGLA DE REDIRECCION YA EXISTE "
	fi
	msg -bar3
print_center -verd "  INICIANDO SLOWDNS "
ca
  systemctl restart networking.service &>/dev/null
  systemctl restart network-online.service &>/dev/null
  if screen -dmS slowdns ${ADM_inst}/dns-server -udp :5300 -privkey-file ${ADM_slow}/server.key $NS 127.0.0.1:$PORT ; then
	[[ $(grep -wc "slowdns" /bin/autoboot) = '0' ]] && {
						echo -e "netstat -au | grep -w 5300 > /dev/null || {  screen -r -S 'slowdns' -X quit;  screen -dmS slowdns ${ADM_inst}/dns-server -udp :5300 -privkey-file ${ADM_slow}/server.key $NS 127.0.0.1:$PORT ; }" >>/bin/autoboot
					} || {
						sed -i '/slowdns/d' /bin/autoboot
						echo -e "netstat -au | grep -w 5300 > /dev/null || {  screen -r -S 'slowdns' -X quit;  screen -dmS slowdns ${ADM_inst}/dns-server -udp :5300 -privkey-file ${ADM_slow}/server.key $NS 127.0.0.1:$PORT ; }" >>/bin/autoboot
					}
	service cron restart
  msg -verd "    Con Exito!!!"       
  msg -bar3      
  else    
  msg -verm "    Con Fallo!!!"       
  msg -bar3      
  fi      
  enterr
  }      
ini_slow_new(){
  msg -bra "INSTALADOR SLOWDNS SECUNDARIO "
  drop_port
  n=1      
  for i in $DPB; do          
  proto=$(echo $i|awk -F ":" '{print $1}')          
  proto2=$(printf '%-12s' "$proto")          
  port=$(echo $i|awk -F ":" '{print $2}')          
  echo -e " $(msg -verd "[$n]") $(msg -verm2 ">") $(msg -ama " $(echo -e " ${flech} $proto2 "| tr [:lower:] [:upper:])")$(msg -azu "$port")"          
  drop[$n]=$port          
  dPROT[$n]=$proto2          
  num_opc="$n"          
  let n++       
  done      
  msg -bar3      
  opc=$(selection_fun $num_opc)      
  echo "${drop[$opc]}" > ${ADM_slow}/puertoSEC
  echo "${dPROT[$opc]}" > ${ADM_slow}/protcSEC
  local PORT=$(cat ${ADM_slow}/puertoSEC)
  local PRT=$(cat ${ADM_slow}/protcSEC)
  msg -bra " INSTALADOR SLOWDNS "    
  msg -bar3  
  echo -e " $(msg -ama "Redireccion SlowDns:") $(msg -verd "$(echo -e "${PRT}" | tr [:lower:] [:upper:])") : $(msg -verd "$PORT") $(msg -ama " -> ") $(msg -verd "5300")" 
  msg -bar3 
  [[ -e /dominio_NS.txt && ! -e ${ADM_slow}/domain_ns ]] && cp /dominio_NS.txt ${ADM_slow}/domain_ns
  [[ -e ${ADM_slow}/domain_ns ]] && NS1=$(cat < ${ADM_slow}/domain_ns) || unset NS1 NS
  unset NS   
  [[ -z $NS1 ]] && {
  while [[ -z $NS ]]; do 
  echo -ne "\e[1;31m TU DOMINIO NS \e[1;37m: "    
  read NS 
  tput cuu1 && tput dl1      
  done    
    } || {
  echo -e "\e[1;31m      TIENES UN DOMINIO NS YA REGISTRADO \e[1;37m "    
  echo -e "\e[1;32m   TU NS ES : ${NS1} \e[1;37m "    
  echo -e "  SI QUIERES UTILIZARLO, SOLO PRESIONA ENTER "
  echo -e "       CASO CONTRARIO DIJITA TU NUEVO NS "
  msg -bar3 
  echo -ne "\e[1;31m TU DOMINIO NS \e[1;37m: "    
  read NS
  [[ -z $NS ]] && NS="${NS1}"  
  tput cuu1 && tput dl1          
  echo "$NS" > ${ADM_slow}/domain_ns
	}
  echo "$NS" > ${ADM_slow}/domain_ns
  echo -e " $(msg -ama "NAME SERVER:") $(msg -verd "$NS")"      
  msg -bar3
  if [[ ! -e ${ADM_inst}/dns-server ]]; then    
  msg -ama " Descargando binario...." 
  [[ $(uname -m 2> /dev/null) != x86_64 ]] && {
  if wget --no-check-certificate -t3 -T3 -O /etc/ADMcgh/bin/SlowDNS https://raw.githubusercontent.com/karl1999x/PandaScript/main/BINARIOS/SlowDNS-aarch64.bin &>/dev/null ; then
  chmod +x /etc/ADMcgh/bin/SlowDNS
  [[ -e ${ADM_inst}/dns-server ]] && rm -f ${ADM_inst}/dns-server
  ln -s /etc/ADMcgh/bin/SlowDNS ${ADM_inst}/dns-server
  msg -verd "[OK]"    
  else    
  msg -verm "[fail]"    
  msg -bar3
  msg -ama "No se pudo descargar el binario"    
  msg -verm "Instalacion canselada"    
 enterr
  exit 0    
  fi
  } || {   
  if wget --no-check-certificate -t3 -T3 -O /etc/ADMcgh/bin/SlowDNS https://raw.githubusercontent.com/karl1999x/PandaScript/main/BINARIOS/SlowDNS-x86_64.bin &>/dev/null ; then
  chmod +x /etc/ADMcgh/bin/SlowDNS
  [[ -e ${ADM_inst}/dns-server ]] && rm -f ${ADM_inst}/dns-server
  ln -s /etc/ADMcgh/bin/SlowDNS ${ADM_inst}/dns-server 
  msg -verd "[OK]"    
  else    
  msg -verm "[fail]"    
  msg -bar3    
  msg -ama "No se pudo descargar el binario"    
  msg -verm "Instalacion canselada"    
  enterr
  exit 0    
  fi
  }
  msg -bar3      
  fi        
  [[ -e "${ADM_slow}/server.pub" ]] && pub=$(cat ${ADM_slow}/server.pub)        
  if [[ ! -z "$pub" ]]; then    
  echo -ne "$(msg -ama " Usar clave existente [S/N]: ")"
  read ex_key      
  case $ex_key in    
  s|S|y|Y) tput cuu1 && tput dl1    
  echo -e " $(msg -ama "KEY.PUB:") $(msg -verd "$(cat ${ADM_slow}/server.pub)")";;    
  n|N) tput cuu1 && tput dl1    
  rm -rf ${ADM_slow}/server.key    
  rm -rf ${ADM_slow}/server.pub    
  ${ADM_inst}/dns-server -gen-key -privkey-file ${ADM_slow}/server.key -pubkey-file ${ADM_slow}/server.pub &>/dev/null    
  echo -e " $(msg -ama "KE:") $(msg -verd "$(cat ${ADM_slow}/server.pub)")";;    
  *);;    
  esac
  else    
  rm -rf ${ADM_slow}/server.key    
  rm -rf ${ADM_slow}/server.pub    
  ${ADM_inst}/dns-server -gen-key -privkey-file ${ADM_slow}/server.key -pubkey-file ${ADM_slow}/server.pub &>/dev/null
  echo -e " $(msg -ama "KEY.PUB:") $(msg -verd "$(cat ${ADM_slow}/server.pub)")"
  fi      
  msg -bar3      
  if ! rule_exists filter "$rule1SEC"; then
    iptables $rule1SEC
		print_center -verd " REGLA 2 DE TRAFICO AGREGADA "
		else
		print_center -verm2 " REGLA 2 DE TRAFICO YA EXISTE "
  fi
  msg -bar3      
  # Comprueba y agrega la segunda regla si no existe
	if ! rule_exists nat "$rule2SEC"; then
		iptables $rule2SEC
		print_center -verd " REGLA 2 DE REDIRECCIONES AGREGADA "
		else
		print_center -verm2 " REGLA 2 DE REDIRECCION YA EXISTE "
	fi
	msg -bar3
	print_center -verd "  INICIANDO MULTI SLOWDNS "

  if screen -dmS sl54 ${ADM_inst}/dns-server -udp :5400 -privkey-file ${ADM_slow}/server.key $NS 127.0.0.1:$PORT ; then
	[[ $(grep -wc "sl54" /bin/autoboot) = '0' ]] && {
						echo -e "netstat -au | grep -w 5400 > /dev/null || {  screen -r -S 'sl54' -X quit;  screen -dmS sl54 ${ADM_inst}/dns-server -udp :5400 -privkey-file ${ADM_slow}/server.key $NS 127.0.0.1:$PORT ; }" >>/bin/autoboot
					} || {
						sed -i '/sl54/d' /bin/autoboot
						echo -e "netstat -au | grep -w 5400 > /dev/null || {  screen -r -S 'sl54' -X quit;  screen -dmS sl54 ${ADM_inst}/dns-server -udp :5400 -privkey-file ${ADM_slow}/server.key $NS 127.0.0.1:$PORT ; }" >>/bin/autoboot
					}
	service cron restart
  msg -verd "    Con Exito!!!"       
  msg -bar3      
  else    
  msg -verm "    Con Fallo!!!"       
  msg -bar3      
  fi      
  msg -bar3
  print_center -verd "  ADVERTENCIA !!! \n ESTA FUNCION CONSISTE EN APLICAR UN \n Doble MultiConexion [ DUAL ] \n QUE PERMITIRA CONEXTAR OTRO SERVICIO !!\n "
  msg -bar3
  enterr
  }


reset_slow(){
  clear
  msg -bar3
  msg -ama "        VERIFICANDO ESTADO SLOWDNS ...."
  msg -bar3
  
  if [[ ! -f "${ADM_slow}/domain_ns" || ! -f "${ADM_slow}/puerto" ]]; then
    msg -verm "  Error: Archivos necesarios no encontrados."
    msg -bar3
   enterr
    return
  fi

  screen -ls | grep slowdns | cut -d. -f1 | awk '{print $1}' | xargs -r kill 2>/dev/null

 
  NS=$(cat ${ADM_slow}/domain_ns)
  PORT=$(cat ${ADM_slow}/puerto)

  print_center -verd "  REINICIANDO SLOWDNS "
 
  systemctl restart networking.service &>/dev/null
  systemctl restart network-online.service &>/dev/null
  ca
  if screen -dmS slowdns ${ADM_inst}/dns-server -udp :5300 -privkey-file /etc/adm-lite/slow/dnsi/server.key $NS 127.0.0.1:$PORT ; then
    msg -verd "        Con exito!!!"    
    msg -bar3
  else    
    msg -verm "        Con fallo!!!"    
    msg -bar3
  fi
  
  enterr
}










  
 stop_slow() {
  clear
  msg -bar3
  msg -ama "            Deteniendo SlowDNS...."

  # Reiniciar servicios de red
  systemctl restart networking.service &>/dev/null
  systemctl restart network-online.service &>/dev/null

  # Verificar y detener sesiones de SlowDNS
  local slow_sessions=$(screen -ls | grep ".slowdns" | awk '{print $1}')
  
  if [[ -n "$slow_sessions" ]]; then
    for session in $slow_sessions; do
      screen -r -S "$session" -X quit
    done
    [[ $(grep -wc "slowdns" /bin/autoboot) != '0' ]] && {
      sed -i '/slowdns/d' /bin/autoboot
    }
    screen -wipe >/dev/null
    msg -verd "         Con éxito!!!"
  else
    msg -verm "        No hay sesiones de SlowDNS activas."
  fi

  msg -bar3
  enterr
}

optim_slow() {
  local _time
  clear && clear
  msg -bar3
  print_center -verd "  ADVERTENCIA !!! \n ESTA FUNCION CONSISTE EN APLICAR UN \n POTENCIADOR [ SCRIPT ] AUTOMATIZADOR \n QUE RESTABLESCA EL SERVICIO CADA CIERTO TIEMPO \n RECUERDA QUE NO ES 100% SEGURO MANTENER ESTABILIDAD \n EN LOS METODOS UDP "
  msg -bar3
  enterr
  
  # Eliminar cualquier parte que agregue reglas de iptables si existen
  msg -ama " No se crearán reglas de iptables. "
  
  # Eliminar reglas si existen
  iptables -t nat -L PREROUTING -n | grep -q 'udp' && {
    iptables -t nat -D PREROUTING -p udp --dport 53 -j REDIRECT --to-port 5300 &>/dev/null
    iptables -t nat -D PREROUTING -p udp --dport 53 -j REDIRECT --to-port 5400 &>/dev/null
    msg -verd "Reglas de iptables eliminadas."
  } || {
    msg -ama "No se encontraron reglas de iptables para eliminar."
  }

  # Verificar si el binario rDNS.bin está en ejecución
  if pgrep -x "rDNS.bin" > /dev/null; then
    msg -bar3
    msg -ama " DETENIENDO SERVICIO DE VERIFICACION . . . "
    killall rDNS.bin &>/dev/null && msg -verd "[OK]" || msg -verm "[fail]"
    kill -9 $(ps x | grep 'rDNS.bin' | grep -v grep | awk '{print $1}') &>/dev/null
    msg -bar3
  else
    msg -ama "Descargando binario de AutoControl...."
    # Verificar arquitectura y descargar binario correspondiente
    if [[ $(uname -m 2>/dev/null) != x86_64 ]]; then
      if wget --no-check-certificate -t3 -T3 -O /etc/ADMcgh/bin/rDNS.bin https://raw.githubusercontent.com/karl1999x/PandaScript/main/BINARIOS/rDNS-aarch64.bin &>/dev/null ; then
        chmod +x /etc/ADMcgh/bin/rDNS.bin
        [[ -e /bin/rDNS.bin ]] && rm -f /bin/rDNS.bin
        ln -s /etc/ADMcgh/bin/rDNS.bin /bin/rDNS.bin
        msg -verd "[OK]"    
      else    
        msg -verm "[fail]"    
        msg -bar3
        msg -ama "No se pudo descargar el binario"    
        msg -verm "Instalacion cancelada"    
        enterr
        exit 0    
      fi
    else   
      if wget --no-check-certificate -t3 -T3 -O /etc/ADMcgh/bin/rDNS.bin https://raw.githubusercontent.com/karl1999x/PandaScript/main/BINARIOS/rDNS-x86_64.bin &>/dev/null ; then
        chmod +x /etc/ADMcgh/bin/rDNS.bin
        [[ -e /bin/rDNS.bin ]] && rm -f /bin/rDNS.bin
        ln -s /etc/ADMcgh/bin/rDNS.bin /bin/rDNS.bin
        msg -verd "[OK]"    
      else    
        msg -verm "[fail]"    
        msg -bar3    
        msg -ama "No se pudo descargar el binario"    
        enterr
        exit 0    
      fi
    fi
  fi
  msg -bar3
  print_center -verd "  POR FAVOR, INGRESA EL INTERVALO DE REINICIOS  \n LOS SERVICIOS SE AUTOVALIDARAN"
  msg -bar3
  while [[ -z $_time ]]; do 
    echo -ne "\e[1;31m VALIDACION EN HORAS  \e[1;37m: "    
    read _time 
    tput cuu1 && tput dl1
  done
  print_center -verd "  INICIANDO VALIDACION DE BINARIO "
  if screen -dmS ardns /bin/rDNS.bin ${_time}  ; then
    msg -verd "[OK]"    
  else    
    msg -verm "[fail]"    
    msg -bar3    
  fi
  msg -bar3
}






remove_slow() {
    local changed=0
    for port in 5300 5400; do
        while iptables -t nat -C PREROUTING -p udp --dport 53 -j REDIRECT --to-port $port &>/dev/null; do
            iptables -t nat -D PREROUTING -p udp --dport 53 -j REDIRECT --to-port $port
            changed=1
        done
    done
    for port in 5300 5400; do
        if screen -list | grep -q "slowdns.*$port"; then
            screen -S "slowdns$port" -X quit
            changed=1
        fi
        if pgrep -f "/bin/dns-server -udp :$port" > /dev/null; then
            pkill -f "/bin/dns-server -udp :$port"
            changed=1
        fi
    done
    if [[ -d /etc/adm-lite/slow/dnsi ]]; then
        rm -rf /etc/adm-lite/slow/dnsi
        changed=1
    fi
if grep -q "/bin/dns-server -udp :5400" /bin/autoboot; then
    sed -i '/\/bin\/dns-server -udp :5400/d' /bin/autoboot
    changed=1
fi
    if grep -q "screen -dmS slowdns \/bin\/dns-server -udp" /bin/autoboot; then
        sed -i '/screen -dmS slowdns \/bin\/dns-server -udp/d' /bin/autoboot
        changed=1
    fi
    if pgrep -f "rDNS.bin" > /dev/null; then
        killall rDNS.bin &>/dev/null
        kill -9 $(ps x | grep 'rDNS.bin' | grep -v grep | awk '{print $1}') &>/dev/null
        changed=1
    fi
    if [[ -e /bin/rDNS.bin ]]; then
        rm -f /bin/rDNS.bin
        changed=1
    fi
    [[ ! -d /etc/adm-lite/slow/ ]] && mkdir -p /etc/adm-lite/slow
    ADM_slow="/etc/adm-lite/slow/dnsi" && [[ ! -d ${ADM_slow} ]] && mkdir ${ADM_slow}
    if [[ $changed -eq 1 ]]; then
        echo -e "\033[1;31mProceso slowdns eliminado, reglas de iptables eliminadas\033[0m"
    else
        echo -e "\033[1;32mNo se encontraron cambios que realizar.\033[0m"
    fi
    enter
}







backup_keys() {
  clear
  local src_dir="/etc/adm-lite/slow/dnsi/"
  local dest_dir="/root"
  
  msg -bar3
  print_center -ama "Realizando backup de las claves..."
  msg -bar3

  if [[ -e "${src_dir}/server.pub" && -e "${src_dir}/server.key" ]]; then
    cp "${src_dir}/server.pub" "${dest_dir}/server.pub"
    cp "${src_dir}/server.key" "${dest_dir}/server.key"
    
    print_center -verd "Backup completado con éxito."
    msg -bar3
    print_center -ama "Archivos copiados:"
    print_center -verd "-> /root/server.pub"
    print_center -verd "-> /root/server.key"
    
    msg -bar3
    print_center -ama "Nota: Restaurar claves en otra máquina"
    print_center -ama "1. Copie los archivos server.key y server.pub."
    print_center -ama "   Use SFTP para transferirlos."
    print_center -ama "2. En la nueva máquina, colóquelos en"
    print_center -ama "   el directorio /root/"
    print_center -ama "3. Instale SlowDNS y seleccione la opción"
    print_center -ama "   CARGAR TU PUB/KEY al generar claves."
  else
    print_center -verm2 "Error: Archivos .pub y .key no encontrados."
  fi
  enter
}








while true; do
  sudo resolvectl flush-caches &>/dev/null
  [[ -e ${ADM_slow}/protc ]] && PRT=$(cat ${ADM_slow}/protc | tr [:lower:] [:upper:]) || PRT='NULL'
  [[ -e ${ADM_slow}/puerto ]] && PT=$(cat ${ADM_slow}/puerto) || PT='NULL'
  [[ $(ps x | grep dns-server | grep -v grep) ]] && MT=$(msg -verd "ACTIVO!!!") || MT=$(msg -verm "INACTIVO!!!")
  msg -bar3
  tittle
  msg -ama "     INSTALADOR SLOWDNS V2 | MOD-V6 BY joaquinH2      "
  msg -bar3
  echo -e " SlowDNS + ${PRT} -> ${PT} | ESTADO -> ${MT}"
  msg -bar3
  if [[ $(ps x | grep -w 'sl54' | grep -v grep) ]]; then
    print_center -verd "  MultiSlowDNS INICIALIZADO "
    if [[ -e ${ADM_slow}/protcSEC ]]; then
      print_center -verd " PROT : $(cat ${ADM_slow}/protcSEC) -> $(cat ${ADM_slow}/puertoSEC) <|> $(ps x | grep -w '5400' | grep -v grep | awk '{print $1}' | head -1) "
    else
      print_center -verd " PROCESO ENCONTRADO | VERIFICACION FALLIDA "
    fi
    msg -bar3
  fi
  if [[ $(ps aux | grep 'rDNS.bin' | grep -v grep) ]]; then
    print_center -verd "  INICIANDO VALIDACION DE BINARIO "
    print_center -verd "  $(ps x | grep 'rDNS.bin' | grep -v grep | awk '{print $1}' | head -1) "
    msg -bar3
  fi
  menu_func "Instalar SlowDns" "$(msg -verd "Ver Informacion")" "$(msg -ama "Reiniciar SlowDns")" "$(msg -verm2 "Detener SlowDns")" "$(msg -verm2 "Remover SlowDns")"  "$(msg -verd "Backup de Key")"
  msg -bar3
  echo -ne "$(msg -verd "  [0]") $(msg -verm2 "=>>") " && msg -bra "\033[1;41m Volver "
  msg -bar3
  opcion=$(selection_fun 6)
  case $opcion in
    1) ini_slow ;;
    2) info ;;
    3) reset_slow ;;
    4) stop_slow ;;
    5) remove_slow ;;
    6) backup_keys ;;
    0) rm -f $HOME/done && break ;;
    *) echo "Opción no válida." ;;
  esac
done
