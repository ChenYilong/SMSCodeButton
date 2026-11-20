---
name: cyl-xcode-compat
description: "Xcode and iOS compatibility of SMSCodeButton: project format, deployment target, Podfile, UIScene, launch screen, app icon, localization regions. Use when touching the .xcodeproj, the Podfile or the Info.plist."
---

# Xcode and iOS compatibility

| Item | Value | Where |
|:---|:---|:---|
| Deployment target | iOS 15.0, app, tests and every pod | project, Podfile `post_install` |
| Component minimum | `CYLAnimatedItem` supports iOS 12.0; the 15.0 is this project's rule | `CYLAnimatedItem.podspec` |
| Swift | 5.0 language mode | `SWIFT_VERSION`, `ENV['SWIFT_VERSION']` |
| Project format | `objectVersion = 46`, `compatibilityVersion = "Xcode 3.2"`, no folder sync, deployment target below 27 | `project.pbxproj` |
| Life cycle | UIScene: `UIApplicationSceneManifest` + `CYLSceneDelegate`; required by the iOS 27 SDK | `SNSCodeTimerDemo-Info.plist` |
| Launch screen | `Base.lproj/LaunchScreen.storyboard`, `UILaunchStoryboardName = LaunchScreen` | Info.plist, project |
| Regions | `en`, `Base`, `zh-Hans` | `knownRegions`, `CFBundleLocalizations` |
| Device capability | `arm64` | Info.plist |

CI on Xcode 26 fails on a project in a newer format, so after any `.xcodeproj` edit check that the first lines still say
`objectVersion = 46` and `compatibilityVersion = "Xcode 3.2"`, that every referenced object ID is defined, and that braces and
parentheses balance. Add a file to the project by hand-editing the explicit lists (a `PBXFileReference`, a `PBXBuildFile`, the group, the
build phase) or with Xcode, never with folder sync.

Localized tables are `PBXVariantGroup`s (`CYLSMSCode.strings`: `en`, `zh-Hans`), in the Resources phase.

Where a check ran matters: GitHub CI for iOS uses macOS 26 / Xcode 26 unless the repository says otherwise; a local run uses the
Mac's Xcode. Name it in every report (`cyl-verify`).
