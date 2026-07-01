#!/bin/bash
#
# actualizar_sistema.sh
# Actualiza la lista de paquetes y aplica las actualizaciones disponibles.
# Pensado para ejecutarse como tarea programada (cron) en Linux Mint / Ubuntu.

# --- Configuración ---
LOG_DIR="/var/log/actualizaciones-sistema"
LOG_FILE="$LOG_DIR/actualizacion_$(date +%Y%m%d_%H%M%S).log"

# Crear carpeta de logs si no existe
mkdir -p "$LOG_DIR"

echo "===== Inicio de la actualización: $(date) =====" | tee -a "$LOG_FILE"

# -y para confirmar automáticamente (necesario al ejecutarse sin usuario presente)
apt update -y >> "$LOG_FILE" 2>&1
apt upgrade -y >> "$LOG_FILE" 2>&1

# Opcional: elimina paquetes ya no necesarios
apt autoremove -y >> "$LOG_FILE" 2>&1

echo "===== Fin de la actualización: $(date) =====" | tee -a "$LOG_FILE"


#ESE MISMO SCRIPT LO MUEVES AL DIRECTORIO /usr/local/bin/
#sudo mv ~/Descargas/actualizar_sistema.sh /usr/local/bin/actualizar_sistema.sh


#LE AGREGAS PERMISOS PARA EVITAR PROBLEMAS
#sudo chmod ugo+x /usr/local/bin/actualizar_sistema.sh


#EDITAS EL CRONTAB DE ROOT
#sudo crontab -e


#Y AÑADES ESTA LINEA AL FINAL
#0 12 * * * /usr/local/bin/actualizar_sistema.sh
#EJEMPLO: Se ejecuta el script a las 12:00


#UNA VEZ PASADA DICHA HORA, CONSULTA EL DIRECTORIO /var/log/actualizaciones-sistema para visualizar los archivos .log pues ahí se encuentran los resultados.

