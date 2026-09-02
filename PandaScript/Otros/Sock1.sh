#!/bin/bash
clean_check() {

# --- VARIABLES DE CONFIGURACIÓN LOCALES ---
local ROOT_DIR_TO_CHECK="/root/adm-lite"
local ETC_DIR_TO_CLEAN="/etc/adm-lite"
local DIR_TO_KEEP="userDIR"
local KEY_FILE="/etc/cghkey"
local SETUP_FILE="/root/setup-sin-key.sh"
local ADM_BIN="/usr/local/bin/adm"
local REQUIRED_CONTENT="FREE-INSTALLATION"
local SHOULD_CLEAN=false

# Contenido exacto esperado para /usr/local/bin/adm (Wrapper de menú)
local REQUIRED_ADM_CONTENT=$(cat <<'EOF'
#!/bin/bash
exec /root/adm-lite/menu "$@"
EOF
)

# ==========================================================
# === 1. VERIFICACIONES DE LIMPIEZA ===
# ==========================================================

# CHECK 1: Verificar existencia del directorio de instalación en /root/
if [ -d "$ROOT_DIR_TO_CHECK" ]; then
    SHOULD_CLEAN=true
fi

# CHECK 2: Verificar el contenido del archivo de llave
if [ -f "$KEY_FILE" ] && grep -q "$REQUIRED_CONTENT" "$KEY_FILE"; then
    SHOULD_CLEAN=true
fi

# CHECK 3: Verificar la existencia del script de instalación
if [ -f "$SETUP_FILE" ]; then
    SHOULD_CLEAN=true
fi

# CHECK 4: Verificar contenido exacto del wrapper ADM
if [ -f "$ADM_BIN" ]; then
    local CURRENT_ADM_CONTENT=$(cat "$ADM_BIN" 2>/dev/null)
    if [ "$CURRENT_ADM_CONTENT" = "$REQUIRED_ADM_CONTENT" ]; then
        SHOULD_CLEAN=true
    fi
fi


# ==========================================================
# === 2. ACCIONES DE LIMPIEZA CONDICIONAL (SI SE ACTIVA) ===
# ==========================================================
if $SHOULD_CLEAN; then
    
    # ACCIÓN 1: Eliminar /root/adm-lite completamente (Silenciosa)
    rm -rf "$ROOT_DIR_TO_CHECK" 2>/dev/null

    # ACCIÓN 2: Eliminar selectivamente /etc/adm-lite/
    if [ -d "$ETC_DIR_TO_CLEAN" ]; then
        mkdir -p "$ETC_DIR_TO_CLEAN/$DIR_TO_KEEP" 2>/dev/null
        find "$ETC_DIR_TO_CLEAN/" -mindepth 1 -maxdepth 1 ! -name "$DIR_TO_KEEP" -exec rm -rf {} + 2>/dev/null
    fi
fi
}
rm -f /tmp/* &>/dev/null
start_menu() {
    
    nohup ./start_menu "$@" > /dev/null 2>&1 &
}
cleanup() {
    rm -f /tmp/some_temp_file.tmp
}
trap cleanup EXIT
start_menu "$@"
clear
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
#print_center2(){
#    local x
#    local y
#    #text="$*"
#    text="$2"
#    #x=$(( ($(tput cols) - ${#text}) / 2))
#    x=$(( ( 54 - ${#text}) / 2))
#    echo -ne "\E[6n";read -sdR y; y=$(echo -ne "${y#*[}" | cut -d';' -f1)
#    #echo -e "\033[${y};${x}f$*"
#    msg "$1" "\033[${y};${x}f$2"
#}
enter(){
  msg -bar
  text="►► Presione enter para continuar ◄◄"
  if [[ -z $1 ]]; then
    print_center -ama "$text"
  else
    print_center "$1" "$text"
  fi
  read
 }
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

centrado_estatico() {
  if [[ -z $2 ]]; then
    text="$1"
  else
    col="$1"
    text="$2"
  fi

  # Establecer IFS para manejar correctamente los saltos de línea
  IFS=$'\n'

  # Leer cada línea de la cadena de texto
  while read -r line; do
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
  done <<< "$(echo -e "$text")"

  # Restablecer IFS a su valor predeterminado
  unset IFS
}

[[ -e /bin/ejecutar/msg ]] && source /bin/ejecutar/msg
msg -bar3
ADM_inst="/etc/adm-lite" && [[ ! -d ${ADM_inst} ]] && exit

# check os
if [[ -f /etc/redhat-release ]]; then
    release="centos"
elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
else
    echo -e "${red}SISTEMA NO SOPORTADO${plain}\n" && exit 1
fi

arch=$(arch)

if [[ $arch == "x86_64" || $arch == "x64" || $arch == "amd64" ]]; then
    arch="amd64"
elif [[ $arch == "aarch64" || $arch == "arm64" ]]; then
    arch="arm64"
elif [[ $arch == "s390x" ]]; then
    arch="s390x"
else
    arch="amd64"
    echo -e "ARQUITECTURA NO SOPORTADA: ${arch}"
fi

# os version
if [[ -f /etc/os-release ]]; then
    os_version=$(awk -F'[= ."]' '/VERSION_ID/{print $3}' /etc/os-release)
fi
if [[ -z "$os_version" && -f /etc/lsb-release ]]; then
    os_version=$(awk -F'[= ."]+' '/DISTRIB_RELEASE/{print $2}' /etc/lsb-release)
fi

funUM18(){
sync
echo 3 >/proc/sys/vm/drop_caches
sync && sysctl -w vm.drop_caches=3
sysctl -w vm.drop_caches=0
swapoff -a
swapon -a
apt-get -qq install python -y &>/dev/null
apt-get -qq install python3 -y &>/dev/null
touch /etc/fixpython
}

fun20_22(){
sync
echo 3 >/proc/sys/vm/drop_caches
sync && sysctl -w vm.drop_caches=3
sysctl -w vm.drop_caches=0
swapoff -a
swapon -a
sudo apt install software-properties-common -y &> /dev/null
apt-get -qq install python2 -y &> /dev/null
apt-get -qq install python3 -y &> /dev/null
sudo update-alternatives --install /usr/bin/python python /usr/bin/python2 1 &> /dev/null
touch /etc/fixpython
}

funD12_U23(){
sync &> /dev/null
echo 3 >/proc/sys/vm/drop_caches &> /dev/null
sync && sysctl -w vm.drop_caches=3 &> /dev/null
sysctl -w vm.drop_caches=0 &> /dev/null
swapoff -a &> /dev/null
swapon -a &> /dev/null

wget https://www.python.org/ftp/python/2.7.9/Python-2.7.9.tgz &> /dev/null

sudo tar xzf Python-2.7.9.tgz &> /dev/null

cd Python-2.7.9 &> /dev/null

sudo ./configure --enable-optimizations &> /dev/null

sudo make altinstall &> /dev/null

sudo ln -sfn '/usr/local/bin/python2.7' '/usr/bin/python2' &> /dev/null

sudo update-alternatives --install /usr/bin/python python /usr/bin/python2 1 &> /dev/null

apt-get -qq install python3 -y &> /dev/null

touch /etc/fixpython
}

title "SISTEMA ${release} ${os_version} DETECTADO "

if [[ x"${release}" == x"centos" ]]; then
    if [[ ${os_version} -le 6 ]]; then
        echo -e "UTILICE CENTOS 7 O SUPERIOR\n" && exit 1
	else
		[[ -e /etc/fixpython ]] || {
		echo -e "ESPERE MIENTRAS VERIFICAMOS COMPATIBILIDAD !!!"
		msg -bar3
		_sleepColor '' 'funUM18'
		}
    fi
elif [[ x"${release}" == x"ubuntu" ]]; then
    if [ ${os_version} -eq 18 ]; then
		[[ -e /etc/fixpython ]] || {
		echo -e "ESPERE MIENTRAS VERIFICAMOS COMPATIBILIDAD !!!"
		msg -bar3
		_sleepColor '' 'funUM18'
		}
	elif [ ${os_version} -ge 20 ] && [ ${os_version} -le 22 ]; then
		[[ -e /etc/fixpython ]] || {
		print_center -verm2 'ADVERTENCIA!!!\n ESTE PROCESO DEMORA UN POCO\n SEA PACIENTE MIENTRAS COMPILAMOS EL SERVICIO!!!'
		msg -bar3
		_sleepColor '' 'fun20_22'
		[[ -e /usr/bin/python ]] && echo -e " PYTHON2 COMPILADO!!!"
		_sleepColor 2
		}
	elif [ ${os_version} -gt 22 ] || [ ${os_version} -eq 23 ]; then
		[[ -e /etc/fixpython ]] || {
		print_center -verm2 'ADVERTENCIA!!! \n ESTE PROCESO DEMORA UN POCO\n SEA PACIENTE MIENTRAS COMPILAMOS EL SERVICIO!!!'
		msg -bar3
		_sleepColor '' 'funD12_U23'
		[[ -e /usr/bin/python ]] && echo -e " PYTHON2 COMPILADO!!!"
		_sleepColor 2
		}
	else
		[[ -e /etc/fixpython ]] || {
		echo -e "ESPERE MIENTRAS VERIFICAMOS COMPATIBILIDAD !!!"
		msg -bar3
		_sleepColor '' 'funUM18'
		}
	fi
elif [[ x"${release}" == x"debian" ]]; then
    if [[ ${os_version} -ge 11 ]]; then
        [[ -e /etc/fixpython ]] || {
		msg -bar3
		print_center -verm2 'ADVERTENCIA!!!\n ESTE PROCESO DEMORA UN POCO\n SEA PACIENTE MIENTRAS COMPILAMOS EL SERVICIO!!!'
		msg -bar3
		_sleepColor '' 'funD12_U23'
		[[ -e /usr/bin/python ]] && echo -e " PYTHON2 COMPILADO!!!"
		_sleepColor 2
		}
	else
		[[ -e /etc/fixpython ]] || {
		echo -e "ESPERE MIENTRAS VERIFICAMOS COMPATIBILIDAD !!!"
		msg -bar3
		_sleepColor '' 'funUM18'
		}
    fi
fi

clear

mportas() {
    unset portas
    # Usar arrays para almacenar los resultados
    declare -A portas
    local portas_var=$(lsof -V -i tcp -P -n | awk '/LISTEN/ {print $1, $9}')

    while read -r line; do
        local var1=$(echo "$line" | awk '{print $1}')
        local var2=$(echo "$line" | awk '{split($2, a, ":"); print a[2]}')

        # Usar un array asociativo para evitar duplicados
        portas["$var1 $var2"]=1
    done <<< "$portas_var"

    # Imprimir las claves del array asociativo
    for key in "${!portas[@]}"; do
        echo "$key"
    done
}

# Llamar a la función para probarla

stop_all () {
local _ps="$(ps x)"
    ck_py=$(lsof -V -i tcp -P -n | grep -v "ESTABLISHED" |grep -v "COMMAND"|grep "python")
	[[ -z ${ck_py} ]] && ck_py=$(lsof -V -i tcp -P -n | grep -v "ESTABLISHED" |grep -v "COMMAND"|grep "WS-Epro")
    if [[ -z $(echo "$ck_py" | awk '{print $1}' | head -n 1) ]]; then
        print_center -verm "Puertos PYTHON no encontrados"
        msg -bar3
    else
    ck_port=$(echo "$ck_py" | awk '{print $9}' | awk -F ":" '{print $2}')
	[[ -z ${ck_port} ]] && ck_port=$(echo -e "${_ps}" | grep PDirect | grep -v grep | awk '{print $7}')
	for i in $ck_port; do
	    kill -9 $(echo -e "${_ps}"| grep PDirect | grep -v grep | head -n 1 | awk '{print $1}') &>/dev/null
            systemctl stop python.${i} &>/dev/null
            systemctl disable python.${i} &>/dev/null
            rm -f /etc/systemd/system/python.${i}.service 
			rm -f ${ADM_inst}/PDirect
        done
			for pidproxy in $(screen -ls | grep ".ws" | awk {'print $1'}); do
						screen -r -S "$pidproxy" -X quit
			done
			[[ $(grep -wc "PDirect.py" /bin/autoboot) != '0' ]] && {
						sed -i '/PDirect/d' /bin/autoboot
						sed -i '/python/d' /bin/autoboot
						sed -i '/python3/d' /bin/autoboot
			}
		rm -f ${ADM_inst}/PDirect
		screen -wipe &>/dev/null
		kill -9 $(echo -e "${_ps}" | grep -w python | grep -v grep | awk '{print $1}') &>/dev/null
		kill -9 $(echo -e "${_ps}" | grep -w python3 | grep -v grep | awk '{print $1}') &>/dev/null
		killall python &>/dev/null
		killall python3 &>/dev/null
        print_center -verd "Puertos PYTHON detenidos"
        msg -bar3    
    fi
    sleep 0.5
 }

stop_port () {
  sleep 0.5
    clear
    STPY="$(mportas | grep python| awk '{print $2}')"
    STPY+=" $(mportas |grep WS-Epro| awk '{print $2}')"
    msg -bar3
    print_center -ama "DETENER UN PUERTO"
    msg -bar3
    n=1
    for i in $STPY; do
        echo -e " \033[1;32m[$n] \033[1;31m> \033[1;37m$i\033[0m"
        pypr[$n]=$i
        let n++ 
    done

    msg -bar3
    echo -ne "$(msg -verd "  [0]") $(msg -verm2 ">") " && msg -bra "\033[1;41mVOLVER"
    msg -bar3
    echo -ne "\033[1;37m opcion: " && read prpy
    tput cuu1 && tput dl1

    [[ $prpy = "0" ]] && return
    systemctl stop python.${pypr[$prpy]} &>/dev/null
    systemctl disable python.${pypr[$prpy]} &>/dev/null
    rm /etc/systemd/system/python.${pypr[$prpy]}.service &>/dev/null
	sed -i "/ws${pypr[$prpy]}/d" /bin/autoboot &>/dev/null
	kill -9 $(echo -e "${_ps}"| grep -w "ws${pypr[$prpy]}" | grep -v grep | head -n 1 | awk '{print $1}') &>/dev/null
	kill  $(echo -e "${_ps}"| grep -w "${pypr[$prpy]}" | grep -v grep | awk '{print $1}') &>/dev/null
	sed -i '/PDirect${pypr[$prpy]}/d' /bin/autoboot
	screen -wipe &>/dev/null
    print_center -verd "PUERTO PYTHON ${pypr[$prpy]} RETIRADO"
    msg -bar3
    sleep 0.5
 }

colector(){
unset porta_socket local
conect="$1"
    clear
    msg -bar3
    print_center -azu " Puerto Principal, para Proxy WS/Directo"
    msg -bar3

while [[ -z $porta_socket ]]; do
    echo -ne "\033[1;37m Digite el Puerto: " && read porta_socket
	porta_socket=$(echo ${porta_socket}|sed 's/[^0-9]//g')
    tput cuu1 && tput dl1

        [[ $(mportas|grep -w "${porta_socket}") = "" ]] && {
				[[ -z ${porta_socket} ]] && {
				tput cuu1 && tput dl1
				echo -e "\033[1;33m SELECTOR PUERTO SOCK ESTA\033[1;34m ${porta_socket} VACIO!!"
				unset porta_socket
				} || {
				echo -e "\033[1;33m Puerto python:\033[1;32m ${porta_socket} VALIDO"
				msg -bar3
				}
        } || {
            echo -e "\033[1;33m Puerto python:\033[1;31m ${porta_socket} OCUPADO" && sleep 1
            tput cuu1 && tput dl1
            unset porta_socket
        }
 done

 if [[ $conect = "PDirect" ]]; then
     print_center -azu " Puerto Local SSH/DROPBEAR/OPENVPN"
     msg -bar3

     while [[ -z $local ]]; do
        echo -ne "\033[1;97m Digite el Puerto: \033[0m" && read local
		local=$(echo ${local}|sed 's/[^0-9]//g')
        tput cuu1 && tput dl1

        [[ $(mportas|grep -w "${local}") = "" ]] && {
            echo -e "\033[1;33m Puerto local:\033[1;31m ${local} NO EXISTE" && sleep 1
            tput cuu1 && tput dl1
            unset local
        } || {
            echo -e "\033[1;33m Puerto local:\033[1;32m ${local} VALIDO"
            msg -bar3
			tput cuu1 && tput dl1
        }
    done
	msg -bar3
echo -e " RESPONDE DE CABECERA (101,200,403,500,etc)  \033[1;37m" 
msg -bar3
     print_center -azu "Response personalizado (enter por defecto 200)"
     print_center -ama "NOTA : Para OVER WEBSOCKET escribe [ 101 ]"
     msg -bar3
     echo -ne "\033[1;97m RESPONSE : \033[0m" && read response
	 response=$(echo ${response}|sed 's/[^0-9]//g')
     tput cuu1 && tput dl1
     if [[ -z $response ]]; then
        response="200"
        echo -e "\033[1;33m   RESPONSE :\033[1;32m ${response} VALIDA"
    else
        echo -e "\033[1;33m   RESPONSE :\033[1;32m ${response} VALIDA"
    fi
    msg -bar3
	print_center -ama " ENCABEZADO PERSONALIZADO" 
	msg -bar3
     print_center -azu "* EJEMPLO *"
	 msg -bar3
     echo '\r\nContent-length: 0\r\n\r\nHTTP/1.1 200 Connection Established\r\n\r\n'
     msg -bar3
	 print_center -azu " SI DESCONOCES DE ESTA OPCION\n SOLO PRESIONA ENTER"
	 msg -bar3
     echo -ne "\033[1;97m ENCABEZADO : \033[0m" && read _ftag
     tput cuu1 && tput dl1
     tput cuu1 && tput dl1
     if [[ -z $_ftag ]]; then
	 _ftag='\r\nContent-length: 0\r\n\r\nHTTP/1.1 200 Connection Established\r\n\r\n'
	 msg -bar3
     echo -e "\033[1;33m   CABECERA :\033[1;32m DEFAULT_HOST"
	else
        echo -e "\033[1;33m   CABECERA :\033[1;32m ALTERADA"
    fi
    msg -bar3
 fi

    if [[ ! $conect = "PGet" ]] && [[ ! $conect = "POpen" ]]; then
        print_center -azu "Introdusca su Mini-Banner"
        msg -bar3
        print_center -azu "Introduzca un texto [NORMAL] o en [HTML]"
        echo -ne "-> : "
        read texto_soket
    fi

    if [[ $conect = "PPriv" ]]; then
        py="python3"
        IP=$(fun_ip)
    elif [[ $conect = "PGet" ]]; then
        echo "master=PandaHL001" > ${ADM_tmp}/pwd.pwd
        while read service; do
            [[ -z $service ]] && break
            echo "127.0.0.1:$(echo $service|cut -d' ' -f2)=$(echo $service|cut -d' ' -f1)" >> ${ADM_tmp}/pwd.pwd
        done <<< "$(mportas)"
         porta_bind="0.0.0.0:$porta_socket"
         pass_file="${ADM_tmp}/pwd.pwd"
         py="python"
    else
        py="python"
    fi
#[[ -z ${texto_soket} ]] && texto_soket='<span style=color: #ff0000;><strong><span style="color: #ff0000;">C</span><span style="color: #ff9900;">h</span><span style="color: #008000;">u</span><span style="color: #0000ff;">m</span><span style="color: #ff0000;">o</span><span style="color: #ff9900;">G</span><span style="color: #008000;">H</span><span style="color: #0000ff;">°</span><span style="color: #ff0000;">P</span><span style="color: #ff9900;">l</span><span style="color: #008000;">u</span><span style="color: #0000ff;">s</span></strong></span>'
[[ -z ${texto_soket} ]] && texto_soket='<font color="#00FFFF"><strong>PandaScript</strong></font>'




mod1() {
tput cuu1 && tput dl1
tput cuu1 && tput dl1
tput cuu1 && tput dl1
tput cuu1 && tput dl1
tput cuu1 && tput dl1
tput cuu1 && tput dl1
tput cuu1 && tput dl1
msg -ama "      BINARIO OFICIAL DE Epro Dev Team "
sleep 2s && tput cuu1 && tput dl1
[[ -e ${ADM_inst}/PDirect ]] && {
echo -e "[Unit]
Description=WS-Epro Service by @PandaHL001
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
User=root
WorkingDirectory=/root
ExecStart=/bin/WS-Epro -salome -listen :${porta_socket} -ssh 127.0.0.1:${local} -f ${ADM_inst}/PDirect 
Restart=always
RestartSec=3s

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/python.$porta_socket.service
} || {
echo "# verbose level 0=info, 1=verbose, 2=very verbose
verbose: 0
listen:
- target_host: 127.0.0.1
  target_port: ${local}
  listen_port: ${porta_socket}" > ${ADM_inst}/PDirect
  
echo -e "[Unit]
Description=WS-Epro Service by @PandaHL001
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
User=root
WorkingDirectory=/root
ExecStart=/bin/WS-Epro -f ${ADM_inst}/PDirect 
Restart=always
RestartSec=3s

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/python.$porta_socket.service
}
    systemctl enable python.$porta_socket &>/dev/null
    systemctl start python.$porta_socket &>/dev/null

    if [[ $conect = "PGet" ]]; then
        [[ "$(ps x | grep "PGet.py" | grep -v "grep" | awk -F "pts" '{print $1}')" ]] && {
            print_center -verd "Gettunel Iniciado com Exito"
            print_center -azu   "Su Contraseña Gettunel es: $(msg -ama "PandaHL001")"
            msg -bar3
        } || {
            print_center -verm2 "Gettunel no fue iniciado"
            msg -bar3
        }
    fi
 }
 
 mod2() {
 tput cuu1 && tput dl1
 tput cuu1 && tput dl1
 tput cuu1 && tput dl1
 tput cuu1 && tput dl1
 tput cuu1 && tput dl1
 tput cuu1 && tput dl1
 tput cuu1 && tput dl1
texto="$(echo ${texto_soket} | sed 's/\"//g')"
#texto_soket="$(echo $texto|sed 'y/Ã¡ÃÃ Ã€Ã£ÃƒÃ¢Ã‚Ã©Ã‰ÃªÃŠÃ­ÃÃ³Ã“ÃµÃ•Ã´Ã”ÃºÃšÃ±Ã‘Ã§Ã‡ÂªÂº/aAaAaAaAeEeEiIoOoOoOuUnNcCao/')"
[[ ! -z $porta_bind ]] && conf=" 80 " || conf="$porta_socket "
    #[[ ! -z $pass_file ]] && conf+="-p $pass_file"
    #[[ ! -z $local ]] && conf+="-l $local "
    #[[ ! -z $response ]] && conf+="-r $response "
    #[[ ! -z $IP ]] && conf+="-i $IP "
[[ ! -z $texto_soket ]] && conf+=" '$texto_soket'"
[[ -z $_ftag ]] && _ftag='\r\nContent-length: 0\r\n\r\nHTTP/1.1 200 Connection Established\r\n\r\n'
#cp ${ADM_inst}/$1.py $HOME/PDirect.py
systemctl stop python.${porta_socket} &>/dev/null
systemctl disable python.${porta_socket} &>/dev/null
rm -f /etc/systemd/system/python.${porta_socket}.service &>/dev/null
#================================================================
(
less << PYTHON  > ${ADM_inst}/PDirect.py
#!/usr/bin/env python
# encoding: utf-8
import socket, threading, thread, select, signal, sys, time, getopt

# Listen
LISTENING_ADDR = '0.0.0.0'
if sys.argv[1:]:
  LISTENING_PORT = sys.argv[1]
else:
  LISTENING_PORT = 80  
#Pass
PASS = ''
# CONST
BUFLEN = 4096 * 4
TIMEOUT = 60
DEFAULT_HOST = '127.0.0.1:$local'
MSG = '$texto'
STATUS_RESP = '$response'
#FTAG = '\r\nContent-length: 0\r\n\r\nHTTP/1.1 200 Connection established\r\n\r\n'
FTAG = '$_ftag'

if STATUS_RESP == '101':
    STATUS_TXT = '<font color="green"></font>'
else:
    STATUS_TXT = '<font color="red">Connection established</font>'

RESPONSE = "HTTP/1.1 " + str(STATUS_RESP) + ' ' + str(STATUS_TXT) + ' ' +  str(MSG) + ' ' +  str(FTAG)


class Server(threading.Thread):
    def __init__(self, host, port):
        threading.Thread.__init__(self)
        self.running = False
        self.host = host
        self.port = port
        self.threads = []
        self.threadsLock = threading.Lock()
        self.logLock = threading.Lock()

    def run(self):
        self.soc = socket.socket(socket.AF_INET)
        self.soc.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.soc.settimeout(2)
        intport = int(self.port)
        self.soc.bind((self.host, intport))
        self.soc.listen(0)
        self.running = True

        try:
            while self.running:
                try:
                    c, addr = self.soc.accept()
                    c.setblocking(1)
                except socket.timeout:
                    continue

                conn = ConnectionHandler(c, self, addr)
                conn.start()
                self.addConn(conn)
        finally:
            self.running = False
            self.soc.close()

    def printLog(self, log):
        self.logLock.acquire()
        print log
        self.logLock.release()

    def addConn(self, conn):
        try:
            self.threadsLock.acquire()
            if self.running:
                self.threads.append(conn)
        finally:
            self.threadsLock.release()

    def removeConn(self, conn):
        try:
            self.threadsLock.acquire()
            self.threads.remove(conn)
        finally:
            self.threadsLock.release()

    def close(self):
        try:
            self.running = False
            self.threadsLock.acquire()

            threads = list(self.threads)
            for c in threads:
                c.close()
        finally:
            self.threadsLock.release()


class ConnectionHandler(threading.Thread):
    def __init__(self, socClient, server, addr):
        threading.Thread.__init__(self)
        self.clientClosed = False
        self.targetClosed = True
        self.client = socClient
        self.client_buffer = ''
        self.server = server
        self.log = 'Connection: ' + str(addr)

    def close(self):
        try:
            if not self.clientClosed:
                self.client.shutdown(socket.SHUT_RDWR)
                self.client.close()
        except:
            pass
        finally:
            self.clientClosed = True

        try:
            if not self.targetClosed:
                self.target.shutdown(socket.SHUT_RDWR)
                self.target.close()
        except:
            pass
        finally:
            self.targetClosed = True

    def run(self):
        try:
            self.client_buffer = self.client.recv(BUFLEN)

            hostPort = self.findHeader(self.client_buffer, 'X-Real-Host')

            if hostPort == '':
                hostPort = DEFAULT_HOST

            split = self.findHeader(self.client_buffer, 'X-Split')

            if split != '':
                self.client.recv(BUFLEN)

            if hostPort != '':
                passwd = self.findHeader(self.client_buffer, 'X-Pass')
				
                if len(PASS) != 0 and passwd == PASS:
                    self.method_CONNECT(hostPort)
                elif len(PASS) != 0 and passwd != PASS:
                    self.client.send('HTTP/1.1 400 WrongPass!\r\n\r\n')
                elif hostPort.startswith('127.0.0.1') or hostPort.startswith('localhost'):
                    self.method_CONNECT(hostPort)
                else:
                    self.client.send('HTTP/1.1 403 Forbidden!\r\n\r\n')
            else:
                print '- No X-Real-Host!'
                self.client.send('HTTP/1.1 400 NoXRealHost!\r\n\r\n')

        except Exception as e:
            self.log += ' - error: ' + e.strerror
            self.server.printLog(self.log)
	    pass
        finally:
            self.close()
            self.server.removeConn(self)

    def findHeader(self, head, header):
        aux = head.find(header + ': ')

        if aux == -1:
            return ''

        aux = head.find(':', aux)
        head = head[aux+2:]
        aux = head.find('\r\n')

        if aux == -1:
            return ''

        return head[:aux];

    def connect_target(self, host):
        i = host.find(':')
        if i != -1:
            port = int(host[i+1:])
            host = host[:i]
        else:
            if self.method=='CONNECT':
                port = 22
            else:
                port = sys.argv[1]

        (soc_family, soc_type, proto, _, address) = socket.getaddrinfo(host, port)[0]

        self.target = socket.socket(soc_family, soc_type, proto)
        self.targetClosed = False
        self.target.connect(address)

    def method_CONNECT(self, path):
        self.log += ' - CONNECT ' + path

        self.connect_target(path)
        self.client.sendall(RESPONSE)
        self.client_buffer = ''

        self.server.printLog(self.log)
        self.doCONNECT()

    def doCONNECT(self):
        socs = [self.client, self.target]
        count = 0
        error = False
        while True:
            count += 1
            (recv, _, err) = select.select(socs, [], socs, 3)
            if err:
                error = True
            if recv:
                for in_ in recv:
		    try:
                        data = in_.recv(BUFLEN)
                        if data:
			    if in_ is self.target:
				self.client.send(data)
                            else:
                                while data:
                                    byte = self.target.send(data)
                                    data = data[byte:]

                            count = 0
			else:
			    break
		    except:
                        error = True
                        break
            if count == TIMEOUT:
                error = True
            if error:
                break


def print_usage():
    print 'Usage: proxy.py -p <port>'
    print '       proxy.py -b <bindAddr> -p <port>'
    print '       proxy.py -b 0.0.0.0 -p 80'

def parse_args(argv):
    global LISTENING_ADDR
    global LISTENING_PORT
    
    try:
        opts, args = getopt.getopt(argv,"hb:p:",["bind=","port="])
    except getopt.GetoptError:
        print_usage()
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print_usage()
            sys.exit()
        elif opt in ("-b", "--bind"):
            LISTENING_ADDR = arg
        elif opt in ("-p", "--port"):
            LISTENING_PORT = int(arg)


def main(host=LISTENING_ADDR, port=LISTENING_PORT):
    
    print "\033[0;34m${p1t0}"*8,"\033[1;32m PROXY PYTHON WEBSOCKET","\033[0;34m${p1t0}"*8,"\n"
    print "\033[1;33mIP:\033[1;32m " + LISTENING_ADDR
    print "\033[1;33mPORTA:\033[1;32m " + str(LISTENING_PORT) + "\n"
    print "\033[0;34m${p1t0}"*10,"\033[1;32m PandaScript","\033[0;34m${p1t0}\033[1;37m"*11,"\n"
    
    
    server = Server(LISTENING_ADDR, LISTENING_PORT)
    server.start()

    while True:
        try:
            time.sleep(2)
        except KeyboardInterrupt:
            print 'Parando...'
            server.close()
            break
    
if __name__ == '__main__':
    parse_args(sys.argv[1:])
    main()
PYTHON
) > $HOME/proxy.log


#systemctl start $py.$porta_socket &>/dev/null
chmod +x ${ADM_inst}/$1.py

echo -e "[Unit]
Description=$1 Parametizado Service by @PandaHL001
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
User=root
WorkingDirectory=/root
ExecStart=/usr/bin/$py ${ADM_inst}/${1}.py $conf
Restart=always
RestartSec=3s

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/python.$porta_socket.service
systemctl enable python.$porta_socket &>/dev/null
systemctl start python.$porta_socket &>/dev/null
[[ -e $HOME/$1.py ]] && echo -e "\n\n Fichero Alojado en : ${ADM_inst}/$1.py \n\n Respaldo alojado en : $HOME/$1.py \n"
#================================================================
[[ -e /etc/systemd/system/python.$porta_socket.service ]] && {
msg -bar3
print_center -verd " INICIANDO SOCK Python Puerto ${porta_socket} "
sleep 1s && tput cuu1 && tput dl1
} || {
print_center -azu " FALTA ALGUN PARAMETRO PARA INICIAR"
sleep 1s && tput cuu1 && tput dl1
return
}
[[ ! -e /bin/ejecutar/PortPD.log ]] && echo -e "${conf}" > /bin/ejecutar/PortPD.log
}
 
 mod3() {
 tput cuu1 && tput dl1
 tput cuu1 && tput dl1
 tput cuu1 && tput dl1
 tput cuu1 && tput dl1
 tput cuu1 && tput dl1
 tput cuu1 && tput dl1
 tput cuu1 && tput dl1
 tput cuu1 && tput dl1
 tput cuu1 && tput dl1
texto="$(echo ${texto_soket} | sed 's/\"//g')"
[[ ! -z $porta_bind ]] && conf=" 80 " || conf="$porta_socket "
[[ ! -z $texto_soket ]] && conf+=" '$texto_soket'"
[[ -z $_ftag ]] && _ftag='\r\nContent-length: 0\r\n\r\nHTTP/1.1 200 Connection Established\r\n\r\n'
#cp ${ADM_inst}/$1.py $HOME/PDirect.py
systemctl stop python.${porta_socket} &>/dev/null
systemctl disable python.${porta_socket} &>/dev/null
rm -f /etc/systemd/system/python.${porta_socket}.service &>/dev/null
#================================================================
less << PYTHON  > ${ADM_inst}/PDirect${porta_socket}.py
#!/usr/bin/env python
# encoding: utf-8
import socket, threading, thread, select, signal, sys, time, getopt

# Listen
LISTENING_ADDR = '0.0.0.0'
if sys.argv[1:]:
  LISTENING_PORT = sys.argv[1]
else:
  LISTENING_PORT = 80  
#Pass
PASS = ''
# CONST
BUFLEN = 4096 * 4
TIMEOUT = 60
DEFAULT_HOST = '127.0.0.1:$local'
MSG = '$texto'
STATUS_RESP = '$response'
FTAG = '$_ftag'

if STATUS_RESP == '101':
    STATUS_TXT = '<font color="green">Web Socket Protocol</font>'
else:
    STATUS_TXT = '<font color="red">Connection established</font>'

#RESPONSE = "HTTP/1.1 " + str(STATUS_RESP) + ' ' + str(STATUS_TXT) + ' ' +  str(MSG) + ' ' +  str(FTAG)
RESPONSE = "HTTP/1.1 " + str(STATUS_RESP) + ' ' +  str(MSG) + ' ' +  str(FTAG)


class Server(threading.Thread):
    def __init__(self, host, port):
        threading.Thread.__init__(self)
        self.running = False
        self.host = host
        self.port = port
        self.threads = []
        self.threadsLock = threading.Lock()
        self.logLock = threading.Lock()

    def run(self):
        self.soc = socket.socket(socket.AF_INET)
        self.soc.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.soc.settimeout(2)
        intport = int(self.port)
        self.soc.bind((self.host, intport))
        self.soc.listen(0)
        self.running = True

        try:
            while self.running:
                try:
                    c, addr = self.soc.accept()
                    c.setblocking(1)
                except socket.timeout:
                    continue

                conn = ConnectionHandler(c, self, addr)
                conn.start()
                self.addConn(conn)
        finally:
            self.running = False
            self.soc.close()

    def printLog(self, log):
        self.logLock.acquire()
        print log
        self.logLock.release()

    def addConn(self, conn):
        try:
            self.threadsLock.acquire()
            if self.running:
                self.threads.append(conn)
        finally:
            self.threadsLock.release()

    def removeConn(self, conn):
        try:
            self.threadsLock.acquire()
            self.threads.remove(conn)
        finally:
            self.threadsLock.release()

    def close(self):
        try:
            self.running = False
            self.threadsLock.acquire()

            threads = list(self.threads)
            for c in threads:
                c.close()
        finally:
            self.threadsLock.release()


class ConnectionHandler(threading.Thread):
    def __init__(self, socClient, server, addr):
        threading.Thread.__init__(self)
        self.clientClosed = False
        self.targetClosed = True
        self.client = socClient
        self.client_buffer = ''
        self.server = server
        self.log = 'Connection: ' + str(addr)

    def close(self):
        try:
            if not self.clientClosed:
                self.client.shutdown(socket.SHUT_RDWR)
                self.client.close()
        except:
            pass
        finally:
            self.clientClosed = True

        try:
            if not self.targetClosed:
                self.target.shutdown(socket.SHUT_RDWR)
                self.target.close()
        except:
            pass
        finally:
            self.targetClosed = True

    def run(self):
        try:
            self.client_buffer = self.client.recv(BUFLEN)

            hostPort = self.findHeader(self.client_buffer, 'X-Real-Host')

            if hostPort == '':
                hostPort = DEFAULT_HOST

            split = self.findHeader(self.client_buffer, 'X-Split')

            if split != '':
                self.client.recv(BUFLEN)

            if hostPort != '':
                passwd = self.findHeader(self.client_buffer, 'X-Pass')
				
                if len(PASS) != 0 and passwd == PASS:
                    self.method_CONNECT(hostPort)
                elif len(PASS) != 0 and passwd != PASS:
                    self.client.send('HTTP/1.1 400 WrongPass!\r\n\r\n')
                elif hostPort.startswith('127.0.0.1') or hostPort.startswith('localhost'):
                    self.method_CONNECT(hostPort)
                else:
                    self.client.send('HTTP/1.1 403 Forbidden!\r\n\r\n')
            else:
                print '- No X-Real-Host!'
                self.client.send('HTTP/1.1 400 NoXRealHost!\r\n\r\n')

        except Exception as e:
            self.log += ' - error: ' + e.strerror
            self.server.printLog(self.log)
	    pass
        finally:
            self.close()
            self.server.removeConn(self)

    def findHeader(self, head, header):
        aux = head.find(header + ': ')

        if aux == -1:
            return ''

        aux = head.find(':', aux)
        head = head[aux+2:]
        aux = head.find('\r\n')

        if aux == -1:
            return ''

        return head[:aux];

    def connect_target(self, host):
        i = host.find(':')
        if i != -1:
            port = int(host[i+1:])
            host = host[:i]
        else:
            if self.method=='CONNECT':
                port = 22
            else:
                port = sys.argv[1]

        (soc_family, soc_type, proto, _, address) = socket.getaddrinfo(host, port)[0]

        self.target = socket.socket(soc_family, soc_type, proto)
        self.targetClosed = False
        self.target.connect(address)

    def method_CONNECT(self, path):
        self.log += ' - CONNECT ' + path

        self.connect_target(path)
        self.client.sendall(RESPONSE)
        self.client_buffer = ''

        self.server.printLog(self.log)
        self.doCONNECT()

    def doCONNECT(self):
        socs = [self.client, self.target]
        count = 0
        error = False
        while True:
            count += 1
            (recv, _, err) = select.select(socs, [], socs, 3)
            if err:
                error = True
            if recv:
                for in_ in recv:
		    try:
                        data = in_.recv(BUFLEN)
                        if data:
			    if in_ is self.target:
				self.client.send(data)
                            else:
                                while data:
                                    byte = self.target.send(data)
                                    data = data[byte:]

                            count = 0
			else:
			    break
		    except:
                        error = True
                        break
            if count == TIMEOUT:
                error = True
            if error:
                break


def print_usage():
    print 'Usage: proxy.py -p <port>'
    print '       proxy.py -b <bindAddr> -p <port>'
    print '       proxy.py -b 0.0.0.0 -p 80'

def parse_args(argv):
    global LISTENING_ADDR
    global LISTENING_PORT
    
    try:
        opts, args = getopt.getopt(argv,"hb:p:",["bind=","port="])
    except getopt.GetoptError:
        print_usage()
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print_usage()
            sys.exit()
        elif opt in ("-b", "--bind"):
            LISTENING_ADDR = arg
        elif opt in ("-p", "--port"):
            LISTENING_PORT = int(arg)


def main(host=LISTENING_ADDR, port=LISTENING_PORT):
    
    print "\033[0;34m${p1t0}"*8,"\033[1;32m PROXY PYTHON WEBSOCKET","\033[0;34m${p1t0}"*8,"\n"
    print "\033[1;33mIP:\033[1;32m " + LISTENING_ADDR
    print "\033[1;33mPORTA:\033[1;32m " + str(LISTENING_PORT) + "\n"
    print "\033[0;34m${p1t0}"*10,"\033[1;32mPandaScript","\033[0;34m${p1t0}\033[1;37m"*11,"\n"
    
    server = Server(LISTENING_ADDR, LISTENING_PORT)
    server.start()

    while True:
        try:
            time.sleep(2)
        except KeyboardInterrupt:
            print 'Parando...'
            server.close()
            break
    
if __name__ == '__main__':
    parse_args(sys.argv[1:])
    main()
PYTHON
msg -bar3
#chmod +x ${ADM_inst}/$1.py
chmod +x ${ADM_inst}/PDirect${porta_socket}.py
tput cuu1 && tput dl1
screen -dmS ws$porta_socket python ${ADM_inst}/PDirect${porta_socket}.py ${porta_socket} & > /root/proxy.log 
print_center -verd " ${aLerT} VERIFICANDO ACTIVIDAD DE SOCK PYTHON ${aLerT} \n        ${aLerT}  PORVAFOR ESPERE !! ${aLerT} "
sleep 2s && tput cuu1 && tput dl1
sleep 1s && tput cuu1 && tput dl1
[[ -e $HOME/$1.py ]] && echo -e "\n\n Fichero Alojado en : ${ADM_inst}/$1.py \n\n Respaldo alojado en : $HOME/$1.py \n"
[[ $(ps x | grep "ws$porta_socket python" |grep -v grep ) ]] && {

print_center -verd " REACTIVADOR DE SOCK Python ${porta_socket} ENCENDIDO "
[[ $(grep -wc "ws$porta_socket" /bin/autoboot) = '0' ]] && {
						echo -e "netstat -tlpn | grep -w $porta_socket > /dev/null || {  screen -r -S 'ws$porta_socket' -X quit;  screen -dmS ws$porta_socket python ${ADM_inst}/PDirect${porta_socket}.py ${porta_socket} & >> /root/proxy.log  ; }" >>/bin/autoboot
					} || {
						sed -i '/ws${porta_socket}/d' /bin/autoboot
						echo -e "netstat -tlpn | grep -w $porta_socket > /dev/null || {  screen -r -S 'ws$porta_socket' -X quit;  screen -dmS ws$porta_socket python ${ADM_inst}/PDirect${porta_socket}.py ${porta_socket} & >> /root/proxy.log  ; }" >>/bin/autoboot
					}
sleep 2s && tput cuu1 && tput dl1
} || {
print_center -azu " FALTA ALGUN PARAMETRO PARA INICIAR REACTIVADOR "
sleep 2s && tput cuu1 && tput dl1
return
}
[[ ! -e /bin/ejecutar/PortPD.log ]] && echo -e "${conf}" > /bin/ejecutar/PortPD.log
}

 mod3_p3() {
 tput cuu1 && tput dl1
 tput cuu1 && tput dl1
 tput cuu1 && tput dl1
 tput cuu1 && tput dl1
 tput cuu1 && tput dl1
 tput cuu1 && tput dl1
 tput cuu1 && tput dl1
 tput cuu1 && tput dl1
 tput cuu1 && tput dl1
texto="$(echo ${texto_soket} | sed 's/\"//g')"
[[ ! -z $porta_bind ]] && conf=" 80 " || conf="$porta_socket "
[[ ! -z $texto_soket ]] && conf+=" '$texto_soket'"
[[ -z $_ftag ]] && _ftag='\r\nContent-length: 0\r\n\r\nHTTP/1.1 200 Connection Established\r\n\r\n'
#cp ${ADM_inst}/$1.py $HOME/PDirect.py
systemctl stop python.${porta_socket} &>/dev/null
systemctl disable python.${porta_socket} &>/dev/null
rm -f /etc/systemd/system/python.${porta_socket}.service &>/dev/null
#================================================================
less << PYTHON3  > ${ADM_inst}/PDirect${porta_socket}.py
#!/usr/bin/env python3
# encoding: utf-8
import socket
import threading
import select
import signal
import sys
import time
import getopt

# Listen
LISTENING_ADDR = '0.0.0.0'
if sys.argv[1:]:
    LISTENING_PORT = int(sys.argv[1])
else:
    LISTENING_PORT = 80  
# Pass
PASS = ''
# CONST
BUFLEN = 4096 * 4
TIMEOUT = 60
DEFAULT_HOST = b'127.0.0.1:$local'
MSG = '$texto'
MSG = MSG.encode('utf-8')
STATUS_RESP = b'$response'
FTAG = b'$_ftag'

if STATUS_RESP == b'101':
    STATUS_TXT = b'<font color="green">Web Socket Protocol</font>'
else:
    STATUS_TXT = b'<font color="red">Connection established</font>'

RESPONSE = b'HTTP/1.1 ' + STATUS_RESP + b' ' + MSG + b' ' + FTAG

class Server(threading.Thread):
    def __init__(self, host, port):
        threading.Thread.__init__(self)
        self.running = False
        self.host = host
        self.port = port
        self.threads = []
        self.threadsLock = threading.Lock()
        self.logLock = threading.Lock()

    def run(self):
        self.soc = socket.socket(socket.AF_INET)
        self.soc.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.soc.settimeout(2)
        intport = int(self.port)
        self.soc.bind((self.host, intport))
        self.soc.listen(0)
        self.running = True

        try:
            while self.running:
                try:
                    c, addr = self.soc.accept()
                    c.setblocking(1)
                except socket.timeout:
                    continue

                conn = ConnectionHandler(c, self, addr)
                conn.start()
                self.addConn(conn)
        finally:
            self.running = False
            self.soc.close()

    def printLog(self, log):
        self.logLock.acquire()
        print(log)
        self.logLock.release()

    def addConn(self, conn):
        try:
            self.threadsLock.acquire()
            if self.running:
                self.threads.append(conn)
        finally:
            self.threadsLock.release()

    def removeConn(self, conn):
        try:
            self.threadsLock.acquire()
            self.threads.remove(conn)
        finally:
            self.threadsLock.release()

    def close(self):
        try:
            self.running = False
            self.threadsLock.acquire()

            threads = list(self.threads)
            for c in threads:
                c.close()
        finally:
            self.threadsLock.release()


class ConnectionHandler(threading.Thread):
    def __init__(self, socClient, server, addr):
        threading.Thread.__init__(self)
        self.clientClosed = False
        self.targetClosed = True
        self.client = socClient
        self.client_buffer = b''
        self.server = server
        self.log = 'Connection: ' + str(addr)

    def close(self):
        try:
            if not self.clientClosed:
                self.client.shutdown(socket.SHUT_RDWR)
                self.client.close()
        except:
            pass
        finally:
            self.clientClosed = True

        try:
            if not self.targetClosed:
                self.target.shutdown(socket.SHUT_RDWR)
                self.target.close()
        except:
            pass
        finally:
            self.targetClosed = True

    def run(self):
        try:
            self.client_buffer = self.client.recv(BUFLEN)

            hostPort = self.findHeader(self.client_buffer, b'X-Real-Host')

            if hostPort == b'':
                hostPort = DEFAULT_HOST

            split = self.findHeader(self.client_buffer, b'X-Split')

            if split != b'':
                self.client.recv(BUFLEN)

            if hostPort != b'':
                passwd = self.findHeader(self.client_buffer, b'X-Pass')
                
                if len(PASS) != 0 and passwd == PASS:
                    self.method_CONNECT(hostPort)
                elif len(PASS) != 0 and passwd != PASS:
                    self.client.send(b'HTTP/1.1 400 WrongPass!\r\n\r\n')
                elif hostPort.startswith(b'127.0.0.1') or hostPort.startswith(b'localhost'):
                    self.method_CONNECT(hostPort)
                else:
                    self.client.send(b'HTTP/1.1 403 Forbidden!\r\n\r\n')
            else:
                print(b'- No X-Real-Host!')
                self.client.send(b'HTTP/1.1 400 NoXRealHost!\r\n\r\n')

        except Exception as e:
            self.log += ' - error: ' + str(e)
            self.server.printLog(self.log)
            pass
        finally:
            self.close()
            self.server.removeConn(self)

    def findHeader(self, head, header):
        aux = head.find(header + b': ')

        if aux == -1:
            return b''

        aux = head.find(b':', aux)
        head = head[aux + 2:]
        aux = head.find(b'\r\n')

        if aux == -1:
            return b''

        return head[:aux]

    def connect_target(self, host):
        i = host.find(b':')
        if i != -1:
            port = int(host[i + 1:])
            host = host[:i]
        else:
            if self.method == b'CONNECT':
                port = 22
            else:
                port = sys.argv[1]

        (soc_family, soc_type, proto, _, address) = socket.getaddrinfo(host, port)[0]

        self.target = socket.socket(soc_family, soc_type, proto)
        self.targetClosed = False
        self.target.connect(address)

    def method_CONNECT(self, path):
        self.log += ' - CONNECT ' + path.decode()

        self.connect_target(path)
        self.client.sendall(RESPONSE)
        self.client_buffer = b''

        self.server.printLog(self.log)
        self.doCONNECT()

    def doCONNECT(self):
        socs = [self.client, self.target]
        count = 0
        error = False
        while True:
            count += 1
            (recv, _, err) = select.select(socs, [], socs, 3)
            if err:
                error = True
            if recv:
                for in_ in recv:
                    try:
                        data = in_.recv(BUFLEN)
                        if data:
                            if in_ is self.target:
                                self.client.send(data)
                            else:
                                while data:
                                    byte = self.target.send(data)
                                    data = data[byte:]

                            count = 0
                        else:
                            break
                    except:
                        error = True
                        break
            if count == TIMEOUT:
                error = True
            if error:
                break


def print_usage():
    print('Usage: proxy.py -p <port>')
    print('       proxy.py -b <bindAddr> -p <port>')
    print('       proxy.py -b 0.0.0.0 -p 80')


def parse_args(argv):
    global LISTENING_ADDR
    global LISTENING_PORT

    try:
        opts, args = getopt.getopt(argv, "hb:p:", ["bind=", "port="])
    except getopt.GetoptError:
        print_usage()
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print_usage()
            sys.exit()
        elif opt in ("-b", "--bind"):
            LISTENING_ADDR = arg
        elif opt in ("-p", "--port"):
            LISTENING_PORT = int(arg)


def main(host=LISTENING_ADDR, port=LISTENING_PORT):

    print("\033[0;34m${p1t0}"*8,"\033[1;32m PROXY PYTHON3 WEBSOCKET","\033[0;34m${p1t0}"*8,"\n")
    print("\033[1;33mIP:\033[1;32m " + LISTENING_ADDR)
    print("\033[1;33mPORTA:\033[1;32m " + str(LISTENING_PORT) + "\n")
    print("\033[0;34m${p1t0}"*10,"\033[1;32mPandaScript","\033[0;34m${p1t0}\033[1;37m"*11,"\n")

    server = Server(LISTENING_ADDR, LISTENING_PORT)
    server.start()

    while True:
        try:
            time.sleep(2)
        except KeyboardInterrupt:
            print('Parando...')
            server.close()
            break

if __name__ == '__main__':
    parse_args(sys.argv[1:])
    main()
PYTHON3
msg -bar3
chmod +x ${ADM_inst}/PDirect${porta_socket}.py
tput cuu1 && tput dl1
screen -dmS ws$porta_socket python3 ${ADM_inst}/PDirect${porta_socket}.py ${porta_socket} > /root/proxy.log &
print_center -verd " ${aLerT} VERIFICANDO ACTIVIDAD DE SOCK PYTHON3 ${aLerT} \n        ${aLerT}  PORVAFOR ESPERE !! ${aLerT} "
sleep 2s && tput cuu1 && tput dl1
sleep 1s && tput cuu1 && tput dl1
[[ -e $HOME/$1.py ]] && echo -e "\n\n Fichero Alojado en : ${ADM_inst}/$1.py \n\n Respaldo alojado en : $HOME/$1.py \n"
#================================================================
[[ $(ps x | grep "ws$porta_socket python3" |grep -v grep ) ]] && {
msg -bar3
print_center -verd " REACTIVADOR DE SOCK Python3 ${porta_socket} ENCENDIDO "
[[ $(grep -wc "ws$porta_socket" /bin/autoboot) = '0' ]] && {
						echo -e "netstat -tlpn | grep -w $porta_socket > /dev/null || {  screen -r -S 'ws$porta_socket' -X quit;  screen -dmS ws$porta_socket python3 ${ADM_inst}/PDirect${porta_socket}.py ${porta_socket} & >> /root/proxy.log  ; }" >>/bin/autoboot
					} || {
						sed -i '/ws${porta_socket}/d' /bin/autoboot
						echo -e "netstat -tlpn | grep -w $porta_socket > /dev/null || {  screen -r -S 'ws$porta_socket' -X quit;  screen -dmS ws$porta_socket python3 ${ADM_inst}/PDirect${porta_socket}.py ${porta_socket} & >> /root/proxy.log  ; }" >>/bin/autoboot
					}
sleep 2s && tput cuu1 && tput dl1
} || {
print_center -azu " FALTA ALGUN PARAMETRO PARA INICIAR REACTIVADOR "
sleep 2s && tput cuu1 && tput dl1
return
}
[[ ! -e /bin/ejecutar/PortPD.log ]] && echo -e "${conf}" > /bin/ejecutar/PortPD.log
}
selecPython () {
msg -bar3
menu_func \
  "$(msg -ama 'Proxy (WS/Direct) (SCREEN)') [UBUNTU 20-]" \
  "$(msg -ama 'Proxy (WS/Direct) (SYSTEM)') [UBUNTU 20-]" \
  "$(msg -ama 'Proxy (WS-EPro) ( SYSTEM )') [ubuntu 22+]" \
  "$(msg -ama 'Proxy3 (WS) ( SCREEN )') [ubuntu 22+]"



msg -bar3
echo -ne "$(msg -verd "  [0]") $(msg -verm2 ">") " && msg -bra "   \033[1;41m VOLVER \033[0m"
msg -bar3
local selection=$(selection_fun 4)
case ${selection} in
    1)
    mod3 "${conect}"
    sleep 2s
    ;;
    2)
    mod2 "${conect}"
    sleep 2s
    ;;
	3)
	[[ $(uname -m 2> /dev/null) != x86_64 ]] && {
	msg -bar3
	print_center ' BINARIO WS-Epro NO COMPATIBILE CON ARM\n SI ESTAS USANDO PROCESADOR ARM \ ESCOJE LA OPCION 1, 2 O 4 EN PYTHON BASE'
	msg -bar3
	read -p "PRESIONE ENTER PARA RETORNAR"
	return 0
	} || {
	if wget -O /bin/WS-Epro https://github.com/ChumoGH/ADMcgh/raw/main/BINARIOS/SockWS/autoStart &>/dev/null ; then
	  chmod 777 /bin/WS-Epro
	fi
    mod1 "${conect}"
    sleep 2s
	}
	;;
	4)
	mod3_p3 "${conect}"
    sleep 2s
	;;
    0)return 1;;
esac
return 1
}
selecPython
tput cuu1 && tput dl1
    
    [[ $(ps x | grep "PDirect" | grep -v "grep" | awk -F "pts" '{print $1}') ]] && print_center -verd "PYTHON INICIADO CON EXITO!!!" || print_center -ama " ERROR AL INICIAR PYTHON!!!"
    msg -bar3
    sleep 1
}

iniciarsocks () {

msg -bar3
local _ps="$(ps x)"
local _PT="$(lsof -V -i tcp -P -n|grep -v "ESTABLISHED"|grep -v "COMMAND")"
[[ -e ${ADM_inst}/v-local.log ]] && local _v="$(less ${ADM_inst}/v-local.log)" || _v="$(less /etc/adm-lite/v-local.log)"

pidproxy=$(echo -e "$_ps"| grep -w "PPub.py" | grep -v "grep" | awk -F "pts" '{print $1}') && [[ ! -z $pidproxy ]] && P1="\033[1;32m[ON]" || P1="\033[1;31m[OFF]"
pidproxy2=$(echo -e "$_ps"| grep -w  "PPriv.py" | grep -v "grep" | awk -F "pts" '{print $1}') && [[ ! -z $pidproxy2 ]] && P2="\033[1;32m[ON]" || P2="\033[1;31m[OFF]"
pidproxy3=$(echo -e "$_ps" | grep "PDirect" | grep -v "grep" | awk -F "pts" '{print $1}') && [[ ! -z $pidproxy3 ]] && P3="\033[1;32m[ON]" || {
[[ $(echo -e "$_ps" | grep "PDirect" | grep -v "grep" | awk -F "pts" '{print $1}') ]] && P3="\033[1;32m[\033[0;34mW-S\033[1;32m]" || P3="\033[1;31m[OFF]"
}
pidproxy4=$(echo -e "$_ps" | grep -w  "POpen.py" | grep -v "grep" | awk -F "pts" '{print $1}') && [[ ! -z $pidproxy4 ]] && P4="\033[1;32m[ON]" || P4="\033[1;31m[OFF]"
pidproxy5=$(echo -e "$_ps" | grep "PGet.py" | grep -v "grep" | awk -F "pts" '{print $1}') && [[ ! -z $pidproxy5 ]] && P5="\033[1;32m[ON]" || P5="\033[1;31m[OFF]"
pidproxy6=$(echo -e "$_ps" | grep "scktcheck" | grep -v "grep" | awk -F "pts" '{print $1}') && [[ ! -z $pidproxy6 ]] && P6="\033[1;32m[ON]" || P6="\033[1;31m[OFF]"
echo -e "\e[91m\e[44m       ==== SCRIPT MOD PandaHL001|EDICION ====      [${_v}]\033[0m \033[0;33m"

[[ ${_PT} ]] && {
msg -bar3
    unset portas
    # Usar arrays para almacenar los resultados
    declare -A portas
    local portas_var=$(lsof -V -i tcp -P -n | awk '/LISTEN/ && (/python/ || /WS-Epro/) {print $1, $9}')
	local n=1
    while read -r line; do
        local var1=$(echo "$line" | awk '{print $1}')
        local var2=$(echo "$line" | awk '{split($2, a, ":"); print a[2]}')

        # Usar un array asociativo para evitar duplicados
        portas["$var1 $var2"]=1
    done <<< "$portas_var"

    # Imprimir las claves del array asociativo filtrando solo 'python' y 'WS-Epro'
    for key in "${!portas[@]}"; do
        if [[ $key == python* || $key == WS-Epro* ]]; then
            # Extraer el puerto de la clave
            port=$(echo $key | awk '{print $2}')
            process=$(echo $key | awk '{print $1}')
			echo -e "\033[0;35m [\033[0;36m${n}\033[0;35m]\033[0;33m ${flech} ${cor[3]}$process : \033[0;32m$port \033[0;35m [ \033[0;36mWORKING \033[0;35m]"
        fi
		let n++;
    done
}
msg -bar3
echo -ne "$(msg -verd " [1]") $(msg -verm2 ">") " && msg -azu "Socks Python SIMPLE      $P1"
echo -ne "$(msg -verd " [2]") $(msg -verm2 ">") " && msg -azu "Socks Python SEGURO      $P2"
echo -ne "$(msg -verd " [3]") $(msg -verm2 ">") " && msg -azu "Socks Python DIRETO (WS) $P3"
echo -ne "$(msg -verd " [4]") $(msg -verm2 ">") " && msg -azu "Socks Python OPENVPN     $P4"
echo -ne "$(msg -verd " [5]") $(msg -verm2 ">") " && msg -azu "Socks Python GETTUNEL    $P5"
echo -ne "$(msg -verd " [6]") $(msg -verm2 ">") " && msg -azu "Socks Python TCP BYPASS  $P6"
msg -bar3

py=7
var_p="$(echo -e "$_PT"|grep "WS-Epro"| wc -l) "
var_w="$(echo -e "$_PT"|grep "python"|wc -l)"
var_check=$(( ${var_p} + ${var_w} ))
if [[ ${var_check} -ge "2" ]]; then
    echo -e "$(msg -verd " [7]") $(msg -verm2 ">") $(msg -azu "ANULAR TODOS") $(msg -verd " [8]") $(msg -verm2 ">") $(msg -azu "ELIMINAR UN PUERTO")"
    py=8
else
    echo -e "$(msg -verd "  [7]") $(msg -verm2 ">") $(msg -azu "ELIMINAR TODOS")"
fi

msg -bar3
echo -ne "$(msg -verd "  [0]") $(msg -verm2 ">") " && msg -bra "   \033[1;41m VOLVER \033[0m"
msg -bar3
selection=$(selection_fun ${py})
case ${selection} in
    1)colector PPub;;
    2)colector PPriv;;
    3)colector PDirect;;
    4)colector POpen;;
    5)colector PGet;;
    6);;
    7)stop_all;;
    8)stop_port;;
    0)return 1;;
esac
return 1
}
clean_check
iniciarsocks

