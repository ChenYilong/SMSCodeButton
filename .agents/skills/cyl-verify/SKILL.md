---
name: cyl-verify
description: "How to build, test and check SMSCodeButton, run the simulator, test the background case on a device, and report what could not be verified. Use before saying a change works, before pushing, and when the app does not build."
---

# Verify

Say plainly what could not be verified. Never call a visual change fixed from a build alone.

## Before every build

1. `scripts/latest-cyl-commit.sh` (newest CYLTabBarController commit on any branch, by commit time). If it differs from the sha in the
   Podfile, put the new sha in the Podfile ("repin"). Name the commit in the report.
2. `pod install`, open `SNSCodeTimerDemo.xcworkspace`.
3. **Clean build**: an empty derived data folder (`-derivedDataPath "$(mktemp -d)"`). A reused build tests an old binary; confirm a new
   symbol is in the app with `strings <app>/<binary> | grep <symbol>` when in doubt.

## Checks

| Check | Command or action |
|:---|:---|
| Build and unit tests | `xcodebuild -workspace SNSCodeTimerDemo.xcworkspace -scheme SNSCodeTimerDemo -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -derivedDataPath "$(mktemp -d)" test` |
| Look | run on the simulator: idle ("Get code" with the envelope), running ("N s left" with the clock, button disabled), finished ("Resend") |
| Accessibility | find the button by identifier `cyl-sms-code-button` (XCUITest or `axe describe-ui`); VoiceOver reads the title and "dimmed" while counting |
| Dynamic Type, Dark Mode, `zh-Hans` and `en` | switch each in the simulator; the width must not jump when the digits change |
| Issue #1, background | real device: tap, lock the screen or go home, return after a known time: the seconds left must have shrunk by that time; the simulator cannot show this reliably |
| Issue #1, flicker | watch the countdown for several seconds: the title changes, nothing else redraws |
| Project file | `objectVersion = 46`; every ID defined; open the project in Xcode |

## What a Linux cloud session can and cannot do

It can edit, search, run Python and Git. It has no Xcode, no simulator and no CocoaPods: nothing is compiled, linted or run there.
Write that in the report and the commit's TODO, and leave the checks above to a Mac or to CI.

## Where a check ran

Name it in every report: GitHub CI (runner) or locally (macOS and Xcode versions). Screenshots follow `cyl-docs`.

## The other platforms

Before every build of `Example-Android`, `Example-HarmonyOS` or `Example-MiniProgram`: `scripts/latest-cyl-commit.sh`, repin if newer
(`scripts/repin-cyl-commit.sh`; the newest commit must contain the countdown style), then `scripts/sync-cyl-components.sh`.

| Platform | Check |
|:---|:---|
| Mini program | `cd Example-MiniProgram && npm run setup && npm test` (Node 22; the page against the real component); then the WeChat developer tools and a device |
| Android | `cd Example-Android && gradle :app:testDebugUnitTest` (Robolectric), then `gradle :app:installDebug` on an emulator; find the button by its tag `cyl-sms-code-button` (`uiautomator`) |
| HarmonyOS | DevEco Studio or `hvigorw assembleHap`, then the emulator (unsigned HAP, `hdc install -r`); find the button by id `cyl-sms-code-button` (`hdc shell uitest`) |

On each: tap, watch "N s left" and the clock icon, background the app for a known time and return (issue #1), kill the process and
start again within the countdown (the cache), set the system clock far forward and back. A Linux cloud session can run only the mini
program tests and the sync scripts: say so in the report.
