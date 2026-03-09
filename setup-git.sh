#!/bin/bash
# Script para configurar git en NixOS live ISO
# Ejecutar antes de clonar el repo

echo "Configurando git..."

# Tus datos
git config --global user.name "René Kuhm"
git config --global user.email "renekuhm2@gmail.com"

# Intentar usar gh si está disponible
if command -v gh &> /dev/null; then
    echo "GH encontrado, configurando credential helper..."
    git config --global credential.helper /usr/bin/gh auth git-credential
else
    echo "GH no encontrado, configurando store..."
    git config --global credential.helper store
fi

echo ""
echo "=== Listo ==="
echo "Ahora podés clonar tu repo:"
echo "git clone https://github.com/Rene-Kuhm/Repo-configuracion-nixos-para-mi-equipo.git"
echo ""
echo "O si tenés SSH configurado:"
echo "git clone git@github.com:Rene-Kuhm/Repo-configuracion-nixos-para-mi-equipo.git"
