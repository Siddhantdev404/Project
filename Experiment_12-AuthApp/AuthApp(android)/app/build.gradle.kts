// file: build.gradle (Module: app)
plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.kotlin.android)
    // 🌟 CORRECTED SYNTAX 🌟
    id("com.google.gms.google-services")
}

android {
    namespace = "com.siddhant.authapp"
    compileSdk {
        version = release(36)
    }

    defaultConfig {
        applicationId = "com.siddhant.authapp"
        minSdk = 24
        targetSdk = 36
        versionCode = 1
        versionName = "1.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
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

dependencies {
    // 🌟 2. ADD FIREBASE BOM (BEST PRACTICE FOR VERSION MANAGEMENT) 🌟
    implementation(platform("com.google.firebase:firebase-bom:32.7.0")) // Check for the latest version

    // 🌟 3. ADD FIREBASE AUTH SDK 🌟
    implementation("com.google.firebase:firebase-auth-ktx")

    // Google Sign-In (already correct, but we'll use the platform version if possible)
    // If libs.play.services.auth is defined in toml, use that. Otherwise, this is correct:
    implementation("com.google.android.gms:play-services-auth:20.7.0")

    // Existing dependencies (assuming these are defined in your libs.versions.toml)
    implementation(libs.androidx.core.ktx)
    implementation(libs.androidx.appcompat)
    implementation(libs.material)
    implementation(libs.androidx.activity)
    implementation(libs.androidx.constraintlayout)

    testImplementation(libs.junit)
    androidTestImplementation(libs.androidx.junit)
    androidTestImplementation(libs.androidx.espresso.core)
}