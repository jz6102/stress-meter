// allprojects {
//     repositories {
//         google()
//         mavenCentral()
//     }
// }

// buildscript {
//     repositories {
//         google()
//         mavenCentral()
//         gradlePluginPortal()  // Ensure this is included
//     }
//     dependencies {
//         classpath ("com.android.tools.build:gradle:8.3.0")
//         classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.21")

//     }
// }

// val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
// rootProject.layout.buildDirectory.value(newBuildDir)

// subprojects {
//     val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
//     project.layout.buildDirectory.value(newSubprojectBuildDir)
// }

// subprojects {
//     afterEvaluate { project: Project ->
//         if (project.plugins.hasPlugin("com.android.application") ||
//             project.plugins.hasPlugin("com.android.library")) {
            
//             project.extensions.findByType<com.android.build.gradle.BaseExtension>()?.apply {
//                 compileSdk = 35  // Corrected syntax

//                 defaultConfig {
//                     minSdk = 21
//                     targetSdk = 35
//                 }

//                 compileOptions {
//                     sourceCompatibility = JavaVersion.VERSION_1_8
//                     targetCompatibility = JavaVersion.VERSION_1_8
//                 }
//             }
//         }
//     }
// }

// subprojects {
//     project.evaluationDependsOn(":app")
// }

// tasks.register<Delete>("clean") {
//     delete(rootProject.layout.buildDirectory)
// }

import com.android.build.gradle.BaseExtension

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

buildscript {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.3.0")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.21")
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    afterEvaluate {
        extensions.findByType<BaseExtension>()?.apply {
            compileSdkVersion(35)  // Corrected Syntax
            defaultConfig {
                minSdk = 23
                targetSdk = 35
            }
            compileOptions {
                sourceCompatibility = JavaVersion.VERSION_1_8
                targetCompatibility = JavaVersion.VERSION_1_8
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
