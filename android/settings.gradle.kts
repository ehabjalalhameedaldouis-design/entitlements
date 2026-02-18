pluginManagement {
    val flutterSdkPath: String = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val path = properties.getProperty("flutter.sdk")
        require(path != null) { "flutter.sdk not set in local.properties" }
        path
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.PREFER_SETTINGS)
    repositories {
        google()
        mavenCentral()
        // Flutter hosted maven for engine/artifact downloads
        maven {
            url = uri("https://storage.googleapis.com/download.flutter.io")
        }
        // Add Flutter local engine/artifacts maven repositories so io.flutter:* artifacts are resolvable
        val flutterSdkPath: String = run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val path = properties.getProperty("flutter.sdk")
            require(path != null) { "flutter.sdk not set in local.properties" }
            path
        }
        maven {
            url = uri("$flutterSdkPath/bin/cache/artifacts/engine/")
        }
        maven {
            url = uri("$flutterSdkPath/bin/cache/artifacts/engine/android")
        }
        maven {
            url = uri("$flutterSdkPath/bin/cache/artifacts/engine/common")
        }
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.11.1" apply false
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
}

include(":app")
