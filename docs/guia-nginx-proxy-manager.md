# Guía de despliegue Nginx Proxy Manager

Esta documentación detalla la configuración y despliegue de los servicios principales: Nginx Proxy Manager (NPM) y FileBrowser, asegurando una gestión centralizada y segura de los servicios en un entorno Dockerizado.

---

## 1. Arquitectura de Red y Despliegue
La infraestructura se basa en una red Docker compartida (toolkit_net) que permite la comunicación entre el Proxy y los contenedores de backend.

### Orden de Ejecución (Obligatorio)
Para garantizar la resolución de nombres y conectividad entre servicios, el orden de despliegue es:
1. Nginx Proxy Manager: Debe levantarse primero para gestionar las rutas y la red.
2. Servicios de Backend (FileBrowser, etc.): Se despliegan posteriormente para que el Proxy pueda descubrir sus rutas internas.

---

## 2. Nginx Proxy Manager (NPM)

### Estructura de Directorios
nginx-proxy-manager/
├── docker-compose.yml     # Definición del contenedor y volúmenes
├── data/                  # Persistencia de configuraciones y base de datos
└── letsencrypt/           # Almacenamiento de certificados SSL

### Configuración del Proxy Host (Ejemplo: FileBrowser)
Para enrutar tráfico interno hacia FileBrowser, se han aplicado las siguientes configuraciones en la interfaz de NPM:
* Scheme: http
* Forward Hostname/IP: filebrowser (Nombre del servicio en Docker)
* Forward Port: 80
* Access List: Solo-Red_Local

### Gestión de Seguridad (Access List: "Solo-Red_Local")
Para restringir el acceso a la red local y evitar exposición pública, se han configurado reglas estrictas en NPM:
* Regla de acceso: Allow 172.19.0.0/16 (Rango de la subred Docker interna).
* Regla por defecto: Deny all (bloquea cualquier tráfico fuera de la red interna definida).

---

## 3. FileBrowser

### Estructura de Directorios
filebrowser/
├── docker-compose.yml     # Definición del contenedor y volúmenes
├── config/                # Persistencia de settings.json y base de datos
└── data/                  # Carpeta raíz gestionada (tus archivos)

### Configuración de Seguridad
* Credenciales: Tras el primer despliegue, la contraseña debe obtenerse mediante los logs del contenedor:
  docker-compose logs filebrowser | grep "password"
* Acceso: Interfaz disponible vía proxy en mis-archivos.local o IP interna.

---

## 4. Notas Técnicas y Resolución de Problemas

### Persistencia de Datos
Se utilizan Bind Mounts para asegurar que los datos sobrevivan a la destrucción de contenedores:
* NPM: ./data:/data y ./letsencrypt:/etc/letsencrypt.
* FileBrowser: ./config:/config y ./data:/srv.

### Consideraciones Generales
1. Websockets: Si algún servicio (como el panel de logs de FileBrowser) falla en la carga, activar "Websockets Support" en la configuración del Proxy Host en NPM.
2. Ciclo de Vida: Utilizar siempre docker-compose down para detener servicios y docker volume prune para limpiar volúmenes huérfanos del sistema.
3. Logs: Ante errores de conexión, siempre revisar los logs de los contenedores implicados: docker-compose logs -f [nombre-servicio].