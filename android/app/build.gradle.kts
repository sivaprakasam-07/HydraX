plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.hydrax" // Update to your project's namespace
    ndkVersion = "27.0.12077973" // Use the same NDK version as your friend's file
    compileSdk = 34 // Update to the latest compileSdk version

    defaultConfig {
        applicationId = "com.example.hydrax" // Update to your project's applicationId
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    buildTypes {
        getByName("release") {
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


