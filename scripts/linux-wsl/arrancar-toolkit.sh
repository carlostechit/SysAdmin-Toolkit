#!/bin/bash
set -e

echo "========================================="
echo "   INICIALIZANDO INFRAESTRUCTURA MODULAR "
echo "========================================="

# 1. Fase de Red (Networking) - Forzar creación si no existe
echo "[+] Configurando la red externa de la plataforma..."
if ! docker network ls | grep -q "toolkit_net"; then
    docker network create toolkit_net
    echo "    -> Red 'toolkit_net' creada globalmente con éxito."
else
    echo "    -> Red 'toolkit_net' ya existe en el sistema. Omitiendo."
fi

# 2. Fase de Core (Nginx Proxy Manager)
echo -e "\n[+] Desplegando servicio Core: NPM..."
cd ../../docker-services/nginx-proxy-manager
docker compose up -d

# 3. Fase de Aplicaciones (FileBrowser)
echo -e "\n[+] Desplegando servicio App: FileBrowser..."
cd ../../docker-services/filebrowser

docker compose up -d

echo -e "\n========================================="
echo "   ¡STACK DESPLEGADO CORRECTAMENTE!      "
echo "========================================="