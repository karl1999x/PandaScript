#!/bin/bash
[[ $(dpkg --get-selections|grep -w "jq"|head -1) ]] || apt-get install jq -y &>/dev/null
[[ $(dpkg --get-selections|grep -w "at"|head -1) ]] || apt-get install at -y &>/dev/null
#apt-get install jq -y

#192.168.100.1
#10.20.10.7
#   Máscara de subred . . . . . . . . . . . . : 255.255.0.0

[[ -e /etc/adm-lite/liberados ]] && UsersID=$(cat /etc/adm-lite/liberados | cut -d '|' -f1) || touch /etc/adm-lite/liberados
[[ -e /etc/adm-lite/liberados ]] && AdminDB=$(cut -d'|' -f1 /etc/adm-lite/liberados | head -n 1) || AdminDB=$(cat /etc/adm-lite/liberados | cut -d '|' -f1| head -1)

#VARIAVEL ENTRADA TOKEN
[[ "$1" = "" ]] && exit 1
if [[ "$2" != "" ]]; then
idioma="$2"
else
idioma="es"
fi
dir_user="/etc/adm-lite/userDIR"
#IMPORTANDO API
source ShellBot.sh

ShellBot.init --token "$1"
ShellBot.username
TOKEN=$1
#ARQUIVOS USADOS NA MESMA PASTA
#infousers / infousers-txt > informação usuarios
#onlines / onlines-txt > usuarios conectados
#criarusr / criarusr-txt > criar usuario
#userdelete  > deletar usuario infovps-txt

#IMPORTANDO TEXTOS
txt[1]="USUARIOS LIBERADOS EN EL BOT"
txt[2]=" Usuario"
txt[3]=" NO PUEDES USAR EL BOT"
txt[4]=" Comandos Bloqueados"
txt[5]=" EL ACCESO YA ESTÁ LIBERADO"
txt[6]=" ya estás liberado"
txt[7]=" "
txt[8]="NO PUEDE USAR ESTE BOT"
txt[9]="No tienes permiso para usar"
txt[10]="Tentativa de acesso negada!"
txt[11]="LANZAMIENTO REALIZADO CON ÉXITO!"
txt[12]="¡Ahora puedes administrar el bot!"
txt[13]="13¡Buen uso!"
txt[14]="INFORMACIÓN DEL SERVIDOR"
txt[15]="HOLA ADMIN, BIENVENIDO"
txt[16]=" SEA BIENVENIDO AL BOT"
txt[17]=" Aqui Esta a lista de Comandos Disponiveis!"
txt[18]=" COMANDOS"
txt[19]=" usuarios conectados"
txt[20]=" adicionar usuario"
txt[21]=" remover usuario"
txt[22]=" informacoes dos usuarios"
txt[23]=" informacao do servidor"
txt[24]=" usuarios liberados no bot"
txt[25]=" gerador de payload"
txt[26]=" libera o bot"
txt[27]=" Usuario Clave"
txt[28]=" comando nao foi executado"
txt[29]=" Usuario"
txt[30]=" Contraseña"
txt[31]=" Dias Restantes"
txt[32]=" Limite"
txt[33]=" Comando Reconocido"
txt[34]=" Usuario"
txt[35]=" Conexines"
txt[36]=" MODO DE USO"
txt[37]=" Usuario Senha Dias Limite"
txt[38]=" Exemplo"
txt[39]=" Usuario Nao Foi Criado"
txt[40]=" USUARIO CRIADO"
txt[41]=" Usuario"
txt[42]=" Senha"
txt[43]=" Duracao"
txt[44]=" Limite"
txt[45]=" MODO DE USO"
txt[46]=" Usuario"
txt[47]=" Ejemplo:"
txt[48]=" Usuario No Eliminado"
txt[49]=" Removido con exito!"
txt[50]=" MODO DE USO"
txt[51]=" Host Requisicao Conexao"
txt[52]=" Ejemplo"
txt[53]=" Metodos Requisicao"
txt[54]=" Metodos Conexao"
txt[55]=" PAYLOADS GENERADOS EXITOSAMENTE"
txt[56]=" PAYLOADS NO GENERADOS"
txt[57]=" Algo deu Errado"


call.mensaje () {
local ID=$1
local mensaje=$2
#--reply_to_message_id ${ID} 
[[ -z ${ID} ]] && local ID=$(cat /etc/adm-lite/liberados | cut -d '|' -f1| head -1)
ShellBot.sendChatAction --chat_id "${ID}" --action typing
		ShellBot.sendMessage	--chat_id "${ID}" \
					--text "<i>$(echo -e ${mensaje})</i>" \
					--parse_mode html
return
}

admkill_fun(){
local IDadd="$1"

[[ $(cat /etc/adm-lite/liberados|grep -w ${IDadd}) ]] && {
local msg='━━━━━━━━━━━━━━━━━━━━━ \n'
    msg+=" 🌚 ID <code>${IDadd}</code> REGISTRADO 🌚\n"
    msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
    msg+=" ⏳ VALIDANDO LA CANTIDAD DE CREDITOS ⏳\n"
    msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
	call.mensaje "${message_chat_id[$id]}" "$msg"
_cred=$(cat /etc/adm-lite/liberados|grep -w ${IDadd} | cut -d "|" -f2)	
}
# verificaruser "${usuario}:${senha}"
[[ $(cat /etc/adm-lite/liberados | head -1 | grep -w ${message_chat_id[$id]}) ]] && {
[[ ${#IDadd} -gt 6 ]] && {
    if [[ -f "/etc/adm-lite/liberados" ]]; then
        sed -i "/${IDadd}/d" /etc/adm-lite/liberados
    else
        echo "Archivo no encontrado: /etc/adm-lite/liberados"
    fi
local msg
          msg='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+="AUTORIZACION RETIRADA EXITOSAMENTE\n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+=" EL ${IDadd} YA NO PUEDE ADMINISTRAR \n"
          msg+=" TENIA ${_cred} CREDITOS DE USO!! \n"
          msg+=" POR CADA USUARIO, SE RESTARA UN CREDITO \n"
          msg+=" 1 CREDITO EQUIVALE A 30 DIAS POR USER  \n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+=' Presiona /start \n'
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
		ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
					--reply_to_message_id "${message_message_id[$id]}" \
					--text "<i>$(echo -e $msg)</i>" \
					--parse_mode html
		call.mensaje "${IDadd}" "$msg"
return 0
} 
} || { 
local msg
          msg='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+=" NO TIENES AUTORIZACION\n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+="   ACCESO DENEGADO\n"
          msg+="CONTACTA CON EL ADMIN\n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
						ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
							--reply_to_message_id "${message_message_id[$id]}" \
							--text "<i>$(echo -e $msg)</i>" \
							--parse_mode html
return 0
}
}

add_admin(){
IDadd="$1"
_cred="$2"
_lim="$2"
[[ $(cat /etc/adm-lite/liberados|grep -w ${IDadd}) ]] && {
local msg
          msg='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+="ACCESO YA FUE RALIZADO\n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+="ID ${IDadd} DE REGISTRO NO REGISTRADO\n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
		call.mensaje "${message_chat_id[$id]}" "$msg"
return 0
}
# verificaruser "${usuario}:${senha}"
[[ $(cat /etc/adm-lite/liberados | head -1 | grep -w ${message_chat_id[$id]}) ]] && {
[[ ${#IDadd} -gt 6 ]] && {
[[ -z ${_cred} ]] && _cred='X'
[[ ${_cred} ]] && _actID="${IDadd}|${_cred}" || _actID="${IDadd}|${_cred}"
[[ -z $(cat /etc/adm-lite/liberados) ]] && {
[[ -e /etc/adm-lite/liberados ]] && echo "${_actID}" > /etc/adm-lite/liberados
}
[[ -e /etc/adm-lite/liberados ]] && echo "${_actID}" >> /etc/adm-lite/liberados
local msg
          msg='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+=" 🫂 AUTORIZACION EMITIDA EXITOSAMENTE 🫂 \n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+=" EL ${IDadd} 🍑 YA PUEDE ADMINISTRAR \n"
          msg+=" UD TIENE 💎 ${_cred} 💎 CREDITOS DE USO!! \n"
          msg+=" POR CADA USUARIO, SE RESTARA UN CREDITO \n"
          msg+=" 1 CREDITO EQUIVALE A 30 DIAS POR USER  \n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+=' Presiona /start \n'
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
		ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
					--reply_to_message_id "${message_message_id[$id]}" \
					--text "<i>$(echo -e $msg)</i>" \
					--parse_mode html
		call.mensaje "${IDadd}" "$msg"
return 0
} 
} || { 
local msg
          msg='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+="NO TIENES AUTORIZACION\n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+="   ACCESO DENEGADO\n"
          msg+="CONTACTA CON EL ADMIN\n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
						ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
							--reply_to_message_id "${message_message_id[$id]}" \
							--text "<i>$(echo -e $msg)</i>" \
							--parse_mode html
return 0
}
}

add_admin_creditos(){
local IDadd="$1"
[[ -z $(cat /etc/adm-lite/liberados|grep ${IDadd}) ]] || {
local msg
          msg='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+="ACCESO YA ESTA ACTIVO\n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+="EL ID DE REGISTRO NO AFECTADO\n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
		call.mensaje "${message_chat_id[$id]}" "$msg"
return 0
}
# verificaruser "${usuario}:${senha}"
[[ $(cat /etc/adm-lite/liberados | head -1 | grep -w ${message_chat_id[$id]}) ]] && {
[[ ${#IDadd} -gt 6 ]] && {
[[ -e /etc/adm-lite/liberados ]] && echo "${IDadd}|" >> /etc/adm-lite/liberados
local msg
          msg='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+="AUTORIZACION REALIZADA EXITOSAMENTE\n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+=" YA PUEDES ADMINISTRAR ESTE BOT\n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+=' Presiona /start \n'
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
		ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
					--reply_to_message_id "${message_message_id[$id]}" \
					--text "<i>$(echo -e $msg)</i>" \
					--parse_mode html
		call.mensaje "${IDadd}" "$msg"
return 0
} 
} || { 
local msg
          msg='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+="NO TIENES AUTORIZACION\n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+="   ACCESO DENEGADO\n"
          msg+="CONTACTA CON EL ADMIN\n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
						ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
							--reply_to_message_id "${message_message_id[$id]}" \
							--text "<i>$(echo -e $msg)</i>" \
							--parse_mode html
return 0
}
}

#IDENTIFICA USUARIO USANDO
loguin_fun () {
local msg='━━━━━━━━━━━━━━━━━━━━━ \n'
      msg+="USUARIOS PERMITIDOS A USAR ESTE BOT\n"
      msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
      msg+=" $(cat -n /etc/adm-lite/liberados) \n"
      msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
	  call.mensaje "${message_chat_id[$id]}" "$msg"
return 0
}

_error_command () {
local msg='━━━━━━━━━━━━━━━━━━━━━ \n'
      msg+=" COMANDO NO RECONOCIDO, TOCA /start \n"
	  msg+=" PRA VER LA LISTA DE OPCIONES VALIDAS!! \n"
      msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
      ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
			--text "$(echo -e $msg)" \
			--parse_mode markdown
return 0
}


blockfun () {
local msg='━━━━━━━━━━━━━━━━━━━━━ \n'
      msg+="NO PUEDES USAR EL BOT\n"
      msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
      msg+="AUTORIZACION INVALIDA\n"
      msg+="SU ID : <code>${message_chat_id[$id]}</code> \n"
      msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
	  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
			--text "$(echo -e $msg)" \
			--parse_mode html
	return 0
}

verificaruser () {
local base_de_dados="./bottokens"
if [[ $(cat $base_de_dados|head -1|awk '{print $1}') = "$1" ]]; then
return 0
 else
return 1
fi
}

ativarid () {
local usrLOG="$1"
local clave="$2"
local usrid="$3"
if [[ "$(cat /etc/adm-lite/liberados|grep "$usrid")" != "" ]]; then
local msg+='━━━━━━━━━━━━━━━━━━━━━━━━━━━━ \n'
      msg+=" ⚠️ ADVERTENCIA ⚠️\n"
      msg+='━━━━━━━━━━━━━━━━━━━━━━━━━━━━ \n'
      msg+=" YA CUENTAS CON UN ACCESO \n PROCURA NO ALTERAR LOS DOBLE ACCESOS \n COLOCA /start "
      msg+='━━━━━━━━━━━━━━━━━━━━━━━━━━━━ \n'
	  ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action typing
	  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
				--text "$(echo -e $msg)" \
				--parse_mode markdown
	ajuda_fun
return 0
fi
verificaruser "${usrLOG}:${clave}"
if [[ "$?" = "1" ]]; then
local msg='━━━━━━━━━━━━━━━━━━━━━━━━━━━━ \n'
      msg+=" CLAVES DE AUTORIZACION INVALIDAS 👀\n"
      msg+='━━━━━━━━━━━━━━━━━━━━━━━━━━━━ \n'
      msg+=" 🔒 Return 0x0001 Code Error 🔐\n"
	  msg+='━━━━━━━━━━━━━━━━━━━━━━━━━━━━ \n'
      msg+=" ERROR EN LIBERAR ACCESO\n"
      msg+=" CONTACTA AL CREADOR DEL BOT\n"
      msg+='━━━━━━━━━━━━━━━━━━━━━━━━━━━━ \n'
	  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
				--text "$(echo -e $msg)" \
				--parse_mode markdown
return 0
else
[[ -e /etc/adm-lite/liberados  ]] && echo "$usrid|X" >> /etc/adm-lite/liberados || echo "$usrid|X|ADMIN" > /etc/adm-lite/liberados
local msg+='━━━━━━━━━━━━━━━━━━━━━━━━━━━━ \n'
      msg+=" 🔰 AUTORIZACION EXITOSA 🔰\n"
      msg+=" ⚡ AHORA ERES SUPER ADMIN ⚡\n"
      msg+=" ERES EL 💥 $(cat /etc/adm-lite/liberados|wc -l) 💥 ADMINISTRADOR !\n"
      msg+='━━━━━━━━━━━━━━━━━━━━━━━━━━━━ \n'
      msg+=" YA PUEDES ADMINISTRAR ESTE BOT\n"
      msg+=" TOCA AQUI /start PARA COMENZAR\n"
      msg+='━━━━━━━━━━━━━━━━━━━━━━━━━━━━ \n'
	  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
				--text "$(echo -e $msg)" \
				--parse_mode markdown
	 ajuda_fun
return 0
fi
}

infovps () {
totalram=$(free | grep Mem | awk '{print $2}')
usedram=$(free | grep Mem | awk '{print $3}')
freeram=$(free | grep Mem | awk '{print $4}')
swapram=$(cat /proc/meminfo | grep SwapTotal | awk '{print $2}')
system=$(cat /etc/issue.net)
#clock=$(lscpu | grep "CPU MHz" | awk '{print $3}')
clock=$(lscpu | grep "Hz" | awk '{print $3}')
based=$(cat /etc/*release | grep ID_LIKE | awk -F "=" '{print $2}')
processor=$(cat /proc/cpuinfo | grep "model name" | uniq | awk -F ":" '{print $2}')
cpus=$(cat /proc/cpuinfo | grep processor | wc -l)
local msg='━━━━━━━━━━━━━━━━━━━━━ \n'
      msg+=" - DETALLES DE TU SERVIDOR VPS - \n"
      msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
	  msg+=" SISTEMA : $system\n"
      msg+=" USO CPU : $(ps aux  | awk 'BEGIN { sum = 0 }  { sum += sprintf("%f",$3) }; END { printf " " "%.2f" "%%", sum}') \n"
      msg+=" CPU ID : $(lscpu | grep "Vendor ID" | awk '{print $3}') \n"
      msg+=" RAM TOTAL : $(($totalram / 1024)) MB \n"
      msg+=" RAM EN USO : $(($usedram / 1024)) MB \n"
      msg+=" RAM EN LIBRE : $(($freeram / 1024)) MB \n"
      msg+=" TIEMPO EN LINEA : $(uptime -p) \n"
      msg+=" ARQUITECTURA : $(uname -m) / CORES : $cpus \n"
      msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
	  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
				--text "$(echo -e $msg)" \
				--parse_mode html
	return 0
}

infoporta () {
#echo "DISEÑANDO MENSAJES!"
local msg='━━━━━━━━━━━━━━━━━━━━━ \n'
      msg+="LISTA DE PUERTAS ACTIVAS EN VPS\n"
      msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
          ports_
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
	      ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
							--text "$(echo -e $msg)" \
							--parse_mode markdown
	return 0
}


mostrar_usuarios_conectados_por_id() {
    local id_buscar="${message_chat_id[$id]}"  # ID que deseas buscar

        grep "^${id_buscar}|" /etc/adm-lite/registerBOT.log | while IFS="|" read -r id_admin nombre_usuario_ssh; do
            # Verificar si el usuario existe en /etc/passwd
            if grep -q "^${nombre_usuario_ssh}:" /etc/passwd; then
                # Solo mostrar usuarios que existen en /etc/passwd
                echo "Usuario SSH válido: ${nombre_usuario_ssh}"
            fi
        done

}


new_users_id(){
local id_reseller=${message_chat_id[$id]}
local users_client=$(cat /etc/adm-lite/registerBOT.log  | grep -w ${id_reseller} | cut -d "|" -f2)
new_mostrar ${users_client}
if [ "$?" = "1" ]; then
local msg
          msg='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+=" COMANDO NO EJECUTADO \n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'   
				ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
							--reply_to_message_id "${message_message_id[$id]}" \
							--text "<i>$(echo -e $msg)</i>" \
							--parse_mode html
	return 0
else
    local msg=' =================================== \n'
	cont=1
    for lines in `echo -e "${_client}"`; do
    [[ -z ${lines} ]] && break
          #user=$(echo "$lines" | awk '{print $1}')
          user=$(echo "$lines" | cut -d '|' -f1)
          sen=$(echo "$lines"  | cut -d '|' -f2)
          limit=$(echo "$lines" | cut -d '|' -f3)
          data=$(echo "$lines"  | cut -d '|' -f4)
          msg+=" USER (${cont}) : $user\n"
          msg+=" PASSWD : $sen\n"
          msg+=" EXPIRA : $data\n"
          msg+=" LIMITE : $limit\n"
		  let cont++;
		  msg+=' =================================== \n'
    done 
	unset _client
	call.Chat_long "${msg}"
#			ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
#							--reply_to_message_id "${message_message_id[$id]}" \
#							--text "<i>$(echo -e $msg)</i>" \
#							--parse_mode html
    return 0
fi

}


mostrar_usuarios_por_id(){
mostrar_info_user
if [ "$?" = "1" ]; then
local msg
          msg='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+=" COMANDO NO EJECUTADO \n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'   
				ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
							--reply_to_message_id "${message_message_id[$id]}" \
							--text "<i>$(echo -e $msg)</i>" \
							--parse_mode html
	return 0
else
    local msg=' =================================== \n'
	cont=1
    for lines in `echo -e "${_client}"`; do
    [[ -z ${lines} ]] && break
          #user=$(echo "$lines" | awk '{print $1}')
          user=$(echo "$lines" | cut -d '|' -f1)
          sen=$(echo "$lines"  | cut -d '|' -f2)
          limit=$(echo "$lines" | cut -d '|' -f3)
          data=$(echo "$lines"  | cut -d '|' -f4)
          msg+=" USER (${cont}) : $user\n"
          msg+=" PASSWD : $sen\n"
          msg+=" EXPIRA : $data\n"
          msg+=" LIMITE : $limit\n"
		  let cont++;
		  msg+=' =================================== \n'
    done 
	unset _client
	call.Chat_long "${msg}"
#			ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
#							--reply_to_message_id "${message_message_id[$id]}" \
#							--text "<i>$(echo -e $msg)</i>" \
#							--parse_mode html
    return 0
fi

}

new_mostrar(){

local id_reseller=${message_chat_id[$id]}
local users_client=("$@")
local _cont=1
unset _client


for nombre_usuario_ssh in ${users_client[@]}; do
                    
					local data_sec=$(date +%s)
					
                    local data_user=$(chage -l "$nombre_usuario_ssh" | grep -i co | awk -F ":" '{print $2}')
                    
					if [ "$data_user" != " never" ]; then
                        data_user_sec=$(date +%s --date="$data_user")
                        if [ "$data_sec" -gt "$data_user_sec" ]; then
                            dias_user="CADUCADO"
                        else
                            variavel_soma=$(($data_user_sec - $data_sec))
                            dias_use=$(($variavel_soma / 86400))
                            dias_user="$dias_use"
                        fi
                    fi
                    [[ "$data_user" = " never" ]] && dias_user="Null"

                    if [ -e "$dir_user/$nombre_usuario_ssh" ]; then
                        _sen=$(cat "$dir_user/$nombre_usuario_ssh" | grep "senha" | awk '{print $2}')
                        _limit=$(cat "$dir_user/$nombre_usuario_ssh" | grep "limite" | awk '{print $2}')
                        [[ ${_limit} = @(HWID|TOKEN) ]] && {
                            _sen="$nombre_usuario_ssh"
                            nombre_usuario_ssh=$(cat "$dir_user/$nombre_usuario_ssh" | grep "senha" | awk '{print $2}')
                        }
                    else
                        local linea=$(grep -w "${nombre_usuario_ssh}" /etc/passwd)
                        if [[ "${linea}" =~ ,([^:]+): ]]; then
                            _sen="${BASH_REMATCH[1]}"
                        fi
                        _limit="$(grep -w "${nombre_usuario_ssh}" /etc/passwd | awk -F ':' '{split($5, a, ","); print a[1]}')"
                        [[ ${_limit} = @(HWID|TOKEN) ]] && {
                            _sen="$nombre_usuario_ssh"
                            nombre_usuario_ssh="TK0${_cont}"
                        }
                    fi
                    [[ -z "$_limit" ]] && _limit="Null"
                    [[ -z "$_sen" ]] && _sen="Null"

                    # Formato final del cliente
                    _client+="$nombre_usuario_ssh|$_sen|$_limit|$dias_user\n"
                    let _cont++
	
done
	

}

mostrar_info_user() {
    local id_buscar="${message_chat_id[$id]}"  # ID que deseas buscar
    local _cont=1
    unset _client
	
    if [[ -f /etc/adm-lite/registerBOT.log ]]; then
        grep "^${id_buscar}|" /etc/adm-lite/registerBOT.log | while IFS="|" read -r id_admin nombre_usuario_ssh; do
                # Verificar si el usuario tiene shell /bin/false
                if grep -q "^${nombre_usuario_ssh}:" /etc/passwd; then
                    data_sec=$(date +%s)
                    data_user=$(chage -l "$nombre_usuario_ssh" | grep -i co | awk -F ":" '{print $2}')
                    if [ "$data_user" != " never" ]; then
                        data_user_sec=$(date +%s --date="$data_user")
                        if [ "$data_sec" -gt "$data_user_sec" ]; then
                            dias_user="CADUCADO"
                        else
                            variavel_soma=$(($data_user_sec - $data_sec))
                            dias_use=$(($variavel_soma / 86400))
                            dias_user="$dias_use"
                        fi
                    fi
                    [[ "$data_user" = " never" ]] && dias_user="Null"
                    
                    # Obtener la información del usuario
                    _sen="Null"
                    _limit="Null"
                    if [ -e "$dir_user/$nombre_usuario_ssh" ]; then
                        _sen=$(cat "$dir_user/$nombre_usuario_ssh" | grep "senha" | awk '{print $2}')
                        _limit=$(cat "$dir_user/$nombre_usuario_ssh" | grep "limite" | awk '{print $2}')
                        [[ ${_limit} = @(HWID|TOKEN) ]] && {
                            _sen="$nombre_usuario_ssh"
                            nombre_usuario_ssh=$(cat "$dir_user/$nombre_usuario_ssh" | grep "senha" | awk '{print $2}')
                        }
                    else
                        local linea=$(grep -w "${nombre_usuario_ssh}" /etc/passwd)
                        if [[ "${linea}" =~ ,([^:]+): ]]; then
                            _sen="${BASH_REMATCH[1]}"
                        fi
                        _limit="$(grep -w "${nombre_usuario_ssh}" /etc/passwd | awk -F ':' '{split($5, a, ","); print a[1]}')"
                        [[ ${_limit} = @(HWID|TOKEN) ]] && {
                            _sen="$nombre_usuario_ssh"
                            nombre_usuario_ssh="TK0${_cont}"
                        }
                    fi
                    [[ -z "$_limit" ]] && _limit="Null"
                    [[ -z "$_sen" ]] && _sen="Null"

                    # Formato final del cliente
                    _client+="$nombre_usuario_ssh|$_sen|$_limit|$dias_user\n"
                    let _cont++
                fi
        done

        # Imprimir los resultados
        echo -e "$_client"
    else
        echo "El archivo /etc/adm-lite/registerBOT.log no existe."
    fi
}

backup_fun () {
local _netCAT="$(netstat -tunlp)"
_SFTP="$(lsof -V -i tcp -P -n | grep -v "ESTABLISHED" |grep -v "COMMAND" | grep "LISTEN" | grep apache2)"
[[ -z ${_SFTP} ]] && _SFTP="$(lsof -V -i tcp -P -n | grep -v "ESTABLISHED" |grep -v "COMMAND" | grep "LISTEN" | grep nginx)"
portFTP=$(echo -e "$_SFTP" |cut -d: -f2 | cut -d' ' -f1 | uniq)
[[ -z ${portFTP} ]] && portFTP='X0'
export portFTP=$(echo ${portFTP} | sed 's/\s\+/,/g' | cut -d , -f1)
    chatuser="${message_chat_id[$id]}"
    local file="/var/www/html/backup_usuarios.txt"
    local dir="/etc/adm-lite"
    local dir_user="/userDIR"

    rm -f "$file"
    touch "$file"

for user in `cat "/etc/passwd"|grep 'home'|grep 'false'|grep -v 'syslog' | cut -d: -f1 |sort`
do
[[ -e $dir$dir_user/$user ]] && {
####################VALIDACION DE SCRIPT#####################
pass="$(cat $dir$dir_user/$user | grep "senha" | awk '{print $2}')"
limite=$(cat $dir$dir_user/$user | grep "limite" | awk '{print $2}')
[[ $limite = @(HWID|TOKEN) ]] && NameTKID=${pass} || NameTKID=${pass}
data=$(cat $dir$dir_user/$user | grep "data" | awk '{print $2}')
data_sec=$(date +%s)
data_user=$(chage -l "$user" |grep -i co |awk -F ":" '{print $2}')
data_user_sec=$(date +%s --date="$data_user")
variavel_soma=$(($data_user_sec - $data_sec))
dias_use=$(($variavel_soma / 86400))
if [[ "$dias_use" -le 0 ]]; 
then
dias_use=0
fi
sl=$((dias_use + 1))
i=$((i + 1))
[[ -z "$limite" ]] && limite="5"
echo -e "\033[1;31m [ SCRIPT ] \033[1;37m "
####################VALIDACION DE SCRIPT#####################
} || {
####################VALIDACION DE PASSWD#####################
linea=$(cat /etc/passwd | grep -w ${user})
limite="$(cat /etc/passwd | grep -w ${user} | awk -F ':' '{split($5, a, ","); print a[1]}')"
if [[ "${linea}" =~ ,([^:]+): ]]; then
        NameTKID="${BASH_REMATCH[1]}"
fi
[[ -z "$limite" ]] && limite="5"
data_sec=$(date +%s)
data_user=$(chage -l "$user" |grep -i co |awk -F ":" '{print $2}')
data_user_sec=$(date +%s --date="$data_user")
variavel_soma=$(($data_user_sec - $data_sec))
dias_use=$(($variavel_soma / 86400))
[[ "$dias_use" -le 0 ]] && dias_use=0
sl=$((dias_use + 1))
i=$((i + 1))
echo -e "\033[1;31m [ SYSTEM ] \033[1;37m"
#read -p "Introduzca la contraseña manualmente o pulse ENTER: " pass
#[[ -z "$pass" ]] && pass="$user"
####################VALIDACION DE PASSWD#####################
}
[[ $(echo $limite) = "HWID" ]] && echo "$user:$user:HWID:$sl:$NameTKID" >> $file && echo -e "\033[1;37mUser $NameTKID \033[0;35m [\033[0;36m$limite\033[0;35m]\033[0;31m Backup [\033[1;31mOK\033[1;37m] con $sl DIAS\033[0m"
[[ $(echo $limite) = "TOKEN" ]] && echo "$user:$passTK:TOKEN:$sl:$NameTKID" >> $file && echo -e "\033[1;37mUser $NameTKID \033[0;35m [\033[0;36m$limite\033[0;35m]\033[0;31m Backup [\033[1;31mOK\033[1;37m] con $sl DIAS\033[0m"
[[ "$limite" =~ ^[0-9]+$ ]] && echo "$user:$NameTKID:$limite:$sl:$NameTKID" >> $file && echo -e "\033[1;37mUser $user \033[0;35m [\033[0;36mSSH\033[0;35m]\033[0;31m Backup [\033[1;31mOK\033[1;37m] con $sl DIAS\033[0m"
#sleep .2s
done
    # Obtener IP pública del servidor
    local ipserver=$(cat /bin/ejecutar/IPcgh 2>/dev/null || wget -qO- ipv4.icanhazip.com)

    # Enviar archivo y link
    ShellBot.sendDocument --chat_id "$chatuser" \
                             --document @${file} \
							 --caption  "🌐 Link de Descarga :\n<code>http://${ipserver}:${portFTP}/backup_usuarios.txt</code>" \
                             --parse_mode html 
						  

#    ShellBot.sendMessage --chat_id "${message_message_id[$id]}" \
#						 --reply_to_message_id "${message_message_id[$id]}" \
#                         --text "🌐 Link de descarga:\n\n<code>http://${ipserver}/backup_usuarios.txt</code>" \
#                         --parse_mode html
return
}

restore_fun () {
    chatuser="${message_chat_id[$id]}"
    local url="$1"
    local file="/root/recovery.txt"

    [[ -z $url ]] && {
        ShellBot.sendMessage --chat_id "$chatuser" --text "⚠️ Debes enviar el enlace del fichero de backup.\n\nEjemplo:\n<code>/restore http://mi-servidor/backup.txt</code>" --parse_mode html
        return
    }

    wget -q -O "$file" "$url" || {
        ShellBot.sendMessage --chat_id "$chatuser" --text "❌ No se pudo descargar el archivo desde: $url"
        return
    }

    while read -r line; do
        USER=$(echo "$line" | awk -F : '{print $1}')
        CLAVE=$(echo "$line" | awk -F : '{print $2}')
        LIMITE=$(echo "$line" | awk -F : '{print $3}')
        DIAS=$(echo "$line" | awk -F : '{print $4}')
        NameTKID=$(echo "$line" | awk -F : '{print $5}')

        if getent passwd "$USER" > /dev/null; then
            echo "Usuario $USER ya existe, saltando..."
        else
            add_new_user "$USER" "$CLAVE" "$DIAS" "$LIMITE" n n "$NameTKID"
            if [[ $? -eq 1 ]]; then
                echo "senha: $NameTKID" > /etc/adm-lite/userDIR/$USER
                echo "limite: $LIMITE" >> /etc/adm-lite/userDIR/$USER
                echo "data: $(date '+%C%y-%m-%d' -d " +$DIAS days")" >> /etc/adm-lite/userDIR/$USER
            fi
        fi
    done < "$file"

    ShellBot.sendMessage --chat_id "$chatuser" --text "✅ Restauración completada."
}




ajuda_fun () {
    ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action typing
    chatuser="${message_chat_id[$id]}"
    local _ADMIN=$(grep -w ${chatuser} /etc/adm-lite/liberados | head -1)
    local _creditos=$(grep -w ${chatuser} /etc/adm-lite/liberados | cut -d '|' -f2)

    local msg="✨━━━━━━━━━━━━━━━━━━━━━✨\n"
    [[ ${_ADMIN} ]] && msg+="<b>👑 BIENVENIDO SUPER ADMIN PREMIUM</b>\n" || msg+="<b>🔑 BIENVENIDO ADMIN RESELLER</b>\n"
    msg+="✨━━━━━━━━━━━━━━━━━━━━━✨\n"
    msg+="<i>😀 MENU DE ACCIONES RÁPIDAS 😀</i>\n"
    msg+="✨━━━━━━━━━━━━━━━━━━━━━✨\n"
    msg+="<b>🌐 IP Asignada:</b> <code>$(cat /bin/ejecutar/IPcgh)</code>\n"
    msg+="✨━━━━━━━━━━━━━━━━━━━━━✨\n"

    # MENÚ PARA SUPER ADMIN O ADMIN CON CREDITOS
    if [[ "$(grep -w "$chatuser" /etc/adm-lite/liberados | cut -d '|' -f2)" == "X" ]]; then
        msg+="<b>👥 Usuarios</b>\n"
        msg+="   • /agregar     ➝ <i>Agregar usuario SSH</i>\n"
        msg+="   • /token       ➝ <i>Agregar usuario TOKEN</i>\n"
        msg+="   • /hwid        ➝ <i>Agregar usuario HWID</i>\n"
        msg+="   • /demo        ➝ <i>Crear usuario demo (1 día)</i>\n"
        msg+="   • /usuarios    ➝ <i>Lista de usuarios</i>\n"
        msg+="   • /conectados  ➝ <i>Usuarios conectados</i>\n"
        msg+="   • /borrar      ➝ <i>Eliminar usuario</i>\n\n"

        msg+="<b>⏳ Renovaciones</b>\n"
        msg+="   • /renovar     ➝ <i>Renovación directa</i>\n"
        msg+="   • /renovarM    ➝ <i>Renovación + días ➕</i>\n"
        msg+="   • /renovarQ    ➝ <i>Renovación - días ➖</i>\n\n"

        msg+="<b>⚙️ VPS</b>\n"
        [[ -e /etc/v2ray/config.json ]] && msg+="   • /v2ray       ➝ <i>Agregar usuario V2Ray</i>\n"
        msg+="   • /puertos     ➝ <i>Puertos activos</i>\n"
        msg+="   • /infovps     ➝ <i>Información del VPS</i>\n"
        msg+="   • /liberados   ➝ <i>Usuarios liberados</i>\n\n"

        msg+="<b>🔐 Gestión de Admin</b>\n"
        [[ ${_ADMIN} ]] && msg+="   • /aggADM      ➝ <i>Agregar admin</i>\n"
        [[ ${_ADMIN} ]] && msg+="   • /creditos    ➝ <i>Autorizar créditos</i>\n"
        [[ ${_ADMIN} ]] && msg+="   • /admkill     ➝ <i>Quitar autorización</i>\n"
        [[ ${_ADMIN} ]] && {
        msg+="\n<b>📝 Herramientas Extra</b>\n"
        msg+="   • /backup       ➝ <i>Generar Respaldo de CLientes</i>\n"
        msg+="   • /restore      ➝ <i>Restaurar Clientes Externos</i>\n"
		}
		

    # MENÚ PARA ADMIN RESELLER (con créditos limitados)
    elif [[ "$(grep -w "$chatuser" /etc/adm-lite/liberados | cut -d '|' -f2)" -gt "0" ]] 2>/dev/null; then
        msg+="<b>👥 Usuarios</b>\n"
        msg+="   • /agregar     ➝ <i>Agregar usuario SSH</i>\n"
        msg+="   • /token       ➝ <i>Agregar usuario TOKEN</i>\n"
        msg+="   • /hwid        ➝ <i>Agregar usuario HWID</i>\n"
        msg+="   • /demo        ➝ <i>Crear usuario demo (1 día)</i>\n"
        msg+="   • /usreg       ➝ <i>Lista de usuarios</i>\n"
        msg+="   • /usconnect   ➝ <i>Usuarios conectados</i>\n\n"

        msg+="<b>⏳ Renovaciones</b>\n"
        msg+="   • /renovar     ➝ <i>Renovación directa</i>\n"
        msg+="   • /renovarM    ➝ <i>Renovación + días ➕</i>\n"
        msg+="   • /renovarQ    ➝ <i>Renovación - días ➖</i>\n\n"

        [[ -e /etc/v2ray/config.json ]] && msg+="<b>⚙️ VPS</b>\n   • /v2ray ➝ <i>Agregar usuario V2Ray</i>\n"

    # MENÚ PARA USUARIO SIN PERMISOS
    else
        msg+="<b>⚠️ Acceso Restringido</b>\n"
        msg+="   • /access ➝ <i>Solicitar acceso (/access user pass)</i>\n"
        msg+="━━━━━━━━━━━━━━━━━━━━━\n"
        msg+="<i>Si no tienes credenciales, pide acceso al dueño del bot.</i>\n"
        msg+="<b>📌 Tu ID:</b> <code>${chatuser}</code>\n"
    fi

    msg+="✨━━━━━━━━━━━━━━━━━━━━━✨\n"

    ShellBot.sendMessage --chat_id "${message_chat_id[$id]}" \
                         --reply_to_message_id "${message_message_id[$id]}" \
                         --text "$(echo -e "$msg")" \
                         --parse_mode html
    return 0
}

infousers () {
_cont=1
for namer in `grep '/home' /etc/passwd | grep 'false' | grep -v 'syslog' | cut -d: -f1`; do
[[ "$namer" = "" ]] && break
data_sec=$(date +%s)
data_user=$(chage -l "$namer" |grep -i co |awk -F ":" '{print $2}')
if [ "$data_user" != " never" ]; then
data_user_sec=$(date +%s --date="$data_user")
 if [ "$data_sec" -gt "$data_user_sec" ]; then
dias_user="CADUCADO"
else
variavel_soma=$(($data_user_sec - $data_sec))
dias_use=$(($variavel_soma / 86400))
dias_user="$dias_use"
 fi
fi
[[ "$data_user" = " never" ]] && dias_user="Null"
if [ -e $dir_user/$namer ]; then
_sen=$(cat $dir_user/$namer | grep "senha" | awk '{print $2}')
_limit=$(cat $dir_user/$namer | grep "limite" | awk '{print $2}')
[[ ${_limit} = @(HWID|TOKEN) ]] && {
_sen=$namer
namer=$(cat $dir_user/$namer | grep "senha" | awk '{print $2}')
}
else
local linea=$(cat /etc/passwd | grep -w ${namer})
if [[ "${linea}" =~ ,([^:]+): ]]; then
        _sen="${BASH_REMATCH[1]}"
fi
_limit="$(cat /etc/passwd | grep -w ${namer} | awk -F ':' '{split($5, a, ","); print a[1]}')"
[[ ${_limit} = @(HWID|TOKEN) ]] && {
_sen=$namer
namer="TK0${_cont}"
}
fi
[[ -z "$_limit" ]] && _limit="Null"
[[ -z "$_sen" ]] && _sen="Null"
_client+="$namer|$_sen|$_limit|$dias_user\n"
let _cont++;
done
local userinfo+="$userinfo"
return 0
}

info_fun () {
infousers
if [ "$?" = "1" ]; then
local msg
          msg='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+=" COMANDO NO EJECUTADO \n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'   
				ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
							--reply_to_message_id "${message_message_id[$id]}" \
							--text "<i>$(echo -e $msg)</i>" \
							--parse_mode html
	return 0
else
    local msg=' =================================== \n'
	cont=1
    for lines in `echo -e "${_client}"`; do
    [[ -z ${lines} ]] && break
          #user=$(echo "$lines" | awk '{print $1}')
          user=$(echo "$lines" | cut -d '|' -f1)
          sen=$(echo "$lines"  | cut -d '|' -f2)
          limit=$(echo "$lines" | cut -d '|' -f3)
          data=$(echo "$lines"  | cut -d '|' -f4)
          msg+=" USER (${cont}) : $user\n"
          msg+=" PASSWD : $sen\n"
          msg+=" EXPIRA : $data\n"
          msg+=" LIMITE : $limit\n"
		  let cont++;
		  msg+=' =================================== \n'
    done 
	unset _client
	call.Chat_long "${msg}"
#			ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
#							--reply_to_message_id "${message_message_id[$id]}" \
#							--text "<i>$(echo -e $msg)</i>" \
#							--parse_mode html
    return 0
fi
}

call.Chat_long () {
listIDSRC=$1
ShellBot.sendChatAction --chat_id $chatuser --action typing
max_length=4000
# Dividir el texto en partes más pequeñas
while [ -n "$listIDSRC" ]; do
    # Tomar una porción del texto dentro del límite de longitud
    local parte="${listIDSRC:0:$max_length}"
    # Enviar la parte como un mensaje
	ShellBot.sendMessage --chat_id "${message_chat_id[$id]}" \
						--reply_to_message_id "${message_message_id[$id]}" \
						--text "<i>$(echo -e ${parte})</i>" \
						--parse_mode html
    # Eliminar la parte ya enviada del texto largo
    listIDSRC="${listIDSRC:$max_length}"
done
return 0
}

function_dropb(){
    local pD=$(netstat -tulpn | awk '/dropbear/ {print $4}' | awk -F: '{print $NF}' | head -n 1)
    local log="/var/log/auth.log"
    local loginsukses='Password auth succeeded'
    clear

    local pids=$(pgrep -f "dropbear.*${pD}")

    for pid in $pids; do
        local pidlogs=$(grep "$pid" "$log" | grep "$loginsukses" | awk -F" " '{print $3}')

        if [ -n "$pidlogs" ]; then
            local login=$(grep "$pid" "$log" | grep "$pidlogs" | grep "$loginsukses")
            local PID=${pid}
            local user=$(echo "$login" | awk -F" " '{print $10}' | sed -r "s/'/ /g")
            local waktu=$(echo "$login" | awk -F" " '{print $2"-"$1,$3}')

            printf "%-16s %-8s %-13s\n" "$user" "$PID" "$waktu"
        fi
    done
}

fun_ovpn_onl () {
for userovpn in `cat /etc/passwd | grep ovpn | awk -F: '{print $1}'`; do
us=$(cat /etc/openvpn/openvpn-status.log | grep $userovpn | wc -l)
if [ "$us" != "0" ]; then
echo "$userovpn"
fi
done
}

online_fun () {
echo -e "FUNCION CONECTADOS"
    for user in $(grep '/home' /etc/passwd | grep 'false' | grep -v 'syslog' | cut -d: -f1); do
        # conexiones SSH
        local ssh_open=$(pgrep -u "$user" -f "sshd: $user*" | wc -l)
        # conexiones Dropbear
        [[ -e /etc/default/dropbear ]] && ssh_drop=$(function_dropb | grep "$user" | wc -l) || ssh_drop=0
        # conexiones OpenVPN
        [[ -e /etc/openvpn/openvpn-status.log ]] && ssh_ovpn=$(fun_ovpn_onl | grep "$user" | wc -l) || ssh_ovpn=0

        local user_pid=$((ssh_open + ssh_drop + ssh_ovpn))

        if [ "$user_pid" -gt 0 ]; then
            # Validación de HWID o TOKEN
            if [[ ${_limit} =~ ^(HWID|TOKEN)$ ]]; then
			linea=$(cat /etc/passwd | grep -w ${user})
			limite="$(cat /etc/passwd | grep -w ${user} | awk -F ':' '{split($5, a, ","); print a[1]}')"
			if [[ "${linea}" =~ ,([^:]+): ]]; then
					NameTKID="${BASH_REMATCH[1]}"
			fi
                nameFX=${NameTKID}
            else
                nameFX="$user"
            fi

            # Enviar mensaje individual por usuario
			 local msg="✨━━━━━━━━━━━━━━━━━━━━━✨\n"
			msg+="<b>👤 Usuario:</b> <code>$nameFX</code>\n"
			msg+="<b>🔌 Conexiones:</b> <code>$user_pid</code>\n"
			msg+="<b>🆔 ID Interno:</b> <code>$user</code>\n"
			msg+="✨━━━━━━━━━━━━━━━━━━━━━✨\n"
            call.Chat_long_inv "${msg}"
        fi
    done
}

call.Chat_long_inv () {
ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action typing
    local msg="$1"
    ShellBot.sendMessage --chat_id "${message_chat_id[$id]}" \
						 --reply_to_message_id "${message_message_id[$id]}" \
                         --text "<i>$(echo -e "$msg")</i>" \
                         --parse_mode html
    return 0
}

online_fun_OLD () {
local msg
unset msg
local msg=' -----------------------\n'
for user in `grep '/home' /etc/passwd | grep 'false' | grep -v 'syslog' | cut -d: -f1`; do
local ssh_open=$(pgrep -u "$user" -f "sshd: $user*" | wc -l)
[[ -e /etc/default/dropbear ]] && ssh_drop=$(function_dropb | grep "$user" | wc -l) || ssh_drop='0'
[[ -e /etc/openvpn/openvpn-status.log ]] && ssh_ovpn=$(fun_ovpn_onl | grep "$user" | wc -l) || ssh_ovpn="0"
u_pid=$(($ssh_open + $ssh_drop))
user_pid=$(($u_pid + $ssh_ovpn))
if [ "$user_pid" -gt "0" ]; then
    msg+=" USER : $user : $user_pid\n"
fi
done
msg+=' ----------------------- \n'
call.Chat_long "${msg}"
}

usv2link () {
[[ ! -z $1 ]] && v2link=$1
[[ ! -z $2 ]] && Img=$2
[[ ! -z $3 ]] && usr=$3

		  ShellBot.sendDocument --chat_id ${message_chat_id[$id]} \
                             --document @${Img} \
                             --caption  "$(echo -e "<code>$v2link</code> ")" \
							 --parse_mode html 


}

criarusrTK () {
ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action typing
[[ -e /bin/ejecutar/token ]] && passTOKEN=$(cat /bin/ejecutar/token) || passTOKEN="ChumoGHPlus"
#[[ -e /etc/adm-lite/liberados ]] && _limC=$(cat /etc/adm-lite/liberados | cut -d '|' -f2)
local _name="$1"
local _token="$2"
local daysrnf="$3"
if cat /etc/passwd |grep ${_token}: |grep -vi [a-z]${_token} |grep -v [0-9]${_token} > /dev/null; then
return 1
fi
[[ $(dpkg --get-selections|grep -w "openvpn"|head -1) ]] && [[ -e /etc/openvpn/openvpn-status.log ]] && {
local newfile='s'
local ovpnauth='s'
}
[[ -z ${newfile} ]] && newfile='n'
[[ -z ${ovpnauth} ]] && ovpnauth='n'
valid=$(date '+%C%y-%m-%d' -d " +${daysrnf} days")
datexp=$(date "+%d/%m/%Y" -d " +${daysrnf} days")
local d_reg=$(( daysrnf + 1 ))
#UserAll new_user "${_token}" "${passTOKEN}" "${daysrnf}" "TOKEN" "${newfile}" "${ovpnauth}" &>/dev/null
add_new_user "${_token}" "${passTOKEN}" "${d_reg}" "TOKEN" "${newfile}" "${ovpnauth}" "${_name}" &>/dev/null
if [ $(cat /etc/passwd | grep -w ${_token}) ]; then
reg_users ${_token}
		echo "senha: ${_name}" > /etc/adm-lite/userDIR/${_token}
		echo "limite: TOKEN" >> /etc/adm-lite/userDIR/${_token}
		echo "data: ${valid}" >> /etc/adm-lite/userDIR/${_token}
		_client="$_name $_token $datexp TOKEN ${daysrnf}"
		return 0
else
		return 1
fi
}

criarusrHWID () {
ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action typing
local _name="$1"
local hwid="$2"
local daysrnf="$3"
if cat /etc/passwd |grep ${hwid}: |grep -vi [a-z]${hwid} |grep -v [0-9]${hwid} > /dev/null; then
return 1
fi
[[ $(dpkg --get-selections|grep -w "openvpn"|head -1) ]] && [[ -e /etc/openvpn/openvpn-status.log ]] && {
newfile='s'
ovpnauth='s'
}
[[ -z ${newfile} ]] && newfile='n'
[[ -z ${ovpnauth} ]] && ovpnauth='n'
valid=$(date '+%C%y-%m-%d' -d " +${daysrnf} days")
datexp=$(date "+%d/%m/%Y" -d " +${daysrnf} days")
local d_reg=$(( daysrnf + 1 ))
#UserAll new_user "${_token}" "${passTOKEN}" "${daysrnf}" "TOKEN" "${newfile}" "${ovpnauth}" &>/dev/null
add_new_user "${hwid}" "${hwid}" "${d_reg}" "HWID" "${newfile}" "${ovpnauth}" "${_name}" &>/dev/null
if [ $(cat /etc/passwd | grep -w ${hwid}) ]; then
reg_users ${hwid}
		echo "senha: ${_name}" > /etc/adm-lite/userDIR/${hwid}
		echo "limite: HWID" >> /etc/adm-lite/userDIR/${hwid}
		echo "data: ${valid}" >> /etc/adm-lite/userDIR/${hwid}
		_client="$_name $hwid $datexp HWID ${daysrnf}"
		return 0
else
		return 1
fi
}

ports_ () {
rm -f ./textoports 
unset puertos texto texto_ svcs porta
local texto
local texto_
local puertos
local svcs
local PT=$(lsof -V -i tcp -P -n | grep -v "ESTABLISHED" |grep -v "COMMAND" | grep "LISTEN")
local _ps="$(ps x)"
x=1
for porta in `echo -e "$PT" | cut -d: -f2 | cut -d' ' -f1 | uniq`; do
	[[ -z $porta ]] && continue
	porta[$x]="$porta"
	#echo "$porta - $(echo -e "$PT" | grep -w "$porta" | awk '{print $1}' | uniq | tail -1)"
	svcs[$x]="$(echo -e "$PT" | grep -w "$porta" | awk '{print $1}' | uniq | tail -1)"
	let x++;
done

for((i=1; i<$x; i++)); do
[[ ! -z ${svcs[$i]} ]] && texto=" ${pPIniT} ${svcs[$i]}:  ${porta[$i]}" || texto=''
[[ ${svcs[$i]} = "apache2" ]] && texto=" ${pPIniT} APACHE:  ${porta[$i]}"
[[ ${svcs[$i]} = "nginx" ]] && texto=" ${pPIniT} WEB-NGinx:  ${porta[$i]}"
[[ ${svcs[$i]} = "node" ]] && texto=" ${pPIniT} WebSocket:  ${porta[$i]}"
[[ ${svcs[$i]} = "clash" ]] && texto=" ${pPIniT} Clash:  ${porta[$i]}"
[[ ${svcs[$i]} = "psiphond" ]] && texto=" ${pPIniT} PSIPHON:  ${porta[$i]}"
[[ ${svcs[$i]} = "xray-v2-u" ]] && texto=" ${pPIniT} XRAY/UI:  ${porta[$i]}"
[[ ${svcs[$i]} = "v2-ui" ]] && texto=" ${pPIniT} V2-UI/WEB:  ${porta[$i]}"
[[ ${svcs[$i]} = "xray-linu" ]] && texto=" ${pPIniT} XRAY/UI:  ${porta[$i]}"
[[ ${svcs[$i]} = "x-ui" ]] && texto=" ${pPIniT} XUI/WEB:  ${porta[$i]}"
[[ ${svcs[$i]} = "openvpn" ]] && texto=" ${pPIniT} OPENVPN-TCP:  ${porta[$i]}"
[[ ${svcs[$i]} = "squid" ]] && texto=" ${pPIniT} SQUID:  ${porta[$i]}"
[[ ${svcs[$i]} = "squid3" ]] && texto=" ${pPIniT} SQUID:  ${porta[$i]}"
[[ ${svcs[$i]} = "dropbear" ]] && texto=" ${pPIniT} DROPBEAR:  ${porta[$i]}"
[[ ${svcs[$i]} = "python3" ]] && texto=" ${pPIniT} SOCKS/PYTHON3:  ${porta[$i]}"
[[ ${svcs[$i]} = "python" ]] && texto=" ${pPIniT} SOCKS/PYTHON:  ${porta[$i]}"
[[ ${svcs[$i]} = "obfs-serv" ]] && texto=" ${pPIniT} SSR (OBFS):  ${porta[$i]}"
[[ ${svcs[$i]} = "ss-server" ]] && texto=" ${pPIniT} SSR (LIV):  ${porta[$i]}"
[[ ${svcs[$i]} = "sshd" ]] && texto=" ${pPIniT} SSH: ${porta[$i]}"
[[ ${svcs[$i]} = "ssh" ]] && texto=" ${pPIniT} SSH: ${porta[$i]}"
[[ ${svcs[$i]} = "systemd-r" ]] && texto=" ${pPIniT} System-DNS:  ${porta[$i]}"
[[ ${svcs[$i]} = "stunnel4" ]] && texto=" ${pPIniT} SSL:  ${porta[$i]}"
[[ ${svcs[$i]} = "stunnel" ]] && texto=" ${pPIniT} SSL:  ${porta[$i]}"
[[ ${svcs[$i]} = "v2ray" ]] && texto=" ${pPIniT} V2RAY:  ${porta[$i]}"
[[ ${svcs[$i]} = "xray" ]] && texto=" ${pPIniT} XRAY:  ${porta[$i]}"
[[ ${svcs[$i]} = "badvpn-ud" ]] && texto=" ${pPIniT} BadVPN:  ${porta[$i]}"
[[ ${svcs[$i]} = "trojan" ]] && texto=" ${pPIniT} Trojan-GO:  ${porta[$i]}"
[[ ${svcs[$i]} = "sslh" ]] && texto=" ${pPIniT} SSLH:  ${porta[$i]}"
[[ ${svcs[$i]} = "nc.tradit" ]] && texto=" ${pPIniT} GenADM-Keys: \033[1;33m✔️"
[[ ${svcs[$i]} = "filebrows" ]] && texto=" ${pPIniT} FileBrowser:  ${porta[$i]}"
[[ ${svcs[$i]} = "rpcbind" ]] && texto=" ${pPIniT} RPCBind:  ${porta[$i]}"
[[ ${svcs[$i]} = "snell-ser" ]] && texto=" ${pPIniT} SNell:  ${porta[$i]}"
[[ ${svcs[$i]} = "dns-serve" ]] && texto=" ${pPIniT} SlowDNS:  ${porta[$i]}"
[[ ${svcs[$i]} = "openvpn" ]] && texto=" ${pPIniT} OPENVPN-UDP:  ${porta[$i]}"
[[ ${svcs[$i]} = "udpServer" ]] && texto=" ${pPIniT} UDPServer:  ${porta[$i]}"
[[ ${svcs[$i]} = "hysteria" ]] && texto=" ${pPIniT} HysteriaUDP:  ${porta[$i]}"
[[ ${svcs[$i]} = "UDP-Custo" ]] && texto=" ${pPIniT} UDP-Custom:  ${porta[$i]}"
[[ ${svcs[$i]} = "php" ]] && texto=" ${pPIniT} AToken:  ${porta[$i]}"
    i=$(($i+1))
[[ ! -z ${svcs[$i]} ]] && texto_=" ${pPIniT} ${svcs[$i]}: ${porta[$i]}" || texto_=''
[[ ${svcs[$i]} = "apache2" ]] && texto_=" ${pPIniT} Apache-WEB: ${porta[$i]}"
[[ ${svcs[$i]} = "nginx" ]] && texto_=" ${pPIniT} WEB-NGinx: ${porta[$i]}"
[[ ${svcs[$i]} = "node" ]] && texto_=" ${pPIniT} WebSocket: ${porta[$i]}"
[[ ${svcs[$i]} = "clash" ]] && texto_=" ${pPIniT} Clash: ${porta[$i]}"
[[ ${svcs[$i]} = "psiphond" ]] && texto_=" ${pPIniT} PSIPHON: ${porta[$i]}"
[[ ${svcs[$i]} = "xray-v2-u" ]] && texto_=" ${pPIniT} XRAY/UI: ${porta[$i]}"
[[ ${svcs[$i]} = "v2-ui" ]] && texto_=" ${pPIniT} V2-UI/WEB: ${porta[$i]}"
[[ ${svcs[$i]} = "xray-linu" ]] && texto_=" ${pPIniT} XRAY/UI: ${porta[$i]}"
[[ ${svcs[$i]} = "x-ui" ]] && texto_=" ${pPIniT} XUI/WEB: ${porta[$i]}"
[[ ${svcs[$i]} = "openvpn" ]] && texto_=" ${pPIniT} OPENVPN-TCP: ${porta[$i]}"
[[ ${svcs[$i]} = "squid" ]] && texto_=" ${pPIniT} SQUID: ${porta[$i]}"
[[ ${svcs[$i]} = "squid3" ]] && texto_=" ${pPIniT} SQUID: ${porta[$i]}"
[[ ${svcs[$i]} = "dropbear" ]] && texto_=" ${pPIniT} DROPBEAR: ${porta[$i]}"
[[ ${svcs[$i]} = "python3" ]] && texto_=" ${pPIniT} SOCKS/PYTHON3: ${porta[$i]}"
[[ ${svcs[$i]} = "python" ]] && texto_=" ${pPIniT} SOCKS/PYTHON: ${porta[$i]}"
[[ ${svcs[$i]} = "obfs-serv" ]] && texto_=" ${pPIniT} SSR (OBFS): ${porta[$i]}"
[[ ${svcs[$i]} = "ss-server" ]] && texto_=" ${pPIniT} SSR (LIV): ${porta[$i]}"
[[ ${svcs[$i]} = "sshd" ]] && texto_=" ${pPIniT} SSH: ${porta[$i]}"
[[ ${svcs[$i]} = "ssh" ]] && texto_=" ${pPIniT} SSH: ${porta[$i]}"
[[ ${svcs[$i]} = "systemd-r" ]] && texto_=" ${pPIniT} System-DNS: ${porta[$i]}"
[[ ${svcs[$i]} = "stunnel4" ]] && texto_=" ${pPIniT} SSL: ${porta[$i]}"
[[ ${svcs[$i]} = "stunnel" ]] && texto_=" ${pPIniT} SSL: ${porta[$i]}"
[[ ${svcs[$i]} = "v2ray" ]] && texto_=" ${pPIniT} V2RAY: ${porta[$i]}"
[[ ${svcs[$i]} = "xray" ]] && texto_=" ${pPIniT} XRAY: ${porta[$i]}"
[[ ${svcs[$i]} = "badvpn-ud" ]] && texto_=" ${pPIniT} BadVPN: ${porta[$i]}"
[[ ${svcs[$i]} = "trojan" ]] && texto_=" ${pPIniT} Trojan-GO: ${porta[$i]}"
[[ ${svcs[$i]} = "sslh" ]] && texto_=" ${pPIniT} SSLH: ${porta[$i]}"
[[ ${svcs[$i]} = "nc.tradit" ]] && texto_=" ${pPIniT} GenADM-Keys: \033[1;33m✔️"
[[ ${svcs[$i]} = "filebrows" ]] && texto_=" ${pPIniT} FileBrowser: ${porta[$i]}"
[[ ${svcs[$i]} = "rpcbind" ]] && texto_=" ${pPIniT} RPCBind: ${porta[$i]}"
[[ ${svcs[$i]} = "snell-ser" ]] && texto_=" ${pPIniT} SNell: ${porta[$i]}"
[[ ${svcs[$i]} = "dns-serve" ]] && texto_=" ${pPIniT} SlowDNS: ${porta[$i]}"
[[ ${svcs[$i]} = "openvpn" ]] && texto_=" ${pPIniT} OPENVPN-UDP: ${porta[$i]}"
[[ ${svcs[$i]} = "udpServer" ]] && texto_=" ${pPIniT} UDPServer: ${porta[$i]}"
[[ ${svcs[$i]} = "hysteria" ]] && texto_=" ${pPIniT} HysteriaUDP: ${porta[$i]}"
[[ ${svcs[$i]} = "UDP-Custo" ]] && texto_=" ${pPIniT} UDP-Custom: ${porta[$i]}"
[[ ${svcs[$i]} = "php" ]] && texto_=" ${pPIniT} AToken: ${porta[$i]}"
msg+="$texto $texto_\n"
done 
local _PT=$(lsof -V -i UDP -P -n | grep -v "ESTABLISHED" |grep -v "COMMAND"|grep -E 'openvpn|dns-serve|udpServer')
x=1
for porta in `echo -e "$_PT" | cut -d: -f2 | cut -d' ' -f1 | uniq`; do
	[[ -z $porta ]] && continue
	_porta[$x]="$porta"
	_svcs[$x]="$(echo -e "$_PT" | grep -w "$porta" | awk '{print $1}' | uniq | tail -1)"
	let x++;
done
for((i=1; i<$x; i++)); do
[[ ! -z ${_svcs[$i]} ]] && texto=" ${pPIniT} ${_svcs[$i]}: ${_porta[$i]}" || texto=''
[[ ${_svcs[$i]} = "dns-serve" ]] && texto=" ${pPIniT} SlowDNS: ${_porta[$i]}"
[[ ${_svcs[$i]} = "openvpn" ]] && texto=" ${pPIniT} OPENVPN-UDP: ${_porta[$i]}"
[[ ${_svcs[$i]} = "udpServer" ]] && texto=" ${pPIniT} UDPServer: ${_porta[$i]}"
[[ ${_svcs[$i]} = "hysteria" ]] && texto=" ${pPIniT} HysteriaUDP: ${_porta[$i]}"
[[ ${_svcs[$i]} = "UDP-Custo" ]] && texto=" ${pPIniT} UDP-Custom: ${_porta[$i]}"
i=$(($i+1))
[[ ! -z ${_svcs[$i]} ]] && texto_=" ${pPIniT} ${_svcs[$i]}: ${_porta[$i]}" || texto_=''
[[ ${_svcs[$i]} = "dns-serve" ]] && texto_=" ${pPIniT} SlowDNS: ${_porta[$i]}"
[[ ${_svcs[$i]} = "openvpn" ]] && texto_=" ${pPIniT} OPENVPN-UDP: ${_porta[$i]}"
[[ ${_svcs[$i]} = "udpServer" ]] && texto_=" ${pPIniT} UDPServer: ${_porta[$i]}"
[[ ${_svcs[$i]} = "hysteria" ]] && texto_=" ${pPIniT} HysteriaUDP: ${_porta[$i]}"
[[ ${_svcs[$i]} = "UDP-Custo" ]] && texto_=" ${pPIniT} UDP-Custom: ${_porta[$i]}"
msg+="$texto $texto_\n"
#echo -e "$texto $texto_"  >> ./textoports 
done
}

criarusr () {
ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action typing
local users=$(grep '/home' /etc/passwd | grep 'false' | grep -v 'syslog' | cut -d: -f1)
name="$1"
if [ -z $name ]; then
return 1
fi
if echo -e "${users}" | grep -w $name ; then
return 1
fi
pass="$2"
daysrnf="$3"
limit="$4"
_uID="$5"
[[ $(dpkg --get-selections|grep -w "openvpn"|head -1) ]] && [[ -e /etc/openvpn/openvpn-status.log ]] && {
newfile='s'
ovpnauth='s'
}
[[ -z ${newfile} ]] && newfile='n'
[[ -z ${ovpnauth} ]] && ovpnauth='n'
valid=$(date '+%C%y-%m-%d' -d " +$daysrnf days")
datexp=$(date "+%d/%m/%Y" -d " +$daysrnf days")
add_new_user "${name}" "${pass}" "${daysrnf}" "${limit}" "${newfile}" "${ovpnauth}" "${pass}" &>/dev/null
if [ $(cat /etc/passwd | grep -w ${name}) ]; then
reg_users ${name}
		echo "senha: ${name}" > /etc/adm-lite/userDIR/${name}
		echo "limite: ${limit}" >> /etc/adm-lite/userDIR/${name}
		echo "data: ${valid}" >> /etc/adm-lite/userDIR/${name}
		_client="$name $pass $datexp $limit $daysrnf"
		#echo "$name $pass $datexp $limit" > ./criarusr-txt
		return 0
else
        print_center -verm2 "Error, Usuario no creado"
		return 1
fi
}

useradd_fun () {

[[ "$1" = "" ]] && exec="error"
[[ "$2" = "" ]] && exec="error"
[[ "$3" = "" ]] && exec="error"
[[ "$4" = "" ]] && exec="error"
if [ "$exec" = "error" ]; then
local msg
         msg='━━━━━━━━━━━━━━━━━━━━━ \n'
         msg+=" FORMA DE USAR ESTA OPC\n"
         msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
		 msg+=" DEBES ENVIAR EL COMANDO \n /agregar Nombre_User Clave Tiempo Limite\n"
		 msg+="━━━━━━━━━━━━━━━━━━━━━ \n"
         msg+='<code>/agregar admin admin 30 1</code>\n'
         msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
						ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
									--reply_to_message_id "${message_message_id[$id]}" \
									--text "<i>$(echo -e $msg)</i>" \
									--parse_mode html
   return 0
fi
criarusr "$1" "$2" "$3" "$4"
if [ "$?" = "1" ]; then
local msg
         msg='━━━━━━━━━━━━━━━━━━━━━ \n'
         msg+=" ERROR INTERNO RETURN 0x0012\n"
         msg+=" USUARIO $1 YA ESTA REGISTRADO!!\n"
         msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
         ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
							--text "$(echo -e $msg)" \
							--parse_mode markdown
return 0
else
[[ -e /etc/adm-lite/liberados ]] && _restM=$(cat /etc/adm-lite/liberados | grep -w ${chatuser} | cut -d '|' -f2)
local myID="${chatuser}"
[[ ${_restM} = 'X' ]] && { 
_newCRED='9999'
} || {

[[ ${_restM} -le 0 ]] && {
sed -i "/${myID}/d" /etc/adm-lite/liberados
local msg
         msg='━━━━━━━━━━━━━━━━━━━━━ \n'
         msg+=" ⚠ ERROR INTERNO RETURN 0x0013 ⚠\n"
         msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
         msg+=' 🙍 IMPOSIBLRE REGISTRAR USUARIO 🙍\n'
         msg+=' 💸 SUS CREDITOS SE HAN AGOTADO 💸 💸 \n'
         msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
         ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
							--text "$(echo -e $msg)" \
							--parse_mode markdown
return 0
}
_newCRED=$((${_restM} - 1))
}

[[ "$_client" = "" ]] && return
          usr=$(echo "$_client" | awk '{print $1}')
          sen=$(echo "$_client"  | awk '{print $2}')
          dia=$(echo "$_client" | awk '{print $3}')
          limit=$(echo "$_client" | awk '{print $4}')
          _mDIAS=$(echo "$_client" | awk '{print $5}')
          local msg='━━━━━━━━━━━━━━━━━━━━━ \n'
		  #ports_
          #msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+=" 💻 TIENES ${_newCRED} CREDITOS 💻  \n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+="Host/IP-Address : <code>$(cat /bin/ejecutar/IPcgh)</code>\n"
          msg+="USUARIO : <code>$usr</code>\n"
          msg+="PASSWD  : <code>$sen</code>\n"
          msg+="DURACION: $dia\n"
          msg+="LIMITE  : $limit\n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
[[ ${_restM} = 'X' ]] || sed -i "/${myID}/d" /etc/adm-lite/liberados
[[ ${_restM} = 'X' ]] || echo -e "${myID}|${_newCRED}" >> /etc/adm-lite/liberados
[[ -e /etc/adm-lite/slow/dnsi/domain_ns ]] && msg+=" DOMINIO NS : <code>$(cat < /etc/adm-lite/slow/dnsi/domain_ns)</code> \n"
[[ -e /etc/adm-lite/slow/dnsi/server.pub ]] && msg+=" KEY PUBLIC : <code>$(cat < /etc/adm-lite/slow/dnsi/server.pub)</code> \n"
[[ -e /etc/adm-lite/slow/dnsi/protc && -e /etc/adm-lite/slow/dnsi/puerto ]] && msg+="PROTOCOLO : $(cat < /etc/adm-lite/slow/dnsi/protc) -> <code>$(cat < /etc/adm-lite/slow/dnsi/puerto)</code> \n"
		  msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
		  ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
			--reply_to_message_id "${message_message_id[$id]}" \
			--text "<i>$(echo -e $msg)</i>" \
			--parse_mode html
[[ -z ${callback_query_from_username} ]] && local usrLOP=${message_from_username} || local usrLOP=${callback_query_from_username}
msg+=" ADM : @${usrLOP} CREO a <code>$usr</code>con ${_mDIAS} Dias \n"
msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
[[ -e /bin/ejecutar/notyadd ]] && {
[[ -e /etc/adm-lite/liberados ]] && AdminDB=$(cut -d'|' -f1 /etc/adm-lite/liberados | head -n 1) || AdminDB=$(cat /etc/adm-lite/liberados | cut -d '|' -f1| head -1)
if [ ${message_chat_id[$id]} == ${AdminDB} ]; then
    echo "Mensaje no enviado"
else
    call.mensaje ${AdminDB} "${msg}"
fi
}
return 0
fi
}

renew () {
local _user="$1"
local _time="$2"
local _ruta="$3"
[[ -z $_user ]] && return 1

# INICIO DE VERIFICACION
local fecha_expiracion=$(chage -l $_user | grep -i co | cut -d: -f2)
local expiracion=$(date -d "$fecha_expiracion" +%s)
local hoy=$(date +%s)
local dias_restantes=$(( (expiracion - hoy) / 86400 ))
# FIN NUEVA VERIFICACION


    if [[ ${_ruta} = @(m|M) ]]; then
        # Acción si _ruta es "M"
        if [[ ${dias_restantes} -ge 0 ]]; then
            _time=$((dias_restantes + _time))
        fi
    elif [[ ${_ruta} = @(Q|q) ]]; then
		   [[ ${dias_restantes} -ge 0 ]] && {
				if [[ ${_time} -gt ${dias_restantes} ]]; then
					echo "No es posible restar porque el tiempo es mayor a los días restantes."
					return 2
				else
					_time=$((dias_restantes - _time))
				fi
			}
    fi


if cat /etc/passwd |grep -w "${_user}": |grep -vi [a-z]${_user} |grep -v [0-9]${_user} > /dev/null; then

[[ $(passwd --status ${_user}|cut -d ' ' -f2) = "L" ]] && usermod -U ${_user}



local limite=$(cat /etc/passwd | grep -w ${_user} | awk -F ':' '{split($5, a, ","); print a[1]}')
[[ -z "$limite" ]] && limite="null"
[[ $(passwd --status ${_user}|cut -d ' ' -f2) = "L" ]] && usermod -U ${_user}
[[ -z ${_ruta} ]] && _ruta='♻'
local datexp=$(date "+%d/%m/%Y" -d "+ ${_time} days")
local localtiempo=$((_time + 1))
local valid=$(date '+%C%y-%m-%d' -d " + ${localtiempo} days")
	if chage -E ${valid} ${_user} ; then 
		chage -d ${valid} -M ${localtiempo} ${_user}
		local usr_var=$(cat $dir_user/${_user} | grep -v "data")
		echo -e "${usr_var}" > $dir_user/${_user}
		echo -e "data: $valid" >> $dir_user/${_user}
		pkill -u ${_user}
		_client+="${_user} R_****${_ruta} $datexp ${limite} $_time"
		return 0
	else
		return 3
	fi
else
return 1
fi
}

renew_cli_add(){
ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action typing
[[ "$1" = "" ]] && exec="error"
[[ "$2" = "" ]] && exec="error"
[[ -z $1 ]] && local _name='My_User' || local _name=$1
local _time=$2
if [ "$exec" = "error" ]; then
local msg
         msg='━━━━━━━━━━━━━━━━━━━━━ \n'
         msg+=" RENOVACION CON DIAS ACUMULATIVOS \n"
         msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
		 msg+=" DEBES ENVIAR EL COMANDO \n /renovarM Nombre_User dias\n"
		 msg+="━━━━━━━━━━━━━━━━━━━━━ \n"
         msg+=' <code>/renovarM ${_name} 30</code> \n'
         msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
						ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
									--reply_to_message_id "${message_message_id[$id]}" \
									--text "<i>$(echo -e $msg)</i>" \
									--parse_mode html
   return 0
fi
renew "${_name}" "${_time}" "M"
if [ "$?" = "1" ]; then
local msg='━━━━━━━━━━━━━━━━━━━━━ \n'
      msg+=" ERROR INTERNO RETURN 0x0010\n"
      msg+=" USUARIO ${_name} NO EXISTE !!!\n"
      msg+='━━━━━━━━━━━━━━━━━━━━━ \n'   
      ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
				--text "$(echo -e $msg)" \
				--parse_mode html
return 0
elif [[ "$?" = "2" ]]; then
      msg+=" ERROR INTERNO RETURN 0x0015\n"
      msg+=" LOS DIAS SON MAYOR AL TIEMPO RESTANTE !!!\n"
      msg+='━━━━━━━━━━━━━━━━━━━━━ \n'   
      ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
				--text "$(echo -e $msg)" \
				--parse_mode html
return 0
elif [[ "$?" = "3" ]]; then
      msg+=" ERROR INTERNO RETURN 0x0022\n"
      msg+=" DETALLE DESCONOCIDO SOBRE EL $_name !!!\n"
      msg+='━━━━━━━━━━━━━━━━━━━━━ \n'   
      ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
				--text "$(echo -e $msg)" \
				--parse_mode html
return 0
else
[[ -e /etc/adm-lite/liberados ]] && _restM=$(cat /etc/adm-lite/liberados | grep -w ${chatuser} | cut -d '|' -f2)
local myID="${chatuser}"
echo -e "DIAS ACTUAL ${_restM} - ID ${myID}"
[[ ${_restM} = 'X' ]] && { 
_newCRED='9999'
} || {

[[ ${_restM} -le 0 ]] && {
sed -i "/${myID}/d" /etc/adm-lite/liberados
local msg='━━━━━━━━━━━━━━━━━━━━━ \n'
      msg+=" ⚠ ERROR INTERNO RETURN 0x0013 ⚠\n"
      msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
      msg+=' IMPOSIBLRE RENOVAR USUARIO \n'
      msg+=' 💸 SUS CREDITOS SE HAN AGOTADO 💸 \n'
      msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
      ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
				--text "$(echo -e $msg)" \
				--parse_mode markdown
return 0
}
local _newCRED=$((${_restM} - 1))
}
[[ "$_client" = "" ]] && return
local msg
local usr=$(echo "$_client" | awk '{print $1}')
local sen=$(echo "$_client"  | awk '{print $2}')
local dia=$(echo "$_client" | awk '{print $3}')
local limit=$(echo "$_client" | awk '{print $4}')
local _ftime=$(echo "$_client" | awk '{print $5}')
local msg='━━━━━━━━━━━━━━━━━━━━━ \n'
		  #ports_
          #msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+=" 💻 TIENES ${_newCRED} CREDITOS 💻  \n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+=" CLIENTE RENOVADO CON ${_ftime} DIAS \n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+="Host/IP-Address : <code>$(cat /bin/ejecutar/IPcgh)</code>\n"
          msg+="USUARIO : <code>$usr</code>\n"
          msg+="PASSWD  : <code>$sen</code>\n"
          msg+="DURACION: $dia\n"
          msg+="LIMITE  : $limit\n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
[[ ${_restM} = 'X' ]] || sed -i "/${myID}/d" /etc/adm-lite/liberados
[[ ${_restM} = 'X' ]] || echo -e "${myID}|${_newCRED}" >> /etc/adm-lite/liberados
[[ -e /etc/adm-lite/slow/dnsi/domain_ns ]] && msg+=" DOMINIO NS : <code>$(cat < /etc/adm-lite/slow/dnsi/domain_ns)</code> \n"
[[ -e /etc/adm-lite/slow/dnsi/server.pub ]] && msg+=" KEY PUBLIC : <code>$(cat < /etc/adm-lite/slow/dnsi/server.pub)</code> \n"
[[ -e /etc/adm-lite/slow/dnsi/protc && -e /etc/adm-lite/slow/dnsi/puerto ]] && msg+="PROTOCOLO : $(cat < /etc/adm-lite/slow/dnsi/protc) -> <code>$(cat < /etc/adm-lite/slow/dnsi/puerto)</code> \n"
		  msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
		  #URG="https://api.telegram.org/bot$TOKEN/sendPhoto"
		  #curl -s -X POST $URG -F chat_id=${message_chat_id[$id]} -F photo="@${Img}"
						ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
									--reply_to_message_id "${message_message_id[$id]}" \
									--text "<i>$(echo -e $msg)</i>" \
									--parse_mode html
[[ -z ${callback_query_from_username} ]] && local usrLOP=${message_from_username} || local usrLOP=${callback_query_from_username}
msg+=" ADM : @${usrLOP} CREO a <code>$usr</code>con ${_mDIAS} Dias \n"
msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
[[ -e /bin/ejecutar/notyadd ]] && {
[[ -e /etc/adm-lite/liberados ]] && AdminDB=$(cut -d'|' -f1 /etc/adm-lite/liberados | head -n 1) || AdminDB=$(cat /etc/adm-lite/liberados | cut -d '|' -f1| head -1)
if [ ${message_chat_id[$id]} == ${AdminDB} ]; then
    echo "Mensaje no enviado"
else
    call.mensaje ${AdminDB} "${msg}"
fi
}
unset msg
return 0
fi
}

renew_cli_quit(){
ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action typing
[[ "$1" = "" ]] && exec="error"
[[ "$2" = "" ]] && exec="error"
[[ -z $1 ]] && local _name='My_User' || local _name=$1
[[ -z $2 ]] || local _time=$2
if [ "$exec" = "error" ]; then
local msg
         msg='━━━━━━━━━━━━━━━━━━━━━ \n'
         msg+=" RENOVACION CON PRORRATEO DE DIAS ( ➖ ) \n"
         msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
		 msg+=" DEBES ENVIAR EL COMANDO \n /renovarQ Nombre_User dias\n"
		 msg+="━━━━━━━━━━━━━━━━━━━━━ \n"
         msg+=' <code>/renovarQ ${_name} 30</code> \n'
         msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
						ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
									--reply_to_message_id "${message_message_id[$id]}" \
									--text "<i>$(echo -e $msg)</i>" \
									--parse_mode html
   return 0
fi
renew "${_name}" "${_time}" "Q"
if [ "$?" = "1" ]; then
local msg='━━━━━━━━━━━━━━━━━━━━━ \n'
      msg+=" ERROR INTERNO RETURN 0x0010\n"
      msg+=" USUARIO ${_name} NO EXISTE !!!\n"
      msg+='━━━━━━━━━━━━━━━━━━━━━ \n'   
      ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
				--text "$(echo -e $msg)" \
				--parse_mode html
return 0
elif [[ "$?" = "2" ]]; then
      msg+=" ERROR INTERNO RETURN 0x0015\n"
      msg+=" LOS DIAS SON MAYOR AL TIEMPO RESTANTE !!!\n"
      msg+='━━━━━━━━━━━━━━━━━━━━━ \n'   
      ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
				--text "$(echo -e $msg)" \
				--parse_mode html
return 0
elif [[ "$?" = "3" ]]; then
      msg+=" ERROR INTERNO RETURN 0x0022\n"
      msg+=" DETALLE DESCONOCIDO SOBRE EL $_name !!!\n"
      msg+='━━━━━━━━━━━━━━━━━━━━━ \n'   
      ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
				--text "$(echo -e $msg)" \
				--parse_mode html
return 0
else
[[ -e /etc/adm-lite/liberados ]] && _restM=$(cat /etc/adm-lite/liberados | grep -w ${chatuser} | cut -d '|' -f2)
local myID="${chatuser}"
echo -e "DIAS ACTUAL ${_restM} - ID ${myID}"
[[ ${_restM} = 'X' ]] && { 
_newCRED='9999'
} || {

[[ ${_restM} -le 0 ]] && {
sed -i "/${myID}/d" /etc/adm-lite/liberados
local msg='━━━━━━━━━━━━━━━━━━━━━ \n'
      msg+=" ⚠ ERROR INTERNO RETURN 0x0013 ⚠\n"
      msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
      msg+=' IMPOSIBLRE RENOVAR USUARIO \n'
      msg+=' 💸 SUS CREDITOS SE HAN AGOTADO 💸 \n'
      msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
      ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
				--text "$(echo -e $msg)" \
				--parse_mode markdown
return 0
}
local _newCRED=$((${_restM} - 1))
}
[[ "$_client" = "" ]] && return
local msg
local usr=$(echo "$_client" | awk '{print $1}')
local sen=$(echo "$_client"  | awk '{print $2}')
local dia=$(echo "$_client" | awk '{print $3}')
local limit=$(echo "$_client" | awk '{print $4}')
local _mDIAS=$(echo "$_client" | awk '{print $5}')
local msg='━━━━━━━━━━━━━━━━━━━━━ \n'
		  #ports_
          #msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+=" 💻 TIENES ${_newCRED} CREDITOS 💻 \n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+="Host/IP-Address : <code>$(cat /bin/ejecutar/IPcgh)</code>\n"
          msg+="USUARIO : <code>$usr</code>\n"
          msg+="PASSWD  : <code>$sen</code>\n"
          msg+="DURACION: $dia\n"
          msg+="LIMITE  : $limit\n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
[[ ${_restM} = 'X' ]] || sed -i "/${myID}/d" /etc/adm-lite/liberados
[[ ${_restM} = 'X' ]] || echo -e "${myID}|${_newCRED}" >> /etc/adm-lite/liberados
[[ -e /etc/adm-lite/slow/dnsi/domain_ns ]] && msg+=" DOMINIO NS : <code>$(cat < /etc/adm-lite/slow/dnsi/domain_ns)</code> \n"
[[ -e /etc/adm-lite/slow/dnsi/server.pub ]] && msg+=" KEY PUBLIC : <code>$(cat < /etc/adm-lite/slow/dnsi/server.pub)</code> \n"
[[ -e /etc/adm-lite/slow/dnsi/protc && -e /etc/adm-lite/slow/dnsi/puerto ]] && msg+="PROTOCOLO : $(cat < /etc/adm-lite/slow/dnsi/protc) -> <code>$(cat < /etc/adm-lite/slow/dnsi/puerto)</code> \n"
		  msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
		  #URG="https://api.telegram.org/bot$TOKEN/sendPhoto"
		  #curl -s -X POST $URG -F chat_id=${message_chat_id[$id]} -F photo="@${Img}"
						ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
									--reply_to_message_id "${message_message_id[$id]}" \
									--text "<i>$(echo -e $msg)</i>" \
									--parse_mode html
[[ -z ${callback_query_from_username} ]] && local usrLOP=${message_from_username} || local usrLOP=${callback_query_from_username}
msg+=" ADM : @${usrLOP} CREO a <code>$usr</code>con ${_mDIAS} Dias \n"
msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
[[ -e /bin/ejecutar/notyadd ]] && {
[[ -e /etc/adm-lite/liberados ]] && AdminDB=$(cut -d'|' -f1 /etc/adm-lite/liberados | head -n 1) || AdminDB=$(cat /etc/adm-lite/liberados | cut -d '|' -f1| head -1)
if [ ${message_chat_id[$id]} == ${AdminDB} ]; then
    echo "Mensaje no enviado"
else
    call.mensaje ${AdminDB} "${msg}"
fi
}
unset msg
return 0
fi
}

renew_cli(){
ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action typing
[[ "$1" = "" ]] && exec="error"
[[ "$2" = "" ]] && exec="error"
[[ -z $1 ]] && local _name='My_User' || local _name=$1
[[ -z $2 ]] || local _time=$2
if [ "$exec" = "error" ]; then
local msg
         msg='━━━━━━━━━━━━━━━━━━━━━ \n'
         msg+=" RENOVACION CON REINICIO DE DIAS \n"
         msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
		 msg+=" DEBES ENVIAR EL COMANDO \n /renovar Nombre_User dias\n"
		 msg+="━━━━━━━━━━━━━━━━━━━━━ \n"
         msg+=' <code>/renovar ${_name} 30</code> \n'
         msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
						ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
									--reply_to_message_id "${message_message_id[$id]}" \
									--text "<i>$(echo -e $msg)</i>" \
									--parse_mode html
   return 0
fi
renew "${_name}" "${_time}"
if [ "$?" = "1" ]; then
local msg='━━━━━━━━━━━━━━━━━━━━━ \n'
      msg+=" ERROR INTERNO RETURN 0x0010\n"
      msg+=" USUARIO ${_name} NO EXISTE !!!\n"
      msg+='━━━━━━━━━━━━━━━━━━━━━ \n'   
      ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
				--text "$(echo -e $msg)" \
				--parse_mode html
return 0
elif [[ "$?" = "2" ]]; then
      msg+=" ERROR INTERNO RETURN 0x0015\n"
      msg+=" LOS DIAS SON MAYOR AL TIEMPO RESTANTE !!!\n"
      msg+='━━━━━━━━━━━━━━━━━━━━━ \n'   
      ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
				--text "$(echo -e $msg)" \
				--parse_mode html
return 0
elif [[ "$?" = "3" ]]; then
      msg+=" ERROR INTERNO RETURN 0x0022\n"
      msg+=" DETALLE DESCONOCIDO SOBRE EL $_name !!!\n"
      msg+='━━━━━━━━━━━━━━━━━━━━━ \n'   
      ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
				--text "$(echo -e $msg)" \
				--parse_mode html
return 0
else
[[ -e /etc/adm-lite/liberados ]] && _restM=$(cat /etc/adm-lite/liberados | grep -w ${chatuser} | cut -d '|' -f2)
local myID="${chatuser}"
echo -e "DIAS ACTUAL ${_restM} - ID ${myID}"
[[ ${_restM} = 'X' ]] && { 
_newCRED='9999'
} || {

[[ ${_restM} -le 0 ]] && {
sed -i "/${myID}/d" /etc/adm-lite/liberados
local msg='━━━━━━━━━━━━━━━━━━━━━ \n'
      msg+=" ⚠ ERROR INTERNO RETURN 0x0013 ⚠\n"
      msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
      msg+=' IMPOSIBLRE RENOVAR USUARIO \n'
      msg+=' 💸 SUS CREDITOS SE HAN AGOTADO 💸 \n'
      msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
      ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
				--text "$(echo -e $msg)" \
				--parse_mode markdown
return 0
}
local _newCRED=$((${_restM} - 1))
}
[[ "$_client" = "" ]] && return
local msg
local usr=$(echo "$_client" | awk '{print $1}')
local sen=$(echo "$_client"  | awk '{print $2}')
local dia=$(echo "$_client" | awk '{print $3}')
local limit=$(echo "$_client" | awk '{print $4}')
local msg='━━━━━━━━━━━━━━━━━━━━━ \n'
		  #ports_
          #msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+=" 💻 TIENES ${_newCRED} CREDITOS 💻  \n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+="Host/IP-Address : <code>$(cat /bin/ejecutar/IPcgh)</code>\n"
          msg+="USUARIO : <code>$usr</code>\n"
          msg+="PASSWD  : <code>$sen</code>\n"
          msg+="DURACION: $dia\n"
          msg+="LIMITE  : $limit\n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
[[ ${_restM} = 'X' ]] || sed -i "/${myID}/d" /etc/adm-lite/liberados
[[ ${_restM} = 'X' ]] || echo -e "${myID}|${_newCRED}" >> /etc/adm-lite/liberados
[[ -e /etc/adm-lite/slow/dnsi/domain_ns ]] && msg+=" DOMINIO NS : <code>$(cat < /etc/adm-lite/slow/dnsi/domain_ns)</code> \n"
[[ -e /etc/adm-lite/slow/dnsi/server.pub ]] && msg+=" KEY PUBLIC : <code>$(cat < /etc/adm-lite/slow/dnsi/server.pub)</code> \n"
[[ -e /etc/adm-lite/slow/dnsi/protc && -e /etc/adm-lite/slow/dnsi/puerto ]] && msg+="PROTOCOLO : $(cat < /etc/adm-lite/slow/dnsi/protc) -> <code>$(cat < /etc/adm-lite/slow/dnsi/puerto)</code> \n"
		  msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
		  #URG="https://api.telegram.org/bot$TOKEN/sendPhoto"
		  #curl -s -X POST $URG -F chat_id=${message_chat_id[$id]} -F photo="@${Img}"
						ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
									--reply_to_message_id "${message_message_id[$id]}" \
									--text "<i>$(echo -e $msg)</i>" \
									--parse_mode html
[[ -z ${callback_query_from_username} ]] && local usrLOP=${message_from_username} || local usrLOP=${callback_query_from_username}
msg+=" ADM : @${usrLOP} CREO a <code>$usr</code>con ${_mDIAS} Dias \n"
msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
[[ -e /bin/ejecutar/notyadd ]] && {
[[ -e /etc/adm-lite/liberados ]] && AdminDB=$(cut -d'|' -f1 /etc/adm-lite/liberados | head -n 1) || AdminDB=$(cat /etc/adm-lite/liberados | cut -d '|' -f1| head -1)
if [ ${message_chat_id[$id]} == ${AdminDB} ]; then
    echo "Mensaje no enviado"
else
    call.mensaje ${AdminDB} "${msg}"
fi
}

		  unset msg
return 0
fi
}

addtk_fun () {
ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action typing
local _mDIAS=$(($(date -d "$(date +'%Y-%m-01') +1 month -1 day" +%-d) + 1))
[[ "$1" = "" ]] && exec="error" || local _nombre=$1
[[ "$2" = "" ]] && exec="error" || local _token=$2
local _tiempo=$3
#[[ "$3" = "" ]] && exec="error"
#[[ "$4" = "" ]] && exec="error"
if [ "$exec" = "error" ]; then
local msg='━━━━━━━━━━━━━━━━━━━━━ \n'
      msg+=" FORMA DE USAR ESTA OPC\n"
      msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
	  msg+=" DEBES ENVIAR EL COMANDO \n /token Nombre_User token dias\n"
	  msg+="━━━━━━━━━━━━━━━━━━━━━ \n"
      msg+='token User123 c2e4ad4y9gcsbs 30 \n'
      msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
			ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
					--reply_to_message_id "${message_message_id[$id]}" \
					--text "<i>$(echo -e $msg)</i>" \
					--parse_mode html
   return 0
fi
[[ -z ${_tiempo} ]] && criarusrTK "${_nombre}" "${_token}" "${_mDIAS}" || criarusrTK "${_nombre}" "${_token}" "${_tiempo}"
if [ "$?" = "1" ]; then
local msg
      msg='━━━━━━━━━━━━━━━━━━━━━ \n'
      msg+=" ERROR INTERNO RETURN 0x0012\n"
      msg+=" USUARIO YA EXISTE, O YA REGISTRADO!!\n"
      msg+='━━━━━━━━━━━━━━━━━━━━━ \n'   
      ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
					--text "$(echo -e $msg)" \
					--parse_mode html
return 0
else
[[ -e /etc/adm-lite/liberados ]] && _restM=$(cat /etc/adm-lite/liberados | grep -w ${chatuser} | cut -d '|' -f2)
local myID="${chatuser}"
[[ ${_restM} = 'X' ]] && { 
_newCRED='9999'
} || {

[[ ${_restM} -le 0 ]] && {
sed -i "/${myID}/d" /etc/adm-lite/liberados
local msg='━━━━━━━━━━━━━━━━━━━━━ \n'
      msg+=" ⚠ ERROR INTERNO RETURN 0x0013 ⚠\n"
      msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
      msg+=' 🙍 IMPOSIBLRE REGISTRAR USUARIO 🙍 \n'
      msg+=' 💸 SUS CREDITOS SE HAN AGOTADO 💸 \n'
      msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
      ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
				--text "$(echo -e $msg)" \
				--parse_mode markdown
		[[ -z ${callback_query_from_username} ]] && local usrLOP=${message_from_username} || local usrLOP=${callback_query_from_username}
msg+=" ADM : @${usrLOP} CREO a <code>$usr</code>con ${_mDIAS} Dias \n"
msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
[[ -e /bin/ejecutar/notyadd ]] && {
[[ -e /etc/adm-lite/liberados ]] && AdminDB=$(cut -d'|' -f1 /etc/adm-lite/liberados | head -n 1) || AdminDB=$(cat /etc/adm-lite/liberados | cut -d '|' -f1| head -1)
if [ ${message_chat_id[$id]} == ${AdminDB} ]; then
    echo "Mensaje no enviado"
else
    call.mensaje ${AdminDB} "${msg}"
fi
}

return 0
}
_newCRED=$((${_restM} - 1))
}
[[ "$_client" = "" ]] && return
          usr=$(echo "$_client" | awk '{print $1}')
          sen=$(echo "$_client"  | awk '{print $2}')
          dia=$(echo "$_client" | awk '{print $3}')
          limit=$(echo "$_client" | awk '{print $4}')
          _mDIAS=$(echo "$_client" | awk '{print $5}')
		  unset _client
		  local msg='━━━━━━━━━━━━━━━━━━━━━ \n'
		  #ports_
          #msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+=" 💻 TIENES ${_newCRED} CREDITOS 💻  \n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+="Host/IP-Address : <code>$(cat /bin/ejecutar/IPcgh)</code>\n"
          msg+="USUARIO : <code>$usr</code>\n"
          msg+="TOKEN  : <code>$sen</code>\n"
          msg+="DURACION: $dia\n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
[[ ${_restM} = 'X' ]] || sed -i "/${myID}/d" /etc/adm-lite/liberados
[[ ${_restM} = 'X' ]] || echo -e "${myID}|${_newCRED}" >> /etc/adm-lite/liberados
[[ -e /etc/adm-lite/slow/dnsi/domain_ns ]] && msg+=" DOMINIO NS : <code>$(cat < /etc/adm-lite/slow/dnsi/domain_ns)</code> \n"
[[ -e /etc/adm-lite/slow/dnsi/server.pub ]] && msg+=" KEY PUBLIC : <code>$(cat < /etc/adm-lite/slow/dnsi/server.pub)</code> \n"
[[ -e /etc/adm-lite/slow/dnsi/protc && -e /etc/adm-lite/slow/dnsi/puerto ]] && msg+="PROTOCOLO : $(cat < /etc/adm-lite/slow/dnsi/protc) -> <code>$(cat < /etc/adm-lite/slow/dnsi/puerto)</code> \n"
		  msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
		  #URG="https://api.telegram.org/bot$TOKEN/sendPhoto"
		  #curl -s -X POST $URG -F chat_id=${message_chat_id[$id]} -F photo="@${Img}"
			ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
					--reply_to_message_id "${message_message_id[$id]}" \
					--text "<i>$(echo -e $msg)</i>" \
					--parse_mode html
[[ -z ${callback_query_from_username} ]] && local usrLOP=${message_from_username} || local usrLOP=${callback_query_from_username}
msg+=" ADM : @${usrLOP} CREO a <code>$usr</code>con ${_mDIAS} Dias \n"
msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
[[ -e /bin/ejecutar/notyadd ]] && {
[[ -e /etc/adm-lite/liberados ]] && AdminDB=$(cut -d'|' -f1 /etc/adm-lite/liberados | head -n 1) || AdminDB=$(cat /etc/adm-lite/liberados | cut -d '|' -f1| head -1)
if [ ${message_chat_id[$id]} == ${AdminDB} ]; then
    echo "Mensaje no enviado"
else
    call.mensaje ${AdminDB} "${msg}"
fi
}

		  unset msg
return 0
fi
}



addHWID_fun () {
ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action typing
local _mDIAS=$(($(date -d "$(date +'%Y-%m-01') +1 month -1 day" +%-d) + 1))
[[ "$1" = "" ]] && exec="error" || local _nombre=$1
[[ "$2" = "" ]] && exec="error" || local _token=$2
local _tiempo=$3
#[[ "$3" = "" ]] && exec="error"
#[[ "$4" = "" ]] && exec="error"
if [ "$exec" = "error" ]; then
local msg='━━━━━━━━━━━━━━━━━━━━━ \n'
      msg+=" FORMA DE USAR ESTA OPC\n"
      msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
	  msg+=" DEBES ENVIAR EL COMANDO \n /hwid Nombre_User codigo_hwid dias\n"
	  msg+="━━━━━━━━━━━━━━━━━━━━━ \n"
      msg+='hwid User123 c2e4ad4y9gcsbs 30 \n'
      msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
			ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
					--reply_to_message_id "${message_message_id[$id]}" \
					--text "<i>$(echo -e $msg)</i>" \
					--parse_mode html
   return 0
fi
[[ -z ${_tiempo} ]] && criarusrHWID "${_nombre}" "${_token}" "30" || criarusrHWID "${_nombre}" "${_token}" "${_tiempo}"
if [ "$?" = "1" ]; then
local msg
      msg='━━━━━━━━━━━━━━━━━━━━━ \n'
      msg+=" ERROR INTERNO RETURN 0x0012\n"
      msg+=" USUARIO YA EXISTE, O YA REGISTRADO!!\n"
      msg+='━━━━━━━━━━━━━━━━━━━━━ \n'   
      ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
					--text "$(echo -e $msg)" \
					--parse_mode html
return 0
else
[[ -e /etc/adm-lite/liberados ]] && _restM=$(cat /etc/adm-lite/liberados | grep -w ${chatuser} | cut -d '|' -f2)
local myID="${chatuser}"
[[ ${_restM} = 'X' ]] && { 
_newCRED='9999'
} || {

[[ ${_restM} -le 0 ]] && {
sed -i "/${myID}/d" /etc/adm-lite/liberados
local msg='━━━━━━━━━━━━━━━━━━━━━ \n'
      msg+=" ⚠ ERROR INTERNO RETURN 0x0013 ⚠\n"
      msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
      msg+=' 🙍 IMPOSIBLRE REGISTRAR USUARIO 🙍 \n'
      msg+=' 💸 SUS CREDITOS SE HAN AGOTADO 💸 \n'
      msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
      ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
				--text "$(echo -e $msg)" \
				--parse_mode markdown
		[[ -z ${callback_query_from_username} ]] && local usrLOP=${message_from_username} || local usrLOP=${callback_query_from_username}
msg+=" ADM : @${usrLOP} CREO a <code>$usr</code> con ${_mDIAS} Dias \n"
msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
[[ -e /bin/ejecutar/notyadd ]] && {
[[ -e /etc/adm-lite/liberados ]] && AdminDB=$(cut -d'|' -f1 /etc/adm-lite/liberados | head -n 1) || AdminDB=$(cat /etc/adm-lite/liberados | cut -d '|' -f1| head -1)
if [ ${message_chat_id[$id]} == ${AdminDB} ]; then
    echo "Mensaje no enviado"
else
    call.mensaje ${AdminDB} "${msg}"
fi
}

return 0
}
_newCRED=$((${_restM} - 1))
}
[[ "$_client" = "" ]] && return
          usr=$(echo "$_client" | awk '{print $1}')
          sen=$(echo "$_client"  | awk '{print $2}')
          dia=$(echo "$_client" | awk '{print $3}')
          limit=$(echo "$_client" | awk '{print $4}')
		  _mDIAS=$(echo "$_client" | awk '{print $5}')
		  unset _client
		  local msg='━━━━━━━━━━━━━━━━━━━━━ \n'
		  #ports_
          #msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+=" 💻 TIENES ${_newCRED} CREDITOS 💻  \n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+="Host/IP-Address : <code>$(cat /bin/ejecutar/IPcgh)</code>\n"
          msg+="USUARIO : <code>$usr</code>\n"
          msg+="HWID  : <code>$sen</code>\n"
          msg+="DURACION: $dia\n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
[[ ${_restM} = 'X' ]] || sed -i "/${myID}/d" /etc/adm-lite/liberados
[[ ${_restM} = 'X' ]] || echo -e "${myID}|${_newCRED}" >> /etc/adm-lite/liberados
[[ -e /etc/adm-lite/slow/dnsi/domain_ns ]] && msg+=" DOMINIO NS : <code>$(cat < /etc/adm-lite/slow/dnsi/domain_ns)</code> \n"
[[ -e /etc/adm-lite/slow/dnsi/server.pub ]] && msg+=" KEY PUBLIC : <code>$(cat < /etc/adm-lite/slow/dnsi/server.pub)</code> \n"
[[ -e /etc/adm-lite/slow/dnsi/protc && -e /etc/adm-lite/slow/dnsi/puerto ]] && msg+="PROTOCOLO : $(cat < /etc/adm-lite/slow/dnsi/protc) -> <code>$(cat < /etc/adm-lite/slow/dnsi/puerto)</code> \n"
		  msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
		  #URG="https://api.telegram.org/bot$TOKEN/sendPhoto"
		  #curl -s -X POST $URG -F chat_id=${message_chat_id[$id]} -F photo="@${Img}"
			ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
					--reply_to_message_id "${message_message_id[$id]}" \
					--text "<i>$(echo -e $msg)</i>" \
					--parse_mode html
[[ -z ${callback_query_from_username} ]] && local usrLOP=${message_from_username} || local usrLOP=${callback_query_from_username}
msg+=" ADM : @${usrLOP} CREO a <code>$usr</code>con ${_mDIAS} Dias \n"
msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
[[ -e /bin/ejecutar/notyadd ]] && {
[[ -e /etc/adm-lite/liberados ]] && AdminDB=$(cut -d'|' -f1 /etc/adm-lite/liberados | head -n 1) || AdminDB=$(cat /etc/adm-lite/liberados | cut -d '|' -f1| head -1)
if [ ${message_chat_id[$id]} == ${AdminDB} ]; then
    echo "Mensaje no enviado"
else
    call.mensaje ${AdminDB} "${msg}"
fi
}

		  unset msg
return 0
fi
}

_userDEMO () {
[[ -d /etc/usuariosteste ]] || mkdir /etc/usuariosteste
[[ -e /bin/ejecutar/token ]] && passTOKEN=$(less /bin/ejecutar/token) || passTOKEN="ChumoGHPlus"
#[[ -e /etc/adm-lite/liberados ]] && _limC=$(cat /etc/adm-lite/liberados | cut -d '|' -f2)
[[ -z $1 ]] && {
_name="demo-$(date | md5sum | head -c10)"
pass="$(date | md5sum | head -c10)"
} || {
_name=$1
pass=${passTOKEN}
}
_tiempo='2'
if cat /etc/passwd |grep ${_name}: |grep -vi [a-z]${_name} |grep -v [0-9]${_name} > /dev/null; then
return 1
fi
if [ "$OPENVPN" = "on" ]; then
open_1 ${_name} ${pass} $_tiempo 1 s
return 0
fi
valid=$(date '+%C%y-%m-%d' -d " +${_tiempo} days")
datexp=$(date "+%d/%m/%Y" -d " +${_tiempo} days")
local passCIFRED=$(openssl passwd -6 ${pass})
useradd -M -s /bin/false -e ${valid} -K PASS_MAX_DAYS=${_tiempo} -p ${passCIFRED} -c 2,${pass} ${_name}
echo "senha: ${_name}" > $dir_user/${_name}
echo "limite: TOKEN" >> $dir_user/${_name}
echo "data: $valid" >> $dir_user/${_name}
_client+="${_name} ${pass} ${datexp} 1 ${_tiempo}"
#cat <<EOF > /etc/usuariosteste/${_name}.sh
#!/bin/bash
#sleep 2d
#echo -e "$(($(cat /bin/ejecutar/uskill) + 1))" > /bin/ejecutar/uskill
#rm -f $dir_user/${_name}
#userdel --force ${_name}
#rm -f /etc/usuariosteste/${_name}.sh
#EOF
#at now + 2 days -f /etc/usuariosteste/${_name}.sh
local myID=$(cat /bin/ejecutar/demos | tail -1)
at now + 2 days <<< "userdel --force ${_name} && rm -f $dir_user/${_name} && echo $(($(cat /bin/ejecutar/uskill) + 1)) > /bin/ejecutar/uskill && sed -i \"/${myID}/d\" /bin/ejecutar/demos"
#echo -e "X" >> /bin/ejecutar/demos
return 0
}


addtk_fun_demo () {
[[ ! -e /bin/ejecutar/demos ]] && touch /bin/ejecutar/demos
ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action typing
local _mDIAS=$(($(date -d "$(date +'%Y-%m-01') +1 month -1 day" +%-d) + 1))
#[[ "$1" = "" ]] && exec="error"
#[[ "$2" = "" ]] && exec="error"
#[[ "$3" = "" ]] && exec="error"
#[[ "$4" = "" ]] && exec="error"
[[ $(cat /bin/ejecutar/demos |grep -w "${message_chat_id[$id]}"| wc -l) -gt 5 ]] && exec='max'
[[ $(cat /bin/ejecutar/demos |grep -w "${message_chat_id[$id]}"| wc -l) -lt 2 ]] && exec='error'
if [ "$exec" = "error" ]; then
local msg='━━━━━━━━━━━━━━━━━━━━━ \n'
	  msg+=" RECUERDA QUE PODRAS GENERAR\n"
	  msg+=" SOLO 3 DEMOS POR USUARIO \n"
	  msg+=" PARA EVITAR SATURAR EL VPS\n"
	  msg+=" MENSAJE DE AVISO, SE OMITIRAN\n"
	  msg+=" EN EL $((2 - $(cat < /bin/ejecutar/demos |grep -w "${message_chat_id[$id]}" | wc -l))) INTENTO!\n"
	  msg+='━━━━━━━━━GUIA━━━━━━━━━ \n'
	  msg+=" DEMO NORMAL /demo \n"
	  msg+=" DEMO TOKEN /demo Token_APK\n"
	  msg+="━━━━━━━━━━━━━━━━━━━━━ \n"
	  msg+=' <code>/demo c2e4ad4y9gcsbs</code> \n'
	  msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
			ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
					--reply_to_message_id "${message_message_id[$id]}" \
					--text "<i>$(echo -e $msg)</i>" \
					--parse_mode html
   return 0
fi

if [ "$exec" = "max" ]; then
local msg='━━━━━━━━━━━━━━━━━━━━━ \n'
	  msg+=" RECUERDA QUE PODRAS GENERAR\n"
	  msg+=" SOLO 3 DEMOS POR USUARIO \n"
	  msg+=" PARA EVITAR SATURAR EL VPS\n"
	  msg+=" MENSAJE DE AVISO, SE OMITIRAN\n"
	  msg+=" UD YA LLEGO AL MAXIMO DE DEMOS \n"
	  msg+='━━━━━━━━━GUIA━━━━━━━━━ \n'
	  msg+=" DEMO NORMAL /demo \n"
	  ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
					--reply_to_message_id "${message_message_id[$id]}" \
					--text "<i>$(echo -e $msg)</i>" \
					--parse_mode html
   return 0
fi


[[ -z $1 ]] || local _name=$1
echo -e "${message_chat_id[$id]}" >> /bin/ejecutar/demos
[[ -z $1 ]] && _userDEMO || _userDEMO "${_name}"
if [ "$?" = "1" ]; then
local msg='━━━━━━━━━━━━━━━━━━━━━ \n'
      msg+=" ERROR INTERNO RETURN 0x0012\n"
      msg+=" USUARIO ${_name} YA ESTA REGISTRADO!!\n"
      msg+='━━━━━━━━━━━━━━━━━━━━━ \n'   
      ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
				--text "$(echo -e $msg)" \
				--parse_mode markdown
return 0
else
[[ -e /etc/adm-lite/liberados ]] && _restM=$(cat /etc/adm-lite/liberados | grep -w ${chatuser} | cut -d '|' -f2)
local myID="${chatuser}"
[[ ${_restM} = 'X' ]] && { 
_newCRED='9999'
} || {
[[ ${_restM} -le 0 ]] && {
sed -i "/${myID}/d" /etc/adm-lite/liberados
local msg
         msg='━━━━━━━━━━━━━━━━━━━━━ \n'
         msg+=" ⚠ ERROR INTERNO RETURN 0x0013 ⚠\n"
         msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
         msg+=' 🙍 IMPOSIBLRE REGISTRAR USUARIO 🙍 \n'
         msg+=' 💸 SUS CREDITOS SE HAN AGOTADO 💸 \n'
         msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
         ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
							--text "$(echo -e $msg)" \
							--parse_mode markdown
		[[ -z ${callback_query_from_username} ]] && local usrLOP=${message_from_username} || local usrLOP=${callback_query_from_username}
msg+=" ADM : @${usrLOP} CREO a <code>$usr</code>con ${_mDIAS} Dias \n"
msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
[[ -e /bin/ejecutar/notyadd ]] && {
[[ -e /etc/adm-lite/liberados ]] && AdminDB=$(cut -d'|' -f1 /etc/adm-lite/liberados | head -n 1) || AdminDB=$(cat /etc/adm-lite/liberados | cut -d '|' -f1| head -1)
if [ ${message_chat_id[$id]} == ${AdminDB} ]; then
    echo "Mensaje no enviado"
else
    call.mensaje ${AdminDB} "${msg}"
fi
}

return 0
}
_newCRED=$((${_restM} - 1))
}
[[ "$_client" = "" ]] && return
          usr=$(echo "$_client" | awk '{print $1}')
          sen=$(echo "$_client"  | awk '{print $2}')
          dia=$(echo "$_client" | awk '{print $3}')
          limit=$(echo "$_client" | awk '{print $4}')
		  _mDIAS=$(echo "$_client" | awk '{print $5}')
		  #ports_
		#msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
		msg+=" 💻 TIENES ${_newCRED} CREDITOS 💻  \n"
		msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
		msg+="Host/IP-Address : <code>$(cat /bin/ejecutar/IPcgh)</code>\n"
		msg+="USUARIO : <code>$usr</code>\n"
		[[ -z $1 ]] && msg+="CLAVE  : <code>$sen</code>\n" || msg+="TOKEN  : <code>$sen</code>\n"
		msg+="DURACION: $dia\n"
		msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
		echo -e "X" >> /bin/ejecutar/demos
#[[ ${_restM} = 'X' ]] || sed -i "/${myID}/d" /etc/adm-lite/liberados
#[[ ${_restM} = 'X' ]] || echo -e "${myID}|${_newCRED}" >> /etc/adm-lite/liberados
[[ -e /etc/adm-lite/slow/dnsi/domain_ns ]] && msg+=" DOMINIO NS : <code>$(cat < /etc/adm-lite/slow/dnsi/domain_ns)</code> \n"
[[ -e /etc/adm-lite/slow/dnsi/server.pub ]] && msg+=" KEY PUBLIC : <code>$(cat < /etc/adm-lite/slow/dnsi/server.pub)</code> \n"
[[ -e /etc/adm-lite/slow/dnsi/protc && -e /etc/adm-lite/slow/dnsi/puerto ]] && msg+="PROTOCOLO : $(cat < /etc/adm-lite/slow/dnsi/protc) -> <code>$(cat < /etc/adm-lite/slow/dnsi/puerto)</code> \n"
	  msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
		  #URG="https://api.telegram.org/bot$TOKEN/sendPhoto"
		  #curl -s -X POST $URG -F chat_id=${message_chat_id[$id]} -F photo="@${Img}"
		ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
					--reply_to_message_id "${message_message_id[$id]}" \
					--text "<i>$(echo -e $msg)</i>" \
					--parse_mode html
[[ -z ${callback_query_from_username} ]] && local usrLOP=${message_from_username} || local usrLOP=${callback_query_from_username}
msg+=" ADM : @${usrLOP} CREO a <code>$usr</code>con ${_mDIAS} Dias \n"
msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
[[ -e /bin/ejecutar/notyadd ]] && {
[[ -e /etc/adm-lite/liberados ]] && AdminDB=$(cut -d'|' -f1 /etc/adm-lite/liberados | head -n 1) || AdminDB=$(cat /etc/adm-lite/liberados | cut -d '|' -f1| head -1)
if [ ${message_chat_id[$id]} == ${AdminDB} ]; then
    echo "Mensaje no enviado"
else
    call.mensaje ${AdminDB} "${msg}"
fi
}

		  unset msg
return 0
fi
}

userdelete () {
local _user="$1"
[[ -z $_user ]] && return 1
if cat /etc/passwd |grep -w "${_user}": |grep -vi [a-z]${_user} |grep -v [0-9]${_user} > /dev/null; then
userdel --force $_user 
kill -9 `ps aux |grep -vi '[a-z]$_user' |grep -vi '$_user[a-z]' |grep -v '[1-9]$_user' |grep -v '$_user[1-9]' |grep $_user |awk {'print $2'}` 2> /dev/null
[[ -e $dir_user/$_user ]] && rm -f $dir_user/$_user
return 0
else
return 1
fi

}


userdell_fun () {
ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action typing
[[ "$1" = "" ]] && exec="error"
if [ "$exec" = "error" ]; then
local msg
         msg='━━━━━━━━━━━━━━━━━━━━━ \n'
         msg+=" - MODO DE USO -\n"
         msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
		 msg+=" DEBES ENVIAR EL COMANDO \n borrar Nombre_User\n"
		 msg+="━━━━━━━━━━━━━━━━━━━━━ \n"
		 msg+=" PARA USUARIOS TOKEN \ n borrar Token_User\n"
		 msg+="━━━━━━━━━━━━━━━━━━━━━ \n"
         msg+='borrar codigo_token\n'
         msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
	     				ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
									--reply_to_message_id "${message_message_id[$id]}" \
									--text "<i>$(echo -e $msg)</i>" \
									--parse_mode html
   return 0
fi
userdelete "$1"
if [ "$?" = "1" ]; then
local msg
          msg='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+=" ERROR INTERNO RETURN 0x0010\n"
          msg+=" USUARIO $1 NO EXISTE !!\n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'   
          				ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
									--reply_to_message_id "${message_message_id[$id]}" \
									--text "<i>$(echo -e $msg)</i>" \
									--parse_mode html
return 0
else
local msg='━━━━━━━━━━━━━━━━━━━━━ \n'
	  msg+=" USUARIO $1 ELIMINADO EXITOSAMENTE \n"
	  msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
			ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
					--reply_to_message_id "${message_message_id[$id]}" \
					--text "<i>$(echo -e $msg)</i>" \
					--parse_mode html
return 0
fi
}

price () {
local msg
          msg=' --------------------------------------------------\n'
          msg+="|       ☆☆☆☆☆ ⚡ ⫷ℂ𝕙𝕦𝕞𝕠𝔾ℍ⫸ ⚡ ☆☆☆☆☆       |\n"
		  msg+='-------------------------------------------------\n' 
          msg+=' $1.50 USD - Acceso ilimitado al BOT 15 dias \n'   
		  msg+=' $3.00 USD - Acceso ilimitado al BOT 120 dias\n' 
		  msg+=' $5.00 USD - Acceso ilimitado al BOT 180 dias\n' 
		  msg+=' $12.00 USD - Acceso ilimitado al BOT 365 dias\n' 
		  msg+='━━━━━━━━━━━━━━━━━━━━━ \n' 
		  msg+=" Recuerda que con el Bot Premium tienes acceso Ilimitado \n Incluyendo tu reseller en la Key! \n Soporte, Actualizaciones y MAS!!)\n"
		  msg+='━━━━━━━━━━━━━━━━━━━━━ \n'  
          ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
							--text "$(echo -e $msg)" \
							--parse_mode markdown
return 0
}

_v2fun() {
usr="$1"
_day="$2"
[[ "$1" = "" ]] && exec="error"
[[ "$2" = "" ]] && exec="error"
if [ "$exec" = "error" ]; then
local msg
         msg='━━━━━━━━━━━━━━━━━━━━━ \n'
         msg+="${txt[36]}\n"
         msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
		 msg+=" DEBES ENVIAR EL COMANDO \n v2ray Nombre_User Tiempo\n"
		 msg+="━━━━━━━━━━━━━━━━━━━━━ \n"
         msg+='v2ray nameUSER 30 \n'
         msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
		 ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action typing
         				ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
									--reply_to_message_id "${message_message_id[$id]}" \
									--text "<i>$(echo -e $msg)</i>" \
									--parse_mode html
   return 0
fi
[[ $_day < 1 ]] && _day='1'
bash ./bot_codes v2r_ "${usr}" "${_day}" 
if [ "$?" = "1" ]; then
local msg
         msg='━━━━━━━━━━━━━━━━━━━━━ \n'
         msg+="USUARIO V2RAY NO CREADO\n"
         msg+='━━━━━━━━━━━━━━━━━━━━━ \n'  
ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action typing		 
         				ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
									--reply_to_message_id "${message_message_id[$id]}" \
									--text "<i>$(echo -e $msg)</i>" \
									--parse_mode html
return 0
else
local msg
		  v2link=$(cat < /bin/ejecutar/${usr}_vmess.txt)
          msg='━━━━━━━━━━━━━━━━━━━━━ \n'
		  #[[ -e /var/www/html/${usr}_vmess_qr.png ]] && valid=$(date '+%C%y-%m-%d' -d " +$daysrnf days")
		  [[ -e /var/www/html/${usr}_vmess_qr.png ]] && datexp=$(date "+%d/%m/%Y" -d " +$_day days")
          msg+=" USUARIO : ${usr}\n"
          msg+=" EXPIRA  : ${datexp}\n"
          #done < ./textoports
		  msg+='• 𝄘𝄘𝄘𝄘𝄘𝄘 URL VMESS 𝄘𝄘𝄘𝄘𝄘 •\n'  
          msg+="<code>${v2link}</code> \n"
		  [[ -e /var/www/html/${usr}_vmess_qr.png ]] && msg+=" http://$(cat /bin/ejecutar/IPcgh):81/${usr}_vmess_qr.png \n"
		  msg+='━━━━━━━━━━━━━━━━━━━━━ \n'  
		  ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action typing
		  				ShellBot.sendMessage	--chat_id "${message_chat_id[$id]}" \
									--reply_to_message_id "${message_message_id[$id]}" \
									--text "<i>$(echo -e $msg)</i>" \
									--parse_mode html
		  unset msg
return 0
fi
}

paygen_fun () {
[[ "$1" = "" ]] && fail="0"
[[ "$2" = "" ]] && fail="0"
[[ "$3" = "" ]] && fail="0"
if [[ "$fail" = "0" ]]; then
local msg
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+="${txt[50]}:\n"
          msg+="/gerar ${txt[51]}\n"
          msg+="${txt[52]}:\n"
          msg+="/gerar claro.com 1/9 1/3\n"
          msg+="${txt[53]}\n1-GET, 2-CONNECT, 3-PUT, 4-OPTIONS, 5-DELETE, 6-HEAD, 7-TRACE, 8-PROPATCH, 9-PATCH\n"
          msg+="${txt[54]}\n1-REALDATA, 2-NETDATA, 3-RAW\n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'  
          ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
							--text "$(echo -e $msg)" \
							--parse_mode markdown
		  unset msg
return 0
fi
host="$1"
req="$2"
conex="$3"
bash ./bot_codes paygen "$host" "$req" "$conex"
if [ "$?" = "0" ]; then
local msg
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+="${txt[55]}\n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'  
          ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
							--text "$(echo -e $msg)" \
							--parse_mode markdown
local msg2
          ShellBot.sendDocument --chat_id ${message_chat_id[$id]} \
                             --document @$HOME/payloads.txt
return 0                           
else
local msg
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+="${txt[56]}\n"
          msg+="${txt[57]}\n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'  
          ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
							--text "$(echo -e $msg)" \
							--parse_mode markdown
return 0
fi
}

teste() {
ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action typing
local msg
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'
          msg+=" HOLIIIIIIS \n"
          msg+='━━━━━━━━━━━━━━━━━━━━━ \n'  
          ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
							--text "$(echo -e $msg)" \
							--parse_mode markdown
ShellBot.sendChatAction --chat_id ${message_chat_id[$id]} --action typing

}

fun_chat () {
    (	
        chatuser="${message_chat_id[$id]}"
        comando=(${message_text[$id]})

        [[ "${comando[0]}" = @(/teste|teste) ]] && teste
        [[ "${comando[0]}" = @(/ayuda|/start|/help|/menu) ]] && ajuda_fun
        [[ "${comando[0]}" = @(/access|access|loguin|/loguin) ]] && ativarid "${comando[1]}" "${comando[2]}" "$chatuser"

        if [[ "$(cat /etc/adm-lite/liberados|grep -w "$chatuser" | cut -d '|' -f2)" = "X" ]]; then
            # === MENÚ SUPER ADMIN ===
            [[ "${comando[0]}" = @(/ayuda|/start|/help|/menu) ]] && ajuda_fun
            [[ "${comando[0]}" = @(activos|/activos|conectados|/conectados) ]] && online_fun 
            [[ "${comando[0]}" = @(/puertos|puertos) ]] && infoporta
            [[ "${comando[0]}" = @(agregar|/agregar|add|/add) ]] && useradd_fun "${comando[1]}" "${comando[2]}" "${comando[3]}" "${comando[4]}"
            [[ "${comando[0]}" = @(token|/token) ]] && addtk_fun "${comando[1]}" "${comando[2]}" "${comando[3]}" "${comando[4]}"
            [[ "${comando[0]}" = @(hwid|/hwid) ]] && addHWID_fun "${comando[1]}" "${comando[2]}" "${comando[3]}" "${comando[4]}"
            [[ "${comando[0]}" = @(renovar|/renovar) ]] && renew_cli "${comando[1]}" "${comando[2]}" "${comando[3]}" "${comando[4]}"
            [[ "${comando[0]}" = @('renovaM'|'/renovarM') ]] && renew_cli_add "${comando[1]}" "${comando[2]}" "${comando[3]}" "${comando[4]}"
            [[ "${comando[0]}" = @('renovaQ'|'/renovarQ') ]] && renew_cli_quit "${comando[1]}" "${comando[2]}" "${comando[3]}" "${comando[4]}"
            [[ "${comando[0]}" = @(v2ray|/v2ray|addv2|/addv2) ]] && _v2fun "${comando[1]}" "${comando[2]}" "${comando[3]}"
            [[ "${comando[0]}" = @(borrar|/borrar|dell|/dell) ]] && userdell_fun "${comando[1]}"
            [[ "${comando[0]}" = @(usuarios|/usuarios) ]] && info_fun
            [[ "${comando[0]}" = @(infovps|/infovps) ]] && infovps
            [[ "${comando[0]}" = @(gerar|/gerar|pay|/pay) ]] && paygen_fun "${comando[1]}" "${comando[2]}" "${comando[3]}"
            [[ "${comando[0]}" = @(liberados|/liberados|libres|/libres) ]] && loguin_fun 
            [[ "${comando[0]}" = @(aggADM|/aggADM) ]] && add_admin "${comando[1]}" "${comando[2]}" "${comando[3]}"
            [[ "${comando[0]}" = @(creditos|/creditos) ]] && add_admin "${comando[1]}" "${comando[2]}" "${comando[3]}"
            [[ "${comando[0]}" = @(admkill|/admkill) ]] && admkill_fun "${comando[1]}" "${comando[2]}" "${comando[3]}"
            [[ "${comando[0]}" = @(precios|/precios) ]] && price
            [[ "${comando[0]}" = @(demo|/demo) ]] && addtk_fun_demo "${comando[1]}" "${comando[2]}"
            
            # 🔹 NUEVOS COMANDOS DE BACKUP/RESTORE
            [[ "${comando[0]}" = @(backup|/backup) ]] && backup_fun
            [[ "${comando[0]}" = @(restore|/restore) ]] && restore_fun "${comando[1]}"
        
        elif [[ "$(cat /etc/adm-lite/liberados|grep -w "$chatuser" | cut -d '|' -f2)" -gt "0" ]] 2>/dev/null; then
            # === MENÚ ADMIN NORMAL ===
            [[ "${comando[0]}" = @(/ayuda|/start|/help|/menu) ]] && ajuda_fun
            [[ "${comando[0]}" = @(usreg|/usreg) ]] && new_users_id
            [[ "${comando[0]}" = @(/puertos|puertos) ]] && infoporta
            [[ "${comando[0]}" = @(/usconnect|usconnect) ]] && mostrar_usuarios_conectados_por_id
            [[ "${comando[0]}" = @(agregar|/agregar|add|/add) ]] && useradd_fun "${comando[1]}" "${comando[2]}" "${comando[3]}" "${comando[4]}"
            [[ "${comando[0]}" = @(v2ray|/v2ray|addv2|/addv2) ]] && _v2fun "${comando[1]}" "${comando[2]}" "${comando[3]}"
            [[ "${comando[0]}" = @(token|/token) ]] && addtk_fun "${comando[1]}" "${comando[2]}" "${comando[3]}" "${comando[4]}"
            [[ "${comando[0]}" = @(hwid|/hwid) ]] && addHWID_fun "${comando[1]}" "${comando[2]}" "${comando[3]}" "${comando[4]}"
            [[ "${comando[0]}" = @(borrar|/borrar|dell|/dell) ]] && userdell_fun "${comando[1]}"
            [[ "${comando[0]}" = @(demo|/demo) ]] && addtk_fun_demo "${comando[1]}" "${comando[2]}"
            [[ "${comando[0]}" = @(renovar|/renovar) ]] && renew_cli "${comando[1]}" "${comando[2]}" "${comando[3]}" "${comando[4]}"
            [[ "${comando[0]}" = @('renovaM'|'/renovarM') ]] && renew_cli_add "${comando[1]}" "${comando[2]}" "${comando[3]}" "${comando[4]}"
            [[ "${comando[0]}" = @('renovaQ'|'/renovarQ') ]] && renew_cli_quit "${comando[1]}" "${comando[2]}" "${comando[3]}" "${comando[4]}"
            [[ "${comando[0]}" = @(gerar|/gerar|pay|/pay) ]] && paygen_fun "${comando[1]}" "${comando[2]}" "${comando[3]}"

            # 🔹 Habilitamos también backup para admins normales
            [[ "${comando[0]}" = @(backup|/backup) ]] && backup_fun

        else
            [[ "${comando[0]}" != "" ]] && _error_command
            [[ "${comando[0]}" = @(/ayuda|/start|/help|/menu) ]] && ajuda_fun
            [[ "${comando[0]}" = @(/access|access|loguin|/loguin) ]] && ativarid "${comando[1]}" "${comando[2]}" "$chatuser"
        fi
    ) &
}

[[ ! -e /etc/adm-lite/liberados ]] && touch /etc/adm-lite/liberados
while :
do
	ShellBot.getUpdates --limit 100 --offset $(ShellBot.OffsetNext) --timeout 30
	for id in $(ShellBot.ListUpdates); do
	  case ${message_text[$id]} in
			*)
				:
			fun_chat
			;;
	        esac
	done
done
