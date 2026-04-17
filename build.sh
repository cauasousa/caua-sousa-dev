#!/bin/bash
set -e

# 1. Instala o Flutter se não existir
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable
fi

# 2. Configura o PATH
export PATH="$PATH:$(pwd)/flutter/bin"

# 3. HABILITAR WEB (O passo que estava faltando para reconhecer a flag)
flutter config --enable-web

# 4. Baixar dependências
flutter pub get

# 5. Build Final
# Removi o '=' e usei a sintaxe mais aceita em servidores CI
flutter build web --release --web-renderer canvaskit