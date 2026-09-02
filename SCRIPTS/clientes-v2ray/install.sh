#!/bin/bash
clear

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
CYAN=$(tput setaf 6)
NC=$(tput sgr0)
BG_BLACK=$(tput setab 0)
BARRA="\033[97m------------------------------------------------"

echo -e "${CYAN}${BG_BLACK}╔═════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}${BG_BLACK}║${NC}                                                 ${CYAN}${BG_BLACK}║${NC}"
echo -e "${CYAN}${BG_BLACK}║${NC}           ${CYAN}BIENVENIDO AL SCRIPT${NC}                  ${CYAN}${BG_BLACK}║${NC}"
echo -e "${CYAN}${BG_BLACK}║${NC}           ${CYAN}MENU V2RAY VERSION 3.8 ${NC}               ${CYAN}${BG_BLACK}║${NC}"
echo -e "${CYAN}${BG_BLACK}║${NC}                                                 ${CYAN}${BG_BLACK}║${NC}"
echo -e "${CYAN}${BG_BLACK}║${NC} DESARROLLADO POR:                               ${CYAN}${BG_BLACK}║${NC}"
echo -e "${CYAN}${BG_BLACK}║${NC}                     JOAQUÍN                     ${CYAN}${BG_BLACK}║${NC}"
echo -e "${CYAN}${BG_BLACK}║${NC}           TELEGRAM: ${YELLOW}t.me/joaquinH2${NC}              ${CYAN}${BG_BLACK}║${NC}"
echo -e "${CYAN}${BG_BLACK}║${NC}                                                 ${CYAN}${BG_BLACK}║${NC}"
echo -e "${CYAN}${BG_BLACK}║${NC} ${YELLOW}Recomendado para Ubuntu 20.04${NC}                   ${CYAN}${BG_BLACK}║${NC}"
echo -e "${CYAN}${BG_BLACK}║${NC}                                                 ${CYAN}${BG_BLACK}║${NC}"
echo -e "${CYAN}${BG_BLACK}╚═════════════════════════════════════════════════╝${NC}"

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

install_package() {
    local package=$1
    echo -ne "\033[97m  # apt-get install ${package}............... "
    if [[ $(dpkg --get-selections | grep -w "${package}" | head -1) ]]; then
        echo -e "\033[92mINSTALADO"
    else
        sudo apt-get install ${package} -y &>/dev/null
        if [[ $(dpkg --get-selections | grep -w "${package}" | head -1) ]]; then
            echo -e "\033[92mINSTALADO"
        else
            echo -e "\033[91mFALLO DE INSTALACION"
        fi
    fi
}

install_ini() {
    sudo apt-get install software-properties-common -y
    sudo add-apt-repository universe
    sudo apt update -y
    sudo apt upgrade -y
    install_package speedtest-cli

    clear

    echo -e "$BARRA"
    echo -e "\033[92m        -- INSTALANDO PAQUETES NECESARIOS -- "
    echo -e "$BARRA"

    install_package jq
    install_package python
    install_package python3
    install_package python3-pip
    install_package curl

    echo -e "$BARRA"
    echo -e "\033[92m La instalacion de paquetes necesarios ha finalizado"
    echo -e "$BARRA"
    echo -e "\033[97m Si la instalacion de paquetes tiene fallas"
    echo -ne "\033[97m Puede intentar de nuevo [s/n]: "
    read inst
    [[ $inst = @(s|S|y|Y) ]] && install_ini
}

install_ini
clear
print_message_with_border "    script by joaquin" 
print_message_with_border "Acceder al menú con v2" 
sleep 10

if [ -f /usr/bin/v2.sh ]; then
    sudo rm /usr/bin/v2.sh
fi

unalias v2 > /dev/null 2>&1

if grep -q "alias v2=" ~/.bashrc; then
    sed -i '/alias v2=/d' ~/.bashrc
fi

wget --no-cache -O /usr/bin/v2.sh https://raw.githubusercontent.com/vpsnet360/clientes-v2ray/main/v2.sh > /dev/null 2>&1
if [ $? -eq 0 ]; then
    sudo chmod +x /usr/bin/v2.sh
    echo "alias v2='/usr/bin/v2.sh'" | sudo tee -a ~/.bashrc > /dev/null
    bash -l
else
    echo "Error: No se pudo descargar el script v2.sh"
fi
