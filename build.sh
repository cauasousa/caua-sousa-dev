#!/bin/bash
set -e

# 1. Instalar Flutter
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable
fi

# 2. Configurar PATH
export PATH="$PATH:$(pwd)/flutter/bin"

# 3. Forçar o download dos artefatos de Web (O segredo para reconhecer a flag)
flutter config --enable-web
flutter precache --web

# 4. Baixar dependências do seu projeto
flutter pub get

# 5. Build com a flag
flutter build web --release --web-renderer canvaskit