#!/bin/bash

set -e
echo "=================================================="
echo "          APAGANDO ESTRUCTURA MODULAR             "
echo "=================================================="

# Deteniendo servicio App: FileBrowser

echo -e "\n[+] Deteniendo servicio App: FileBrowser..."
cd ../../docker-services/filebrowser
docker compose down

# Deteniendo servicio Core: Nginx Proxy Manager

echo -e "\n[+] Deteniendo servicio Core: Nginx Proxy Manager..."
cd ../../docker-services/nginx-proxy-manager
docker compose down

echo "    -> Red Toolkit mantenida, para futuros arranques."

echo -e "\n=============================================="
echo "     ESTRUCTURA MODULAR APAGADA CORRECTAMENTE      "
echo -e "================================================"