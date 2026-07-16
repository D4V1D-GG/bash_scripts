#!/bin/bash
#
# actualizar_sistema.sh
# Actualiza la lista de paquetes y aplica las actualizaciones disponibles.
# Pensado para ejecutarse como tarea programada (cron/systemd) en Debian,
# Pensado para servidores headless.

# --- Configuración ---
LOG_DIR="/var/log/actualizaciones-sistema"
LOG_FILE="$LOG_DIR/actualizacion_$(date +%Y%m%d_%H%M%S).log"

# Evita que dpkg/apt lancen prompts interactivos (crítico en headless,
# donde nadie puede responder y el proceso se quedaría colgado)
export DEBIAN_FRONTEND=noninteractive

# Crear carpeta de logs si no existe

mkdir -p "$LOG_DIR"

echo "===== Inicio de la actualización: $(date) =====" | tee -a "$LOG_FILE"

# -y para confirmar automáticamente (necesario al ejecutarse sin usuario presente)
# --force-confdef / --force-confold: si hay conflicto en archivos de configuración,
# mantiene automáticamente la versión actual en vez de preguntar
apt-get update -y >> "$LOG_FILE" 2>&1
apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade >> "$LOG_FILE" 2>&1

# Opcional: elimina paquetes ya no necesarios
apt-get autoremove -y >> "$LOG_FILE" 2>&1

# Comprobar si el sistema necesita un reinicio (típico tras actualizar el kernel
# o librerías como libssl). No reinicia automáticamente, solo avisa en el log.
if [ -f /var/run/reboot-required ]; then
    echo "¡ATENCIÓN! El sistema requiere un reinicio." | tee -a "$LOG_FILE"
    if [ -f /var/run/reboot-required.pkgs ]; then
        echo "Paquetes que lo motivan:" | tee -a "$LOG_FILE"
        cat /var/run/reboot-required.pkgs | tee -a "$LOG_FILE"
    fi
fi

echo "===== Fin de la actualización: $(date) =====" | tee -a "$LOG_FILE"
