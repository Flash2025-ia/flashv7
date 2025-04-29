#!/bin/bash

# Colores para mejorar la legibilidad
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Generando APK para Flash App ===${NC}"

# Verificar si ya se ha inicializado Capacitor
if [ ! -d "android" ]; then
  echo -e "${YELLOW}➡️ Inicializando proyecto para Android...${NC}"
  node prepare-android.js
  if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Falló la preparación para Android${NC}"
    exit 1
  fi
else
  echo -e "${GREEN}✅ Proyecto Android ya inicializado${NC}"
  echo -e "${YELLOW}➡️ Sincronizando cambios...${NC}"
  npx cap sync android
fi

# Entrar a la carpeta android y generar el APK
echo -e "${YELLOW}➡️ Generando APK...${NC}"
cd android && ./gradlew assembleDebug

# Verificar si la compilación fue exitosa
if [ $? -eq 0 ]; then
  APK_PATH="app/build/outputs/apk/debug/app-debug.apk"
  
  # Verificar si el APK existe
  if [ -f "$APK_PATH" ]; then
    echo -e "${GREEN}✅ APK generado exitosamente${NC}"
    echo -e "${BLUE}📱 Ruta del APK:${NC} android/$APK_PATH"
    echo -e "${YELLOW}➡️ Puedes descargar el APK desde el panel de archivos de Replit${NC}"
    
    # Copiar APK a la raíz para facilitar acceso
    cp "$APK_PATH" ../FlashApp.apk
    echo -e "${GREEN}✅ APK copiado a la raíz como FlashApp.apk${NC}"
  else
    echo -e "${RED}❌ No se encontró el archivo APK en la ruta esperada${NC}"
  fi
else
  echo -e "${RED}❌ Error al generar el APK${NC}"
fi