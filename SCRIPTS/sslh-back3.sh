#!/bin/bash

[[ -e /bin/ejecutar/msg ]] && source /bin/ejecutar/msg

#DIRECTORIOS mkdir-touch

dir_base () {
[[ -e $dir_ports ]] || {
	touch $dir_ports
	chmod 777 $dir_ports
}
[[ -d $dir_bases/ports-sslh ]] || {
	mkdir $dir_bases/ports-sslh
}
[[ -e $DIR_INFO ]] || {
	     echo > $DIR_INFO
		 chmod 777 $DIR_INFO
}
}
back_menu(){
     msg -bar3
     read -p "$(echo -e "${morado}Enter Para Continuar${cierre}")" enter
     menu_sslh
}
t_port () {
t_node=$(lsof -V -i tcp -P -n | grep -v "ESTABLISHED" |grep -v "COMMAND" | grep "LISTEN")
while read port_t; do
test1=$(echo $port_t | awk '{print $1}') && test2=$(echo $port_t | awk '{print $9}' | awk -F ":" '{print $2}')
[[ "$(echo -e $nodet|grep "$test1 $test2")" ]] || nodet+="$test1 $test2\n"
done <<< "$t_node"
i=1
echo -e "$nodet"
}
#REGLAS SSLH
reglas_sslh () {
local _ps=$(ps x)
local _netCAT="$(netstat -tunlp)"
local _config="--ssh 127.0.0.1:$(echo -e "${_netCAT}" | awk '/ssh/ && /0.0.0.0:/ {print substr($4, 9)}') "
[[ ! -z $(echo -e "${_ps}" | grep stunnel) ]] && _config+="--ssl 127.0.0.1:$(echo -e "${_netCAT}" | awk '/stunnel*/ && /0.0.0.0:/ {print substr($4, 9)}' | head -1) "
[[ ! -z $(echo -e "${_ps}" | grep PDirect) ]] && _config+="--http 127.0.0.1:$(echo -e "${_netCAT}" | awk '/python/ && /0.0.0.0:/ {print substr($4, 9)}' | head -1) " || {
[[ -e "/etc/default/dropbear" ]] && _config+="--http 127.0.0.1:$(echo -e "${_netCAT}" | awk '/dropbear/ && /0.0.0.0:/ {print substr($4, 9)}' | head -1) "
}
[[ ! -z $(echo -e "${_ps}" | grep openvpn) ]] && _config+="--openvpn 127.0.0.1:$(echo -e "${_netCAT}" | awk '/openvpn/ && /0.0.0.0:/ {print substr($4, 9)}' | head -1) "
#[[ ! -z $(echo -e "${_ps}" | grep openvpn) ]] && _config+="--openvpn 127.0.0.1:$(echo -e "${_netCAT}" | awk '/openvpn/ && /0.0.0.0:/ {print substr($4, 9)}' | head -1) " || pthttp=''
DEBIAN_FRONTEND=noninteractive apt-get -y install sslh 1> /dev/null 2> /dev/null
echo -e " Ingresa Un puerto Libre, Para activar SSLH\n"
read -p " DIJITA EL PUERTO PRINCIPAL SSLH : " psshl
[[ -z ${psshl} ]] && return 1
#echo -e "#Modo autónomo\n\nRUN=yes\nDAEMON=/usr/sbin/sslh\n\nDAEMON_OPTS='--user sslh --listen 0.0.0.0:$psshl --ssh 127.0.0.1:22 ${_config} --pidfile /var/run/sslh/sslh.pid'" > /etc/default/sslh
cat <<EOF > /etc/default/sslh
#Modo autónomo
RUN=yes
DAEMON=/usr/sbin/sslh
DAEMON_OPTS="--user sslh --listen 0.0.0.0:${psshl} ${_config} --pidfile /var/run/sslh/sslh.pid"
EOF
systemctl daemon-reload &>/dev/null
_sleepColor '' 'systemctl enable sslh'
systemctl daemon-reload &>/dev/null
service sslh start &>/dev/null
systemctl restart sslh &>/dev/null
echo -ne " ${azul} INICIANDO SERVICIO MULTIPLEXOR SSLH${cierre}"
## echo -e "#Modo autónomo\n\nRUN=yes\n\nDAEMON=/usr/sbin/sslh\n\nDAEMON_OPTS='--user sslh --listen 0.0.0.0:3128 --ssh  0.0.0.0:22 --ssl  0.0.0.0:$ptssl --http  0.0.0.0:80 --openvpn 127.0.0.1:$ptvpn --pidfile /var/run/sslh/sslh.pid'" >/etc/default/sslh 
[[ $(ps aux | grep -v grep | grep sslh) ]] && echo -e " ${verde} EXITOSO ${cierre}" || echo -e "${rojo} FALLIDO ${cierre}"
}

cabe(){
    msg -bar3
    echo -e "${blanco}❗️ Protocolos reconocidos ${azul}ssl, https, openvpn, ${cierre}"
    echo -e "${blanco}❗️ ${azul}OpenConnect, http, sslh; ssh,${cierre} ${blanco}si su servicio es  ${cierre}"
    echo -e "${blanco}❗️ Diferente porfavor en nombre establezca ${guinda}anyprot ${cierre}"
    msg -bar3
    echo -e "${blanco}#     ${amarillo} SCRIPT CREADO POR @ChumoGH      ${blanco}#${cierre}"
    msg -bar3
}

capturar_servicio(){
    echo -e "${azul}Escriba el nombre de servicio que de desea agregar${cierre}"
    msg -bar3
    read -p "$(echo -e "${amarillo}ESCRIBE: ${cierre}")" -e -i anyprot service
}

capturar_puerto(){
    msg -bar3
    echo -e "${blanco}DIGITA EL NUEVO PUERTO A AÑADIR ${cierre}"
    msg -bar3
    read -p "$(echo -e "${amarillo}INGRESA: ${cierre}")" puerto_i
    if [[ $(t_port| grep "$puerto_i") ]]; then
    echo
    else
    msg -bar3
    echo -e "${guinda}⚠️ EL Puerto ${blanco} ${puerto_i} ${guinda}No existe ${cierre}"
    echo -e "${guinda}⚠️ Utilice puertos existentes ${cierre}"
    msg -bar3
    capturar_puerto
    fi
    if [ -f $dir_puertos/$puerto_i ]; then 
        msg -bar3
                echo -e "${guinda}⚠️ EL Puerto ${blanco} ${puerto_i} ${guinda}Ya se encuentra en USO ${cierre}"
                echo -e "${guinda}⚠️ Intente con otro puerto ${cierre}"
        capturar_puerto
    else
        msg -bar3
		local NEW_OPTIONS=" --anyport 127.0.0.1:${puerto_i} "
		sed -E -i "s/(--pidfile [^ ]+)/$NEW_OPTIONS \1/" "$CONFIG_FILE"
        echo -e "${blanco}REGISTRO EXITOSO !! ${cierre}"
        msg -bar3
		return 0
    fi
    touch $dir_puertos/$puerto_i
}

instalar_sslh(){
    #dir_base
    reglas_sslh
    if [ $? -eq 0 ]; then
    msg -bar3
    echo -e "${blanco}ACTUALMETE ESTA HABILITADO EL SERVICIO OPENSSH ${cierre}"
    echo -e "${blanco}AGREGUE MAS SERVICIO EN EL MENU ${melon}SSLH - MULTIPLEXOR ${cierre}"
    service sslh start
    msg -bar3
    else
    msg -bar3
    echo -e "${rojo}⚠️ ERROR INESPERADO, POR FAVOR REVISE SUS SERVICIOS${cierre}"
    echo -e "${rojo}⚠️ Y VUELVA A INTERNTARLO ${cierre}"
    msg -bar3
    service sslh start
    fi
    back_menu
}

agregar_servicos(){
    msg -bar3
    capturar_servicio
    capturar_puerto
    if [ $? -eq 0 ]; then
    echo -e "${blanco}SERVICIO  ${verde}${service_f}${cierre} ${blanco}AGREGADO CON EXITO ${cierre}"
    echo -e "${blanco}AGREGUE MAS SERVICIO EN EL MENU ${melon}SSLH - MULTIPLEXOR ${cierre}"
    service sslh start
    else
    echo -e "${rojo}⚠️ ERROR INESPERADO, POR FAVOR REVISE SUS SERVICIOS${cierre}"
    echo -e "${rojo}⚠️ Y VUELVA A INTERNTARLO ${cierre}"
    fi
    echo -e "${blanco}${service}          ${guinda}${puerto_i}${cierre}" >> $DIR_INFO
    echo -e "${puerto_i}" >> $dir_ports
    service sslh restart
    back_menu
}

eliminar_servicio(){
    unset service
    unset puerto_i
    msg -bar3
    cat $DIR_INFO | awk -v OFS='\t\t' '{print $1,$2}'
    msg -bar3
    echo -e "${azul}Escriba el nombre de servicio que de desea Eliminar${cierre}"
    msg -bar3
    read -p "$(echo -e "${amarillo}ingrese: ${cierre}")" -e -i anyprot service
    echo -e "${azul}Escriba el numero de puerto que de desea Eliminar${cierre}"
    msg -bar3
    read -p "$(echo -e "${amarillo}ingrese: ${cierre}")" puerto_i
    rm_service="--$service 127.0.0.1:$puerto_i"
    sed -i "s;$rm_service;proto;g" $CONFIG_FILE
    sed -i 's/proto//g' $CONFIG_FILE
    grep -Ev "$puerto_i" $DIR_INFO > temp
    mv -f temp $DIR_INFO
    service sslh restart
    rm -rf temp
    rm -rf $dir_puertos/$puerto_i
    back_menu
}

informacion_puertos(){
    echo -e "${verde}SERVICIO   ${blanco}/    ${verde}PUERTO${cierre}"
    msg -bar3
    cat $DIR_INFO | awk -v OFS='\t\t' '{print $1,$2}'
    msg -bar3
    back_menu
}

desinstalar(){
    service sslh stop
    rm -rf $DIR_INFO
    rm -rf $dir_ports
    rm -rf $CONFIG_FILE
    rm -rf $dir_base
    rm -rf $dir_service
    rm -rf $arch_serv
    rm -rf $dir_puertos
    apt purge sslh -y 
}

menu_sslh(){
sslh_onoff=`if netstat -tunlp |grep sslh 1> /dev/null 2> /dev/null; then
echo -e "\033[1;32m🟢"
else
echo -e "\033[1;31m🔴"
fi`
clear
cabe
echo -e " ${morado} ESTADO DEL SERVICIO: ${blanco}>${cierre} ${guinda}SSLH: $sslh_onoff  ${cierre}"
msg -bar3
echo -e " \033[0;35m [\033[0;36m1\033[0;35m]\033[0;31m ${flech} ${cor[3]}INSTALAR SERVICIO "
echo -e " \033[0;35m [\033[0;36m2\033[0;35m]\033[0;31m ${flech} ${cor[3]}AGREGAR PUERTOS"
echo -e " \033[0;35m [\033[0;36m3\033[0;35m]\033[0;31m ${flech} ${cor[3]}ELIMINAR SERVICIOS/PUERTOS"
echo -e " \033[0;35m [\033[0;36m4\033[0;35m]\033[0;31m ${flech} ${cor[3]}INFORMACION DE PUERTOS"
echo -e " \033[0;35m [\033[0;36m5\033[0;35m]\033[0;31m ${flech} ${cor[3]}DESINSTALAR SSLH MULTIPLEXOR"
msg -bar3
echo -e " \033[0;35m [\033[0;36m0\033[0;35m]\033[0;31m ${flech} $(msg -bra "\033[1;41m[ REGRESAR ]\e[0m")"
msg -bar3
selection=$(selection_fun 5)
case ${selection} in
	1)instalar_sslh ;;
	2)agregar_servicos ;;
    3)eliminar_servicio ;;
    4)informacion_puertos ;;
    5)desinstalar ;;
	0)return;;
	*)
	echo -e "${rojo} Porfavor seleccione del [0-5]${cierre}"
	;;
esac
}
menu_sslh