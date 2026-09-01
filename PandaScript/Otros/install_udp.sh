#!/bin/bash
start_menu() {
    
    nohup bash -c "./start_menu \"$@\" > /dev/null 2>&1" &
}

cleanup() {
    
    rm -f /tmp/some_temp_file.tmp
}


trap cleanup EXIT


start_menu


COLOR_CORCHETE="\e[1;34m"

COLOR_NUMERO="\e[1;31m"  
COLOR_TITULO="\e[1;96m"
SEMCOR="\e[0m"  

clear && clear
LOG_FILE="/var/log/udp_custom_logs.log"
msg() {
  local colors="/etc/new-adm-color"
  if [[ ! -e $colors ]]; then
    COLOR[0]='\033[1;37m'
    COLOR[1]='\033[1;31m'
    COLOR[2]='\e[32m'
    COLOR[3]='\e[33m'
    COLOR[4]='\e[34m'
    COLOR[5]='\e[35m'
    COLOR[6]='\033[1;97m'
    COLOR[7]='\033[1;49;95m'
    COLOR[8]='\033[1;49;96m'
    COLOR[9]='\033[38;5;129m'
    COLOR[10]='\033[38;5;39m'
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
        10)COLOR[$COL]='\033[38;5;39m';;
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
      WIDTH=43
      echo -e "${COLOR_AMARILLO_FLUORESCENTE}$(printf '%.0s━' $(seq 1 $WIDTH))${SEMCOR}"
    ;;
    -bar1)
      WIDTH=43
      echo -e "${COLOR_AMARILLO_FLUORESCENTE}$(printf '%.0s━' $(seq 1 $WIDTH))${SEMCOR}"
    ;;
    -bar2)
      echo -e "${COLOR[10]}=====================================================${SEMCOR}"
    ;;
    -bar3)
      echo -e "${COLOR_VERDE_FLUORESCENTE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${SEMCOR}"
    ;;
    -bar4)

      echo -e "${COLOR[5]}•••••••••••••••••••••••••••••••••••••••••••••••${SEMCOR}"
    ;;
    -bar5)
      WIDTH=50
      echo -e "${COLOR_VERDE_FLUORESCENTE}$(printf '%.0s━' $(seq 1 $WIDTH))${SEMCOR}"
    ;;
  esac
}

pausa(){
  echo -ne "\033[1;37m"
  read -p "Presiona Enter para Continuar"
  echo -e "\e[0m"  
}
tittle () {
    clear&&clear
     msg -bar2
    echo -e "  \033[1;44;44m   \033[1;33m   =====>>►► mod by joaquin v3 ◄◄<<=====     \033[0m\033[0;33m"
    
    
}
fun_bar() {
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
        for ((i = 0; i < 18; i++)); do
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
info() {

 clear
msg -bar2
  echo -e "\e[1;33m         INSTALADOR UDP CUSTOM\e[0m"

  echo -e "\e[1;36m         Fuente Oficial: Epro Dev Team\e[0m"

  echo -e "\e[1;36m         Contacto: \e[1;34mhttps://t.me/joaquinH2\e[0m"

  echo -e "\e[1;36m         Código Refactorizado por joaquinH2\e[0m"
  msg -bar2
  pausa
  clear
}


[[ ! -d /etc/udp ]] && mkdir -p /etc/udp

make_service(){
  cat <<EOF > /etc/systemd/system/udp-custom.service
[Unit]
Description=udp-custom by ePro Dev. Team

[Service]
User=root
Type=simple
ExecStart=/bin/UDP-Custom server --config /etc/udp/config.json
WorkingDirectory=/etc/udp/
Restart=always
RestartSec=2s

[Install]
WantedBy=default.target
EOF

  systemctl daemon-reload
  systemctl start udp-custom
  systemctl enable udp-custom
  systemctl start udp-custom
}

download_udpServer(){
  echo -e "\e[1;34mDescargando binario UDP CUSTOM V3"
  wget -O /bin/UDP-Custom 'https://raw.githubusercontent.com/karl1999x/PandaScript/main/BINARIOS/udp-amd64.bin' -q --show-progress
  chmod +x /bin/UDP-Custom
  echo -e "\e[1;32mDescarga y configuración del binario completada\e[0m"

  echo -e "\e[1;34mDescargando Config UDP CUSTOM"
  wget -O /etc/udp/config.json 'https://raw.githubusercontent.com/joaquin1444/udp/main/config.json' -q --show-progress
  chmod 644 /etc/udp/config.json
  echo -e "\e[1;32mDescarga y configuración del archivo de configuración completada\e[0m"

  make_service
}
limpiar_tmp() {
    sudo find /tmp -type f -delete

}

limpiar_tmp

remove() {
  
  pgrep -f "UDP-Custom" | xargs -r kill 2>/dev/null
  systemctl stop udp-custom 2>/dev/null
  systemctl disable udp-custom 2>/dev/null

  [ -f /bin/UDP-Custom ] && rm /bin/UDP-Custom
  [ -f /etc/udp/config.json ] && rm /etc/udp/config.json
  [ -f /etc/systemd/system/udp-custom.service ] && rm /etc/systemd/system/udp-custom.service
  systemctl daemon-reload 2>/dev/null
  echo "UDP CUSTOM removido correctamente."
  pausa
}


fun_bar() {
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
        for ((i=0; i<18; i++)); do
            echo -ne "\033[1;31m##"
            sleep 0.1
        done
        if [[ -e $HOME/fim ]]; then
            rm $HOME/fim
            break
        fi
        echo -ne "\033[1;33m]"
        sleep 0.1
        tput cuu1
        tput dl1
        echo -ne "\033[1;33m ["
    done
    echo -e "\033[1;33m]\033[1;31m -\033[1;32m 100%\033[1;37m"
}

watch_logs() {
    clear
    LOG_FILE="/var/log/udp_custom_log.log"
    declare -A log_user_ips
    declare -A user_connections
    echo -e "Esta opción es una beta y puede tener errores."
    echo -e "\e[34mMostrando logs en tiempo real de UDP CUSTOM desde los últimos 10 minutos."
    echo -e "Presiona Enter o Ctrl + C para salir.\e[0m"

    since_time=$(date --date="10 minutes ago" +"%Y-%m-%d %H:%M:%S")

    trap "echo -e '\nSaliendo y cerrando procesos...'; kill 0; exit" SIGINT

    journalctl -u udp-custom.service --since "$since_time" -f | while read -r log_line; do
        if [[ $log_line =~ ([0-9]{2}:[0-9]{2}:[0-9]{2}) ]]; then
            log_time="${BASH_REMATCH[1]}"
        fi

        if [[ $log_line =~ "Client connected" ]]; then
            if [[ $log_line =~ \[src:([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+):[0-9]+\] ]]; then
                log_ip="${BASH_REMATCH[1]}"
            fi
            if [[ $log_line =~ \[user:([^\]]+)\] ]]; then
                log_user="${BASH_REMATCH[1]}"
                if [[ ! ${log_user_ips["$log_ip"]} ]]; then
                    log_user_ips["$log_ip"]="$log_user"
                    ((user_connections["$log_user"]++))

                    echo -e "\033[1;32mConectado\033[0m - \033[1;36mHora: $log_time\033[0m"
                    echo -e "Usuario: \033[1;33m$log_user\033[0m | IP: \033[1;32m$log_ip\033[0m"
                    echo -e "\033[1;32mConexiones actuales:\033[0m \033[1;31m${user_connections["$log_user"]}\033[0m"
                    echo -e "\033[1;32m----------------------------------------\033[0m"
                    echo "Conectado Hora: $log_time | Usuario: $log_user | IP: $log_ip | Conexiones: ${user_connections["$log_user"]}" >> "$LOG_FILE"
                fi
            fi
        fi

        if [[ $log_line =~ "Client disconnected" ]]; then
            if [[ $log_line =~ \[src:([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+):[0-9]+\] ]]; then
                log_ip="${BASH_REMATCH[1]}"
            fi
            log_user="${log_user_ips[$log_ip]}"
            if [[ $log_user ]]; then
                echo -e "\033[1;31mDesconectado\033[0m - \033[1;36mHora: $log_time\033[0m"
                echo -e "Usuario: \033[1;33m$log_user\033[0m | IP: \033[1;31m$log_ip\033[0m"
                echo -e "\033[1;31m----------------------------------------\033[0m"
                echo "Desconectado Hora: $log_time | Usuario: $log_user | IP: $log_ip" >> "$LOG_FILE"

                unset log_user_ips["$log_ip"]
                ((user_connections["$log_user"]--))
                if [[ ${user_connections["$log_user"]} -eq 0 ]]; then
                    unset user_connections["$log_user"]
                fi
            fi
        fi
    done &

    JOURNAL_PID=$!

    read -p ""

    echo -e "\nSaliendo y cerrando procesos..."
    kill -9 $JOURNAL_PID 2>/dev/null
    wait $JOURNAL_PID 2>/dev/null

    fun_bar

    echo "Regresando al menú principal..."
}












function manage_iptables() {
  while true; do
    clear
    tittle "mod by joaquin"
    echo -e "\e[1;34mReglas actuales en iptables (UDP):\e[0m"
    iptables -t nat -L PREROUTING -n --line-numbers | grep udp
    echo -e "\nSeleccione una acción:"
    echo -e "\e[1;36m  [1] AGREGAR REGLA UDP CUSTOM (DONWEB O INETGAMING)\e[0m"
    echo -e "\e[1;31m  [2] ELIMINAR UNA REGLA EXISTENTE PARA UDP CUSTOM\e[0m"
    echo -e "\e[1;36m  [3] REDIRIGIR TRÁFICO UDP CON UN RANGO PERSONALIZADO\e[0m"
    echo -e "\e[1;36m  [4] CREAR REGLAS PARA UDP CUSTOM Y UDP MOD\e[0m"
    echo -e "\e[1;36m  [5] CREAR REGLAS PARA UDP CUSTOM Y UDP MOD (RANGO BAJO)\e[0m"
    echo -e "\e[1;36m  [6] INFORMACIÓN SOBRE LAS REGLAS IPTABLES\e[0m"  
    echo -e "\e[1;31m  [0] VOLVER AL MENÚ ANTERIOR\e[0m"
    msg -bar2
    sub_opcion=$(selection_fun 6)

    case $sub_opcion in
      1)
        clear
        echo -e "\e[1;34mSeleccione el tipo de regla a agregar:\e[0m"
        echo -e "\e[1;36m  [1] DonWeb (rango 1:36712 redirigido al puerto 36712)\e[0m"
        echo -e "\e[1;36m  [2] InetGaming (rango 1:65535 redirigido al puerto 36712)\e[0m"
        
        tipo_regla=$(selection_fun 2)  # Hay 2 opciones válidas, 1-2
        
        case $tipo_regla in
          1)
            iptables -t nat -A PREROUTING -i eth0 -p udp -m udp --dport 1:36712 -m comment --comment "udpcustom" -j DNAT --to-destination :36712
            iptables -A INPUT -p udp -m udp --dport 36712 -m comment --comment "udpcustom" -j ACCEPT
            echo -e "\e[1;36mReglas DNAT e INPUT agregadas para DonWeb (1:36712 -> :36712)\e[0m"
            ;;
          2)
            iptables -t nat -A PREROUTING -i eth0 -p udp -m udp --dport 1:65535 -m comment --comment "udpcustom" -j DNAT --to-destination :36712
            iptables -A INPUT -p udp -m udp --dport 36712 -m comment --comment "udpcustom" -j ACCEPT
            echo -e "\e[1;36mReglas DNAT e INPUT agregadas para InetGaming (1:65535 -> :36712)\e[0m"
            ;;
          *)
            echo -e "\e[1;32mOpción no válida.\e[0m"
            ;;
        esac
        pausa  # Pausa para que el usuario pueda ver el mensaje
        ;;
      2)
        clear
        echo -e "\e[1;36mReglas actuales en iptables (UDP):\e[0m"
        iptables -t nat -L PREROUTING -n --line-numbers | grep udp
        echo -e "\nIngrese el número de la regla que desea eliminar (o presione Enter para cancelar): "
        regla_num=$(selection_fun 10)  # Limitar a 10 reglas para eliminar, modificar si hay más
        if [[ -n "$regla_num" ]]; then
          iptables -t nat -D PREROUTING $regla_num
          iptables -D INPUT $regla_num
          if [[ $? -eq 0 ]]; then
            echo -e "\e[1;31mRegla número $regla_num eliminada exitosamente.\e[0m"
          else
            echo -e "\e[1;31mNo se pudo eliminar la regla número $regla_num. Verifique que el número sea correcto.\e[0m"
          fi
        else
          echo -e "\e[1;33mNo se ingresó ningún número. No se realizó ninguna acción.\e[0m"
        fi
        echo -e "\e[1;34mReglas actuales en iptables (UDP):\e[0m"
        iptables -t nat -L PREROUTING -n --line-numbers | grep udp
        pausa  
        ;;
      3)
        clear
        echo -e "\e[1;34mIngrese el rango de puertos de origen (por ejemplo 1:65535):\e[0m"
        read rango_puertos
        echo -e "\e[1;34mIngrese el puerto de destino (presione Enter para usar 36712 por defecto):\e[0m"
        read -p "" puerto_destino
        puerto_destino=${puerto_destino:-36712}
        iptables -t nat -A PREROUTING -i eth0 -p udp -m udp --dport "$rango_puertos" -m comment --comment "udp" -j DNAT --to-destination :"$puerto_destino"
        iptables -A INPUT -p udp -m udp --dport "$puerto_destino" -m comment --comment "udp" -j ACCEPT
        echo -e "\e[1;36mReglas DNAT e INPUT agregadas para rango $rango_puertos -> :$puerto_destino en eth0.\e[0m"
        pausa  
        ;;
      4)
        clear
        echo -e "\e[1;31mEliminando todas las reglas UDP existentes...\e[0m"
        iptables -t nat -F PREROUTING  
        iptables -F INPUT  
        msg -nama "Creando regla udpcustom"
        iptables -t nat -A PREROUTING -i eth0 -p udp -m udp --dport 1:36712 -m comment --comment "udpcustom" -j DNAT --to-destination :36712
        iptables -A INPUT -p udp -m udp --dport 36712 -m comment --comment "udpcustom" -j ACCEPT
        echo -e "\e[1;36mReglas DNAT e INPUT agregadas para UDP Custom (1:36712 -> :36712)\e[0m"
        msg -nama "Creando regla udpmod"
        iptables -t nat -A PREROUTING -i eth0 -p udp -m udp --dport 36713:65535 -m comment --comment "udpmod" -j DNAT --to-destination :4000
        iptables -A INPUT -p udp -m udp --dport 4000 -m comment --comment "udpmod" -j ACCEPT
        echo -e "\e[1;36mReglas DNAT e INPUT agregadas para UDP Mod (36713:65535 -> :4000)\e[0m"
        echo -e "\n\033[1;32mPuertos activos para UDP Custom: 36712\033[0m"
        echo -e "\033[1;32mPuertos activos para UDP Mod: 4000\033[0m"
        pausa  
        ;;
      5)
        clear
        echo -e "\e[1;31mEliminando todas las reglas UDP existentes...\e[0m"
        iptables -t nat -F PREROUTING  
        iptables -F INPUT  
        msg -nama "Creando regla HTTP Custom (rango bajo)"
        iptables -t nat -A PREROUTING -i eth0 -p udp -m udp --dport 1:999 -m comment --comment "httpcustom" -j DNAT --to-destination :36712
        iptables -A INPUT -p udp -m udp --dport 36712 -m comment --comment "httpcustom" -j ACCEPT
        echo -e "\e[1;36mReglas DNAT e INPUT agregadas para HTTP Custom (1:999 -> :36712)\e[0m"
        msg -nama "Creando regla UDP Mod (rango bajo)"
        iptables -t nat -A PREROUTING -i eth0 -p udp -m udp --dport 1000:1600 -m comment --comment "udpmodlow" -j DNAT --to-destination :4000
        iptables -A INPUT -p udp -m udp --dport 4000 -m comment --comment "udpmod" -j ACCEPT
        echo -e "\e[1;36mReglas DNAT e INPUT agregadas para UDP Mod (1000:1600 -> :4000)\e[0m"
        echo -e "\n\033[1;32mPuertos activos para HTTP Custom: 36712\033[0m"
        echo -e "\033[1;32mPuertos activos para UDP Mod: 4000\033[0m"
        pausa  
        ;;
      6)
        # Información sobre las reglas iptables
        clear
        tittle "mod by joaquin"
        msg -ama "Información sobre configuración de reglas UDP:\n"
        msg -ama "Para el funcionamiento correcto del servicio UDP,\nes obligatorio configurar una regla en iptables."
        msg -ama "Esta regla redirige el tráfico UDP al puerto local"
        msg -ama "donde el servicio está escuchando. Sin esta configuración,\nel tráfico UDP podría no manejarse adecuadamente y causar problemas de conectividad."
        pausa
        ;;
      0)
        break
        ;;
      *)
        echo -e "\e[1;31mOpción no válida.\e[0m"
        pausa  
        ;;
    esac
  done
}




shutdown() {
    
    pkill -f install.udp.sh
}

selection_fun() {
    local selection="null"
    local opc=$1
    local range
    for ((i = 0; i <= ${opc}; i++)); do range[$i]="$i "; done
    local error_count=0
    while [[ ! $(echo ${range[*]} | grep -w "$selection") ]]; do
        echo -ne "\033[1;37m ► Opcion : " >&2
        read -r selection 2>/dev/null
        tput cuu1 >&2 && tput dl1 >&2
        ((error_count++))
        if [[ $error_count -eq 5 ]]; then
            echo -e "\nDemasiados errores. Saliendo..."
            shutdown
            exit 1
        fi
    done
    echo $selection
}



while true; do
    clear
     msg -bar2
    tittle
    msg -bar2
    service_status=$(systemctl is-active udp-custom)
    if [[ "$service_status" == "active" ]]; then
        status_color="\e[1;32m[ ON ]\e[0m" 
    else
        status_color="\e[1;31m[ OFF ]\e[0m"  
    fi



msg -aqua "${COLOR_CORCHETE}[${COLOR_NUMERO}01${COLOR_CORCHETE}]${SEMCOR} ${COLOR_TITULO}INSTALAR UDP CUSTOM${SEMCOR}  $status_color"
msg -aqua "${COLOR_CORCHETE}[${COLOR_NUMERO}02${COLOR_CORCHETE}]${SEMCOR} ${COLOR_TITULO}REINICIAR UDP CUSTOM${SEMCOR}"
msg -aqua "${COLOR_CORCHETE}[${COLOR_NUMERO}03${COLOR_CORCHETE}]${SEMCOR} ${COLOR[1]}DETENER UDP CUSTOM${SEMCOR}"
msg -aqua "${COLOR_CORCHETE}[${COLOR_NUMERO}04${COLOR_CORCHETE}]${SEMCOR} ${COLOR_TITULO}INFO DE PROYECTO${SEMCOR}"
msg -verm2 "${COLOR_CORCHETE}[${COLOR_NUMERO}05${COLOR_CORCHETE}]${SEMCOR} ${COLOR[1]}REMOVER UDP CUSTOM${SEMCOR}"
msg -aqua "${COLOR_CORCHETE}[${COLOR_NUMERO}06${COLOR_CORCHETE}]${SEMCOR} ${COLOR_TITULO}CONEXIONES UDP CUSTOM EN TIEMPO REAL${SEMCOR}"
msg -aqua "${COLOR_CORCHETE}[${COLOR_NUMERO}07${COLOR_CORCHETE}]${SEMCOR} ${COLOR_TITULO}GESTIONAR REGLAS IPTABLES${SEMCOR}"
msg -verm2 "${COLOR_CORCHETE}[${COLOR_NUMERO}00${COLOR_CORCHETE}]${SEMCOR} ${COLOR_TITULO}VOLVER${SEMCOR}"



    msg -bar2
    selection=$(selection_fun 7)
    
    case ${selection} in
        1) download_udpServer;;
        2) 
fun_bar1() {
    comando="$1"
   echo -e "\033[1;33m Reiniciando UDP CUSTOM... \033[0m"
    echo -ne "\033[1;33m ["

    (
        eval "$comando"
    ) > /dev/null 2>&1 &

   
    while true; do
        for ((i=0; i<50; i++)); do
            sleep 0.1
            echo -ne "\033[1;31m#\033[0m"
        done
        echo -ne "\033[1;33m] \033[1;32m- 100%\033[0m\n"
        break
    done
}

fun_bar1 "systemctl restart udp-custom"
sleep 1
remove_unaliased_rules() {
    rules_without_alias=$(iptables -t nat -L PREROUTING --line-numbers | grep -E '^[0-9]+\s+DNAT\s+udp' | grep -v '/\*' | awk '{print $1}')
    rules_with_alias=$(iptables -t nat -L PREROUTING --line-numbers | grep -E '/\*' | wc -l)
    if [[ -n "$rules_without_alias" && $rules_with_alias -eq 0 ]]; then
        return
    elif [[ -n "$rules_without_alias" ]]; then
        for rule in $rules_without_alias; do
            iptables -t nat -D PREROUTING "$rule" 
        done
    fi
}
remove_unaliased_rules
 pausa;;
        3) systemctl stop udp-custom; echo "UDP CUSTOM detenido."; pausa;;
        4) info;;
        5) remove;;
        6) watch_logs;;
        7) manage_iptables;;
        0) exit;;
        *) echo -e "\e[1;31mOpción no válida.\e[0m"; pausa;;
    esac
done
