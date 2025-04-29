# Guía para convertir Flash App en una aplicación Android (APK)

Esta guía te mostrará cómo convertir tu aplicación web actual en una aplicación Android nativa usando Capacitor, paso a paso.

## Requisitos previos

1. **Node.js y npm**: Asegúrate de tener Node.js instalado en tu computadora.
2. **Android Studio**: Necesitarás Android Studio para compilar la APK.
3. **JDK (Java Development Kit)**: Asegúrate de tener instalado JDK 11 o superior.

## Pasos para generar la APK

### 1. Preparar estructura del proyecto

Crea un nuevo directorio para tu proyecto si aún no lo tienes:

```bash
mkdir flash-app
cd flash-app
```

### 2. Inicializar proyecto NPM

```bash
npm init -y
```

### 3. Instalar Capacitor

```bash
npm install @capacitor/core @capacitor/cli @capacitor/android
```

### 4. Inicializar Capacitor

```bash
npx cap init "Flash App" com.flash.app
```

### 5. Copiar los archivos web actuales

Copia todos tus archivos web (HTML, CSS, JS) al directorio principal del proyecto:

- `index.html`
- `css/`
- `js/`
- `assets/`

### 6. Configurar Capacitor

Edita el archivo `capacitor.config.json` para configurar tu aplicación:

```json
{
  "appId": "com.flash.app",
  "appName": "Flash App",
  "webDir": ".",
  "bundledWebRuntime": false,
  "plugins": {
    "Permissions": {
      "geolocation": true
    }
  },
  "server": {
    "androidScheme": "https"
  }
}
```

### 7. Agregar plataforma Android

```bash
npx cap add android
```

### 8. Configurar permisos de Android

Edita el archivo `android/app/src/main/AndroidManifest.xml` y agrega los siguientes permisos:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```

### 9. Actualizar WebView para habilitar Geolocalización

Edita el archivo `android/app/src/main/java/com/flash/app/MainActivity.java`:

```java
package com.flash.app;

import android.os.Bundle;
import android.webkit.GeolocationPermissions;
import android.webkit.WebChromeClient;
import android.webkit.WebView;

import com.getcapacitor.BridgeActivity;

public class MainActivity extends BridgeActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Configurar WebView para geolocalización
        WebView webView = getBridge().getWebView();
        webView.getSettings().setGeolocationEnabled(true);
        webView.setWebChromeClient(new WebChromeClient() {
            @Override
            public void onGeolocationPermissionsShowPrompt(String origin, GeolocationPermissions.Callback callback) {
                callback.invoke(origin, true, false);
            }
        });
    }
}
```

### 10. Sincronizar cambios

```bash
npx cap sync android
```

### 11. Abrir proyecto en Android Studio

```bash
npx cap open android
```

### 12. Generar APK desde Android Studio

1. En Android Studio, ve a Build > Build Bundle(s) / APK(s) > Build APK(s)
2. Espera a que se complete la construcción
3. Haz clic en el enlace "Locate" para encontrar el archivo APK generado

### 13. Instalar APK en tu dispositivo

1. Transfiere el APK a tu dispositivo Android
2. Instálalo (asegúrate de permitir la instalación de orígenes desconocidos)

## Problemas comunes y soluciones

### Error de permisos

Si la aplicación no puede acceder a la ubicación, verifica que:

1. Hayas agregado los permisos en el AndroidManifest.xml
2. Hayas configurado correctamente el WebView como se muestra arriba
3. El usuario haya aceptado los permisos durante la ejecución de la app

### Problemas con WhatsApp

Si la integración con WhatsApp no funciona:

1. Asegúrate de que el dispositivo tenga WhatsApp instalado
2. Verifica que la URL de WhatsApp esté correctamente formateada en tu código JS

## Optimizaciones adicionales

### Iconos y Splash Screen

Para agregar iconos personalizados y pantalla de inicio:

```bash
npm install @capacitor/splash-screen
npx cap add @capacitor/splash-screen
```

Luego genera los recursos según las especificaciones de Capacitor.

### Modo de pantalla completa

Para hacer que la app se ejecute en pantalla completa, agrega al archivo `capacitor.config.json`:

```json
"android": {
  "screenOrientation": "portrait",
  "hideNavigationBar": true,
  "fullscreen": true
}
```

## Distribución de la APK

Para publicar tu aplicación en Google Play Store:

1. Crea una cuenta de desarrollador en Google Play Console
2. Genera una versión firmada de tu APK (Build > Generate Signed Bundle/APK)
3. Sigue las instrucciones de Google Play Console para publicar tu app

---

¡Eso es todo! Esta guía te ayudará a convertir tu aplicación web Flash App en una aplicación Android nativa con todas las funcionalidades necesarias.