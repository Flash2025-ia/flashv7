const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

// Configuración de la app
const appConfig = {
  appName: 'Flash App',
  appId: 'com.flash.app',
  webDir: '.'
};

// Inicializar Capacitor (solo una vez)
function initCapacitor() {
  try {
    console.log('Inicializando Capacitor...');
    execSync('npx cap init "Flash App" com.flash.app --web-dir=.', { stdio: 'inherit' });
    console.log('✅ Capacitor inicializado correctamente');
  } catch (error) {
    console.error('❌ Error al inicializar Capacitor:', error.message);
    process.exit(1);
  }
}

// Añadir plataforma Android (solo una vez)
function addAndroidPlatform() {
  try {
    console.log('Añadiendo plataforma Android...');
    execSync('npx cap add android', { stdio: 'inherit' });
    console.log('✅ Plataforma Android añadida correctamente');
  } catch (error) {
    console.error('❌ Error al añadir plataforma Android:', error.message);
    process.exit(1);
  }
}

// Actualizar configuración de la app
function updateConfiguration() {
  try {
    console.log('Actualizando configuración de la app...');
    
    // Copiar el AndroidManifest.xml personalizado si existe
    const manifestTemplatePath = path.join(__dirname, 'android-manifest-template.xml');
    if (fs.existsSync(manifestTemplatePath)) {
      const targetManifestPath = path.join(__dirname, 'android/app/src/main/AndroidManifest.xml');
      fs.copyFileSync(manifestTemplatePath, targetManifestPath);
      console.log('✅ AndroidManifest.xml actualizado');
    }
    
    // Sincronizar cambios con la plataforma Android
    execSync('npx cap sync android', { stdio: 'inherit' });
    console.log('✅ Configuración actualizada');
  } catch (error) {
    console.error('❌ Error al actualizar configuración:', error.message);
    process.exit(1);
  }
}

// Función principal
function main() {
  console.log('🔄 Preparando Flash App para Android...');
  
  // Verificar si ya existe la plataforma Android
  const androidDirExists = fs.existsSync(path.join(__dirname, 'android'));
  
  if (!androidDirExists) {
    initCapacitor();
    addAndroidPlatform();
  } else {
    console.log('ℹ️ La plataforma Android ya existe, actualizando...');
  }
  
  updateConfiguration();
  
  console.log('\n🎉 ¡Preparación completada!');
  console.log('\nPara generar el APK:');
  console.log('1. Ve a la carpeta android: cd android');
  console.log('2. Ejecuta: ./gradlew assembleDebug');
  console.log('3. El APK se generará en: android/app/build/outputs/apk/debug/app-debug.apk');
}

// Ejecutar función principal
main();