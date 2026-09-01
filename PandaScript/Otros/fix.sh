#!/bin/bash
URL_DROPBOX="https://github.com/joaquin1444/repo/raw/main/sdsd.rar"
DIR_ADM="/etc/adm-lite"
TMP_RAR="/tmp/sdsd.rar"
TMP_EXTRACT="/tmp/sdsd_extract"

get_real_ip() {
    curl -4 -s --connect-timeout 5 https://api.ipify.org | tr -d '[:space:]'
}

{
    timedatectl set-ntp true

    # Instalar unrar si falta
    if ! command -v unrar &>/dev/null; then
        DEBIAN_FRONTEND=noninteractive apt-get update -y
        DEBIAN_FRONTEND=noninteractive apt-get install unrar -y
    fi

    # Descargar
    rm -f "$TMP_RAR"
    wget -4 -q --no-check-certificate --tries=3 --timeout=15 -O "$TMP_RAR" "$URL_DROPBOX"

    # Verificar que se descargó bien
    if [[ ! -s "$TMP_RAR" ]]; then
        echo "ERROR: descarga fallida"
        exit 1
    fi

    # Extraer en carpeta temporal primero
    rm -rf "$TMP_EXTRACT"
    mkdir -p "$TMP_EXTRACT"
    unrar x -o+ -inul "$TMP_RAR" "$TMP_EXTRACT/"

    # Detectar si el RAR tiene subcarpeta (ej: adm-lite/menu en vez de menu directo)
    SUBDIR=$(find "$TMP_EXTRACT" -maxdepth 1 -mindepth 1 -type d | head -1)
    if [[ -f "$TMP_EXTRACT/menu" ]]; then
        SRC="$TMP_EXTRACT"
    elif [[ -n "$SUBDIR" && -f "$SUBDIR/menu" ]]; then
        SRC="$SUBDIR"
    else
        echo "ERROR: no se encontró archivo 'menu' en el RAR"
        exit 1
    fi

    # Limpiar destino preservando userDIR
    if [[ -d "$DIR_ADM" ]]; then
        find "$DIR_ADM" -mindepth 1 -maxdepth 1 ! -name "userDIR" -exec rm -rf {} +
    else
        mkdir -p "$DIR_ADM"
    fi

    # Copiar archivos al destino final
    cp -r "$SRC"/. "$DIR_ADM/"
    chmod -R +x "$DIR_ADM"

    # Crear accesos directos
    for BIN in /usr/bin/menu /usr/bin/adm /usr/local/bin/adm; do
        printf '#!/bin/bash\ncd /etc/adm-lite && ./menu\n' > "$BIN"
        chmod +x "$BIN"
    done

    # Limpieza
    rm -f "$TMP_RAR"
    rm -rf "$TMP_EXTRACT"
    sync && echo 3 > /proc/sys/vm/drop_caches

} 2>/tmp/fix_error.log

# Mostrar resultado
REAL_IP=$(get_real_ip)
if [[ -f "$DIR_ADM/menu" ]]; then
    STATUS="\033[1;32m✅ SISTEMA RESTAURADO"
else
    STATUS="\033[1;31m❌ FALLO - ver /tmp/fix_error.log"
fi
clear
echo -e "\033[1;32m=================================================="
echo -e " $STATUS"
echo -e " 🌐 IP REAL: \033[1;33m${REAL_IP:-Desconocida}\033[1;32m"
echo -e " ⌨️  COMANDO: \033[1;33mmenu\033[1;32m"
echo -e "==================================================\033[0m"