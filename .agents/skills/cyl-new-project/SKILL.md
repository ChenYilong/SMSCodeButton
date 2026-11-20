---
name: cyl-new-project
description: "Create a new app or demo on CYLAnimatedItem (or change this app's structure): pure Swift, UIScene, Podfile pinned to the latest CYLTabBarController commit, localization table, app icon and launch screen, tests. Use whenever a new target or demo folder is created."
---

# New project on CYLAnimatedItem

Follow this order; `AGENTS.md` has the reasons.

1. **Language and entry**: pure Swift, `@main` app delegate, `UIWindowSceneDelegate` with `UIApplicationSceneManifest` in the Info.plist
   (`$(PRODUCT_MODULE_NAME).CYLSceneDelegate`). Names start with `CYL`; files are named after their main type.
2. **Podfile**: the three top lines, the `CYLAnimatedItem` pod pinned by `:git` and `:commit` to the sha that
   `scripts/latest-cyl-commit.sh --sha` prints, the test target with `inherit! :search_paths`, and the `post_install` hook that
   sets `IPHONEOS_DEPLOYMENT_TARGET = 15.0`. `pod install`, open the `.xcworkspace`.
3. **Subspec**: `CYLAnimatedItem` (Core: static images). Add `CYLAnimatedItem/LottieSwift`, `PAG`, `Rive`, `SVGA` or `GIF` only to play
   an animation file (`animationURL`); each one is the same pod, the same `:git` and `:commit`.
4. **Project file**: `objectVersion = 46`, explicit file lists, deployment target 15.0, `SWIFT_VERSION = 5.0`, `ENABLE_TESTABILITY = YES`
   in Debug, `AppIcon` and `LaunchScreen` copied from CYLTabBarController's ObjC example (`Example/Images.xcassets/AppIcon.appiconset`,
   `Example/Base.lproj/LaunchScreen.storyboard`, `CYLTabBar.imageset`). See `cyl-xcode-compat`.
5. **Texts**: a `CYLSMSCode.strings` table in `en` and `zh-Hans` and `cylLocalizedString("<Chinese original>")`; list `en`, `Base`, `zh-Hans`
   in `knownRegions` and `CFBundleLocalizations`.
6. **The page**: create a `CYLAnimatedItemView`, set the style and the texts, set the delegate, an `accessibilityIdentifier`, add it with
   Auto Layout (it has an intrinsic size). No logic of the component is repeated here (`cyl-api-map`).
7. **Tests** in `SNSCodeTimerDemoTests` (`@testable import SNSCodeTimerDemo`): move the component's clock, never sleep.
8. **Docs**: a TODO entry first, then the feature document and the README (`cyl-docs`); then `cyl-verify`.
