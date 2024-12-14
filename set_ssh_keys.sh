#!/bin/bash

# Verifica si sshpass está instalado, si no lo está, lo instala
if ! command -v sshpass &> /dev/null; then
    echo "sshpass no está instalado. Instalando..."
    sudo apt-get update
    sudo apt-get install sshpass -y
fi

# Variables globales (define estos valores al inicio del script)
SERVIDOR="192.168.0.1"      # IP del servidor
USUARIO=""              # Usuario del servidor
CONTRASENA=""     # Contraseña actual del servidor
CARPETA_BACKUP="./ssh_config_backup"  # Carpeta donde se guardarán las claves SSH

# Ruta del archivo de clave SSH (en la carpeta de respaldo)
CLAVE_PRIVADA="$CARPETA_BACKUP/id_rsa"
CLAVE_PUBLICA="$CARPETA_BACKUP/id_rsa.pub"

# Verifica si la carpeta de respaldo existe, si no la crea
if [ ! -d "$CARPETA_BACKUP" ]; then
    echo "Creando carpeta de respaldo en $CARPETA_BACKUP..."
    mkdir -p "$CARPETA_BACKUP"
fi

# Verifica si ya existe una clave SSH en la carpeta de respaldo
if [ ! -f "$CLAVE_PRIVADA" ]; then
    echo "No se encontró clave SSH en la carpeta de respaldo, generando una nueva..."
    # Generar clave SSH si no existe
    ssh-keygen -t rsa -b 4096 -C "tu_correo@ejemplo.com" -f "$CLAVE_PRIVADA" -N ""
else
    echo "Clave SSH ya existe en $CLAVE_PRIVADA. Continuando..."
fi

# Copiar la clave pública al servidor remoto usando sshpass para ingresar la contraseña automáticamente
echo "Copiando clave pública al servidor $SERVIDOR..."
sshpass -p "$CONTRASENA" ssh-copy-id -i "$CLAVE_PUBLICA" "$USUARIO@$SERVIDOR"

# Verificar si la clave fue copiada correctamente
if [ $? -eq 0 ]; then
    echo "La clave pública fue copiada correctamente al servidor $SERVIDOR."
else
    echo "Hubo un error al copiar la clave al servidor. Verifica las credenciales o la conectividad."
    exit 2
fi

# Agregar configuración al archivo ~/.ssh/config si no existe ya
CONFIG_SSH="$HOME/.ssh/config"

if ! grep -q "Host $SERVIDOR" "$CONFIG_SSH"; then
    echo "Agregando configuración de conexión SSH al archivo $CONFIG_SSH..."
    echo -e "\nHost $SERVIDOR\n  HostName $SERVIDOR\n  User $USUARIO\n  IdentityFile $CLAVE_PRIVADA\n  StrictHostKeyChecking no" >> "$CONFIG_SSH"
else
    echo "Ya existe una configuración para el servidor $SERVIDOR en $CONFIG_SSH."
fi

# Probar la conexión SSH sin contraseña
echo "Probando la conexión SSH sin contraseña..."
ssh "$USUARIO@$SERVIDOR" "echo 'Conexión exitosa sin contraseña.'"

# Verificación del éxito
if [ $? -eq 0 ]; then
    echo "¡Configuración completa! Ahora puedes conectarte sin ingresar contraseña."
else
    echo "Hubo un error en la conexión. Revisa la configuración."
    exit 3
fi

# Instrucciones finales
echo -e "\n\n"
cat ~/.ssh/config
echo -e "\n\n"
echo "Recuerda que la carpeta de respaldo con las claves SSH está en $CARPETA_BACKUP."
echo "Puedes usar esta carpeta para configurar otros servidores o restaurar la configuración después de una reinstalación del sistema."

