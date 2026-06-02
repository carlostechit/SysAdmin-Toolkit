# Guía de Despliegue: FileBrowser

## 1. Introducción
**FileBrowser** es una herramienta de gestión de archivos basada en web que permite organizar, editar, subir y descargar archivos en nuestro servidor local. En este Toolkit, actúa como nuestra nube privada y gestor de archivos centralizado.

## 2. Estructura de Directorios
El servicio se organiza bajo la siguiente jerarquía dentro de `docker-services/`:

filebrowser/
├── docker-compose.yml   # Definición del contenedor y volúmenes
├── config/              # Almacena settings.json y database.db (Persistencia)
└── data/                # Carpeta raíz gestionada (tus archivos)

## 3. Despliegue y Configuración Inicial
Para desplegar el servicio, asegúrate de estar en el directorio `docker-services/filebrowser/` y ejecuta:

`docker-compose up -d`

### Obtención de Credenciales
Por motivos de seguridad, FileBrowser genera una contraseña aleatoria en su primer despliegue. **No intentes credenciales por defecto**. Para obtenerla, consulta los logs del contenedor:

`docker-compose logs filebrowser | grep "password"`

*Si no aparece, revisa el log completo con `docker-compose logs filebrowser` y busca la línea que indica el usuario y la contraseña inicial.*

Accede a `http://localhost:8080`. Se recomienda cambiar la contraseña inmediatamente en el panel de Ajustes tras el primer inicio de sesión.

## 4. Notas Técnicas y Resolución de Problemas

### Persistencia de Datos
Se utilizan Bind Mounts para asegurar que los datos sobrevivan a la destrucción del contenedor:
* ./config:/config: Mantiene la configuración y la base de datos (vital para no perder usuarios/ajustes).
* ./data:/srv: Mantiene tus archivos físicos.

### Ciclo de Vida y Mantenimiento
* **Detener el servicio:** Usa `docker-compose down` para detener y eliminar el contenedor sin borrar tus datos.
* **Limpieza de sistema:** Ejecuta periódicamente `docker volume prune` para eliminar volúmenes anónimos huérfanos creados por pruebas o extensiones que no están siendo utilizados por ningún contenedor activo.