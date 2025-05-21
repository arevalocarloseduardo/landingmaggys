#!/bin/bash

# Salir si ocurre un error
set -e

# 1. Compilar la app Flutter para web con base-href correcto
REPO_NAME="landingmaggys"
echo "Compilando Flutter web con base-href=/$REPO_NAME/ ..."
flutter build web --base-href="/$REPO_NAME/"

# 2. Instalar ghp-import si no está instalado
if ! command -v ghp-import &> /dev/null
then
    echo "Instalando ghp-import..."
    pip install ghp-import==2.1.0
fi

# 3. Publicar en gh-pages
echo "Publicando en gh-pages..."
ghp-import -n -p -f build/web

echo "¡Despliegue completado! Recuerda configurar GitHub Pages en la rama gh-pages si no lo has hecho."