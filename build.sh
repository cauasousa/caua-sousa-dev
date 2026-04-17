#!/bin/bash
set -e

# 1. Instalar Flutter (usando o canal beta para garantir compatibilidade web)
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b beta
fi

# 2. Configurar PATH
export PATH="$PATH:$(pwd)/flutter/bin"

# 3. Configurações de ambiente
flutter config --enable-web
flutter doctor

# 4. Limpeza e Dependências
flutter clean
flutter pub get

# 5. Build Simplificado (Sem a flag que está travando)
flutter build web --release