#!/bin/bash
telegran_bot () {
clear&&clear
cd /etc/adm-lite
msg -bar3
echo -e " INGRESA TUS CREDENCIALES DE ACCESO AL BOT"
msg -bar3
[[ -e /bin/ejecutar/TKBot ]] && read -p " TELEGRAN BOT TOKEN: " -e -i "$(cat < /bin/ejecutar/TKBot)" tokenxx || read -p " TELEGRAN BOT TOKEN: " tokenxx
[[ -e ./bottokens ]] && read -p " TELEGRAN BOT LOGUIN: " -e -i "$(cat < ./bottokens| cut -d ':' -f1)" loguin || read -p " TELEGRAN BOT LOGUIN: " loguin
[[ -e ./bottokens ]] && read -p " TELEGRAN BOT PASS: " -e -i "$(cat < ./bottokens| cut -d ':' -f2)" pass || read -p " TELEGRAN BOT PASS: " pass
read -p " IDIOMA DEL BOT [ES]: " lang
[[ -z $lang ]] && lang="es"
msg -bar3
echo -e "${loguin}:${pass}" > ./bottokens
echo -e "${tokenxx}" > /bin/ejecutar/TKBot
echo > /bin/ejecutar/demos
cat <<EOF > /etc/systemd/system/BotSSH.service
[Unit]
Description=BotGenSSH Service by @joa
After=network.target
StartLimitIntervalSec=0


[Service]
Type=simple
User=root
WorkingDirectory=/etc/adm-lite
ExecStart=$(which bash) /etc/adm-lite/ultimatebot $tokenxx $lang
Restart=always
RestartSec=3


[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload &>/dev/null
systemctl enable BotSSH.service &>/dev/null 
sudo systemctl start BotSSH.service &>/dev/null 
echo -e " INICIANDO CONFIGURACION DEL BOT, ESPERE"
sleep .5
if [[ $(systemctl is-active BotSSH) = "active" ]]; then
echo -e "${tokenxx}" > /bin/ejecutar/TKBot
print_center -verd " Bot Telegram SSH Control INICIADO !!!"    
msg -bar3   
msg -bar3
echo -e ""
echo -e " SE ENCONTRO LINEAS DE ACCESOS ANTIGUOS .."
echo -e " DESEAS REINICIARLOS??."
echo -ne "Esta SEGURO QUE DESEAS CONTINUAR ?:"
read -p " [S/N]: " -e -i n rac
[[ "$rac" = @(s|S|y|Y) ]] && {
rm -f /etc/adm-lite/liberados
echo -e " ESTADISTICAS Y ACCESOS REMOVIDOS!!!"
msg -bar3
}
echo -e " RECUERDA QUE EL PRIMER ACCESO ES SUPER ADMIN"
msg -bar3
echo -e " COLOCA TUS CREDENCIALES EN EL BOT HACI :"
echo -e "   "
echo -e "   /access $loguin $pass"
echo -e "   "
msg -bar3
else
print_center -verm " ERROR AL INICIAR EL BOT !!!"       
msg -bar3 
fi
read -p " PRESIONA ENTER PARA CONTINUAR"
[[ ! -e /bin/ejecutar/token ]] && {
clear&&clear
msg -bar3
echo -e " NO POSEES UNA CLAVE TOKEN PARA APP'S"
echo -e " ESTA CLAVE ES ESCLUSIVA PARA APPS"
read -p " CONTRASEÑA TOKEN : " _tk
echo -e "${_tk}" > /bin/ejecutar/token
msg -bar3
read -p " PRESIONA ENTER PARA CONTINUAR"
}
cd $HOME
return 0
}
mostrar_menu() {
[[ -e /bin/ejecutar/notyadd ]] && _x="\033[0;31m[\033[0;32mON\033[0;31m]" || _x="\033[1;31m[OFF]"
msg -bar3
tittle
msg -ama "         INSTALADOR BotSSH | mod @joaquinH2 "
msg -bar3
menu_func "$(msg -verd "INSTALAR BotSSH")" "$(msg -ama "Reiniciar BotSSH")" "ACTUALIZAR BINARIO" "Notificar CREADOS ${_x}" "Mostrar Creados Reseller" "$(msg -verm2 "DESINSTALAR BotSSH")"
msg -bar3
echo -ne "$(msg -verd "  [0]") $(msg -verm2 "=>>") " && msg -bra "\033[1;41m Volver "
msg -bar3
}
on_off_create(){
[[ -e /bin/ejecutar/notyadd ]] && rm -f /bin/ejecutar/notyadd || touch /bin/ejecutar/notyadd
}
instalar() {
    echo "Instalando..."
    [[ ! -e "/bin/ShellBot.sh" ]] && wget -O /bin/ShellBot.sh https://raw.githubusercontent.com/ChumoGH/ADMcgh/main/BINARIOS/ShellBot/ShellBot.sh &> /dev/null
    chmod +x /bin/ShellBot.sh
    [[ ! -d /etc/ADMcgh ]] && mkdir -p /etc/ADMcgh/bin
    [[ ! -d /etc/adm-lite ]] && mkdir -p /etc/adm-lite
    wget -q -O /etc/adm-lite/ultimatebot https://raw.githubusercontent.com/karl1999x/PandaScript/main/SCRIPTS/ultimate_botv2.sh?rlkey=kbkmuy5o1zupylvq6wyhbd8nv && chmod +x /etc/adm-lite/ultimatebot &> /dev/null
    wget -O /etc/adm-lite/trans https://raw.githubusercontent.com/ChumoGH/chumogh-gmail.com/master/trans -o /dev/null 2>&1
    chmod +x /etc/adm-lite/trans
    rm -f $(which trans) &>/dev/null
    [[ ! -e /bin/trans ]] && ln -s /etc/adm-lite/trans /bin/trans
    
    wget -q -O /etc/adm-lite/bot_codes https://raw.githubusercontent.com/karl1999x/PandaScript/main/SCRIPTS/bot_codes-ant.sh && chmod +x /etc/adm-lite/bot_codes &> /dev/null
    
    [[ $(dpkg --get-selections | grep -w "at" | head -1) ]] || apt-get install at -y &>/dev/null

    [[ ! -e /bin/UserAll ]] && {
        if [[ $(uname -m 2> /dev/null) != x86_64 ]]; then
            rm_rf="https://raw.githubusercontent.com/karl1999x/PandaScript/main/BINARIOS/UserAll-aarch64.bin"
        else
            rm_rf="https://raw.githubusercontent.com/karl1999x/PandaScript/main/BINARIOS/UserAll-x86_64.bin"
        fi
        [[ -e /bin/UserAll ]] && rm -f /bin/UserAll
        if wget -O /etc/adm-lite/UserAll "${rm_rf}" &>/dev/null; then
            chmod +x /etc/adm-lite/UserAll
            [[ ! -e /bin/UserAll ]] && ln -s /etc/adm-lite/UserAll /bin/UserAll
        fi
    }
    if systemctl list-units --type=service | grep -q BotSSH.service; then
        echo "Reiniciando BotSSH..."
        systemctl restart BotSSH.service
        echo "Reinicio completado."
    else
        echo "Servicio BotSSH no encontrado. Asegúrate de que esté instalado correctamente."
    fi

    echo "Instalación completada."
}


reiniciar() {
    echo "Reiniciando..."
    systemctl restart BotSSH
    echo "Reinicio completado."
	read -p " PRESS TO ENTER TO CONTINUED" 
}
edit_admins(){
echo -e "HOLA"
}
limit_creadores(){
touch /etc/adm-lite/registerBOT.log
}
desinstalar() {
    echo "Desinstalando..."
    systemctl daemon-reload &>/dev/null
	systemctl disable BotSSH.service &>/dev/null 
	sed -i '/ultimatebot/d' /bin/autoboot &>/dev/null 
	systemctl stop BotSSH.service &>/dev/null 
	rm -f /etc/systemd/system/BotSSH.service
	kill -9 $(ps x | grep "ultimatebot" | grep -v "grep" | awk '{print $1}') > /dev/null 2>&1
	kill $(ps x | grep "telebotusr" | grep -v "grep" | awk '{print $1}') > /dev/null 2>&1
	[[ -e ./bottokens ]] && rm ./bottokens
	msg -bar3
	echo -e " ESTAMOS DETENIENDO EL BOT"
	msg -bar3
	[[ -e /etc/adm-lite/ShellBot.sh ]] && rm /etc/adm-lite/ShellBot.sh 
	[[ -e /etc/adm-lite/ultimatebot ]] && rm /etc/adm-lite/ultimatebot 
	[[ -e /etc/adm-lite/bot_codes ]] && rm /etc/adm-lite/bot_codes
	[[ -e /etc/adm-lite/liberados ]] && rm /etc/adm-lite/liberados
    echo "Desinstalación completada."
}
while true; do
clear&&clear
    mostrar_menu
    read -p " OPCION : " opcion
    case $opcion in
        1)
			instalar
            telegran_bot
            ;;
        2)
            reiniciar
            ;;
        3)
            instalar
			reiniciar
            ;;
		4)
		on_off_create
		;;
		5)
		edit_admins
		;;
		6)
		desinstalar
		;;
		7)
            limit_creadores
            ;;
        0)
            echo "Saliendo del menú..."
            break
            ;;
        *)
            echo "Opción no válida. Inténtalo de nuevo."
            ;;
    esac
    echo ""
done
return 0
