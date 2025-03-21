plugins {
    id("com.android.application")
    id("kotlin-android")
   
    id("dev.flutter.flutter-gradle-plugin")

   
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.hydrax" 
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.hydrax" 
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    
    implementation(platform("com.google.firebase:firebase-bom:33.10.0"))

    
    implementation("com.google.firebase:firebase-firestore-ktx") // Firestore
    implementation("com.google.firebase:firebase-auth-ktx")      // Firebase Auth (Optional)
    implementation("com.google.firebase:firebase-analytics-ktx") // Analytics (Optional)
}


