// The example app: one "Get code" button, CYLAnimatedItemView in its countdown style.
// 示例 App：一个「获取验证码」按钮，即倒计时样式的 CYLAnimatedItemView。
plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.kotlin.android)
}

android {
    namespace = "com.cyl.smscode"
    compileSdk = 35

    defaultConfig {
        applicationId = "com.cyl.smscode"
        minSdk = 23
        targetSdk = 35
        versionCode = 1
        versionName = "1.0.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    testOptions {
        unitTests.isIncludeAndroidResources = true
    }

    kotlinOptions {
        jvmTarget = "17"
    }
}

dependencies {
    implementation(project(":cylanimateditem"))
    implementation(libs.androidx.appcompat)
    testImplementation(libs.junit)
    testImplementation(libs.robolectric)
    testImplementation(libs.androidx.test.core)
}
