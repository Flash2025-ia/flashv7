#!/bin/bash

# Colores para mejorar la legibilidad
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Preparando Proyecto Android para Flash App ===${NC}"

# Directorio para el proyecto Android
ANDROID_DIR="flash-app-android"
ASSETS_DIR="$ANDROID_DIR/app/src/main/assets"

# Crear directorio para el proyecto Android
mkdir -p "$ASSETS_DIR"

echo -e "${YELLOW}➡️ Copiando archivos de la aplicación web a assets...${NC}"

# Copiar archivos de la aplicación web
cp -r index.html css js assets "$ASSETS_DIR"
cp assets/logo.svg "$ASSETS_DIR"

# Crear estructura de directorios para código Java
mkdir -p "$ANDROID_DIR/app/src/main/java/com/flash/app"

echo -e "${YELLOW}➡️ Creando archivos de configuración de Android...${NC}"

# Crear archivo MainActivity.java
cat > "$ANDROID_DIR/app/src/main/java/com/flash/app/MainActivity.java" << 'EOF'
package com.flash.app;

import android.os.Bundle;
import android.webkit.GeolocationPermissions;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import androidx.appcompat.app.AppCompatActivity;

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
EOF

# Crear archivo activity_main.xml
mkdir -p "$ANDROID_DIR/app/src/main/res/layout"
cat > "$ANDROID_DIR/app/src/main/res/layout/activity_main.xml" << 'EOF'
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
EOF

# Crear archivo AndroidManifest.xml
mkdir -p "$ANDROID_DIR/app/src/main"
cat > "$ANDROID_DIR/app/src/main/AndroidManifest.xml" << 'EOF'
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
EOF

# Crear archivo build.gradle para el proyecto
cat > "$ANDROID_DIR/build.gradle" << 'EOF'
// Top-level build file where you can add configuration options common to all sub-projects/modules.
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:7.2.2'
        
        // NOTE: Do not place your application dependencies here; they belong
        // in the individual module build.gradle files
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

task clean(type: Delete) {
    delete rootProject.buildDir
}
EOF

# Crear archivo build.gradle para la app
mkdir -p "$ANDROID_DIR/app"
cat > "$ANDROID_DIR/app/build.gradle" << 'EOF'
plugins {
    id 'com.android.application'
}

android {
    compileSdkVersion 33
    
    defaultConfig {
        applicationId "com.flash.app"
        minSdkVersion 21
        targetSdkVersion 33
        versionCode 1
        versionName "1.0"
        
        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
    }
    
    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
}

dependencies {
    implementation 'androidx.appcompat:appcompat:1.6.1'
    implementation 'com.google.android.material:material:1.9.0'
    implementation 'androidx.constraintlayout:constraintlayout:2.1.4'
    testImplementation 'junit:junit:4.13.2'
    androidTestImplementation 'androidx.test.ext:junit:1.1.5'
    androidTestImplementation 'androidx.test.espresso:espresso-core:3.5.1'
}
EOF

# Crear archivo settings.gradle
cat > "$ANDROID_DIR/settings.gradle" << 'EOF'
include ':app'
rootProject.name = "Flash App"
EOF

# Crear archivos de recursos
mkdir -p "$ANDROID_DIR/app/src/main/res/values"
cat > "$ANDROID_DIR/app/src/main/res/values/strings.xml" << 'EOF'
<resources>
    <string name="app_name">Flash App</string>
</resources>
EOF

cat > "$ANDROID_DIR/app/src/main/res/values/styles.xml" << 'EOF'
<resources>
    <!-- Base application theme. -->
    <style name="AppTheme" parent="Theme.AppCompat.Light.DarkActionBar">
        <!-- Customize your theme here. -->
        <item name="colorPrimary">#1f8ef1</item>
        <item name="colorPrimaryDark">#0d6efd</item>
        <item name="colorAccent">#f0c420</item>
    </style>
</resources>
EOF

echo -e "${GREEN}✅ Proyecto Android generado en la carpeta '$ANDROID_DIR'${NC}"
echo -e "${YELLOW}➡️ Ahora puedes abrir este proyecto en Android Studio y generar la APK${NC}"
echo -e "${BLUE}📱 Sigue las instrucciones en README_CREAR_APK.md para compilar la APK${NC}"

# Crear archivo ZIP con todo el proyecto
echo -e "${YELLOW}➡️ Creando archivo ZIP del proyecto...${NC}"
/nix/store/ig56yz6lgkmlwjvkrdz51pp94212kwyf-zip-3.0/bin/zip -r flash-app-android.zip "$ANDROID_DIR"
echo -e "${GREEN}✅ Proyecto comprimido en 'flash-app-android.zip'${NC}"
echo -e "${BLUE}📥 Puedes descargar este archivo ZIP y abrir el proyecto en Android Studio${NC}"