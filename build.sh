#!/bin/bash
# Interrompe o script se houver erro
set -e

# 1. Instala o Flutter caso não exista
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable
fi

# 2. Configura o PATH de forma absoluta
export PATH="$PATH:$(pwd)/flutter/bin"

# 3. Baixa as dependências do seu projeto (Essencial para não dar erro 64)
flutter pub get

# 4. Build com sintaxe corrigida
flutter build web --release --web-renderer=canvaskit