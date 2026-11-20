// The Android example of SMSCodeButton. The countdown button is CYLAnimatedItemView of the `cylanimateditem` module of
// CYLTabBarController, built from the sources of the commit in ../CYL_COMMIT (scripts/sync-cyl-components.sh fetches them).
// SMSCodeButton 的 Android 示例。倒计时按钮是 CYLTabBarController 的 `cylanimateditem` 模块中的 CYLAnimatedItemView，
// 由 ../CYL_COMMIT 记录的 commit 的源码构建（scripts/sync-cyl-components.sh 取回源码）。
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.name = "SMSCodeButton-Android"
include(":app")
include(":cylanimateditem")
project(":cylanimateditem").projectDir = file("../.cyl-components/Example-Android/cylanimateditem")
