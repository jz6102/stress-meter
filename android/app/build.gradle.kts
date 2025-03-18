import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // Flutter Gradle Plugin
}

// Load keystore properties
val keystorePropertiesFile = rootProject.file("keystore.properties")
val keystoreProperties = Properties().apply {
    load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.example.stress_meter"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    signingConfigs {
        create("release") {
            storeFile = file(keystoreProperties["MY_KEYSTORE_FILE"] as String)
            storePassword = keystoreProperties["MY_KEYSTORE_PASSWORD"] as String
            keyAlias = keystoreProperties["MY_KEY_ALIAS"] as String
            keyPassword = keystoreProperties["MY_KEY_PASSWORD"] as String
        }
    }

    defaultConfig {
        applicationId = "com.example.stress_meter"
        minSdk = 23
        targetSdk = 35
        multiDexEnabled = true
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

dependencies {
    implementation("com.google.firebase:firebase-bom:32.7.1")
    implementation("com.google.firebase:firebase-auth-ktx")
    implementation("com.google.firebase:firebase-firestore-ktx")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}

flutter {
    source = "../.."
}

// plugins {
//     id("com.android.application")
//     id("kotlin-android")
//     // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
//     id("dev.flutter.flutter-gradle-plugin")
    
// }

// android {
    
//     namespace = "com.example.stress_meter"
//     compileSdk = 35
//     ndkVersion = "27.0.12077973"

//     compileOptions {
//         sourceCompatibility = JavaVersion.VERSION_11
//         targetCompatibility = JavaVersion.VERSION_11
//         isCoreLibraryDesugaringEnabled = true
//     }

//     kotlinOptions {
//         jvmTarget = JavaVersion.VERSION_11.toString()
//     }

//     signingConfigs {
//         create("release") {
//             storeFile = file("../keystore.jks") // Adjust path if needed
//             storePassword = keystoreProperties["MYAPP_KEYSTORE_PASSWORD"]
//             keyAlias = keystoreProperties["MYAPP_KEY_ALIAS"]
//             keyPassword = keystoreProperties["MYAPP_KEY_PASSWORD"]
//         }
//     }

//     defaultConfig {
//         // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
//         applicationId = "com.example.stress_meter"
//         // You can update the following values to match your application needs.
//         // For more information, see: https://flutter.dev/to/review-gradle-config.
//         minSdk = 23
//         targetSdk = 35
//         multiDexEnabled = true
//         versionCode = flutter.versionCode
//         versionName = flutter.versionName
//     }


//     buildTypes {
//         release {
//             // TODO: Add your own signing config for the release build.
//             // Signing with the debug keys for now, so `flutter run --release` works.
//             signingConfig = signingConfigs.getByName("release")
//             isMinifyEnabled = false
//             isShrinkResources = false
//         }
//     }

//     dependencies {
//         implementation("com.google.firebase:firebase-bom:32.7.1")
//         implementation("com.google.firebase:firebase-auth-ktx")
//         implementation("com.google.firebase:firebase-firestore-ktx")
//         coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
//     }
// }

// flutter {
//     source = "../.."
// }
