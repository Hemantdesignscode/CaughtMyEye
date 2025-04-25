buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:7.3.0") // Adjust based on your Flutter version
        classpath("com.google.gms:google-services:4.4.1") // Add this for Firebase
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = File("../build")
subprojects {
    project.buildDir = File("${rootProject.buildDir}/${project.name}")
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}
