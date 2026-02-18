val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

// Ensure project repositories include Flutter hosted maven and local engine artifacts
val flutterSdkPath: String = run {
    val properties = java.util.Properties()
    file("local.properties").inputStream().use { properties.load(it) }
    val path = properties.getProperty("flutter.sdk")
    require(path != null) { "flutter.sdk not set in local.properties" }
    path
}

allprojects {
    repositories {
        google()
        mavenCentral()
        maven {
            url = uri("https://storage.googleapis.com/download.flutter.io")
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

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

plugins {

  // ...


  // Add the dependency for the Google services Gradle plugin

  id("com.google.gms.google-services") version "4.4.4" apply false

}-