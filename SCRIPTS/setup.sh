#!/usr/bin/env bash
#
# setup.sh — Instalador único e INTERACTIVO para BTUN pré-ZTUN (v1.0.44).
#
# Este script es INDEPENDIENTE del zip: se coloca aparte y, al ejecutarlo,
# descarga el paquete, lo extrae y hace TODO, preguntando los puertos.
#
# Solo pregunta por:
#   - BHTTP (SSH): puerto directo (vacío = defecto 80)
#   - Puerto OpenSSH local: puerto directo (vacío = defecto 22)
#   - BTUN nativo: si activar (s/S/y/Y = sí, n/N = no)
#
# Los demás servicios (XHTTP, BTUN sobre BHTTP, BTUN sobre XHTTP) 
# quedan DESACTIVADOS por defecto sin preguntar.
#
# No pide claves (key) ni licencias: usa autenticación PAM por usuario+contraseña.
#
# Uso en la VPS (como root):
#   bash setup.sh
#
# Modo no interactivo (automático), por variables de entorno:
#   BHTTP_PORT=80 SSH_PORT=22 ENABLE_BTUN=1 ...
#   SETUP_USERNAME=cliente SETUP_PASSWORD='clave' bash setup.sh
#
set -Eeuo pipefail

# ---- URL del paquete (sin setup.sh). Edita si el enlace cambia. ----
BTUN_ZIP_URL="${BTUN_ZIP_URL:-https://github.com/karl1999x/PandaScript/raw/refs/heads/main/SCRIPTS/btun-full-install.zip}"

WORK_DIR="${WORK_DIR:-/root/btun-offline}"
SETUP_SSH_PORT="${SETUP_SSH_PORT:-22}"
SETUP_USERNAME="${SETUP_USERNAME:-}"
SETUP_PASSWORD="${SETUP_PASSWORD:-}"

C='\033[0m'; CY='\033[0;36m'; YE='\033[0;33m'; RE='\033[0;31m'; GR='\033[0;32m'
log()  { printf "${CY}[setup]${C} %s\n" "$*"; }
warn() { printf "${YE}[setup]${C} %s\n" "$*" >&2; }
die()  { printf "${RE}[setup ERROR]${C} %s\n" "$*" >&2; exit 1; }

valid_port() { [[ "$1" =~ ^[0-9]+$ ]] && (( 10#$1 >= 1 && 10#$1 <= 65535 )); }

# ---- Valores por defecto de puertos / servicios ----
BHTTP_PORT="${BHTTP_PORT:-80}"
SSH_PORT="$SETUP_SSH_PORT"
ENABLE_BTUN="${ENABLE_BTUN:-1}"

# DESACTIVADOS POR DEFECTO (sin preguntar)
ENABLE_XHTTP=0
ENABLE_BTUN_BHTTP=0
ENABLE_BTUN_XHTTP=0
XHTTP_PORT=443
BTUN_BHTTP_PORT=7080
BTUN_PORT=7300
BTUN_XHTTP_PORT=7443

# ---- Preguntas (SOLO 3) ----
ask_port() {                    # $1 texto, $2 defecto -> deja el resultado en _PORT
    local txt="$1" def="$2" ans
    read -r -p "$txt" ans
    ans="$(echo "$ans" | tr -d ' ')"
    if [[ -z "$ans" ]]; then _PORT="$def"; return 0; fi
    if valid_port "$ans"; then _PORT="$ans"; return 0; fi
    echo "  Puerto inválido, se usará $def."; _PORT="$def"
}
ask_yn() {                      # $1 texto, $2 defecto (s/n) -> 0=sí, 1=no
    local txt="$1" def="$2" ans
    read -r -p "$txt" ans
    ans="$(echo "$ans" | tr '[:upper:]' '[:lower:]')"
    [[ -z "$ans" ]] && ans="$def"
    case "$ans" in
        y|s|si|yes) return 0 ;;
        n|no)       return 1 ;;
        *) echo "  Responde s/n."; ask_yn "$txt" "$def" ;;
    esac
}

# ---- 1. Comprobaciones previas ----
(( EUID == 0 )) || die "Ejecuta como root:  sudo bash setup.sh  (o  bash setup.sh  como root)"
for cmd in systemctl ip iptables sshd install cp awk grep ldd; do
    command -v "$cmd" >/dev/null 2>&1 || die "Comando obligatorio ausente: $cmd"
done
[[ -d /run/systemd/system ]] || die "systemd no está activo en este sistema"
[[ -c /dev/net/tun ]] || die "Falta el dispositivo TUN: /dev/net/tun"

# ---- 2. Configuración interactiva (SOLO 3 PREGUNTAS) ----
if [[ -t 0 ]]; then
    echo ""
    echo "=== Configuración básica de BTUN pré-ZTUN ==="
    ask_port "BHTTP (SSH)        [defecto 80, vacío=80]: " 80; BHTTP_PORT="$_PORT"
    ask_port "Puerto OpenSSH local [defecto 22, vacío=22]: " 22; SSH_PORT="$_PORT"

    if ask_yn "¿Activar BTUN nativo (7300 tcp+udp)? [S/n]: " s; then
        ENABLE_BTUN=1
        if ask_yn "  ¿Puerto por defecto 7300? [S/n]: " s; then BTUN_PORT=7300
        else ask_port "  Puerto personalizado para BTUN nativo: " 7300; BTUN_PORT="$_PORT"; fi
    else 
        ENABLE_BTUN=0
        # Si no se activa BTUN nativo, se desactivan los que dependen de él
        ENABLE_BTUN_BHTTP=0
        ENABLE_BTUN_XHTTP=0
    fi
    echo ""
    echo "${CY}NOTA:${C} SSH_XHTTP, BTUN sobre BHTTP y BTUN sobre XHTTP han sido"
    echo "      desactivados automáticamente (no se preguntaron)."
    echo ""
fi

# Validar puertos elegidos
valid_port "$SSH_PORT"      || die "Puerto SSH inválido: $SSH_PORT"
valid_port "$BHTTP_PORT"    || die "Puerto BHTTP inválido: $BHTTP_PORT"
(( ENABLE_BTUN == 1 )) && { valid_port "$BTUN_PORT" || die "Puerto BTUN inválido: $BTUN_PORT"; }

# Puertos que NUESTROS servicios van a enlazar
PORTS_TO_FREE=()
add_free_port() { [[ "$1" != "$SSH_PORT" ]] && PORTS_TO_FREE+=("$1"); }
add_free_port "$BHTTP_PORT"
(( ENABLE_BTUN == 1 )) && add_free_port "$BTUN_PORT"

# Servicios web conocidos que entran en conflicto
KNOWN_WEB=(apache2 nginx lighttpd httpd)

port_holder() {
    local port="$1" pid comm
    pid="$(ss -lntpn "sport = :$port" 2>/dev/null | grep -oP 'pid=\K[0-9]+' | head -1)"
    [[ -n "$pid" ]] || return 0
    comm="$(tr '\0' ' ' < /proc/$pid/comm 2>/dev/null)"
    printf '%s %s' "$pid" "$comm"
}
free_required_ports() {
    local port info pid comm stopped svc
    for port in "${PORTS_TO_FREE[@]}"; do
        info="$(port_holder "$port")"
        [[ -n "$info" ]] || continue
        pid="${info%% *}"; comm="${info#* }"
        case "$comm" in
            bilola-server|bilola-xhttp-server|btun-server|xhttp-smoke|bhttp-smoke)
                if kill "$pid" 2>/dev/null; then
                    log "Puerto $port liberado (PID $pid: $comm)."
                fi ;;
            *)
                stopped=0
                for svc in "${KNOWN_WEB[@]}"; do
                    if [[ "$comm" == "$svc" ]] && systemctl is-active --quiet "$svc" 2>/dev/null; then
                        systemctl stop "$svc" >/dev/null 2>&1 && \
                            log "Detenido '$svc' que ocupaba el puerto $port." && stopped=1 && break
                    fi
                done
                if (( stopped == 0 )); then
                    warn "El puerto $port está ocupado por PID $pid ($comm)."
                    die "Puerto $port ocupado por proceso ajeno; detenlo manualmente (kill $pid  o  systemctl stop <servicio>) y reejecuta setup.sh."
                fi ;;
        esac
    done
}

# ---- 3. Obtener el paquete (descargar o usar local) ----
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

ZIP_PATH="$WORK_DIR/btun-full-install.zip"
if [[ -n "${BTUN_ZIP_LOCAL:-}" ]]; then
    [[ -f "$BTUN_ZIP_LOCAL" ]] || die "No existe el zip local: $BTUN_ZIP_LOCAL"
    log "Usando zip local: $BTUN_ZIP_LOCAL"
    cp -f "$BTUN_ZIP_LOCAL" "$ZIP_PATH"
else
    if command -v curl >/dev/null 2>&1; then
        log "Descargando paquete desde Dropbox..."
        curl -fL --retry 3 --retry-delay 2 -o "$ZIP_PATH" "$BTUN_ZIP_URL" \
            || die "No se pudo descargar el paquete desde: $BTUN_ZIP_URL"
    elif command -v wget >/dev/null 2>&1; then
        log "Descargando paquete desde Dropbox..."
        wget -q -O "$ZIP_PATH" "$BTUN_ZIP_URL" \
            || die "No se pudo descargar el paquete desde: $BTUN_ZIP_URL"
    else
        die "Se requiere curl o wget para descargar el paquete"
    fi
fi

if ! (head -c4 "$ZIP_PATH" | grep -q 'PK'); then
    die "El archivo descargado no parece un ZIP. Revisa BTUN_ZIP_URL."
fi

# ---- 4. Extraer ----
log "Extrayendo paquete..."
command -v unzip >/dev/null 2>&1 || die "Se requiere 'unzip' para extraer el paquete"
rm -rf "$WORK_DIR/BTUN"
unzip -o -q "$ZIP_PATH" -d "$WORK_DIR" || die "Fallo al extraer el zip"
[[ -d "$WORK_DIR/BTUN" ]] || die "No se encontró la carpeta BTUN tras extraer"
cd "$WORK_DIR/BTUN"

# ---- 5. Reparar permisos y verificar integridad ----
log "Reparando permisos de ejecución..."
chmod +x bin/amd64/* bin/arm64/* bhttp-menu 2>/dev/null || true

if [[ -f SHA256SUMS ]]; then
    if sha256sum -c SHA256SUMS --quiet >/dev/null 2>&1; then
        log "Integridad verificada (SHA256SUMS OK)."
    else
        warn "Algunos hashes no coinciden o faltan archivos. Continúo de todos modos."
    fi
else
    warn "SHA256SUMS no encontrado; se omite la verificación de integridad."
fi

# ---- 6. Liberar puertos y ejecutar el instalador (no interactivo) ----
if command -v ss >/dev/null 2>&1; then
    log "Verificando que los puertos elegidos estén libres..."
    free_required_ports
else
    warn "'ss' no disponible; no se pudo comprobar conflictos de puertos."
fi

log "Ejecutando install.sh (detección automática, sin claves)..."
export BHTTP_PORT XHTTP_PORT BTUN_BHTTP_PORT BTUN_PORT BTUN_XHTTP_PORT
export ENABLE_XHTTP ENABLE_BTUN_BHTTP ENABLE_BTUN ENABLE_BTUN_XHTTP
bash install.sh --ssh-port "$SSH_PORT"

# ---- 7. Garantizar login por contraseña (sin SSH key) ----
ensure_password_auth() {
    local dropin="/etc/ssh/sshd_config.d/btun-password-auth.conf"
    if [[ -d /etc/ssh/sshd_config.d ]]; then
        printf 'PasswordAuthentication yes\n' > "$dropin"
    elif [[ -f /etc/ssh/sshd_config ]]; then
        if grep -qi '^[[:space:]]*PasswordAuthentication[[:space:]]' /etc/ssh/sshd_config; then
            sed -i 's/^[[:space:]]*PasswordAuthentication[[:space:]].*/PasswordAuthentication yes/' /etc/ssh/sshd_config
        else
            printf '\nPasswordAuthentication yes\n' >> /etc/ssh/sshd_config
        fi
    else
        warn "No se encontró configuración de sshd; revisa la autenticación manualmente."
        return 0
    fi
    if sshd -t >/dev/null 2>&1; then
        systemctl reload ssh sshd >/dev/null 2>&1 || true
        log "Autenticación por contraseña SSH habilitada (no se requiere key)."
    else
        warn "La configuración de sshd no valida; revísala manualmente (sshd -t)."
    fi
}
log "Habilitando autenticación por contraseña en SSH (para no usar key)..."
ensure_password_auth

# ---- 8. (Opcional) crear un usuario SSH sin prompts ----
if [[ -n "$SETUP_USERNAME" && -n "$SETUP_PASSWORD" ]]; then
    if id "$SETUP_USERNAME" >/dev/null 2>&1; then
        log "El usuario '$SETUP_USERNAME' ya existe; no se modifica."
    else
        useradd -m -s /bin/bash "$SETUP_USERNAME" || die "No se pudo crear el usuario '$SETUP_USERNAME'"
        printf '%s:%s\n' "$SETUP_USERNAME" "$SETUP_PASSWORD" | chpasswd || die "No se pudo fijar la contraseña"
        log "Usuario '$SETUP_USERNAME' creado (acceso por contraseña, sin key)."
    fi
fi

# ---- 9. Resumen ----
PUBLIC_HOST="$(ip -4 route get 1.1.1.1 2>/dev/null | awk '/src/ {for (i=1; i<=NF; i++) if ($i == "src") {print $(i+1); exit}}')"
[[ -n "$PUBLIC_HOST" ]] || PUBLIC_HOST="$(hostname -f 2>/dev/null || hostname)"

cat <<EOF

${GR}===========================================================${C}
${GR}  BTUN pré-ZTUN instalado y en ejecución${C}
${GR}===========================================================${C}
Host / IP:        $PUBLIC_HOST
OpenSSH local:    $SSH_PORT/tcp   (login por contraseña, sin key)
BHTTP (SSH):      $BHTTP_PORT/tcp
EOF
if (( ENABLE_BTUN == 1 )); then
cat <<EOF
BTUN nativo:      $BTUN_PORT/tcp + $BTUN_PORT/udp
EOF
fi
if (( ENABLE_XHTTP == 1 )); then
cat <<EOF
SSH_XHTTP / BTUN:  $XHTTP_PORT/tcp  (TLS autofirmado, sin CA)
EOF
fi
if (( ENABLE_BTUN_BHTTP == 1 )); then
cat <<EOF
BTUN sobre BHTTP: $BTUN_BHTTP_PORT/tcp
EOF
fi
if (( ENABLE_BTUN_XHTTP == 1 )); then
cat <<EOF
BTUN sobre XHTTP: $BTUN_XHTTP_PORT/tcp
EOF
fi
cat <<EOF

Menú de gestión (crear usuarios, ver conexiones, logs, puertos):
  bhttp            -> abre el menú interactivo
  bhttp status     -> estado del servicio principal

Para conectar el cliente:
  Servidor: $PUBLIC_HOST
  Puerto:   $BHTTP_PORT   Modo: BHTTP   SSH: $SSH_PORT
  Usuario / contraseña: una cuenta válida de esta VPS
EOF

if [[ -z "$SETUP_USERNAME" ]]; then
    cat <<EOF

${YE}Nota:${C} aún no hay un usuario SSH de acceso. Créalo sin prompts con:
  SETUP_USERNAME=cliente SETUP_PASSWORD='tu-clave' bash setup.sh
  o ábrelo en el menú:  bhttp  -> opción 1.
EOF
fi