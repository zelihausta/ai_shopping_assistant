plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter Gradle Plugin must be last
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.ai_shoppinng_assistant"
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
        applicationId = "com.example.ai_shopping_assistant"
        minSdk = 26               // Flutter + tflite için uygun
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
