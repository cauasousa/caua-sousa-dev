#!/bin/bash
# Instala o Flutter caso não exista (a Vercel usa ambientes Linux)
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable
fi
export PATH="$PATH:`pwd`/flutter/bin"
flutter doctor
flutter build web --release --web-renderer canvaskit