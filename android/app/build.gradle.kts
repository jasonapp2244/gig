import java.util.Properties

plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // if using Firebase
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val localProperties = Properties().apply {
    val localFile = rootProject.file("local.properties")
    if (localFile.exists()) {
        load(localFile.inputStream())
    }
}

val flutterVersionCode: String = localProperties.getProperty("flutter.versionCode") ?: "1"
val flutterVersionName: String = localProperties.getProperty("flutter.versionName") ?: "1.0"

android {
    namespace = "com.craftech.gig"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.craftech.gig"
        minSdk = flutter.minSdkVersion   // ✅ fixed
        targetSdk = 34
        versionCode = flutterVersionCode.toInt()
        versionName = flutterVersionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
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
    // Add this dependency for AdMob
    implementation("com.google.android.gms:play-services-ads:23.1.0")
    
    // If you're using Firebase, you might also want these
    // implementation(platform("com.google.firebase:firebase-bom:32.7.0"))
    // implementation("com.google.firebase:firebase-analytics")
}
