plugins {
    id("com.android.application")
    id("kotlin-android")
    // El plugin de Flutter debe aplicarse después de Android y Kotlin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.moodly.moodly"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // Habilita el soporte para funciones modernas de Java (necesario para notificaciones)
        isCoreLibraryDesugaringEnabled = true
        
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.moodly.moodly"
        // minSdk 21 es el estándar actual para evitar errores de compatibilidad
        minSdk = flutter.minSdkVersion 
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // Permite que la app maneje muchas librerías sin desbordar el índice de métodos
        multiDexEnabled = true 
    }

    buildTypes {
        release {
            // Configuración de firma para debug (permite correr --release localmente)
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Esta librería resuelve el error "core library desugaring"
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
