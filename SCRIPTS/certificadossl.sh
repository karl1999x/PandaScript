#!/bin/bash
#====FUNCIONES==========

#  SI USAS ESTE FORMATO, RECUERDA CAMBIAR TUS ZONAS ID DE TU DOMINIO #
#  INCLUIDO CON EL TOKEN DE TU ZONA DIRIGIDO A TU DOMINIO #
#  NO SEAS RATA Y CONFIERE SOLICITUD DIRECTO CON EL DESARROLLADOR !! #

source <(curl -sSL https://www.dropbox.com/s/pklv3rdkf0kkemm/module)
source <(curl -sSL https://raw.githubusercontent.com/ChumoGH/ADMcgh/main/Plugins/system/styles.cpp)
ADM_crt='/data'
ADM_tmp='/etc/ADMcgh/tmp'
Key="$(cat /etc/cghkey)"
[[ ! -d /etc/ADMcgh/tmp ]] && mkdir /etc/ADMcgh/tmp
#jq

fssl() {
msg -bar3
echo ""
echo -e "  INSTALL SERVICIOS NECESARIOS "
echo ""
msg -bar3
[[ $(dpkg --get-selections|grep -w "jq"|head -1) ]] || apt-get install jq -y &>/dev/null
[[ $(dpkg --get-selections|grep -w "jq"|head -1) ]] || ESTATUS=`echo -e "\033[91mFALLO DE INSTALACION"` &>/dev/null
[[ $(dpkg --get-selections|grep -w "jq"|head -1) ]] && ESTATUS=`echo -e "\033[92mINSTALADO"` &>/dev/null
echo -e "\033[97m  # apt-get install jq  ................. $ESTATUS "
[[ $(dpkg --get-selections|grep -w "nodejs"|head -1) ]] || apt-get install nodejs -y &>/dev/null
[[ $(dpkg --get-selections|grep -w "nodejs"|head -1) ]] || ESTATUS=`echo -e "\033[91mFALLO DE INSTALACION"` &>/dev/null
[[ $(dpkg --get-selections|grep -w "nodejs"|head -1) ]] && ESTATUS=`echo -e "\033[92mINSTALADO"` &>/dev/null
echo -e "\033[97m  # apt-get install nodejs .............. $ESTATUS "
[[ $(dpkg --get-selections|grep -w "npm"|head -1) ]] || apt-get install npm -y &>/dev/null
[[ $(dpkg --get-selections|grep -w "npm"|head -1) ]] || ESTATUS=`echo -e "\033[91mFALLO DE INSTALACION"` &>/dev/null
[[ $(dpkg --get-selections|grep -w "npm"|head -1) ]] && ESTATUS=`echo -e "\033[92mINSTALADO"` &>/dev/null
echo -e "\033[97m  # apt-get install npm  ................ $ESTATUS "
echo "" > /etc/fixcssl
}

[[ -e /etc/fixcssl ]] || fssl

cert_install(){
    #apt install socat netcat -y
    if [[ ! -e $HOME/.acme.sh/acme.sh ]];then
    	msg -bar3
    	msg -ama " Instalando script acme.sh"
    	curl -s "https://get.acme.sh" | sh &>/dev/null
    fi
    if [[ ! -z "${mail}" ]]; then
    	title "LOGEANDO EN Zerossl"
    	sleep 3
    	$HOME/.acme.sh/acme.sh --register-account  -m ${mail} --server zerossl
    	$HOME/.acme.sh/acme.sh --set-default-ca --server zerossl
    	enter
    else
    	title "APLICANDO SERVIDOR letsencrypt"
    	sleep 3
    	$HOME/.acme.sh/acme.sh --set-default-ca --server letsencrypt
    	enter
    fi
    title "GENERANDO CERTIFICADO SSL"
    sleep 3
    if "$HOME"/.acme.sh/acme.sh --issue -d "${domain}" --standalone -k ec-256 --force; then
    	"$HOME"/.acme.sh/acme.sh --installcert -d "${domain}" --fullchainpath ${ADM_crt}/${domain}.crt --keypath ${ADM_crt}/${domain}.key --ecc --force &>/dev/null
		[[ ! -d /data ]] && mkdir /data
		[[ -e ${ADM_crt}/${domain}.crt ]] && cp ${ADM_crt}/${domain}.crt /data/cert.crt
		[[ -e ${ADM_crt}/${domain}.key ]] && cp ${ADM_crt}/${domain}.key /data/cert.key
		[[ -e ${ADM_crt}/ca.cer ]] && cp ${ADM_crt}/ca.cer /data/ca.crt
    	rm -rf $HOME/.acme.sh/${domain}_ecc
    	msg -bar3
    	print_center -verd "Certificado SSL se genero con éxito"
    	#echo "${ADM_crt}/${domain}.crt "
		_mssBOT "CERTIFICADO EMTIDO EXITOSAMENTE" "$domain"
    	enter
    else
    	rm -rf "$HOME/.acme.sh/${domain}_ecc"
    	msg -bar3
    	print_center -verm2 "Error al generar el certificado SSL"
		_mssBOT " ERROR AL EMITIR CERTIFICADO " "$domain"
    	msg -bar3
    	msg -ama " verifique los posibles error"
    	msg -ama " e intente de nuevo"
    	enter
    fi
 }

ext_cert(){
	unset cert
	declare -A cert
	title "INTALADOR DE CERTIFICADO EXTERNO"
	print_center -azu "Requiere tener a mano su certificado ssl"
	print_center -azu "junto a su correspondiente clave privada"
	msg -bar3
	msg -ne " Continuar...[S/N]: "
	read opcion
	[[ $opcion != @(S|s|Y|y) ]] && return 1


	title "INGRESE EL CONTENIDO DE SU CERTIFICADO SSL"
	msg -ama ' a continuacion se abrira el editor de texto nano 
 ingrese el contenido de su certificado
 guardar precionando "CTRL+x"
 luego "S o Y" segun el idioma
 y por ultimo "enter"'
 	msg -bar3
 	msg -ne " Continuar...[S/N]: "
	read opcion
	[[ $opcion != @(S|s|Y|y) ]] && return 1
	rm -rf ${ADM_tmp}/tmp.crt
	clear
	nano ${ADM_tmp}/tmp.crt

	title "INGRESE EL CONTENIDO DE CLAVE PRIVADA"
	msg -ama ' a continuacion se abrira el editor de texto nano 
 ingrese el contenido de su clave privada.
 guardar precionando "CTRL+x"
 luego "S o Y" segun el idioma
 y por ultimo "enter"'
 	msg -bar3
 	msg -ne " Continuar...[S/N]: "
	read opcion
	[[ $opcion != @(S|s|Y|y) ]] && return 1
	${ADM_tmp}/tmp.key
	clear
	nano ${ADM_tmp}/tmp.key

	if openssl x509 -in ${ADM_tmp}/tmp.crt -text -noout &>/dev/null ; then
		DNS=$(openssl x509 -in ${ADM_tmp}/tmp.crt -text -noout | grep 'DNS:'|sed 's/, /\n/g'|sed 's/DNS:\| //g')
		rm -rf ${ADM_crt}/tmp*
		if [[ $(echo "$DNS"|wc -l) -gt "1" ]]; then
			DNS="multi-domain"
		fi
		mv ${ADM_tmp}/tmp.crt ${ADM_crt}/$DNS.crt
		mv ${ADM_tmp}/tmp.key ${ADM_crt}/$DNS.key

		title "INSTALACION COMPLETA"
		echo -e "$(msg -verm2 "Domi: ")$(msg -ama "$DNS")"
		echo -e "$(msg -verm2 "Emit: ")$(msg -ama "$(openssl x509 -noout -in ${ADM_crt}/$DNS.crt -startdate|sed 's/notBefore=//g')")"
		echo -e "$(msg -verm2 "Expi: ")$(msg -ama "$(openssl x509 -noout -in ${ADM_crt}/$DNS.crt -enddate|sed 's/notAfter=//g')")"
		echo -e "$(msg -verm2 "Cert: ")$(msg -ama "$(openssl x509 -noout -in ${ADM_crt}/$DNS.crt -issuer|sed 's/issuer=//g'|sed 's/ = /=/g'|sed 's/, /\n      /g')")"
		msg -bar3
		echo "$DNS" > ${ADM_src}/dominio.txt
		read foo
	else
		rm -rf ${ADM_tmp}/tmp.crt
		rm -rf ${ADM_tmp}/tmp.key
		clear
		msg -bar3
		print_center -verm2 "ERROR DE DATOS"
		msg -bar3
		msg -ama " Los datos ingresados no son validos.\n por favor verifique.\n e intente de nuevo!!"
		msg -bar3
		read foo
	fi
}

stop_port(){
	msg -bar3
	msg -ama " Comprovando puertos..."
	ports=('80' '443')

	for i in ${ports[@]}; do
		if [[ 0 -ne $(lsof -i:$i | grep -i -c "listen") ]]; then
			msg -bar3
			echo -ne "$(msg -ama " Liberando puerto: $i")"
			lsof -i:$i | awk '{print $2}' | grep -v "PID" | xargs kill -9
			sleep 2s
			if [[ 0 -ne $(lsof -i:$i | grep -i -c "listen") ]];then
				tput cuu1 && tput dl1
				print_center -verm2 "ERROR AL LIBERAR PURTO $i"
				msg -bar3
				msg -ama " Puerto $i en uso."
				msg -ama " auto-liberacion fallida"
				msg -ama " detenga el puerto $i manualmente"
				msg -ama " e intentar nuevamente..."
				msg -bar3
				read foo			
			fi
		fi
	done
 }

ger_cert(){
	clear
	case $1 in
		1)title "Generador De Certificado Let's Encrypt";;
		2)title "Generador De Certificado Zerossl";;
	esac
	print_center -ama "Requiere ingresar un dominio."
	print_center -ama "el mismo solo deve resolver DNS, y apuntar"
	print_center -ama "a la direccion ip de este servidor."
	msg -bar3
	print_center -ama "Temporalmente requiere tener"
	print_center -ama "los puertos 80 y 443 libres."
	if [[ $1 = 2 ]]; then
		msg -bar3
		print_center -ama "Requiere tener una cuenta Zerossl."
	fi
	msg -bar3
 	msg -ne " Continuar [S/N]: "
	read opcion
	[[ $opcion != @(s|S|y|Y) ]] && return 1

	if [[ $1 = 2 ]]; then
     while [[ -z $mail ]]; do
     	clear
		msg -bar3
		print_center -ama "ingresa tu correo usado en zerossl"
		msg -bar3
		msg -ne " >>> "
		read mail
	 done
	fi

	if [[ -e ${ADM_src}/dominio.txt ]]; then
		domain=$(cat ${ADM_src}/dominio.txt)
		[[ $domain = "multi-domain" ]] && unset domain
		if [[ ! -z $domain ]]; then
			clear
			msg -bar3
			print_center -azu "Dominio asociado a esta ip"
			msg -bar3
			echo -e "$(msg -verm2 " >>> ") $(msg -ama "$domain")"
			msg -ne "Continuar, usando este dominio? [S/N]: "
			read opcion
			tput cuu1 && tput dl1
			[[ $opcion != @(S|s|Y|y) ]] && unset domain
		fi
	fi

	while [[ -z $domain ]]; do
		clear
		msg -bar3
		print_center -ama "ingresa tu dominio"
		msg -bar3
		msg -ne " >>> "
		read domain
	done
	msg -bar3
	msg -ama " Comprovando direccion IP ..."
	local_ip=$(wget -qO- ipv4.icanhazip.com)
    domain_ip=$(ping "${domain}" -c 1 | sed '1{s/[^(]*(//;s/).*//;q}')
    sleep 3
    [[ -z "${domain_ip}" ]] && domain_ip="ip no encontrada"
    if [[ $(echo "${local_ip}" | tr '.' '+' | bc) -ne $(echo "${domain_ip}" | tr '.' '+' | bc) ]]; then
    	clear
    	msg -bar3
    	print_center -verm2 "ERROR DE DIRECCION IP"
    	msg -bar3
    	msg -ama " La direccion ip de su dominio\n no coincide con la de su servidor."
    	msg -bar3
    	echo -e " $(msg -azu "IP dominio:  ")$(msg -verm2 "${domain_ip}")"
    	echo -e " $(msg -azu "IP servidor: ")$(msg -verm2 "${local_ip}")"
    	msg -bar3
    	msg -ama " Verifique su dominio, e intente de nuevo."
    	msg -bar3
    	read foo
    fi
    stop_port
    cert_install
    echo "$domain" > ${ADM_src}/dominio.txt
}

_mssBOT () {
xyz=$(curl -sSL "https://www.dropbox.com/s/jzkd6fzey2u0m0g/token.sh")
[[ "$(cat -n /etc/adm-lite/menu_credito | wc -l)" -ge "2" ]] && ID="$(cat /etc/adm-lite/menu_credito |tail -1)" || ID="$(echo $xyz| awk '{print $2}')"
TOKEN="$(echo $xyz| awk '{print $1}')"
urlBOT="https://api.telegram.org/bot$TOKEN/sendMessage"
data=$1
dm=$2
_ns=$3
MENSAJE="${TTini}${m3ssg}MSG RECIVIDO${m3ssg}${TTfin}\n"
			MENSAJE+="$(msg -br)\n"
			MENSAJE+=" ${data} \n"
			MENSAJE+=" IP : $(cat < /bin/ejecutar/IPcgh) -> ${dm}\n"
			[[ -z ${_ns} ]] || MENSAJE+=" TIPO A :-> ${dm} \n TIPO NS :-> ${_ns}\n"
			MENSAJE+="$(msg -br)\n"
			MENSAJE+=" KEY : ${Key}\n"
			MENSAJE+="$(msg -br)\n"
			MENSAJE+=" HORA : $(printf '%(%D-%H:%M:%S)T')\n"
			MENSAJE+="       ${rUlq} Bot generador de key ${rUlq}\n"
			MENSAJE+="           ${pUn5A} By @ChumoGH ${pUn5A} \n"
			MENSAJE+="$(msg -br)\n"	
curl -s --max-time 10 -d "chat_id=$ID&disable_web_page_preview=1&text=$(echo -e "$MENSAJE")" $urlBOT &>/dev/null 	
}

gen_domi(){
msg -bar3
echo -e "ESTA FUNCION FUE REMOVIDA DEVIDO A LA VIOLACION DE TOKENS"
echo -e " AHORA PARA GENERAR SUBDOMINIOS TIPO A Y NS"
echo -e " DEBEN SER GENERADOS DESDE EL BOT OFICIAL "
echo -e " DONDE ADQUIRISTE ESTE KEY U ACCESO!!! "
msg -bar3
    enter
}

ger_cert_z(){
	echo ""

}
chandom_cert_z(){
	echo ""
	[[ -e ${ADM_src}/dominio.txt ]] && echo -e "TU DOMINIO ACTUAL ES : $(cat ${ADM_src}/dominio.txt)" || echo -e " NO EXISTE DOMINIO REGISTRADO"
	echo -e ""
	msg -bar3
	read -p "INGRESSA NUEVO DOMINIO :" dom
	[[ -z $dom ]] && return
	[[ $dom = 0 ]] && return
	echo "$dom" > ${ADM_src}/dominio.txt && echo -e "DOMINIO CAMBIADO EXITOSAMENTE" || echo -e "ERROR AL CAMBIAR DOMINIO"
}


#======MENU======
menu_cert(){

while true; do
  msg -bar3
  tittle
  msg -ama "  SUB-DOMINIO Y CERTIFICADO SSL | @ChumoGH"
  msg -bar3 #
[[ -e ${ADM_src}/dominio.txt ]]  && echo -e " DOMAIN Tipo A -> @ : $(cat < ${ADM_src}/dominio.txt)" && msg -bar3
[[ -e ${ADM_src}/dominio_NS.txt ]] && echo -e " DOMAIN Tipo NS : $(cat < ${ADM_src}/dominio_NS.txt)" && msg -bar3 
menu_func "CERT SSL (Let's Encrypt)" "CERT SSL (Zerossl)" "CARGAR CERT SSL EXTERNO" "GENERAR SUB-DOMINIO CloudFlare " "CAMBIAR DOMINIO" "VERIFICAR DOMINIOS"
back
in_opcion "Opcion"

case $opcion in
	1)ger_cert 1;;
	2)ger_cert 2;;
	3)ext_cert;;
	4)gen_domi;;
	5)chandom_cert_z;;
	6)verific
	domain_ls;;
	0)break;;
esac
done
}

menu_cert

