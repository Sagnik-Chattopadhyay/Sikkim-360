// Top-level build.gradle.kts

import org.gradle.api.tasks.Delete
import org.gradle.kotlin.dsl.*

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // ✅ Android Gradle Plugin
        classpath("com.android.tools.build:gradle:8.6.0")
        // ✅ Kotlin Gradle Plugin
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.25")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ✅ Move build directories to a parent folder
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

// ✅ Clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
