// file: build.gradle.kts (Project: AuthApp)

plugins {
    alias(libs.plugins.android.application) apply false
    alias(libs.plugins.kotlin.android) apply false
    // 🌟 Ensure the Google Services plugin is listed here, likely using 'id' 🌟
    id("com.google.gms.google-services") version "4.4.1" apply false // Use the latest version
}
// ... rest of the file