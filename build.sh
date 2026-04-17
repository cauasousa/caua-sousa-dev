#!/bin/bash
set -e

# 1. Instalar Flutter se não existir
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable
fi

# 2. Configurar PATH
export PATH="$PATH:$(pwd)/flutter/bin"

# 3. Forçar o Flutter a se "reconhecer" como Web
flutter config --enable-web
flutter precache --web

# 4. Baixar dependências
flutter pub get

# 5. Build (Trocando a flag por uma alternativa caso a versão tenha mudado)
# Se o erro 64 persistir aqui, o Flutter está em uma versão que usa 
# apenas 'flutter build web' e assume o renderer automaticamente.
flutter build web --release --wasm --web-renderer canvaskit