#!/bin/bash

set -e

echo -e "\n[+] Limpiando volumenes sin usar ..."


docker volume prune -f

echo -e "\n=============================================================="
echo "     LOS VOLUMENES SIN USAR FUERON LIMPIADOS CORRECTAMENTE    "
echo "=============================================================="
