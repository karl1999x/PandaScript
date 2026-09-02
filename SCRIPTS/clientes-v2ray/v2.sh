#!/bin/bash
command -v bash >/dev/null 2>&1 || { echo >&2 ""; exit 1; }



trap '"; exit 1' STOP

if [ -t 1 ]; then
    : 
else
    echo ""
    exit 1
fi

sudo rm -f /root/install.sh

CONFIG_FILE="/etc/v2ray/config.json"
USERS_FILE="/etc/v2ray/v2clientes.txt"

RESET="\e[0m"             
RED='\033[0;31m'
red="\033[1;31m" 
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
LIGHT_BLUE='\033[1;34m'
LIGHT_BLUE_CYAN="\033[1;36m"
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'
print_message() {
    local color="$1"
    local message="$2"
    echo -e "${color}${message}${NC}"
}
check_v2ray_status() {
    if systemctl is-active --quiet v2ray; then
        echo -e "${YELLOW}V2Ray está ${LIGHT_BLUE_CYAN}activo${NC}"
    else
        echo -e "${YELLOW}V2Ray está ${RED}desactivado${NC}"
    fi
}

show_menu() {
    local VERSION="3.9"
    local latest_version=$(check_github_version)
    local user_counts=$(count_users)
    local total_users=$(echo "$user_counts" | cut -d'|' -f1)
    local expired_users=$(echo "$user_counts" | cut -d'|' -f2)

    clear
    echo -e "\e[36m╔════════════════════════════════════════════════════╗\e[0m"
    echo -e "\e[33m •••••••••• Menú V2Ray •••••••••• (versión) \e[35m$VERSION\e[33m \e[32m$latest_version\e[32m"
    
    menu_info
    
    echo -e "${LIGHT_BLUE_CYAN}  Registrados: ${LIGHT_BLUE}[${LIGHT_BLUE_CYAN}${total_users}${LIGHT_BLUE}] ${LIGHT_BLUE_CYAN}Expirados: ${LIGHT_BLUE}[${red}${expired_users}${LIGHT_BLUE}]${NC}"




    echo -e "\e[36m╚════════════════════════════════════════════════════╝\e[0m"
    echo -e "${RED}[${NC}${LIGHT_BLUE}01${NC}${RED}]${NC} ${LIGHT_BLUE}➕ AGREGAR NUEVO USUARIO ${NC}"
    echo -e "${RED}[${NC}${LIGHT_BLUE}02${NC}${RED}]${NC} ${RED}🧹 ELIMINAR USUARIO ${NC}"
    echo -e "${RED}[${NC}${LIGHT_BLUE}03${NC}${RED}]${NC} ${LIGHT_BLUE}🔄 EDITAR UUID DE USUARIO ${NC}"
    echo -e "${RED}[${NC}${LIGHT_BLUE}04${NC}${RED}]${NC} ${LIGHT_BLUE}👥 VER INFORMACIÓN DE USUARIOS ${NC}"
    echo -e "${RED}[${NC}${LIGHT_BLUE}05${NC}${RED}]${NC} ${LIGHT_BLUE}🔍 VER VMESS ${NC}"
    echo -e "${RED}[${NC}${LIGHT_BLUE}06${NC}${RED}]${NC} ${RED}🚮 ELIMINAR EXPIRADOS ${NC}"
    echo -e "${RED}[${NC}${LIGHT_BLUE}07${NC}${RED}]${NC} ${LIGHT_BLUE}🔄 RENOVAR USUARIO ${NC}"
    echo -e "${RED}[${NC}${LIGHT_BLUE}08${NC}${RED}]${NC} ${LIGHT_BLUE}🟢 VER CONECTADOS ${NC}"
    echo -e "${RED}[${NC}${LIGHT_BLUE}09${NC}${RED}]${NC} ${LIGHT_BLUE}📂 GESTIÓN DE COPIAS DE SEGURIDAD ${NC}"
    echo -e "${RED}[${NC}${LIGHT_BLUE}10${NC}${RED}]${NC} ${LIGHT_BLUE}🔧 CONFIGURAR V2RAY ${NC}"
    echo -e "${RED}[${NC}${LIGHT_BLUE}00${NC}${RED}]${NC} ${RED}🚪 SALIR ${NC}"
    echo -e "\e[36m╚════════════════════════════════════════════════════╝\e[0m"
    print_message_with_border "Acceder al menú con  v2"
    check_noti
}

check_github_version() {
    local url="https://raw.githubusercontent.com/joaquin1444/clientes-v2ray/main/versión"
    local latest_version=$(wget -qO- "$url" | tr -d '')
    
    if [[ "$VERSION" != "$latest_version" ]]; then
        echo -e "\e[32m$latest_version\e[0m"
    fi
}
check_noti() {
    local url="https://raw.githubusercontent.com/joaquin1444/clientes-v2ray/main/noti"
    local noti=$(wget -qO- "$url")

    echo -e "\033[1;32m${noti}\033[0m"
}





get_and_save_public_ip() {
    curl -s --max-time 5 https://api.ipify.org > ip.txt
}
get_saved_public_ip() {
    cat ip.txt
}
get_os_info() {
    if [[ "$(grep -c "Ubuntu" /etc/issue.net)" = "1" ]]; then
        echo "Ubuntu $(cut -d' ' -f2 /etc/issue.net)"
    elif [[ "$(grep -c "Debian" /etc/issue.net)" = "1" ]]; then
        echo "Debian $(cut -d' ' -f3 /etc/issue.net)"
    else
        echo "$(cut -d' ' -f1 /etc/issue.net)"
    fi
}




if [ ! -f "ip.txt" ]; then
    get_and_save_public_ip
fi
menu_info() {
    public_ip=$(get_saved_public_ip)
    local status_line
    status_line=$(check_v2ray_status)
    os_info=$(get_os_info)
    _usor=$(printf '%-8s' "$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')")
    _ram=$(printf ' %-8s' "$(free -h | grep -i mem | awk {'print $2'})")
    _ram2=$(printf ' %-8s' "$(free -h | grep -i mem | awk {'print $4'})")
    _system=$(printf '%-9s' "$os_info")
    _core=$(printf '%-8s' "$(grep -c cpu[0-9] /proc/stat)")
    _usop=$(top -bn1 | sed -rn '3s/[^0-9]* ([0-9\.]+) .*/\1/p;4s/.*, ([0-9]+) .*/\1/p' | tr '\n' ' ')
    modelo1=$(printf '%-11s' "$(lscpu | grep Arch | sed 's/\s\+/,/g' | cut -d , -f2)")
    mb=$(printf '%-8s' "$(free -h | grep Mem | sed 's/\s\+/,/g' | cut -d , -f6)")
    _hora=$(printf '%(%H:%M:%S)T')
    _hoje=$(date +'%d/%m/%Y')
    echo -e "\033[1;37m SO \033[1;31m: \033[1;32m$_system \033[1;37mTIEMPO\033[1;31m: \033[1;32m$_hora"
    echo -e "\033[1;37m RAM\e[31m: \033[1;32m$_ram \033[1;37mUSADA\033[1;31m: \033[1;32m$mb\033[1;37m LIBRE\033[1;31m: \033[1;32m$_ram2"
    echo -e " \033[1;34m[\033[0m${status_line}\033[1;34m]\033[0m \033[1;37mIP\033[1;31m:\033[1;32m $public_ip"
}

show_backup_menu() {
    clear
    print_message_with_border "MENU DE COPIA DE SEGURIDAD "
    print_separator

    echo -e "${RED}[${NC}${LIGHT_BLUE}01${NC}${RED}]${NC} ${LIGHT_BLUE_CYAN} Crear copia de seguridad ${NC}"
    echo -e "${RED}[${NC}${LIGHT_BLUE}02${NC}${RED}]${NC} ${LIGHT_BLUE_CYAN} Restaurar copia de seguridad ${NC}"
    echo -e "${RED}[${NC}${LIGHT_BLUE}00${NC}${RED}]${NC} ${RED} Volver al menú principal ${NC}"
    print_separator
    read -p "Seleccione una opción: " backupOption

    case $backupOption in
        1)
            create_backup
            ;;
        2)
            restore_backup
            ;;
        0)
            main_menu  
            ;;
        *)
            print_message "${RED}" "Opción no válida."
            ;;
    esac
}

create_backup() {
    clear
    print_separator
    read -p "INGRESE EL NOMBRE DEL ARCHIVO DE RESPALDO: " backupFileName
    backupFilePath="/root/$backupFileName.rar"

    
    if ! command -v rar &> /dev/null; then
        print_message_with_border "Instalando rar..."
        apt-get update &> /dev/null
        apt-get install -y rar &> /dev/null
    fi

    
    rar a -r "$backupFilePath" /etc/v2ray/config.json /etc/v2ray/v2clientes.txt &> /dev/null

    print_message_with_border "COPIA DE SEGURIDAD CREADA EN: $backupFilePath"
    read -p "PRESIONE ENTER PARA CONTINUAR"
}









show_backups() {
    clear
    echo "==============================="
    echo -e "\e[1m\e[34mBACKUPS DISPONIBLES:\e[0m"

    
    for backupFile in /root/*.rar /root/*_config.json; do
        
        backupName=$(basename "$backupFile" .rar)
        backupName=$(basename "$backupName" _config.json)

        
        backupDateTime=$(date -r "$backupFile" "+%Y-%m-%d %H:%M:%S")

        
        echo -e "\e[1m\e[32mNombre:\e[0m $backupName"
        echo -e "\e[1m\e[32mFecha y hora:\e[0m $backupDateTime"
        echo "==============================="
    done
}

restore_backup() {
    local backup_files_rar="/root/*.rar"
    local backup_files_json="/root/*_config.json"
    local backup_count_rar=$(ls $backup_files_rar 2>/dev/null | wc -l)
    local backup_count_json=$(ls $backup_files_json 2>/dev/null | wc -l)
    
    if [[ $backup_count_rar -gt 0 || $backup_count_json -gt 0 ]]; then
        show_backups
        read -p "Ingrese el nombre del archivo de respaldo a restaurar (sin la extensión): " backupFileName
        
        if [[ -f "/root/${backupFileName}.rar" ]]; then
            rar x -o+ "/root/${backupFileName}.rar" / &> /dev/null
            print_message_with_border "¡Copia de seguridad '$backupFileName' restaurada exitosamente!"
            read -p "Presione Enter para regresar al menú principal" enterKey
            systemctl restart v2ray
            exec "$0"
        elif [[ -f "/root/${backupFileName}_config.json" ]]; then
            cp "/root/${backupFileName}_config.json" "/etc/v2ray/config.json"
            cp "/root/${backupFileName}_v2clientes.txt" "/etc/v2ray/v2clientes.txt"
            print_message_with_border "¡Copia de seguridad '$backupFileName' restaurada exitosamente!"
            read -p "Presione Enter para regresar al menú principal" enterKey
            systemctl restart v2ray
            exec "$0"
        else
            print_message_with_border "El archivo de respaldo '$backupFileName' no existe."
            read -p "Presione Enter para regresar al menú principal" enterKey
        fi
    else
        print_message_with_border "No hay archivos de respaldo disponibles."
        read -p "Presione Enter para regresar al menú principal" enterKey
    fi
}




add_user() {
    clear
    print_separator
    print_message_with_border "AGREGAR NUEVO USUARIO"

    print_separator

    
    if [ ! -f "$USERS_FILE" ]; then
        touch "$USERS_FILE"
    fi

    while true; do
        echo -e "${YELLOW}INGRESE EL NOMBRE DEL NUEVO USUARIO:${NC}"
        echo -ne "\033[33m\u27A4 \033[0m"
        read -r userName
        userName=$(echo "$userName" | tr -d '[:space:]')  
        userName=$(echo "$userName" | tr '[:upper:]' '[:lower:]')  
        print_separator
        if [ -z "$userName" ]; then
            print_message "${RED}" "EL NOMBRE DEL USUARIO NO PUEDE ESTAR VACÍO. POR FAVOR, INGRESE UN NOMBRE."
        elif grep -q "| $userName |" "$USERS_FILE" || grep -q "\"email\": \"$userName\"" "$CONFIG_FILE"; then
            print_message "${RED}" "YA EXISTE UN USUARIO CON EL MISMO NOMBRE. POR FAVOR, ELIJA OTRO NOMBRE."
        else
            break
        fi
    done

    echo -e "${YELLOW}INGRESE LA DURACIÓN EN DÍAS PARA EL NUEVO USUARIO:${NC}"
    echo -ne "\033[33m\u27A4 \033[0m"
    read -r days
    print_separator

    if ! [[ "$days" =~ ^[0-9]+$ ]]; then
        print_message "${RED}" "LA DURACIÓN DEBE SER UN NÚMERO."
        read -p "PRESIONE ENTER PARA REGRESAR AL MENÚ PRINCIPAL" enterKey
        clear
        return 1
    fi

    echo -e "${YELLOW}¿UUID PERSONALIZADO? (SÍ: S, NO: CUALQUIER TECLA)${NC}"
    echo -ne "\033[33m\u27A4 \033[0m"
    read -r customUuidChoice

    if [[ "${customUuidChoice,,}" == "s" ]]; then
        print_separator
        echo -e "${YELLOW}INGRESE EL UUID PERSONALIZADO PARA EL NUEVO USUARIO (FORMATO: XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX):${NC}"
        echo -ne "\033[33m\u27A4 \033[0m"
        read -r userId

        if ! [[ "$userId" =~ ^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$ ]]; then
            print_message "${RED}" "FORMATO DE UUID NO VÁLIDO. DEBE SER XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX."
            read -p "PRESIONE ENTER PARA REGRESAR AL MENÚ PRINCIPAL" enterKey
            print_separator
            clear
            return 1
        fi

        if grep -q "$userId" "$USERS_FILE"; then
            print_message "${RED}" "ADVERTENCIA: YA EXISTE UN USUARIO CON EL MISMO UUID. ELIMINANDO EL USUARIO EXISTENTE..."
            delete_user_by_uuid1 "$userId"
        fi
    else
        userId=$(uuidgen)
    fi

    alterId=0
    expiration_date=$(date -d "+$days days" "+%Y-%m-%d %H:%M:%S")
    print_separator
    print_message "${CYAN}" "UUID DEL NUEVO USUARIO: ${LIGHT_BLUE_CYAN}$userId${NC}"
    print_message "${YELLOW}" "FECHA DE EXPIRACIÓN: ${LIGHT_BLUE_CYAN}$expiration_date${NC}"

    userJson="{\"alterId\": $alterId, \"id\": \"$userId\", \"email\": \"$userName\", \"expiration\": $(date -d "$expiration_date" +%s)}"

    jq ".inbounds[0].settings.clients += [$userJson]" "$CONFIG_FILE" > "$CONFIG_FILE.tmp" 2>/dev/null && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"

    echo "$userId | $userName | $expiration_date" >> "$USERS_FILE"

    systemctl restart v2ray
    print_message "${GREEN}" "USUARIO AGREGADO EXITOSAMENTE."
    print_separator
    
    IP=$(hostname -I | awk '{print $1}')
    add=$(jq -r --arg IP "$IP" '.inbounds[0].domain // (if .inbounds[0].listen | type == "string" then .inbounds[0].listen | split(":")[0] else $IP end)' "$CONFIG_FILE")
    net=$(jq -r '.inbounds[0].streamSettings.network' "$CONFIG_FILE")
    path=$(jq -r '.inbounds[0].streamSettings.wsSettings.path // empty' "$CONFIG_FILE")
    host=$(jq -r '.inbounds[0].streamSettings.wsSettings.headers.Host // empty' "$CONFIG_FILE")
    tls="none"
    
    
    port=$(jq -r '.inbounds[0].port' "$CONFIG_FILE")
    print_message "${CYAN}" "VMESS CON PUERTO $port:"
    var="{\"v\":\"2\",\"ps\":\"$userName\",\"add\":\"$add\",\"port\":$port,\"aid\":$alterId,\"type\":\"none\",\"net\":\"$net\",\"path\":\"$path\",\"host\":\"$host\",\"id\":\"$userId\",\"tls\":\"$tls\"}"
    print_message "${GREEN}" "vmess://$(echo "$var" | jq -r '.|@base64')"

    print_separator
    read -p "PRESIONE ENTER PARA REGRESAR AL MENÚ PRINCIPAL" enterKey
    print_separator
}
print_message_with_border() {
    local message="$1"
    local border_color='\e[1;31m' 
    local text_color='\e[1;36m'   
    local NC='\e[0m'              

    
    local length=$((${#message} + 4)) 

    
    local border=$(printf '%.0s-' $(seq 1 $length))

    
    local spaces=$(( (length - ${#message}) / 2 ))
    local left_spaces=$(printf "%${spaces}s")
    local right_spaces=$(printf "%$((length - ${#message} - spaces))s")

    
    echo -e "${border_color}┌${border}┐${NC}"
    echo -e "${border_color}│${NC}${left_spaces}${text_color}${message}${right_spaces}${border_color}│${NC}"
    echo -e "${border_color}└${border}┘${NC}"
}














edit_user_uuid() {
    show_registered_user
    echo -e "INGRESE EL ID DEL USUARIO QUE DESEA EDITAR (O PRESIONE ENTER PARA CANCELAR): " 
    echo -ne "\033[33m\u27A4 \033[0m"
    read userId

    if [ -z "$userId" ]; then
        print_message "${YELLOW}" "NO SE SELECCIONÓ NINGÚN ID. VOLVIENDO AL MENÚ PRINCIPAL."
        read -p "PRESIONE ENTER PARA REGRESAR AL MENÚ PRINCIPAL" enterKey
        return
    fi

    oldUserData=$(grep "$userId" /etc/v2ray/v2clientes.txt)

    if [ -z "$oldUserData" ]; then
        print_message "${RED}" "ID NO ENCONTRADO. VOLVIENDO AL MENÚ PRINCIPAL."
        read -p "PRESIONE ENTER PARA REGRESAR AL MENÚ PRINCIPAL" enterKey
        return
    fi

    clear

    echo -e "INGRESE EL NUEVO UUID PARA EL USUARIO CON ID $userId (O PRESIONE ENTER PARA CONSERVAR EL UUID $userId): " 
    echo -ne "\033[33m\u27A4 \033[0m"
    read newUuid

    if [ -z "$newUuid" ]; then
        newUuid=$userId
    elif [[ ! "$newUuid" =~ ^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$ ]]; then
        print_message "${RED}" "FORMATO DE UUID NO VÁLIDO. DEBE SER XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX."
        read -p "PRESIONE ENTER PARA REGRESAR AL MENÚ PRINCIPAL" enterKey
        return
    fi

    oldName=$(echo "$oldUserData" | awk -F "|" '{print $2}')

    while true; do
        echo -e "INGRESE EL NUEVO NOMBRE PARA EL USUARIO CON ID $userId (O PRESIONE ENTER PARA CONSERVAR EL NOMBRE $oldName): " 
        echo -ne "\033[33m\u27A4 \033[0m"
         read newName
        newName=$(echo $newName | xargs)
        if [ -z "$newName" ]; then
            print_message "${RED}" "EL NOMBRE DEL USUARIO NO PUEDE ESTAR VACÍO. POR FAVOR, INGRESE UN NOMBRE."
        elif grep -q "| $newName |" /etc/v2ray/v2clientes.txt && [ "$newName" != "$oldName" ]; then
            print_message "${RED}" "YA EXISTE UN USUARIO CON EL MISMO NOMBRE. POR FAVOR, ELIJA OTRO NOMBRE."
        else
            break
        fi
    done

    while true; do
        echo -e "INGRESE EL NÚMERO DE DÍAS PARA LA FECHA DE EXPIRACIÓN (O PRESIONE ENTER PARA CONSERVAR LA FECHA DEL USUARIO ANTERIOR): " 
        echo -ne "\033[33m\u27A4 \033[0m"
        read expiryDays
        expiryDays=$(echo $expiryDays | xargs)
        if [ -z "$expiryDays" ]; then
            oldDate=$(echo "$oldUserData" | awk -F "|" '{print $3}' | xargs)
            newDate=$oldDate
            break
        elif ! [[ "$expiryDays" =~ ^[0-9]+$ ]]; then
            print_message "${RED}" "LA DURACIÓN DEBE SER UN NÚMERO."
        else
            newDate=$(date -d "+$expiryDays days" "+%Y-%m-%d")
            break
        fi
    done

    sleep 2
    sed -i "/$userId/d" /etc/v2ray/v2clientes.txt

    echo "$newUuid | $newName | $newDate" >> /etc/v2ray/v2clientes.txt

    jq ".inbounds[0].settings.clients = (.inbounds[0].settings.clients | map(if .id == \"$userId\" then .id = \"$newUuid\" | .email = \"$newName\" else . end))" "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"

    systemctl restart v2ray

    print_message "${GREEN}" "UUID DEL USUARIO CON ID $userId EDITADO EXITOSAMENTE."
    read -p "PRESIONE ENTER PARA REGRESAR AL MENÚ PRINCIPAL" enterKey
    return
}

delete_user_by_uuid1() {
    local userId=$1

    
    jq ".inbounds[0].settings.clients = (.inbounds[0].settings.clients | map(select(.id != \"$userId\")))" "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"

    
    sed -i "/$userId/d" "$USERS_FILE"

    
    systemctl restart v2ray
    echo -e "\033[33mUSUARIO CON UUID $userId ELIMINADO.\033[0m"
}

delete_user_by_uuid() {
    local userId=$1

    
    jq ".inbounds[0].settings.clients = (.inbounds[0].settings.clients | map(select(.id != \"$userId\")))" "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"

    
    sed -i "/$userId/d" "$USERS_FILE"

    
    systemctl restart v2ray
    echo -e "\033[33mUSUARIO CON UUID $userId ELIMINADO.\033[0m"
    read -p "PRESIONE ENTER PARA CONTINUAR"
}



show_registered_user() {
    
    clear

    print_message_with_border "Información de Usuarios:" '\e[1;36m' 
    echo -e "\e[1;36m==========================================================\e[0m" 
    echo -e "\e[1;36m  UUID                              Nombre     Expiración\e[0m" 
    echo -e "\e[1;36m==========================================================\e[0m" 

    current_time=$(date +%s)

    contador_activos=0
    contador_expirados=0
    contador=0

    while IFS='|' read -r uuid nombre fecha_expiracion || [[ -n "$uuid" ]]; do
        contador=$((contador+1))  # Incrementar el contador
        if [ -z "$fecha_expiracion" ]; then
            dias_horario="[--]"
        else
            expiracion_timestamp=$(date -d "$fecha_expiracion" +%s)
            diferencia=$((expiracion_timestamp - current_time))

            if ((diferencia >= 0)); then
                dias_restantes=$((diferencia / 86400))
                if ((dias_restantes >= 1)); then
                    dias_horario="[+${dias_restantes}d]"
                else
                    horas_restantes=$((diferencia / 3600))
                    if ((horas_restantes >= 24)); then
                        dias_horario="[+1d]"
                    else
                        dias_horario="[+${horas_restantes}h]"
                    fi
                fi
            else
                dias_restantes=$((diferencia / 86400))
                if ((dias_restantes < -1)); then
                    dias_horario="[${dias_restantes}d]"
                else
                    horas_restantes=$((diferencia / 3600))
                    dias_horario="[${horas_restantes}h]"
                fi
            fi
        fi

        if [ -z "$fecha_expiracion" ] || [ "$current_time" -ge "$expiracion_timestamp" ]; then
            if [ -z "$fecha_expiracion" ]; then
                color="\e[1;32m"
            else
                color="\e[1;31m"
            fi
            ((contador_expirados++))
        else
            color="\e[1;32m"
            ((contador_activos++))
        fi

        printf "%b[%s]%b%-30s %-8s %s\n\e[0m" "\e[1;36m" "$contador" "$color" "$uuid" "$nombre" "$dias_horario"
    done < /etc/v2ray/v2clientes.txt

    echo -e "\e[1;36m==========================================================\e[0m" 
    echo -e "Usuarios activos: [\e[1;32m${contador_activos}\e[0m]" 
    echo -e "Usuarios expirados: [\e[1;31m${contador_expirados}\e[0m]" 
    
}






CONFIG_FILE="/etc/v2ray/config.json"
USERS_FILE="/etc/v2ray/v2clientes.txt"

print_message() {
    echo -e "$1$2${NC}"
}






delete_user() {
    clear
    echo -e "${CYAN}⚠️ ADVERTENCIA: LOS USUARIOS EXPIRADOS SE RECOMIENDA ELIMINARLOS MANUALMENTE CON EL ID ⚠️${NC}"
    show_registered_user
    local users_list=($(grep -oP '[0-9a-f-]{36}' "$USERS_FILE"))  # Lista de UUIDs en el archivo USERS_FILE
    while true; do
        echo -e "${CYAN}INGRESE EL UUID O NÚMERO DEL USUARIO QUE DESEA ELIMINAR (O PRESIONE ENTER PARA CANCELAR):${NC}"
        echo -ne "${YELLOW}\u27A4 ${NC}"
        read input
        if [ -z "$input" ]; then
            echo -e "${YELLOW}NO SE SELECCIONÓ EL UUID O NÚMERO. VOLVIENDO AL MENÚ PRINCIPAL.${NC}"
            sleep 0.5
            return
        fi

        # Verificar si el input es un número de índice
        if [[ "$input" =~ ^[0-9]+$ ]] && [ "$input" -le "${#users_list[@]}" ] && [ "$input" -gt 0 ]; then
            userId="${users_list[$((input-1))]}"
        elif [[ "$input" =~ ^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$ ]]; then
            userId="$input"
        else
            echo -e "${RED}USUARIO CON NÚMERO O UUID $input NO ENCONTRADO. INTENTE DE NUEVO.${NC}"
            continue
        fi

        # Verificar si el usuario existe en el archivo de configuración
        local found_in_json=$(jq -r ".inbounds[0].settings.clients[] | select(.id == \"$userId\")" "$CONFIG_FILE")
        local found_in_users=$(grep -q "$userId" "$USERS_FILE"; echo $?)

        if [[ -z "$found_in_json" ]] && [[ "$found_in_users" -ne 0 ]]; then
            echo -e "${RED}USUARIO CON UUID $userId NO SE ENCONTRÓ EN LOS ARCHIVOS CONFIGURADOS. INTENTE DE NUEVO.${NC}"
            continue
        fi

        # Eliminar del archivo de configuración
        if [[ -n "$found_in_json" ]]; then
            jq ".inbounds[0].settings.clients = (.inbounds[0].settings.clients | map(select(.id != \"$userId\")))" "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
        fi

        # Eliminar del archivo de usuarios
        if [[ "$found_in_users" -eq 0 ]]; then
            sed -i "/$userId/d" "$USERS_FILE"
        fi

        echo -e "${GREEN}USUARIO CON UUID $userId ELIMINADO.${NC}"
        systemctl restart v2ray
        read -p "PRESIONE ENTER PARA REGRESAR AL MENÚ PRINCIPAL" enterKey
        return
    done
}





show_registered_users() {
    
    clear

    print_message_with_border "Información de Usuarios:" '\e[1;36m' 
    echo -e "\e[1;36m==========================================================\e[0m" 
    echo -e "\e[1;36m#   UUID                               Nombre     Expiración\e[0m" 
    echo -e "\e[1;36m==========================================================\e[0m" 

    current_time=$(date +%s)

    contador_activos=0
    contador_expirados=0
    contador=0

    while IFS='|' read -r uuid nombre fecha_expiracion || [[ -n "$uuid" ]]; do
        contador=$((contador+1))  # Incrementar el contador
        if [ -z "$fecha_expiracion" ]; then
            dias_horario="[--]"
        else
            expiracion_timestamp=$(date -d "$fecha_expiracion" +%s)
            diferencia=$((expiracion_timestamp - current_time))

            if ((diferencia >= 0)); then
                dias_restantes=$((diferencia / 86400))
                if ((dias_restantes >= 1)); then
                    dias_horario="[+${dias_restantes}d]"
                else
                    horas_restantes=$((diferencia / 3600))
                    if ((horas_restantes >= 24)); then
                        dias_horario="[+1d]"
                    else
                        dias_horario="[+${horas_restantes}h]"
                    fi
                fi
            else
                dias_restantes=$((diferencia / 86400))
                if ((dias_restantes < -1)); then
                    dias_horario="[${dias_restantes}d]"
                else
                    horas_restantes=$((diferencia / 3600))
                    dias_horario="[${horas_restantes}h]"
                fi
            fi
        fi

        if [ -z "$fecha_expiracion" ] || [ "$current_time" -ge "$expiracion_timestamp" ]; then
            if [ -z "$fecha_expiracion" ]; then
                color="\e[1;32m"
            else
                color="\e[1;31m"
            fi
            ((contador_expirados++))
        else
            color="\e[1;32m"
            ((contador_activos++))
        fi

        printf "%b[%s]%b%-30s %-8s %s\n\e[0m" "\e[1;36m" "$contador" "$color" "$uuid" "$nombre" "$dias_horario"
    done < /etc/v2ray/v2clientes.txt

    echo -e "\e[1;36m==========================================================\e[0m" 
    echo -e "Usuarios activos: [\e[1;32m${contador_activos}\e[0m]" 
    echo -e "Usuarios expirados: [\e[1;31m${contador_expirados}\e[0m]" 
    read -p "Presione Enter para regresar al menú principal" enterKey
}
























count_users() {
    local total_users=0
    local expired_users=0
    local current_time=$(date +%s)
    local uuid
    local nombre
    local fecha_expiracion
    local expiracion_timestamp

    while IFS='|' read -r uuid nombre fecha_expiracion || [[ -n "$uuid" ]]; do
        ((total_users++))
        expiracion_timestamp=$(date -d "$fecha_expiracion" +%s)
        if [ "$current_time" -ge "$expiracion_timestamp" ]; then
            ((expired_users++))
        fi
    done < /etc/v2ray/v2clientes.txt

    echo "$total_users|$expired_users"
}


# Función para renovar usuarios
renew() {
    clear
    print_message_with_border "RENOVAR USUARIOS"

    config_path="/etc/v2ray/config.json"
    usuarios_path="/etc/v2ray/v2clientes.txt"

    current_date=$(date +%s)

    expired_users=()
    user_count=0

    while IFS=' | ' read -r uuid username expiration_date horario
    do
        expiration_epoch=$(date -d"$expiration_date" +%s)

        if (( expiration_epoch < current_date )); then
            expired_users+=("$username | $expiration_date")
            (( user_count++ ))
        fi
    done < "$usuarios_path"

    if [ "$user_count" -eq 0 ]; then
        print_message "${YELLOW}" "No hay usuarios expirados."
        read -p $'\e[1;36mPresiona Enter para continuar...\e[0m'
        return
    fi

    print_message "${YELLOW}" "Usuarios Expirados:"
    print_separator
    for ((i=0; i<user_count; i++)); do
        printf "${YELLOW}[$((i+1))] ${expired_users[$i]}\n"
    done
    print_separator

    local user_selection
    echo -e $'\e[1;36mSeleccione el número de usuario que desea renovar: \e[0m'
    echo -ne "\033[33m\u27A4 \033[0m"
    read user_selection

    if [[ -z "$user_selection" ]]; then
        return
    elif ! [[ "$user_selection" =~ ^[0-9]+$ ]] || (( user_selection < 1 || user_selection > user_count )); then
        print_message "${RED}" "Selección no válida."
        read -p $'\e[1;36mPresiona Enter para continuar...\e[0m'
        return
    fi

    local selected_user="${expired_users[$((user_selection-1))]}"
    local username=$(echo "$selected_user" | awk -F '|' '{print $1}' | tr -d '[:space:]')
    local old_exp_date=$(echo "$selected_user" | awk -F '|' '{print $2}' | tr -d '[:space:]')

    local new_duration
    echo -e $'\e[1;36mIngrese la nueva duración en días para el usuario '\"$username\"$': \e[0m'
    echo -ne "\033[33m\u27A4 \033[0m"
    read new_duration
    
    local new_exp_date=$(date -d "+$new_duration days" +%Y-%m-%d)

    sed -i "s/$username | $old_exp_date/$username | $new_exp_date/" "$usuarios_path"

    print_message "${GREEN}" "¡Usuario \"$username\" renovado exitosamente hasta $new_exp_date!"
    read -p $'\e[1;36mPresiona Enter para continuar...\e[0m'
}

car_a() {
    if [ ! -f "$USERS_FILE" ]; then
        touch "$USERS_FILE"
    fi
}

car_a


show_vmess_by_id() {
    clear
    print_separator
    print_message_with_border  "Mostrar VMess :)"
    
    declare -a id_array=()
    while IFS='|' read -r uuid nombre fecha_expiracion || [[ -n "$uuid" ]]; do
        id_array+=("$uuid|$nombre|$fecha_expiracion")
        echo -e "${YELLOW}[${#id_array[@]}] \e[38;5;110m➤ $nombre ${NC}"
    done < /etc/v2ray/v2clientes.txt

    echo -e "${YELLOW}Ingrese el número del usuario VMess que desea ver:${NC}" 
    echo -ne "\033[33m\u27A4 \033[0m"
    read -r user_number

    if ! [[ $user_number =~ ^[0-9]+$ ]] || [[ $user_number -le 0 || $user_number -gt ${#id_array[@]} ]]; then
        print_message "${RED}" "Número de usuario inválido."
        read -p "Presione Enter para regresar al menú principal" enterKey
        return
    fi

    selected_user=$(echo "${id_array[$user_number-1]}" | cut -d '|' -f 2)
    vmess_id=$(echo "${id_array[$user_number-1]}" | cut -d '|' -f 1 | tr -d '[:space:]') # Remove any spaces
    expiration_date=$(echo "${id_array[$user_number-1]}" | cut -d '|' -f 3)

    current_date=$(date +%F)
    days_difference=$(( ($(date -d "$expiration_date" +%s) - $(date -d "$current_date" +%s)) / (60*60*24) ))

    echo -e "${CYAN}NOMBRE DE USUARIO: \e[38;5;110m$selected_user\e[0m"

    if [[ $days_difference -gt 0 ]]; then
        echo -e "${CYAN}FECHA DE EXPIRACIÓN: \e[38;5;110m$expiration_date (quedan $days_difference días)\e[0m"
    elif [[ $days_difference -eq 0 ]]; then
        echo -e "${CYAN}FECHA DE EXPIRACIÓN: \e[38;5;110m$expiration_date (expira hoy)\e[0m"
    else
        days_difference=$(( -$days_difference ))
        echo -e "${CYAN}FECHA DE EXPIRACIÓN: \e[38;5;110m$expiration_date (expiró hace $days_difference días)\e[0m"
    fi

    ps="$selected_user"
    id="$vmess_id"
    aid=0
    IP=$(hostname -I | awk '{print $1}')
    add=$(jq -r --arg IP "$IP" '.inbounds[0].domain // (if .inbounds[0].listen | type == "string" then .inbounds[0].listen | split(":")[0] else $IP end)' "$CONFIG_FILE")
    port=$(jq -r '.inbounds[0].port' "$CONFIG_FILE")
    net=$(jq -r '.inbounds[0].streamSettings.network' "$CONFIG_FILE")
    path=$(jq -r '.inbounds[0].streamSettings.wsSettings.path // empty' "$CONFIG_FILE")
    host=$(jq -r '.inbounds[0].streamSettings.wsSettings.headers.Host // empty' "$CONFIG_FILE")
    tls="none"

    var="{\"v\":\"2\",\"ps\":\"$ps\",\"add\":\"$add\",\"port\":$port,\"aid\":$aid,\"type\":\"none\",\"net\":\"$net\",\"path\":\"$path\",\"host\":\"$host\",\"id\":\"$id\",\"tls\":\"$tls\"}"
    vmess_url="vmess://$(echo "$var" | jq -r '.|@base64')"

    print_message "${GREEN}" "$vmess_url"
    read -p "Presione Enter para regresar al menú principal" enterKey
}




mostrar_menu() {
    while true; do
        clear
        print_message_with_border "SELECCIONAR ZONA HORARIA"

        echo -e "${RED}[${NC}${LIGHT_BLUE}01${NC}${RED}]${NC} ${LIGHT_BLUE}Argentina${NC}"
        echo -e "${RED}[${NC}${LIGHT_BLUE}02${NC}${RED}]${NC} ${LIGHT_BLUE}Brasil${NC}"
        echo -e "${RED}[${NC}${LIGHT_BLUE}03${NC}${RED}]${NC} ${LIGHT_BLUE}Chile${NC}"
        echo -e "${RED}[${NC}${LIGHT_BLUE}04${NC}${RED}]${NC} ${LIGHT_BLUE}Perú${NC}"
        echo -e "${RED}[${NC}${LIGHT_BLUE}05${NC}${RED}]${NC} ${LIGHT_BLUE}México${NC}"
        echo -e "${RED}[${NC}${LIGHT_BLUE}00${NC}${RED}]${NC} ${LIGHT_BLUE}Volver${NC}"

        read -p "Ingrese el número de la opción deseada y luego presione Enter: " opcion

        case $opcion in
            1) sudo timedatectl set-timezone "America/Argentina/Buenos_Aires" ;;
            2) sudo timedatectl set-timezone "America/Sao_Paulo" ;;
            3) sudo timedatectl set-timezone "America/Santiago" ;;
            4) sudo timedatectl set-timezone "America/Lima" ;;
            5) sudo timedatectl set-timezone "America/Mexico_City" ;;
            0) break ;;  
            *) echo -e "\033[31mOpción no válida\033[0m";;
        esac

        echo -e "\033[1;32mZona horaria cambiada exitosamente.\033[0m"
        read -p "Presione Enter para continuar..." -s
    done
}







conexion() {
    clear
    CGHlog='/var/log/v2ray/access.log'
    [[ $log0 -le 1 ]] && {
        v2ray restart &> /dev/null
        v2ray clean &> /dev/null && let log0++ && clear 
    }
    echo ""
    
    echo -ne '\033[0;34mCargando [\033[0m'
    for i in {1..10}
    do
        echo -ne '\033[0;32m###\033[0m'
        sleep 0.4
    done
    echo -e '\033[0;34m] completo\033[0m'
    sleep 0.3
    clear && clear
    users=$(jq -r '.inbounds[0].settings.clients[] | .email' /etc/v2ray/config.json)
    v2rayports=$(jq -r '.inbounds[0].port' /etc/v2ray/config.json)
    
    
    activos=$(grep -c "accepted" ${CGHlog})
    
    n=1
    echo -e "\033[1;97;41m     PUERTO ACTIVO : $v2rayports    ACTIVOS:  $activos \033[0m"
    echo -e "\033[1;97;41m N) | USER  |   CONEXIONES \033[0m"
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    for U in $users
    do
        CConT=$(grep -c "accepted.*email: $U" ${CGHlog})
        [[ $CConT = 0 ]] && continue
        printf "\033[0;32m%-5s | %-10s | %-10s\033[0m\n" "$n)" "$U" "$CConT"
        let n++
    done
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\033[0mPRESIONE CUALQUIER TECLA PARA CONTINUAR..."
    read -n 1 -s -r
    v2ray clean > /dev/null 2>&1
}


interface="eth0"


v2ray_port="80"


get_traffic() {
    vnstat -i "$interface" --json | jq ".interfaces[0].traffic.total.rx+ .interfaces[0].traffic.total.tx"
}

get_connections() {
    netstat -anp | grep ":$v2ray_port " | grep ESTABLISHED | wc -l
}








install_v2ray() {
    
    download_and_move_v2ctl() {
        
        
        
        curl -o v2ctl.zip -sSL https://raw.githubusercontent.com/joaquin1444/clientes-v2ray/main/v2ctl.zip &>/dev/null

        
        unzip -o -q v2ctl.zip -d /usr/bin/v2ray/ 

        
        if [ $? -eq 0 ]; then
            
            chmod +x /usr/bin/v2ray/v2ctl
        else
            echo " "
        fi
        
        rm v2ctl.zip &>/dev/null
    }

    
    curl -sL https://multi.netlify.app/v2ray.sh | bash 
    
    
    cat <<EOF > /etc/systemd/system/v2ray.service
[Unit]
Description=V2Ray Service
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/v2ray/v2ray run -c /etc/v2ray/config.json
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

    
    config="/etc/v2ray/config.json"
    tmp_config="/etc/v2ray/tmp.json"
    if [ -e "$config" ]; then
        jq 'del(.inbounds[].streamSettings.kcpSettings)' < "$config" >> "$tmp_config"
    fi

    
    download_and_move_v2ctl

    
    systemctl daemon-reload &>/dev/null
    
    systemctl start v2ray &>/dev/null
    systemctl enable v2ray &>/dev/null
    systemctl restart v2ray.service &>/dev/null

    
    echo -e "${GREEN}V2Ray instalado con éxito.${NC}" >&2
    echo -e "${CYAN}Presiona Enter para continuar${NC}" && read enter
}
entrar_v2ray_original() {

    
    v2ray

    print_message "${CYAN}" "Has entrado al menú nativo de V2Ray."
}
archivo="/etc/v2ray/v2clientes.txt"


cp "$archivo" "$archivo.bak"

cambiar_formatos_y_eliminar_dias() {
    while IFS=' | ' read -r id nombre dias fecha; do
        
        if [[ $fecha =~ ^[0-9]{2}-[0-9]{2}-[0-9]{2}$ ]]; then
            
            dia=${fecha:0:2}
            mes=${fecha:3:2}
            ano="20${fecha:6:2}"
            fecha_nueva="$ano-$mes-$dia"
            
            
            sed -i "s/$id | $nombre | $dias | $fecha/$id | $nombre | $fecha_nueva/" "$archivo"
        fi
    done < "$archivo"
}
restart_v2ray() {
    systemctl restart v2ray
}
cambiar_path() {
    sleep 1
    clear
    while true; do
        printf "\e[1;33mSELECCIONA UNA OPCIÓN:\e[0m\n"
        echo -e "${RED}[${NC}${LIGHT_BLUE}1${NC}${RED}]${NC} ${LIGHT_BLUE}CAMBIAR EL NUEVO PATH${NC}"
        echo -e "${RED}[${NC}${LIGHT_BLUE}0${NC}${RED}]${NC} ${LIGHT_BLUE}Salir${NC}"
        printf "\e[36mOPCIÓN: \e[0m"
        read opcion

        case $opcion in
            1)
                printf "\e[1;32mSELECCIONASTE CAMBIAR EL PATH...\e[0m\n"
                printf "\e[36mINTRODUCE EL NUEVO PATH: \e[0m"
                read nuevo_path
                printf "\e[1;32mMODIFICANDO EL PATH A $nuevo_path EN EL ARCHIVO DE CONFIGURACIÓN...\e[0m\n"

                if ! command -v jq &> /dev/null; then
                    printf "\e[91mERROR: 'jq' NO ESTÁ INSTALADO. INSTÁLALO PARA CONTINUAR.\e[0m\n"
                    return
                fi

                if [ ! -f "$CONFIG_FILE" ]; then
                    printf "\e[91mERROR: EL ARCHIVO DE CONFIGURACIÓN '$CONFIG_FILE' NO EXISTE.\e[0m\n"
                    return
                fi

                jq --arg nuevo_path "$nuevo_path" '.inbounds[0].streamSettings.wsSettings.path = $nuevo_path' "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"

                if [ $? -eq 0 ]; then
                    printf "\e[33mEL PATH HA SIDO CAMBIADO A $nuevo_path.\e[0m\n"
                    systemctl restart v2ray
                    printf "\e[36mPRESIONA ENTER PARA REGRESAR AL MENÚ PRINCIPAL\e[0m"
                    read enterKey
                    return
                else
                    printf "\e[91mERROR AL MODIFICAR EL ARCHIVO DE CONFIGURACIÓN CON jq.\e[0m\n"
                    printf "\e[36mPRESIONA ENTER PARA REGRESAR AL MENÚ PRINCIPAL\e[0m"
                    read enterKey
                    return
                fi
                ;;
            0)
                printf "\e[1;31mSELECCIONASTE SALIR...\e[0m\n"
                return
                ;;
            *)
                printf "\e[91mOPCIÓN INVÁLIDA. POR FAVOR, SELECCIONA UNA OPCIÓN VÁLIDA.\e[0m\n"
                ;;
        esac
    done
}
configurar_temporizador() {
    while true; do
        clear
        print_separator
        echo -e "${CYAN}Selecciona el intervalo de tiempo:${NC}"
        echo -e "1. ${GREEN}5 minutos${NC}"
        echo -e "2. ${GREEN}30 minutos${NC}"
        echo -e "3. ${GREEN}1 hora${NC}"
        echo -e "4. ${RED}Desactivar temporizador${NC}"
        echo -e "5. ${YELLOW}Salir${NC}"
        print_separator

        read -p "Selecciona una opción (1-5): " opcion

        case $opcion in
            1)
                configurar_temporizador_con_intervalo "5:00"
                ;;
            2)
                configurar_temporizador_con_intervalo "30:00"
                ;;
            3)
                configurar_temporizador_con_intervalo "59:00"
                ;;
            4)
                desactivar_temporizador
                ;;
            5)
                echo "Volviendo al menú principal..."
                return  
                ;;
            "")
                echo "Volviendo al menú principal..."
                return  
                ;;
            *)
                echo -e "${RED}Opción no válida. Por favor, selecciona una opción válida.${NC}"
                ;;
        esac

        read -p "Presiona Enter para continuar..."
    done
}


eliminar_expirados() {
    clear
print_message_with_border "ELIMINAR EXPIRADOS"
    config_path="/etc/v2ray/config.json"
    usuarios_path="/etc/v2ray/v2clientes.txt"

    print_separator() {
        echo -e "\e[1;36m============================================================\e[0m"
    }

    current_date=$(date +%s)

    expired_users=()
    user_count=0

    while IFS=' | ' read -r uuid username expiration_date; do
        expiration_epoch=$(date -d"$expiration_date" +%s)

        if (( expiration_epoch < current_date )); then
            expired_users+=("$uuid | $username | $expiration_date")  # Almacenamos UUID, nombre y fecha de expiración
            (( user_count++ ))
        fi
    done < "$usuarios_path"

    if [ "$user_count" -eq 0 ]; then
        print_message "${YELLOW}" "No hay usuarios expirados."
        read -p $'\e[1;36mPresiona Enter para continuar...\e[0m'
        return
    fi

    print_message "${YELLOW}" "Usuarios Expirados:"
    for ((i=0; i<user_count; i++)); do
        print_message "${YELLOW}" "[$((i+1))] ${expired_users[$i]}"
    done

    read -p $'\e[1;36m¿Quieres eliminar los usuarios expirados? (s/n): \e[0m' answer

    if [[ "$answer" != "s" ]]; then
        echo "No se eliminaron usuarios expirados."
        read -p $'\e[1;36mPresiona Enter para continuar...\e[0m'
        return
    fi

    while IFS=' | ' read -r uuid username expiration_date; do
        expiration_epoch=$(date -d"$expiration_date" +%s)

        if (( expiration_epoch < current_date )); then
            
            print_separator
            echo -e "\e[1;31mEliminando usuario expirado:\e[0m\n  \e[1;34mUUID:\e[0m $uuid\n  \e[1;34mUsuario:\e[0m $username\n  \e[1;34mFecha de expiración:\e[0m $expiration_date"

            jq --arg uuid "$uuid" '.inbounds[0].settings.clients |= map(select(.id != $uuid))' "$config_path" > "$config_path.tmp" && mv "$config_path.tmp" "$config_path"
            
            sed -i "/$uuid | $username | $expiration_date/d" "$usuarios_path"
        fi
    done < "$usuarios_path"

    sudo systemctl restart v2ray
    read -p $'\e[1;36mPresiona Enter para continuar...\e[0m'
}












acomodar_usuarios() {
    
    usuarios_path="/etc/v2ray/v2clientes.txt"

    if [ ! -f "$usuarios_path" ]; then
        return
    fi

    temp_file=$(mktemp)

    while IFS= read -r line; do
        formatted_line=$(echo "$line" | sed 's/ *| */ | /g')
        echo "$formatted_line" >> "$temp_file"
    done < "$usuarios_path"

    mv "$temp_file" "$usuarios_path"
    sudo sync; sudo echo 3 > /proc/sys/vm/drop_caches
}

acomodar_usuarios






print_separator() {
    echo -e "\e[1;36m============================================================\e[0m"
}

addres_ip() {
    config="/etc/v2ray/config.json"
    temp="/tmp/temp_v2ray_config.json"

    add=$(jq -r '.inbounds[] | select(.domain != null) | .domain' "$config")
    _add=""

    print_separator
    print_message_with_border "CONFIGURACIÓN DE ADDRES V2RAY"

    print_separator

    while [[ -z $_add || $_add == '' ]]; do
        echo -e "\e[1;34mNueva ADDRES\e[0m"
        read -p "Ingrese la nuevo addres (presione Enter para cancelar): " _add
        if [[ -z "$_add" ]]; then
            echo -e "\e[1;31mCancelado.\e[0m"
            return
        elif [[ "$_add" != *.* ]]; then
            echo -e "\e[1;31mFormato no válido.\e[0m"
            unset _add
        fi
    done

    mv "$config" "$temp"
    jq --arg a "$_add" '.inbounds[] += {"domain":$a}' < "$temp" >> "$config"
    chmod 777 "$config"
    rm "$temp"
     print_separator
    echo -e "\e[1;33mSu addres ha sido cambiada a: \e[1;32m$_add\e[0m"
    print_separator
    systemctl restart v2ray

    read -p "Presione Enter para volver atrás..."
}








limpiar_ram() {
    clear
    # Definir colores
    local CYAN="\033[1;36m"
    local GREEN="\033[1;32m"
    local YELLOW="\033[1;33m"
    local RED="\033[1;31m"
    local NC="\033[0m" 

    
    echo -e "${GREEN}REFRESCANDO CACHE Y RAM${NC}"
    (
        local VE="\033[1;33m" && local MA="\033[1;31m" && local DE="\033[1;32m"
        local A=""
        while [[ ! -e /tmp/abc ]]; do
            A+="#"
            echo -e "${VE}[${MA}${A}${VE}]" >&2
            sleep 0.3s
            tput cuu1 && tput dl1
        done
        echo -e "${VE}[${MA}${A}${VE}] - ${DE}[100%]" >&2
        rm /tmp/abc
    ) &
    sudo echo 3 > /proc/sys/vm/drop_caches &>/dev/null
    sleep 1s
    sysctl -w vm.drop_caches=3 &>/dev/null
    apt-get autoclean -y &>/dev/null
    sleep 1s
    apt-get clean -y &>/dev/null
    rm /tmp/* &>/dev/null
    touch /tmp/abc
    wait
    echo -e "${GREEN}CACHE/RAM LIMPIADA CON ÉXITO!${NC}"
}











programar_tarea() {
    clear
    
    echo -ne "\e[34m PERIODO DE EJECUCIÓN DE LA TAREA [1-12HS]: \e[0m"
    read ram_c
    if [[ $ram_c =~ $numero ]]; then
        
        crontab -l | grep -v "systemctl restart v2ray" | crontab -
        crontab -l | grep -v "v2ray clean" | crontab -
        crontab -l | grep -v "sudo sysctl -w vm.drop_caches=3" | crontab -
        
        crontab -l > /root/cron
        echo "0 */$ram_c * * * sudo sysctl -w vm.drop_caches=3 > /dev/null 2>&1" >> /root/cron
        echo "0 */$ram_c * * * v2ray clean > /dev/null 2>&1" >> /root/cron
        echo "0 */$ram_c * * * systemctl restart v2ray > /dev/null 2>&1" >> /root/cron
        crontab /root/cron
        rm /root/cron
        tput cuu1 && tput dl1
        echo -e "\e[34m TAREA AUTOMÁTICA PROGRAMADA CADA: \e[32m${ram_c}HS\e[0m" && sleep 2
    else
        tput cuu1 && tput dl1
        echo -e "\e[31m INGRESE SOLO NÚMEROS ENTRE 1 Y 12\e[0m"
        sleep 2
    fi
}



desactivar_tarea() {
    
    crontab -l | grep -v "sudo sysctl -w vm.drop_caches=3" | crontab -
    crontab -l | grep -v "v2ray clean" | crontab -
    crontab -l | grep -v "systemctl restart v2ray" | crontab -
    echo -e "\e[34mLa tarea automática ha sido desactivada.\e[0m"

}

get_scheduled_task_frequency() {
    local entry=$(crontab -l 2>/dev/null | grep 'sudo sysctl -w vm.drop_caches=3')
    if [ -z "$entry" ]; then
        echo "no programada"
    else
        local frequency=$(echo "$entry" | awk '{print $2}' | cut -d '/' -f2)
        if [ -z "$frequency" ]; then
            echo "error"
        else
            echo "${frequency}h"
        fi
    fi
}


optimizacion() {
    local scheduled_frequency

    while true; do
        scheduled_frequency=$(get_scheduled_task_frequency)
        clear
        print_message_with_border "===== MENÚ DE OPTIMIZACIÓN ====="

        echo -e "${RED}[${NC}${LIGHT_BLUE}1${NC}${RED}]${NC} ${LIGHT_BLUE}Limpiar RAM${NC}"
        echo -e "${RED}[${NC}${LIGHT_BLUE}2${NC}${RED}]${NC} ${LIGHT_BLUE}Programar tarea automática [${CYAN}${scheduled_frequency}${NC}${LIGHT_BLUE}]${NC}"
        echo -e "${RED}[${NC}${LIGHT_BLUE}3${NC}${RED}]${NC} ${LIGHT_BLUE}Desactivar tarea automática${NC}"
        echo -e "${RED}[${NC}${LIGHT_BLUE}0${NC}${RED}]${NC} ${LIGHT_BLUE}Salir${NC}"
        read -p "Elige una opción: " opcion

        case $opcion in
            1)
                limpiar_ram
                ;;
            2)
                programar_tarea
                ;;
            3)
                desactivar_tarea
                ;;
            0)
                break
                ;;
            *)
                echo "Opción no válida"
                ;;
        esac

        read -p "Presiona Enter para continuar..."
    done
}


limpiar_tmp() {
    sudo find /tmp -type f -delete

}

limpiar_tmp

install_new_version() {
    clear
    
    if [ -f /usr/bin/v2.sh ]; then
        sudo rm /usr/bin/v2.sh
    fi

    unalias v2 > /dev/null 2>&1

    wget --no-cache -O /usr/bin/v2.sh https://raw.githubusercontent.com/joaquin1444/clientes-v2ray/main/v2.sh > /dev/null 2>&1
    
    if [ $? -eq 0 ]; then
        sudo chmod +x /usr/bin/v2.sh
        local latest_version=$(check_github_version)
        print_separator
        echo -e "\e[35m¡Felicidades! Has actualizado con éxito la versión $latest_version 🎉\e[0m"

        print_separator
        
        log_content=$(curl -s https://raw.githubusercontent.com/joaquin1444/clientes-v2ray/main/log)
        
        # Función para recortar líneas largas
        recortar_lineas() {
            local linea
            while IFS= read -r linea; do
                echo "$linea" | fold -s -w 60
            done
        }

        echo -e "\e[33m${log_content}\e[0m" | recortar_lineas
print_message_with_border "SOPORTE EN TELEGRAM: https://t.me/joaquinH2 "
        print_separator
        read -p $'\e[36mPresiona Enter para continuar...\e[0m' -s
        clear
        exec sudo /usr/bin/v2.sh
    else
        print_separator
        echo -e "\e[31mError: No se pudo descargar el script v2 😞\e[0m"
        echo "$(date): Error al actualizar a la versión $latest_version" >> update.log
        print_separator
        read -p $'\e[36mPresiona Enter para continuar...\e[0m' -s
    fi
}









protocolv2ray () {
    clear
    echo -e "\e[1mESCOGER OPCIÓN 3 Y PONER EL DOMINIO DE NUESTRA IP:\e[0m"
    print_separator
    v2ray stream
    print_separator
    echo -e "\e[1mENTER PARA CONTINUAR\e[0m" && read enter
    ${SCPinst}/v2ray.sh
}
tls () {
    clear
    print_message_with_border "ACTIVAR O DESACTIVAR TLS:"

    print_separator
    v2ray tls
    print_separator
    echo -e "\e[1mENTER PARA CONTINUAR\e[0m" && read enter
    ${SCPinst}/v2ray.sh
}
portv () {
    clear
    print_message_with_border "CAMBIAR PUERTO V2RAY:"

    print_separator
    v2ray port
    print_separator
    echo -e "\e[1mENTER PARA CONTINUAR\e[0m" && read enter
    ${SCPinst}/v2ray.sh
}
stats () {
    clear
    print_message_with_border "ESTADÍSTICAS DE CONSUMO:"

    v2ray stats
    echo -e "\e[1mENTER PARA CONTINUAR\e[0m" && read enter
    ${SCPinst}/v2ray.sh
}

show_speedtest_menu() {
    clear
    print_message_with_border "===== SpeedTest Menu ====="

    echo -e "${RED}[${NC}${LIGHT_BLUE}1${NC}${RED}]${NC} ${LIGHT_BLUE}EJECUTAR SPEEDTEST${NC}"
    echo -e "${RED}[${NC}${LIGHT_BLUE}0${NC}${RED}]${NC} ${LIGHT_BLUE}Salir${NC}"
    echo -e "\e[1;32m==========================\e[0m"
}
run_speedtest_menu() {
    while true; do
        show_speedtest_menu
        read -p "Ingrese su elección: " choice_speedtest
        case $choice_speedtest in
            1)
                echo -e "\e[1;33mEJECUTANDO SPEEDTEST \e[0m"
                speedtest-cli --share
                ;;
            2)
                echo "VOLVIENDO AL MENÚ PRINCIPAL."
                break
                ;;
            *)
                echo "OPCIÓN INVÁLIDA. POR FAVOR, SELECCIONE UNA OPCIÓN VÁLIDA."
                ;;
        esac
    done
}

while true; do
    show_menu
    read -p "Seleccione una opción: " opcion

    case $opcion in
        1)
        clear
            add_user
            ;;
        2)
        clear
            delete_user
            ;;
        3)
        clear
            edit_user_uuid
            ;;
        4)
        clear
            show_registered_users
            
            ;;
        5)
        clear
            show_vmess_by_id
            ;;
        6)
        clear
            eliminar_expirados
            ;;
        7)
        clear
            renew
            ;;
        8)
        clear
            conexion
            ;;
        9)
        clear
            show_backup_menu
            ;;
        10)
            while true; do
    clear
    echo -e "\e[36m╔════════════════════════════════════════════════════╗\e[0m"
                 print_message_with_border  "      ===== CONFIGURAR V2RAY =====      "
    
    menu_info
print_separator

echo -e "${RED}[${RESET}${LIGHT_BLUE}01${RESET}${RED}] ${GREEN}INSTALAR V2RAY ${RESET}"
echo -e "${RED}[${RESET}${LIGHT_BLUE}02${RESET}${RED}] ${RED}DESINSTALAR V2RAY ${RESET}"

optimize_status="${RED}[off]${RESET}"
if crontab -l 2>/dev/null | grep -q "vm.drop_caches=3"; then
    optimize_status="${GREEN}[on]${RESET}"
fi

echo -e "${RED}[${RESET}${LIGHT_BLUE}03${RESET}${RED}] ${LIGHT_BLUE}OPTIMIZAR VPS AUT. ${optimize_status} ${RESET}"
echo -e "${RED}[${RESET}${LIGHT_BLUE}04${RESET}${RED}] ${LIGHT_BLUE}CAMBIAR EL PATH DE V2RAY ${RESET}"
echo -e "${RED}[${RESET}${LIGHT_BLUE}05${RESET}${RED}] ${LIGHT_BLUE}CAMBIAR PROTOCOLO ${RESET}"
echo -e "${RED}[${RESET}${LIGHT_BLUE}06${RESET}${RED}] ${LIGHT_BLUE}ACTIVAR TLS ${RESET}"
echo -e "${RED}[${RESET}${LIGHT_BLUE}07${RESET}${RED}] ${LIGHT_BLUE}CAMBIAR PUERTO ${RESET}"
echo -e "${RED}[${RESET}${LIGHT_BLUE}08${RESET}${RED}] ${LIGHT_BLUE}CAMBIAR IP ${RESET}"
echo -e "${RED}[${RESET}${LIGHT_BLUE}09${RESET}${RED}] ${LIGHT_BLUE}VER DATOS CONSUMIDOS ${RESET}"
echo -e "${RED}[${RESET}${LIGHT_BLUE}10${RESET}${RED}] ${LIGHT_BLUE}ENTRAR AL V2RAY NATIVO ${RESET}"
echo -e "${RED}[${RESET}${LIGHT_BLUE}11${RESET}${RED}] ${LIGHT_BLUE}ACTUALIZAR SCRIPT V2 ${RESET}"
echo -e "${RED}[${RESET}${LIGHT_BLUE}12${RESET}${RED}] ${LIGHT_BLUE}CAMBIAR HORARIO ${RESET}"
echo -e "${RED}[${RESET}${LIGHT_BLUE}13${RESET}${RED}] ${LIGHT_BLUE}SPEEDTEST ${RESET}"
echo -e "${RED}[${RESET}${LIGHT_BLUE}00${RESET}${RED}] ${GREEN}VOLVER AL MENÚ PRINCIPAL ${RESET}"





    print_separator
    read -r main_option



                case $main_option in
                    1) 
                   clear


echo -e "${CYAN}¿DESEA INSTALAR V2RAY? (S PARA INSTALAR, ENTER PARA CANCELAR) ${NC}"
echo -en "${CYAN}Respuesta:${NC} "
read answer
answer="${answer,,}" 


if [ "$answer" = "s" ]; then
    install_v2ray
elif [ -z "$answer" ]; then
    echo -e "${GREEN}Instalación de V2Ray cancelada.${NC}"
else
    echo -e "${CYAN}Volviendo atrás${NC}"
    echo -e "${CYAN}Presiona Enter para volver atrás...${NC}"
    read -s -n 1
fi

                        ;;
                    2) 
                        clear

echo -e "${YELLOW}¿ESTÁS SEGURO DE QUE DESEAS DESINSTALAR V2RAY? (S PARA DESINSTALAR, ENTER PARA CANCELAR)${NC}"
read -n 1 -r confirmacion


confirmacion=$(echo "$confirmacion" | tr '[:lower:]' '[:upper:]')

if [ "$confirmacion" = "S" ]; then
    echo -e "\n${GREEN}DESINSTALANDO V2RAY...${NC}"
    sudo systemctl stop v2ray
    sudo systemctl disable v2ray
    sudo rm -f /etc/systemd/system/v2ray.service
    sudo rm -rf /usr/bin/v2ray /etc/v2ray
    echo -e "${GREEN}V2RAY SE HA DESINSTALADO CORRECTAMENTE.${NC}"
    echo -e "PRESIONA ENTER PARA SALIR..."
    read -s -n 1
else
    echo -e "\nOPERACIÓN DE DESINSTALACIÓN CANCELADA. VOLVIENDO AL MENÚ PRINCIPAL..."
    echo -e "PRESIONA ENTER PARA SALIR..."
    read -s -n 1
fi

                        ;;
                    3) 
                    clear
                        optimizacion
                        ;;
                    4)
                    clear
                        cambiar_path
                        ;;
                    5)
                    clear
                        protocolv2ray
                        ;;
                    6)
                    clear
                        tls
                        ;;
                    7)
                    clear
                        portv
                        ;;
                    8)
                    clear
                        addres_ip
                        ;;
                    9)
                    clear
                   stats
                     ;;
                      10)
                      clear
                entrar_v2ray_original
                      ;;
                      11) 
                      clear
                      install_new_version
                      ;;
                       12) 
                       clear
                      mostrar_menu
                      ;;
      13)
    while true; do
    clear
        show_speedtest_menu
        read -p "Ingrese su elección: " choice
        case $choice in
            1)
            clear
                echo -e "\e[1;33mEJECUTANDO SPEEDTEST\e[0m"
                echo "ESPERE MIENTRAS SE CARGAN LOS RESULTADOS:"
                speedtest-cli --simple --share > speedtest_results.txt 2>/dev/null &
                speedtest_pid=$!

                echo -ne '\033[0;34mCargando [\033[0m'
                while ps -p $speedtest_pid > /dev/null; do
                    echo -ne '\033[0;32m#\033[0m'
                    sleep 0.8
                done
                echo -e '\033[0;34m] completo\033[0m'

                speedtest_results=$(cat speedtest_results.txt)

                echo ""
                print_separator
                echo -e "\e[1;32m$speedtest_results\e[0m" 
                print_separator

                rm speedtest_results.txt

                echo -e "\n\e[1;33mPRESIONE ENTER PARA VOLVER AL MENÚ PRINCIPAL...\e[0m"
                read -s -r
                ;;
            0)
                echo "Volviendo al menú principal."
                break
                ;;
            *)
                echo -e "${RED}Opción no válida${NC}"
                ;;
        esac
    done
    ;;
0)
                        echo "Volviendo al menú principal."
                        break  
                        ;;
                    *)
                        echo -e "${RED}Opción no válida${NC}"
                        ;;
                esac
            done 
                ;;
            0)
            clear
                echo "Saliendo..."
                exit 0  
                ;;
            *)
            echo "Opción no válida"
            ;;
    esac
done
