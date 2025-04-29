# Instrucciones para convertir Flash App en APK

Este documento contiene instrucciones paso a paso para convertir la aplicación web Flash App en una aplicación Android (APK) utilizando servicios gratuitos en línea.

## Método 1: Usando GoNative.io (Recomendado)

GoNative.io es un servicio en línea que permite convertir sitios web en aplicaciones nativas sin programación.

### Pasos:

1. Visita [GoNative.io](https://gonative.io/)

2. Completa el formulario con esta información:
   - **URL:** La URL de tu aplicación web desplegada
   - **App Name:** Flash App
   - **App Icon:** Sube el logo.jpg incluido en este proyecto

3. En la sección de configuración avanzada:
   - Activa "Enable Geolocation"
   - Activa "Pull to Refresh"
   - Configura la pantalla de inicio con el logo
   - En permisos, asegúrate de incluir:
     - INTERNET
     - ACCESS_FINE_LOCATION
     - ACCESS_COARSE_LOCATION

4. Genera la aplicación y descarga el APK

## Método 2: Usando WebViewGold

WebViewGold es otra opción que ofrece características adicionales.

1. Visita [WebViewGold](https://www.webviewgold.com/)

2. Compra una licencia si decides usar este servicio

3. Configura tu aplicación con:
   - URL de tu aplicación web
   - Nombre: Flash App
   - Permisos de geolocalización habilitados

## Método 3: Configuración manual con Android Studio

Si prefieres crear la APK manualmente:

### Requisitos:
- Android Studio instalado
- JDK (Java Development Kit)
- Conocimientos básicos de Android

### Pasos:

1. Crea un nuevo proyecto en Android Studio tipo "Empty Activity"

2. Configura el proyecto:
   - Nombre: Flash App
   - Paquete: com.flash.app
   - Mínimo SDK: API 21 (Android 5.0)

3. Modifica el archivo `activity_main.xml`:
   ```xml
   <?xml version="1.0" encoding="utf-8"?>
   <RelativeLayout xmlns:android="http://schemas.android.com/apk/res/android"
       xmlns:tools="http://schemas.android.com/tools"
       android:layout_width="match_parent"
       android:layout_height="match_parent"
       tools:context=".MainActivity">

       <WebView
           android:id="@+id/webView"
           android:layout_width="match_parent"
           android:layout_height="match_parent" />

   </RelativeLayout>
   ```

4. Modifica el archivo `MainActivity.java`:
   ```java
   package com.flash.app;

   import androidx.appcompat.app.AppCompatActivity;
   import android.os.Bundle;
   import android.webkit.GeolocationPermissions;
   import android.webkit.WebChromeClient;
   import android.webkit.WebSettings;
   import android.webkit.WebView;
   import android.webkit.WebViewClient;

   public class MainActivity extends AppCompatActivity {
       private WebView webView;

       @Override
       protected void onCreate(Bundle savedInstanceState) {
           super.onCreate(savedInstanceState);
           setContentView(R.layout.activity_main);

           webView = findViewById(R.id.webView);
           WebSettings webSettings = webView.getSettings();
           webSettings.setJavaScriptEnabled(true);
           webSettings.setGeolocationEnabled(true);
           webSettings.setDomStorageEnabled(true);
           
           webView.setWebViewClient(new WebViewClient());
           webView.setWebChromeClient(new WebChromeClient() {
               @Override
               public void onGeolocationPermissionsShowPrompt(String origin, GeolocationPermissions.Callback callback) {
                   callback.invoke(origin, true, false);
               }
           });
           
           // Carga el HTML desde los assets
           webView.loadUrl("file:///android_asset/index.html");
       }
       
       @Override
       public void onBackPressed() {
           if (webView.canGoBack()) {
               webView.goBack();
           } else {
               super.onBackPressed();
           }
       }
   }
   ```

5. Modifica el archivo `AndroidManifest.xml` para agregar permisos:
   ```xml
   <?xml version="1.0" encoding="utf-8"?>
   <manifest xmlns:android="http://schemas.android.com/apk/res/android"
       package="com.flash.app">

       <uses-permission android:name="android.permission.INTERNET" />
       <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
       <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

       <application
           android:allowBackup="true"
           android:icon="@mipmap/ic_launcher"
           android:label="@string/app_name"
           android:roundIcon="@mipmap/ic_launcher_round"
           android:supportsRtl="true"
           android:theme="@style/AppTheme">
           <activity
               android:name=".MainActivity"
               android:exported="true">
               <intent-filter>
                   <action android:name="android.intent.action.MAIN" />
                   <category android:name="android.intent.category.LAUNCHER" />
               </intent-filter>
           </activity>
       </application>
   </manifest>
   ```

6. Copia todos los archivos de tu aplicación web (HTML, CSS, JS, imágenes) a la carpeta `app/src/main/assets/` del proyecto

7. Genera la APK: Build > Build Bundle(s) / APK(s) > Build APK(s)

## Verificación y Pruebas

Una vez que tengas la APK:

1. Instala la APK en tu dispositivo Android
2. Verifica que la aplicación se inicie correctamente
3. Prueba que la detección de ubicación funcione
4. Comprueba que la integración con WhatsApp funcione al solicitar un servicio

## Solución de Problemas Comunes

### La aplicación no detecta la ubicación
- Verifica que hayas concedido permisos de ubicación a la aplicación
- Asegúrate de tener el GPS activado en tu dispositivo

### Los enlaces a WhatsApp no funcionan
- Verifica que WhatsApp esté instalado en el dispositivo
- Comprueba que el número de teléfono en el código JavaScript sea correcto

### La aplicación se cierra inesperadamente
- Verifica los permisos en el Manifiesto
- Comprueba que el WebView esté bien configurado para JavaScript y geolocalización