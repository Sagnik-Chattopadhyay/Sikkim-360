plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter Gradle plugin must come last
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.sikkim_app"
    compileSdk = 35  // Must be 35 for androidx.activity 1.10.1+

    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "com.example.sikkim_app"
        minSdk = flutter.minSdkVersion  // ML Kit + Camera require at least 21
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        debug {
            isMinifyEnabled = false      // Disable code shrinking for debug
            isShrinkResources = false    // Disable resource shrinking for debug
        }
        release {
            isMinifyEnabled = true       // Enable code shrinking for release
            isShrinkResources = true     // Enable resource shrinking for release
            signingConfig = signingConfigs.getByName("debug")
            // Optional: configure ProGuard rules if needed
            // proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }
}

flutter {
    source = "../.."
}
