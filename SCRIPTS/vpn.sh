##!/usr/bin/env zsh

# Configuración de colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
BLUE='\033[0;34m'
LIGHT_BLUE='\033[1;34m'
LIGHT_BLUE_CYAN='\033[38;2;0;212;255m'

TMP_FILE="/tmp/conexiones_ajustadas.txt"
echo "0" > $TMP_FILE  


display_banner() {
    local config_file="/root/linklayer-vpn-server/cfg/config.json"
    local conexiones_ajustadas=0

    if [[ -f "$config_file" ]]; then
        local puerto=$(jq -r '.services[0].cfg.Listen' "$config_file" | cut -d':' -f2)
        local num_conexiones=$(sudo ss -Htn "sport = :$puerto" | grep ESTAB | wc -l)
        conexiones_ajustadas=$((num_conexiones / 2))  # Ajusta según tu necesidad
    fi

    echo -e "${BLUE}====================================${NC}"
    echo -e "           SCRIPT LINKLAYER VPN"
    echo -e "${BLUE}====================================${NC}"
    if screen -list | grep -q "server"; then
        echo -e "ESTADO: ${LIGHT_BLUE_CYAN}[ACTIVO] - CONEXIONES: ${conexiones_ajustadas}${NC}"
    else
        echo -e "ESTADO: ${RED}[DESACTIVADO]${NC}"
    fi
    echo -e "${BLUE}====================================${NC}"
}



background_pid=$!

display_banner() {
    local config_file="/root/linklayer-vpn-server/cfg/config.json"
    local conexiones_ajustadas=0

    if [[ -f "$config_file" ]]; then
        local puerto=$(jq -r '.services[0].cfg.Listen' "$config_file" | cut -d':' -f2)
        local num_conexiones=$(sudo ss -Htn "sport = :$puerto" | grep ESTAB | wc -l)
        conexiones_ajustadas=$((num_conexiones / 2))  # Ajusta según tu necesidad
    fi

    echo -e "${BLUE}====================================${NC}"
    echo -e "           SCRIPT LINKLAYER VPN"
    echo -e "${BLUE}====================================${NC}"
    if screen -list | grep -q "server"; then
        echo -e "ESTADO: ${LIGHT_BLUE_CYAN}[ACTIVO] - CONEXIONES: ${conexiones_ajustadas}${NC}"
    else
        echo -e "ESTADO: ${RED}[DESACTIVADO]${NC}"
    fi
    echo -e "${BLUE}====================================${NC}"
}


install_server() {
    clear
    echo -e "${YELLOW}INSTALANDO DEPENDENCIAS...${NC}"
    apt-get install screen git jq -y

    echo -e "${YELLOW}VERIFICANDO EL REPOSITORIO...${NC}"
    if [ -d "linklayer-vpn-server" ]; then
        echo -e "${RED}EL DIRECTORIO 'LINKLAYER-VPN-SERVER' YA EXISTE. OMITIENDO CLONACIÓN.${NC}"
    else
        git clone https://bitbucket.org/iopmx/linklayer-vpn-server.git
        if [ $? -ne 0 ]; then
            echo -e "${RED}ERROR CLONANDO EL REPOSITORIO. VERIFIQUE SU CONEXIÓN A INTERNET Y LOS PERMISOS.${NC}"
            return
        fi
    fi

    
    local puerto
    while true; do
        echo -e "${YELLOW}Ingrese el puerto en el que desea instalar el servidor (por defecto 80):${NC}"
        read puerto
        puerto=${puerto:-80}  

        
        if ! ss -tuln | grep -q ":$puerto "; then
            echo -e "${GREEN}El puerto $puerto está disponible.${NC}"
            break
        else
            echo -e "${RED}El puerto $puerto ya está en uso. Por favor, intente con otro puerto.${NC}"
        fi
    done

    
    cat > linklayer-vpn-server/cfg/config.json << EOF
{
    "auth":"system",
    "file":"/root/cfg/auth.txt",
    "executable":"/root/auth.sh",
    "banner":"server privado",
    "limit_conn_single":-1,
    "limit_conn_request":-1,
    "services":[
        {
            "type":"httpdual",
            "cfg":{
                "Listen":"0.0.0.0:$puerto"
            }
        }
    ]
}
EOF

    
    screen -dmS server /root/linklayer-vpn-server/server -cfg /root/linklayer-vpn-server/cfg/config.json
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}SERVIDOR VPN CONFIGURADO Y EJECUTÁNDOSE EN 'SCREEN' BAJO EL NOMBRE 'SERVER' EN EL PUERTO $puerto.${NC}"
    else
        echo -e "${RED}ERROR AL INTENTAR EJECUTAR EL SERVIDOR VPN.${NC}"
    fi
}

uninstall_server() {
    clear
    echo -e "${YELLOW}DESMONTANDO EL SERVIDOR VPN...${NC}"

    
    local pid=$(pgrep -f 'linklayer-vpn-server/server')
    if [[ -n "$pid" ]]; then
        kill $pid
        
        wait $pid 2>/dev/null
        if [[ $? -eq 0 ]]; then
            echo -e "${GREEN}Proceso del servidor VPN terminado.${NC}"
        else
            echo -e "${RED}Error al terminar el proceso del servidor VPN.${NC}"
        fi
    else
        echo -e "${RED}No se encontró el proceso del servidor VPN.${NC}"
    fi

    
    if [[ -d "/root/linklayer-vpn-server" ]]; then
        rm -rf /root/linklayer-vpn-server
        echo -e "${GREEN}Directorio del servidor VPN eliminado.${NC}"
    else
        echo -e "${RED}Directorio del servidor VPN no encontrado.${NC}"
    fi

    echo -e "${GREEN}SERVIDOR VPN DESINSTALADO.${NC}"
    echo -e "${YELLOW}Presione Enter para volver al menú.${NC}"
    read -r
    show_menu
}


check_status() {
    clear
    echo -e "${BLUE}VERIFICANDO EL ESTADO DEL SERVIDOR VPN...${NC}"
    
    if screen -list | grep -q "server"; then
        echo -e "${BLUE}SERVIDOR VPN ESTÁ [${LIGHT_BLUE_CYAN}ACTIVO${BLUE}]${NC}"
        
        
        local config_file="/root/linklayer-vpn-server/cfg/config.json"
        if [[ -f "$config_file" ]]; then
            
            local port=$(jq -r '.services[0].cfg.Listen' $config_file | cut -d':' -f2)
            echo -e "${BLUE}PUERTO EN USO: ${LIGHT_BLUE_CYAN}$port${NC}"

            
            local limit_conn=$(jq -r '.limit_conn_single' $config_file)
            if [[ "$limit_conn" == "-1" ]]; then
                echo -e "${BLUE}LÍMITE DE CONEXIÓN POR USUARIO: ${LIGHT_BLUE_CYAN}Sin límite${NC}"
            else
                echo -e "${BLUE}LÍMITE DE CONEXIÓN POR USUARIO: ${LIGHT_BLUE_CYAN}$limit_conn${NC}"
            fi

            
            local banner=$(jq -r '.banner' $config_file)
            echo -e "${BLUE}BANNER CONFIGURADO: ${LIGHT_BLUE_CYAN}$banner${NC}"
        else
            echo -e "${RED}EL ARCHIVO DE CONFIGURACIÓN NO EXISTE.${NC}"
        fi
    else
        echo -e "${BLUE}SERVIDOR VPN ESTÁ [${LIGHT_BLUE_CYAN}DESACTIVADO${BLUE}]${NC}"
    fi
    echo -e "${LIGHT_BLUE_CYAN}PRESIONE CUALQUIER TECLA PARA CONTINUAR...${NC}"
    read -n 1
}


add_banner() {
    clear
    echo -e "${GREEN}INTRODUCE EL TEXTO DEL BANNER:${NC}"
    echo -e "${YELLOW}NOTA: EL BANNER NO SOPORTA HTML Y NO DEBE SER MUY LARGO.${NC}"  # Mensaje adicional
    read banner_text
    if [ ! -f "/root/linklayer-vpn-server/cfg/config.json" ]; then
        echo -e "${RED}EL ARCHIVO DE CONFIGURACIÓN NO EXISTE.${NC}"
        return
    fi
    jq --arg bn "$banner_text" '.banner = $bn' /root/linklayer-vpn-server/cfg/config.json > /tmp/temp_config.json && mv /tmp/temp_config.json /root/linklayer-vpn-server/cfg/config.json
    echo -e "${GREEN}BANNER ACTUALIZADO CORRECTAMENTE.${NC}"
    restart_server
}


remove_banner() {
    clear
    if [ -f "/root/linklayer-vpn-server/cfg/config.json" ]; then
        jq '.banner = " "' /root/linklayer-vpn-server/cfg/config.json > /tmp/temp_config.json && mv /tmp/temp_config.json /root/linklayer-vpn-server/cfg/config.json
        echo -e "${GREEN}BANNER ELIMINADO.${NC}"
        restart_server
    else
        echo -e "${RED}EL ARCHIVO DE CONFIGURACIÓN NO EXISTE.${NC}"
    fi
}


modify_connection_limit() {
    clear
    echo -e "${GREEN}INTRODUCE EL NUEVO LÍMITE DE CONEXIONES POR USUARIO (INGRESA -1 PARA SIN LÍMITE):${NC}"
    read new_limit
    if [ ! -f "/root/linklayer-vpn-server/cfg/config.json" ]; then
        echo -e "${RED}EL ARCHIVO DE CONFIGURACIÓN NO EXISTE.${NC}"
        return
    fi
    jq --arg nl "$new_limit" '.limit_conn_single = ($nl | tonumber)' /root/linklayer-vpn-server/cfg/config.json > /tmp/temp_config.json && mv /tmp/temp_config.json /root/linklayer-vpn-server/cfg/config.json
    echo -e "${GREEN}LÍMITE DE CONEXIÓN POR USUARIO ACTUALIZADO CORRECTAMENTE A $new_limit.${NC}"
    restart_server
}
modify_port() {
    clear
    echo -e "${BLUE}INTRODUCE EL NUEVO PUERTO:${NC}"
    read new_port
    
    
    if ! [[ "$new_port" =~ ^[0-9]+$ ]] || [ "$new_port" -lt 1 ] || [ "$new_port" -gt 65535 ]; then
        echo -e "${RED}Por favor, introduce un número de puerto válido (1-65535).${NC}"
        echo "PRESIONE CUALQUIER TECLA PARA CONTINUAR..."
        read -n 1
        return
    fi

    
    if sudo netstat -tuln | grep -q ":$new_port\s"; then
        echo -e "${RED}El puerto $new_port ya está en uso. Elige otro puerto.${NC}"
        echo "PRESIONE CUALQUIER TECLA PARA CONTINUAR..."
        read -n 1
        return
    fi

    local config_file="/root/linklayer-vpn-server/cfg/config.json"
    if [ ! -f "$config_file" ]; then
        echo -e "${RED}El archivo de configuración no existe.${NC}"
        echo "PRESIONE CUALQUIER TECLA PARA CONTINUAR..."
        read -n 1
        return
    fi
    
    
    jq --arg np "$new_port" '.services[0].cfg.Listen = "0.0.0.0:" + $np' $config_file > /tmp/temp_config.json && mv /tmp/temp_config.json $config_file
    
    if [ $? -eq 0 ]; then
        echo -e "${LIGHT_BLUE_CYAN}Puerto actualizado correctamente a $new_port.${NC}"
        restart_server
    else
        echo -e "${RED}Hubo un error al actualizar el puerto.${NC}"
    fi
    echo "PRESIONE CUALQUIER TECLA PARA CONTINUAR..."
    read -n 1
}

restart_server() {
    
    if screen -list | grep -q "server"; then
        echo -e "${GREEN}Deteniendo el servidor VPN...${NC}"
        
        screen -S server -X quit

        
        sleep 2

        echo -e "${GREEN}Reiniciando el servidor VPN...${NC}"
        
        screen -dmS server /root/linklayer-vpn-server/server -cfg /root/linklayer-vpn-server/cfg/config.json
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}SERVIDOR VPN REINICIADO Y CONFIGURADO CON ÉXITO.${NC}"
        else
            echo -e "${RED}ERROR AL INTENTAR REINICIAR EL SERVIDOR VPN.${NC}"
        fi
    else
        echo -e "${RED}No hay ninguna sesión de 'screen' con el nombre 'server' ejecutándose. Verificando instalación...${NC}"
        
        if [ -f "/root/linklayer-vpn-server/server" ]; then
            echo -e "${GREEN}Instalación encontrada. Iniciando servidor VPN...${NC}"
            screen -dmS server /root/linklayer-vpn-server/server -cfg /root/linklayer-vpn-server/cfg/config.json
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}SERVIDOR VPN INICIADO CON ÉXITO.${NC}"
            else
                echo -e "${RED}ERROR AL INTENTAR INICIAR EL SERVIDOR VPN.${NC}"
            fi
        else
            echo -e "${RED}No se encontró instalación del servidor VPN. Por favor, instale el servidor primero.${NC}"
        fi
    fi
}

while true; do
    clear
    display_banner  
    
    echo -e "${RED}[${NC}${LIGHT_BLUE}01${NC}${RED}]${NC} ${LIGHT_BLUE}INSTALAR SERVIDOR VPN ${NC}"
    echo -e "${RED}[${NC}${LIGHT_BLUE}02${NC}${RED}]${NC} ${LIGHT_BLUE}REINICIAR SERVIDOR VPN ${NC}"
    echo -e "${RED}[${NC}${LIGHT_BLUE}03${NC}${RED}]${NC} ${LIGHT_BLUE}MODIFICAR PUERTO ${NC}"
    echo -e "${RED}[${NC}${LIGHT_BLUE}04${NC}${RED}]${NC} ${LIGHT_BLUE}MODIFICAR LÍMITE DE CONEXIONES POR USUARIO ${NC}"
    echo -e "${RED}[${NC}${LIGHT_BLUE}05${NC}${RED}]${NC} ${RED}DESINSTALAR SERVIDOR VPN ${NC}"
    echo -e "${RED}[${NC}${LIGHT_BLUE}06${NC}${RED}]${NC} ${LIGHT_BLUE}VERIFICAR ESTADO DEL SERVIDOR VPN ${NC}"
    echo -e "${RED}[${NC}${LIGHT_BLUE}07${NC}${RED}]${NC} ${LIGHT_BLUE}AGREGAR BANNER ${NC}"
    echo -e "${RED}[${NC}${LIGHT_BLUE}08${NC}${RED}]${NC} ${RED}ELIMINAR BANNER ${NC}"
    echo -e "${RED}[${NC}${LIGHT_BLUE}09${NC}${RED}]${NC} ${RED}SALIR ${NC}"
    echo -e "${BLUE}====================================${NC}"
    echo -e "INTRODUZCA SU ELECCIÓN: "

    read -t 15 choice
    case $choice in
        1) install_server ;;
        2) restart_server ;;
        3) modify_port ;;
        4) modify_connection_limit ;;
        5) uninstall_server ;;
        6) check_status ;;
        7) add_banner ;;
        8) remove_banner ;;
        9) exit 0 ;;
        *) echo -e "${RED}OPCIÓN INVÁLIDA. POR FAVOR, ELIJA UNA OPCIÓN VÁLIDA.${NC}" ;;
    esac
done