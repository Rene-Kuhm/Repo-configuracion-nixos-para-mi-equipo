#!/bin/bash
# Script de configuración inicial para NixOS live ISO
# Ejecutar al inicio antes de instalar

set -e

echo "=== Configuración inicial NixOS ==="

# 1. Configurar git
echo "[1/4] Configurando git..."
git config --global user.name "René Kuhm"
git config --global user.email "renekuhm2@gmail.com"

# 2. Iniciar SSH agent y agregar clave
echo "[2/4] Configurando SSH..."
eval "$(ssh-agent -s)"

# Buscar clave SSH existente o generar nueva
SSH_KEY="$HOME/.ssh/id_ed25519"
if [ -f "$SSH_KEY" ]; then
    echo "Clave SSH existente encontrada"
else
    echo "Generando nueva clave SSH..."
    ssh-keygen -t ed25519 -C "renekuhm2@gmail.com" -f "$SSH_KEY" -N ""
fi

# Agregar clave al agente
ssh-add "$SSH_KEY"

# 3. Mostrar clave pública para agregar a GitHub
echo "[3/4] Tu clave SSH pública:"
echo ""
cat "${SSH_KEY}.pub"
echo ""
echo "=== AGREGAR ESTA CLAVE A GITHUB ==="
echo "Ir a: https://github.com/settings/keys"
echo "Click: New SSH key"
echo "Pegar la clave de arriba"
echo "===================================="
echo ""

# 4. Esperar confirmación
read -p "Presiona Enter después de agregar la clave a GitHub..."

# 5. Probar conexión SSH
echo "[4/4] Probando conexión SSH a GitHub..."
ssh -T git@github.com && echo "¡Conexión exitosa!"

echo ""
echo "=== Configuración completa ==="
echo "Ahora podés clonar tu repo:"
echo "git clone git@github.com:Rene-Kuhm/Repo-configuracion-nixos-para-mi-equipo.git"
