# Script de Configuración de SSH sin Contraseña

Este script automatiza el proceso de configuración de una clave SSH para permitir conexiones seguras a un servidor remoto **sin necesidad de ingresar la contraseña** cada vez que te conectes.

### Características

- **Instalación automática** de `sshpass` si no está presente.
- **Generación y almacenamiento** de claves SSH si no existen previamente.
- **Copia de la clave pública** al servidor remoto utilizando `sshpass` para la autenticación automática.
- **Configuración de SSH** mediante la creación o actualización del archivo `~/.ssh/config`.
- **Prueba de conexión SSH** sin necesidad de contraseña.
- **Respaldo** de las claves generadas en un directorio configurado por el usuario.

### Requisitos previos

- **Sistema operativo**: Linux (comprobado en Ubuntu/Debian).
- **Herramientas necesarias**:
  - `sshpass`: Para automatizar la copia de la clave pública.
  - `ssh-keygen`: Para la creación de claves SSH.
  
Puedes instalar `sshpass` manualmente ejecutando:
```bash
sudo apt-get install sshpass
