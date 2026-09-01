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
# --- Configuración de Enlaces ---
# Enlace de Dropbox para badvpn-udpgw (específicamente para x86_64, ajusta si es para otra arquitectura)
DROPBOX_BADVPN_URL="https://raw.githubusercontent.com/karl1999x/PandaScript/main/BINARIOS/badvpn-udpgw"
# Enlace para badvpn-udpgw para aarch64 (u otras ARM)
GITHUB_AARCH64_BADVPN_URL="https://raw.githubusercontent.com/karl1999x/PandaScript/main/BINARIOS/badvpn-udpgw-aarch64"
# Enlace para el script 'msg' de utilidades
MSG_SCRIPT_URL="https://gitea.com/joaquin1444/install/src/branch/main/PandaScript/Otros/msg"

# --- Limpieza inicial y directorios ---
cleanup() {
    rm -f /tmp/some_temp_file.tmp
}
trap cleanup EXIT

[[ -d /etc/ADMcgh ]] || mkdir -p /etc/ADMcgh
[[ -d /etc/ADMcgh/bin ]] || mkdir -p /etc/ADMcgh/bin

# --- Asegurar que el script 'msg' y el directorio existan y sean ejecutables ---
[[ -d /bin/ejecutar ]] || mkdir -p /bin/ejecutar
if [[ ! -e /bin/ejecutar/msg ]]; then
    wget -q -O /bin/ejecutar/msg "$MSG_SCRIPT_URL"
    chmod +x /bin/ejecutar/msg
fi
# Fuente el script 'msg' si existe
[[ -e /bin/ejecutar/msg ]] && source /bin/ejecutar/msg

# --- Colores y Símbolos (manteniendo tus definiciones) ---
COLOR_VIOLETA='\033[38;5;129m'
RESET='\033[0m'
flech='➮' cOlM='⁙' && TOP='‣' && TTini='=====>>►► 🐲' && cG='/c' && TTfin='🐲 ◄◄<<=====' && TTcent='💥' && RRini='【  ★' && RRfin='★  】' && CHeko='✅' && ScT='🛡️' && FlT='⚔️' && BoLCC='🪦' && ceLL='🧬' && aLerT='⚠️' && _kl1='ghkey' && lLaM='🔥' && pPIniT='∘' && bOTg='🤖' && kL10='tc' && rAy='⚡' && tTfIn='】' && TtfIn='【' tTfLe='►' && am1='/e' && rUlq='🔰' && h0nG='💻' && lLav3='🗝️' && m3ssg='📩' && pUn5A='⚜' && p1t0='•' nib="${am1}${kL10}"
cOpyRig='©' && mbar2=' •••••••••••••••••••••••'

# --- Funciones de tu script original ---
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

trap 'shutdown' SIGINT

shutdown() {
    pkill -f usercodes >/dev/null 2>&1
    pkill -f ferramentas >/dev/null 2>&1
    pkill -f menu_inst >/dev/null 2>&1
    pkill -f menu >/dev/null 2>&1
    pkill -f slowdns1 >/dev/null 2>&1
    pkill -f badvpn-udpgw >/dev/null 2>&1 # Asegurarse de matar BadVPN
    screen -wipe >/dev/null 2>&1 # Limpiar sesiones screen muertas
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
    echo -e "\033[1;44;44m     \033[1;33m=====>>►► 🐲 SCRIPT-V6 🐲 ◄◄<<=====   [$(less /etc/${rt}/v-local.log 2>/dev/null)]     \033[0m\033[0;33m"
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

cor[0]="\033[0m"
cor[1]="\033[1;34m"
cor[2]="\033[1;32m"
cor[3]="\033[1;37m"
cor[4]="\033[1;36m"
cor[5]="\033[1;33m"
cor[6]="\033[1;35m"

# Exportar las funciones
export -f msg
export -f fun_bar
export -f tittle
export -f enter
export -f back
export -f print_center
export -f in_opcion
export -f del
export -f menu_func
export -f selection_fun
export -f shutdown

function roleta() {
    work=$1
    sleep 1
    helice() {
        ${work} >/dev/null 2>&1 &
        tput civis
        while [ -d /proc/$! ]; do
            for i in / - \\ \|; do
                sleep .1
                echo -ne "\e[1D$i"
            done
        done
        tput cnorm
    }
    echo -ne "\033[1;37mBuscando Binario \033[1;32mBadVPN \033[1;37me \033[1;32mSWAP\033[1;32m.\033[1;33m.\033[1;31m. \033[1;33m"
    helice
    echo -e "\e[1DOk"
}

# --- Función BadVPN principal, con enlaces actualizados ---
BadVPN () {
    clear
    msg -bar3
    pid_badvpn=$(pgrep -f badvpn-udpgw)

    if [[ "$pid_badvpn" = "" ]]; then
        # No está corriendo, entonces descargamos y arrancamos
        msg -ama " FUNCION REDISEÑADA HABILITARA EL PUERTO 7300 en BADVPN-UDP"
        msg -ama " ADICIONAL APERTURARENOS EL 7200 PARA UN DUAL CHANNEL"
        msg -ama " PROCURA ALTERNAR LOS PUERTOS EN LAS APPS"
        msg -ama " PARA UNA EXPERIENCIA LIGERA Y SIN CORTES DE LLAMADAS"
        msg -bar3

        # Descargar si no existe el binario
        if [[ ! -e /bin/badvpn-udpgw ]]; then
            echo -ne " DESCARGANDO BINARIO UDP V2.."
            local arch=$(uname -m 2> /dev/null)
            if [[ "$arch" = "x86_64" ]]; then
                # Para x86_64, usar el link de Dropbox
                if wget -O /bin/badvpn-udpgw "$DROPBOX_BADVPN_URL" &>/dev/null ; then
                    chmod 777 /bin/badvpn-udpgw
                    msg -verd "[OK]"
                else
                    msg -verm "[fail]"
                    msg -bar3
                    msg -ama "No se pudo descargar el binario para x86_64 desde Dropbox."
                    msg -verm "Instalación cancelada"
                    read -p "ENTER PARA CONTINUAR"
                    return
                fi
            else
                # Para otras arquitecturas (como aarch64, armv7l, etc.), usar el link de GitHub
                if wget -O /bin/badvpn-udpgw "$GITHUB_AARCH64_BADVPN_URL" &>/dev/null ; then
                    chmod 777 /bin/badvpn-udpgw
                    msg -verd "[OK]"
                else
                    msg -verm "[fail]"
                    msg -bar3
                    msg -ama "No se pudo descargar el binario para ${arch} desde GitHub."
                    msg -verm "Instalación cancelada"
                    read -p "ENTER PARA CONTINUAR"
                    return
                fi
            fi
            msg -ama " ACTIVANDO BADVPN Plus"
            msg -bar3
            tput cuu1 && tput dl1
            tput cuu1 && tput dl1
        fi

        (
            screen -dmS badvpn -- /bin/badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 1000 --max-connections-for-client 10
            screen -dmS badUDP72 -- /bin/badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 1000 --max-connections-for-client 10
        ) || msg -ama " Error al Activar BadVPN"
        sleep 2s

        if [[ ! -z $(pgrep -f badvpn-udpgw) ]]; then
            msg -verd " ACTIVADO CON EXITO"
            msg -bar3
            read -t 15 -p " $(echo -e "\033[1;97m Poner en línea después de un reinicio [s/n]: ")" -e -i "s" bot_ini

            tput cuu1 && tput dl1
            tput cuu1 && tput dl1
            if [[ $bot_ini = @(s|S|y|Y) ]]; then
                # Limpia entradas antiguas para evitar duplicados en autoboot
                sed -i '/badvpn-udpgw/d' /bin/autoboot >/dev/null 2>&1
                echo -e " REACTIVADOR DE BADVPN ACTIVADO !! " && sleep 2s
                tput cuu1 && tput dl1
                echo -e "netstat -tlpn | grep -w 7300 > /dev/null || { screen -r -S 'badvpn' -X quit; screen -dmS badvpn $(which badvpn-udpgw) --listen-addr 127.0.0.1:7300 --max-clients 1000 --max-connections-for-client 10; }" >>/bin/autoboot
                echo -e "netstat -tlpn | grep -w 7200 > /dev/null || { screen -r -S 'badUDP72' -X quit; screen -dmS badUDP72 $(which badvpn-udpgw) --listen-addr 127.0.0.1:7200 --max-clients 1000 --max-connections-for-client 10; }" >>/bin/autoboot
            else
                sed -i '/badvpn-udpgw/d' /bin/autoboot >/dev/null 2>&1
                msg -ama " AUTOREINICIO EN INACTIVIDAD DESACTIVADO !! " && sleep 2s
            fi
        fi
    fi

    # Menú siempre mostrado
    clear && clear
    msg -bar3
    msg -ama " Administrador BadVPN UDP | @PandaHL001"
    msg -bar3
    menu_func "AÑADIR 1+ PUERTO BadVPN" "$(msg -verm2 "Detener BadVPN")"
    echo -ne "$(msg -verd " [0]") $(msg -verm2 "=>>") " && msg -bra "\033[1;41m Volver "
    msg -bar3
    opcion=$(selection_fun 2)
    case $opcion in
        1)
            msg -bar3
            msg -ama " FUNCION EXPERIMENTAL AGREGARA PUERTO en BADVPN-UDP"
            msg -bar3
            read -p " DIJITA TU PUERTO CUSTOM PARA BADVPN :" -e -i "7100" port

            # Validar si el puerto ya está en uso antes de intentar iniciarlo
            if netstat -tulnp | grep -q ":${port}\b"; then
                msg -verm "ERROR: El puerto ${port} ya está en uso. Por favor, elige otro."
                enter
                return
            fi

            echo -e " VERIFICANDO BADVPN "
            msg -bar3
            screen -dmS badvpn$port /bin/badvpn-udpgw --listen-addr 127.0.0.1:${port} --max-clients 1000 --max-connections-for-client 10 && msg -ama " BadVPN ACTIVADA CON EXITO"  || msg -ama " Error al Activar BadVPN"
            # Añadir al autoboot si se activa con éxito
            if pgrep -f "badvpn-udpgw --listen-addr 127.0.0.1:${port}" >/dev/null; then
                echo -e "netstat -tlpn | grep -w ${port} > /dev/null || { screen -r -S 'badvpn'${port} -X quit; screen -dmS badvpn${port} $(which badvpn-udpgw) --listen-addr 127.0.0.1:${port} --max-clients 1000 --max-connections-for-client 10; }" >>/bin/autoboot
            fi
            msg -bar3
            return
            ;;
        2)
            msg -ama " DESACTIVANDO BADVPN"
            pids=$(pidof badvpn-udpgw)
            if [[ -n "$pids" ]]; then
                kill -9 $pids
                # Limpiar las sesiones de screen específicas
                screen -X -S badvpn quit >/dev/null 2>&1
                screen -X -S badUDP72 quit >/dev/null 2>&1
                # Limpiar otras sesiones de badvpn que puedan existir (por el puerto custom)
                for session in $(screen -ls | grep badvpn | awk '{print $1}'); do
                    screen -X -S "$session" quit >/dev/null 2>&1
                done
                screen -wipe >/dev/null 2>&1 # Limpiar sesiones screen muertas
                sed -i '/badvpn-udpgw/d' /bin/autoboot >/dev/null 2>&1 # Eliminar de autoboot
                msg -verd "BadVPN detenido con éxito y eliminado del inicio automático."
            else
                msg -verm "No se encontró proceso BadVPN activo."
            fi
            enter
            return
            ;;
        0)
            msg -ama "Volviendo."
            return
            ;;
    esac
    enter
}
clean_check
BadVPN
