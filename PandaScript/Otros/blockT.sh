#!/bin/bash

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

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
declare -A cor=( [0]="\033[1;37m" [1]="\033[1;34m" [2]="\033[1;31m" [3]="\033[1;33m" [4]="\033[1;32m" )
SCPfrm="/etc/adm-lite" && [[ ! -d ${SCPfrm} ]] && exit
SCPinst="/etc/adm-lite" && [[ ! -d ${SCPinst} ]] && exit

sh_ver="MOD-V6"
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[Informacion]${Font_color_suffix}"
Error="${Red_font_prefix}[Error]${Font_color_suffix}"

smtp_port="25,26,465,587"
pop3_port="109,110,995"
imap_port="143,218,220,993"
other_port="24,50,57,105,106,158,209,1109,24554,60177,60179"
bt_key_word="torrent
.torrent
announce
get_peers
find_node
BitTorrent
announce_peer
BitTorrent protocol
announce.php?passkey=
magnet:
xunlei
sandai
Thunder
XLLiveUD
utorrent
bittorrent
transmission
vuze
deluge
qbittorrent
rtorrent
tixati
biglybt
tribler
pdanet
foxfi
usb tether
wifi tether
pdanet+
libtorrent
torrentz
torlock
thepiratebay
1337x
torrentdownloads
torrentfunk
torrentproject
btjunkie
demonoid
isohunt
seedpeer
skytorrents
torrentz2
extratorrent
mediafire
mega
zippyshare.com
4shared.com
dropbox.com
drive
onedrive.live.com
wetransfer.com
rapidgator.net
uploaded.net
filefactory.com
sendspace.com
tusfiles.com
uptobox.com
1fichier.com
depositfiles.com
turbobit.net
hitfile.net
epicgames.com
steamcommunity.com
softonic.com
steamcontent.com
steampowered.com
mediafire.com/folder
"

check_sys(){
    if [[ -f /etc/redhat-release ]]; then
        release="centos"
    elif cat /etc/issue | grep -q -E -i "debian"; then
        release="debian"
    elif cat /etc/issue | grep -q -E -i "ubuntu"; then
        release="ubuntu"
    elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
        release="centos"
    elif cat /proc/version | grep -q -E -i "debian"; then
        release="debian"
    elif cat /proc/version | grep -q -E -i "ubuntu"; then
        release="ubuntu"
    elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
        release="centos"
    fi
    bit=`uname -m`
}
check_BT(){
    Cat_KEY_WORDS
    BT_KEY_WORDS=$(echo -e "$Ban_KEY_WORDS_list"|grep "torrent")
}
check_SPAM(){
    Cat_PORT
    SPAM_PORT=$(echo -e "$Ban_PORT_list"|grep "${smtp_port}")
}
Cat_PORT(){
    Ban_PORT_list=$(iptables -t filter -L OUTPUT -nvx --line-numbers|grep "REJECT"|awk '{print $13}')
}
Cat_KEY_WORDS(){
    Ban_KEY_WORDS_list=""
    Ban_KEY_WORDS_v6_list=""
    if [[ ! -z ${v6iptables} ]]; then
        Ban_KEY_WORDS_v6_text=$(${v6iptables} -t mangle -L OUTPUT -nvx --line-numbers|grep "DROP")
        Ban_KEY_WORDS_v6_list=$(echo -e "${Ban_KEY_WORDS_v6_text}"|sed -r 's/.*\"(.+)\".*/\1/')
    fi
    Ban_KEY_WORDS_text=$(${v4iptables} -t mangle -L OUTPUT -nvx --line-numbers|grep "DROP")
    Ban_KEY_WORDS_list=$(echo -e "${Ban_KEY_WORDS_text}"|sed -r 's/.*\"(.+)\".*/\1/')
}
View_PORT(){
    Cat_PORT
    echo -e "========${Red_background_prefix} Puerto Bloqueado Actualmente ${Font_color_suffix}========="
    echo -e "$Ban_PORT_list" && echo && echo -e "==============================================="
}
View_KEY_WORDS(){
    Cat_KEY_WORDS
    echo -e "============${Red_background_prefix} Actualmente Prohibido ${Font_color_suffix}============"
    echo -e "$Ban_KEY_WORDS_list" && echo -e "==============================================="
}
View_ALL(){
    echo
    View_PORT
    View_KEY_WORDS
    echo
    msg -bar2
}
Save_iptables_v4_v6(){
    if [[ ${release} == "centos" ]]; then
        if [[ ! -z "$v6iptables" ]]; then
            service ip6tables save
            chkconfig --level 2345 ip6tables on
        fi
        service iptables save
        chkconfig --level 2345 iptables on
    else
        if [[ ! -z "$v6iptables" ]]; then
            ip6tables-save > /etc/ip6tables.up.rules
            echo -e "#!/bin/bash\n/sbin/iptables-restore < /etc/iptables.up.rules\n/sbin/ip6tables-restore < /etc/ip6tables.up.rules" > /etc/network/if-pre-up.d/iptables
        else
            echo -e "#!/bin/bash\n/sbin/iptables-restore < /etc/iptables.up.rules" > /etc/network/if-pre-up.d/iptables
        fi
        iptables-save > /etc/iptables.up.rules
        chmod +x /etc/network/if-pre-up.d/iptables
    fi
}
# Verifica si el módulo string está disponible
check_string_module() {
    if ! lsmod | grep -q xt_string; then
        sudo modprobe xt_string 2>/dev/null
        if [[ $? -ne 0 ]]; then
            echo -e "${Error} El módulo xt_string no está disponible en el kernel."
            echo -e "${Error} No se pueden bloquear palabras clave (como torrents)."
            return 1
        fi
    fi
    return 0
}
Set_key_word() { 
    check_string_module || return 1
    [[ -z "$2" || "$2" =~ ^[[:space:]]*$ ]] && {
        echo -e "${Error} Palabra clave vacía o inválida ignorada: '$2'"
        return 1
    }
    $1 -t mangle -D OUTPUT -p tcp --sport 81 -j ACCEPT 2>/dev/null || true
    $1 -t mangle -I OUTPUT 1 -p tcp --sport 81 -j ACCEPT
    if ! $1 -t mangle -$3 OUTPUT -m string --string "$2" --algo bm --to 65535 -j DROP 2>/dev/null; then
        echo -e "${Error} Fallo al agregar la regla para '$2' con $1"
        return 1
    fi
    return 0
}
Set_BT() {
    key_word=$(echo -e "${bt_key_word}" | sed '/^[[:space:]]*$/d' | sed 's/[[:space:]]*$//')
    key_word_num=$(echo -e "${key_word}" | wc -l)
    local success=0
    local failed=0

    [[ $key_word_num -eq 0 ]] && {
        echo -e "${Error} No hay palabras clave válidas para bloquear."
        return 1
    }

    for ((integer = 1; integer <= ${key_word_num}; integer++))
    do
        i=$(echo -e "${key_word}" | sed -n "${integer}p")
        if [[ -n "$v4iptables" ]]; then
            if Set_key_word "$v4iptables" "$i" "$s"; then
                ((success++))
            else
                ((failed++))
                echo -e "${Error} Fallo en iptables para '$i'"
            fi
        fi
        if [[ -n "$v6iptables" ]]; then
            if Set_key_word "$v6iptables" "$i" "$s"; then
                ((success++))
            else
                ((failed++))
                echo -e "${Error} Fallo en ip6tables para '$i'"
            fi
        fi
    done

    if [[ $success -gt 0 ]]; then
        Save_iptables_v4_v6
        if [[ "$s" == "A" ]]; then
            echo -e "${Info} $success palabras clave de BT bloqueadas con éxito."
        else
            echo -e "${Info} $success palabras clave de BT desbloqueadas con éxito."
        fi
    fi
    if [[ $failed -gt 0 ]]; then
        echo -e "${Error} $failed palabras clave fallaron al procesarse."
    fi
}

Ban_BT() {
    check_BT
    [[ ! -z ${BT_KEY_WORDS} ]] && echo -e "${Error} Torrent bloqueados y Palabras Claves, no es\nnecesario volver a prohibirlas !" && msg -bar2 && exit 0
    s="A"
    check_string_module || {
        echo -e "${Error} No se puede proceder sin el módulo xt_string. Instale el soporte necesario."
        msg -bar2
        exit 1
    }
    Set_BT
    View_ALL
    echo -e "${Info} Torrent bloqueados y Palabras Claves !"
    msg -bar2
}
Set_tcp_port() {
    [[ "$1" = "$v4iptables" ]] && $1 -t filter -$3 OUTPUT -p tcp -m multiport --dports "$2" -m state --state NEW,ESTABLISHED -j REJECT --reject-with icmp-port-unreachable
    [[ "$1" = "$v6iptables" ]] && $1 -t filter -$3 OUTPUT -p tcp -m multiport --dports "$2" -m state --state NEW,ESTABLISHED -j REJECT --reject-with tcp-reset
}
Set_udp_port() { $1 -t filter -$3 OUTPUT -p udp -m multiport --dports "$2" -j DROP; }
Set_SPAM_Code_v4(){
    for i in ${smtp_port} ${pop3_port} ${imap_port} ${other_port}
        do
        Set_tcp_port $v4iptables "$i" $s
        Set_udp_port $v4iptables "$i" $s
    done
}
Set_SPAM_Code_v4_v6(){
    for i in ${smtp_port} ${pop3_port} ${imap_port} ${other_port}
    do
        for j in $v4iptables $v6iptables
        do
            Set_tcp_port $j "$i" $s
            Set_udp_port $j "$i" $s
        done
    done
}
Set_PORT(){
    if [[ -n "$v4iptables" ]] && [[ -n "$v6iptables" ]]; then
        Set_tcp_port $v4iptables $PORT $s
        Set_udp_port $v4iptables $PORT $s
        Set_tcp_port $v6iptables $PORT $s
        Set_udp_port $v6iptables $PORT $s
    elif [[ -n "$v4iptables" ]]; then
        Set_tcp_port $v4iptables $PORT $s
        Set_udp_port $v4iptables $PORT $s
    fi
    Save_iptables_v4_v6
}
Set_KEY_WORDS(){
    key_word_num=$(echo -e "${key_word}"|wc -l)
    for((integer = 1; integer <= ${key_word_num}; integer++))
        do
            i=$(echo -e "${key_word}"|sed -n "${integer}p")
            Set_key_word $v4iptables "$i" $s
            [[ ! -z "$v6iptables" ]] && Set_key_word $v6iptables "$i" $s
    done
    Save_iptables_v4_v6
}

Set_SPAM(){
    if [[ -n "$v4iptables" ]] && [[ -n "$v6iptables" ]]; then
        Set_SPAM_Code_v4_v6
    elif [[ -n "$v4iptables" ]]; then
        Set_SPAM_Code_v4
    fi
    Save_iptables_v4_v6
}
Set_ALL(){
    Set_BT
    Set_SPAM
}

Ban_SPAM(){
    check_SPAM
    [[ ! -z ${SPAM_PORT} ]] && echo -e "${Error} Se detectó un puerto SPAM bloqueado, no es\nnecesario volver a bloquear !" && msg -bar2 && exit 0
    s="A"
    Set_SPAM
    View_ALL
    echo -e "${Info} Puertos SPAM Bloqueados !"
    msg -bar2
}
Ban_ALL(){
    check_BT
    check_SPAM
    s="A"
    if [[ -z ${BT_KEY_WORDS} ]]; then
        if [[ -z ${SPAM_PORT} ]]; then
            Set_ALL
            View_ALL
            echo -e "${Info} Torrent bloqueados, Palabras Claves y Puertos SPAM !"
            msg -bar2
        else
            Set_BT
            View_ALL
            echo -e "${Info} Torrent bloqueados y Palabras Claves !"
        fi
    else
        if [[ -z ${SPAM_PORT} ]]; then
            Set_SPAM
            View_ALL
            echo -e "${Info} Puerto SPAM (spam) prohibido !"
        else
            echo -e "${Error} Torrent Bloqueados, Palabras Claves y Puertos SPAM,\nno es necesario volver a prohibir !" && msg -bar2 && exit 0
        fi
    fi
}
UnBan_BT(){
    check_BT
    [[ -z ${BT_KEY_WORDS} ]] && echo -e "${Error} Torrent y Palabras Claves no bloqueadas, verifique !"&& msg -bar2 && exit 0
    s="D"
    Set_BT
    View_ALL
    echo -e "${Info} Torrent Desbloqueados y Palabras Claves !"
    msg -bar2
}
UnBan_SPAM(){
    check_SPAM
    [[ -z ${SPAM_PORT} ]] && echo -e "${Error} Puerto SPAM no detectados, verifique !" && msg -bar2 && exit 0
    s="D"
    Set_SPAM
    View_ALL
    echo -e "${Info} Puertos de SPAM Desbloqueados !"
    msg -bar2
}
UnBan_ALL() {
    check_BT
    check_SPAM
    s="D"
    local something_unbanned=0

    if [[ ! -z ${BT_KEY_WORDS} ]]; then
        Set_BT
        something_unbanned=1
    fi
    if [[ ! -z ${SPAM_PORT} ]]; then
        Set_SPAM
        something_unbanned=1
    fi

    if [[ $something_unbanned -eq 1 ]]; then
        Save_iptables_v4_v6
        View_ALL
        echo -e "${Info} Torrent, Palabras Claves y Puertos SPAM Desbloqueados !"
        msg -bar2
    else
        echo -e "${Error} No se detectan Torrent, Palabras Claves ni Puertos SPAM Bloqueados, verifique !" && msg -bar2 && exit 0
    fi
}
ENTER_Ban_KEY_WORDS_type(){
    Type=$1
    Type_1=$2
    if [[ $Type_1 != "ban_1" ]]; then
        echo -e "Por favor seleccione un tipo de entrada：
        
 1. Entrada manual (solo se admiten palabras clave únicas)
 
 2. Lectura local de archivos (admite lectura por lotes de palabras clave, una palabra clave por línea)
 
 3. Lectura de dirección de red (admite lectura por lotes de palabras clave, una palabra clave por línea)" && echo
        read -e -p "(Por defecto: 1. Entrada manual):" key_word_type
    fi
    [[ -z "${key_word_type}" ]] && key_word_type="1"
    if [[ ${key_word_type} == "1" ]]; then
        if [[ $Type == "ban" ]]; then
            ENTER_Ban_KEY_WORDS
        else
            ENTER_UnBan_KEY_WORDS
        fi
    elif [[ ${key_word_type} == "2" ]]; then
        ENTER_Ban_KEY_WORDS_file
    elif [[ ${key_word_type} == "3" ]]; then
        ENTER_Ban_KEY_WORDS_url
    else
        if [[ $Type == "ban" ]]; then
            ENTER_Ban_KEY_WORDS
        else
            ENTER_UnBan_KEY_WORDS
        fi
    fi
}
ENTER_Ban_PORT(){
    echo -e "Ingrese el puerto que Bloqueará:\n(segmento de Puerto único / Puerto múltiple / Puerto continuo)\n"
    if [[ ${Ban_PORT_Type_1} != "1" ]]; then
    echo -e "
    ${Green_font_prefix}======== Ejemplo Descripción ========${Font_color_suffix}
    
 -Puerto único: 25 (puerto único)
 
 -Multipuerto: 25, 26, 465, 587 (varios puertos están separados por comas)

 -Segmento de puerto continuo: 25: 587 (todos los puertos entre 25-587)" && echo
    fi
    read -e -p "(Intro se cancela por defecto):" PORT
    [[ -z "${PORT}" ]] && echo "Cancelado..." && View_ALL && exit 0
}
ENTER_Ban_KEY_WORDS(){
    msg -bar2
    echo -e "Ingrese las palabras clave que se prohibirán\n(nombre de dominio, etc., solo admite una sola palabra clave)"
    if [[ ${Type_1} != "ban_1" ]]; then
    echo ""
    echo -e "${Green_font_prefix}======== Ejemplo Descripción ========${Font_color_suffix}
    
 -Palabras clave: youtube, que prohíbe el acceso a cualquier nombre de dominio que contenga la palabra clave youtube.
 
 -Palabras clave: youtube.com, que prohíbe el acceso a cualquier nombre de dominio (máscara de nombre de pan-dominio) que contenga la palabra clave youtube.com.

 -Palabras clave: www.youtube.com, que prohíbe el acceso a cualquier nombre de dominio (máscara de subdominio) que contenga la palabra clave www.youtube.com.

 -Autoevaluación de más efectos (como la palabra clave .zip se puede usar para deshabilitar la descarga de cualquier archivo de sufijo .zip)." && echo
    fi
    read -e -p "(Intro se cancela por defecto):" key_word
    [[ -z "${key_word}" ]] && echo "Cancelado ..." && View_ALL && exit 0
}
ENTER_Ban_KEY_WORDS_file(){
    echo -e "Ingrese el archivo local de palabras clave que se prohibirá / desbloqueará (utilice la ruta absoluta)" && echo
    read -e -p "(El valor predeterminado es leer key_word.txt en el mismo directorio que el script):" key_word
    [[ -z "${key_word}" ]] && key_word="key_word.txt"
    if [[ -e "${key_word}" ]]; then
        key_word=$(cat "${key_word}")
        [[ -z ${key_word} ]] && echo -e "${Error} El contenido del archivo está vacío. !" && View_ALL && exit 0
    else
        echo -e "${Error} Archivo no encontrado ${key_word} !" && View_ALL && exit 0
    fi
}
ENTER_Ban_KEY_WORDS_url(){
    echo -e "Ingrese la dirección del archivo de red de palabras clave que se prohibirá / desbloqueará (por ejemplo, http: //xxx.xx/key_word.txt)" && echo
    read -e -p "(Intro se cancela por defecto):" key_word
    [[ -z "${key_word}" ]] && echo "Cancelado ..." && View_ALL && exit 0
    key_word=$(wget --no-check-certificate -t3 -T5 -qO- "${key_word}")
    [[ -z ${key_word} ]] && echo -e "${Error} El contenido del archivo de red está vacío o se agotó el tiempo de acceso !" && View_ALL && exit 0
}
ENTER_UnBan_KEY_WORDS(){
    View_KEY_WORDS
    echo -e "Ingrese la palabra clave que desea desbloquear (ingrese la palabra clave completa y precisa de acuerdo con la lista anterior)" && echo
    read -e -p "(Intro se cancela por defecto):" key_word
    [[ -z "${key_word}" ]] && echo "Cancelado ..." && View_ALL && exit 0
}
ENTER_UnBan_PORT(){
    echo -e "Ingrese el puerto que desea desempaquetar:\n(ingrese el puerto completo y preciso de acuerdo con la lista anterior, incluyendo comas, dos puntos)" && echo
    read -e -p "(Intro se cancela por defecto):" PORT
    [[ -z "${PORT}" ]] && echo "Cancelado ..." && View_ALL && exit 0
}
Ban_PORT(){
    s="A"
    ENTER_Ban_PORT
    Set_PORT
    echo -e "${Info} Puerto bloqueado [ ${PORT} ] !\n"
    Ban_PORT_Type_1="1"
    while true
    do
        ENTER_Ban_PORT
        Set_PORT
        echo -e "${Info} Puerto bloqueado [ ${PORT} ] !\n"
    done
    View_ALL
}
Ban_KEY_WORDS(){
    s="A"
    ENTER_Ban_KEY_WORDS_type "ban"
    Set_KEY_WORDS
    echo -e "${Info} Palabras clave bloqueadas [ ${key_word} ] !\n"
    while true
    do
        ENTER_Ban_KEY_WORDS_type "ban" "ban_1"
        Set_KEY_WORDS
        echo -e "${Info} Palabras clave bloqueadas [ ${key_word} ] !\n"
    done
    View_ALL
}
UnBan_PORT(){
    s="D"
    View_PORT
    [[ -z ${Ban_PORT_list} ]] && echo -e "${Error} Se detecta cualquier puerto no bloqueado !" && exit 0
    ENTER_UnBan_PORT
    Set_PORT
    echo -e "${Info} Puerto decapsulado [ ${PORT} ] !\n"
    while true
    do
        View_PORT
        [[ -z ${Ban_PORT_list} ]] && echo -e "${Error} No se detecta puertos bloqueados !" && msg -bar2 && exit 0
        ENTER_UnBan_PORT
        Set_PORT
        echo -e "${Info} Puerto decapsulado [ ${PORT} ] !\n"
    done
    View_ALL
}
UnBan_KEY_WORDS(){
    s="D"
    Cat_KEY_WORDS
    [[ -z ${Ban_KEY_WORDS_list} ]] && echo -e "${Error} No se ha detectado ningún bloqueo !" && exit 0
    ENTER_Ban_KEY_WORDS_type "unban"
    Set_KEY_WORDS
    echo -e "${Info} Palabras clave desbloqueadas [ ${key_word} ] !\n"
    while true
    do
        Cat_KEY_WORDS
        [[ -z ${Ban_KEY_WORDS_list} ]] && echo -e "${Error} No se ha detectado ningún bloqueo !" && msg -bar2 && exit 0
        ENTER_Ban_KEY_WORDS_type "unban" "ban_1"
        Set_KEY_WORDS
        echo -e "${Info} Palabras clave desbloqueadas [ ${key_word} ] !\n"
    done
    View_ALL
}
UnBan_KEY_WORDS_ALL(){
    Cat_KEY_WORDS
    [[ -z ${Ban_KEY_WORDS_text} ]] && echo -e "${Error} No se detectó ninguna clave, verifique !" && msg -bar2 && exit 0
    if [[ ! -z "${v6iptables}" ]]; then
        Ban_KEY_WORDS_v6_num=$(echo -e "${Ban_KEY_WORDS_v6_list}"|wc -l)
        for((integer = 1; integer <= ${Ban_KEY_WORDS_v6_num}; integer++))
            do
                ${v6iptables} -t mangle -D OUTPUT 1
        done
    fi
    Ban_KEY_WORDS_num=$(echo -e "${Ban_KEY_WORDS_list}"|wc -l)
    for((integer = 1; integer <= ${Ban_KEY_WORDS_num}; integer++))
        do
            ${v4iptables} -t mangle -D OUTPUT 1
    done
    Save_iptables_v4_v6
    View_ALL
    echo -e "${Info} Todas las palabras clave han sido desbloqueadas !"
}
check_iptables(){
    v4iptables=`iptables -V`
    v6iptables=`ip6tables -V`
    if [[ ! -z ${v4iptables} ]]; then
        v4iptables="iptables"
        if [[ ! -z ${v6iptables} ]]; then
            v6iptables="ip6tables"
        fi
    else
        echo -e "${Error} El firewall de iptables no está instalado !
Por favor, instale el firewall de iptables：
CentOS Sistema： yum install iptables -y
Debian / Ubuntu Sistema： apt-get install iptables -y"
    fi
}
Update_Shell(){
    sh_new_ver=$(wget --no-check-certificate -qO- -t1 -T3 "https://raw.githubusercontent.com/joaquin1444/MOD-V6/refs/heads/main/script-v6/Otros/blockT.sh" | grep 'sh_ver="' | awk -F "=" '{print $NF}' | sed 's/\"//g' | head -1)
    
    if [[ -z ${sh_new_ver} ]]; then
        echo -e "${Error} No se puede vincular a Github !"
        exit 0
    fi

    wget -q --no-check-certificate -O /etc/ger-frm/blockBT.sh "https://raw.githubusercontent.com/joaquin1444/MOD-V6/refs/heads/main/script-v6/Otros/blockT.sh"
    
    if [[ -s /etc/ger-frm/blockBT.sh ]]; then
        chmod +x /etc/ger-frm/blockBT.sh
        echo -e "El script ha sido actualizado a la última versión. [ ${sh_new_ver} ]"
        msg -bar2
        ./etc/ger-frm/blockBT.sh  # Ejecuta el script con ./
    else
        echo -e "${Error} Error al descargar el script."
    fi
    
    exit 0
}

check_sys
check_iptables
action=$1
if [[ ! -z $action ]]; then
    [[ $action = "banbt" ]] && Ban_BT && exit 0
    [[ $action = "banspam" ]] && Ban_SPAM && exit 0
    [[ $action = "banall" ]] && Ban_ALL && exit 0
    [[ $action = "unbanbt" ]] && UnBan_BT && exit 0
    [[ $action = "unbanspam" ]] && UnBan_SPAM && exit 0
    [[ $action = "unbanall" ]] && UnBan_ALL && exit 0
fi

clear
msg -bar2
msg -azu "  Panel de Firewall by joaquinH2 [${sh_ver}]"
msg -bar2
msg -verd "  [0] Ver la lista actual de prohibidos"
msg -bar2
msg -ama "  Opciones de Bloqueo:"
msg -verd "  [1] Bloquear Torrent y Palabras Clave"
msg -verd "  [2] Bloquear Puertos SPAM"
msg -verd "  [3] Bloquear Todo (Torrent, Palabras Clave + Puertos SPAM)"
msg -verd "  [4] Bloquear Puerto Personalizado"
msg -verd "  [5] Bloquear Palabras Clave Personalizadas"
msg -bar2
msg -ama "  Opciones de Desbloqueo:"
msg -verd "  [6] Desbloquear Torrent y Palabras Clave"
msg -verd "  [7] Desbloquear Puertos SPAM"
msg -verd "  [8] Desbloquear Todo (Torrent, Palabras Clave, Puertos SPAM)"
msg -verd "  [9] Desbloquear Puerto Personalizado"
msg -verd " [10] Desbloquear Palabra Clave Personalizada"
msg -verd " [11] Desbloquear Todas las Palabras Clave Personalizadas"
msg -bar2
msg -aqua " [12] Actualizar Script"
msg -bar2
msg -ne " Por favor ingrese un número [0-12]: " && read num
msg -bar2

case "$num" in
    0) View_ALL ;;
    1) Ban_BT ;;
    2) Ban_SPAM ;;
    3) Ban_ALL ;;
    4) Ban_PORT ;;
    5) Ban_KEY_WORDS ;;
    6) UnBan_BT ;;
    7) UnBan_SPAM ;;
    8) UnBan_ALL ;;
    9) UnBan_PORT ;;
    10) UnBan_KEY_WORDS ;;
    11) UnBan_KEY_WORDS_ALL ;;
    12) Update_Shell ;;
    *) msg -verm2 "Por favor ingrese un número válido [0-12]" ;;
esac