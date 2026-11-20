# Agent rules for this repository (any tool)

SMSCodeButton is a small iOS demo app, written in pure Swift, of a countdown button for SMS verification codes ("Get code",
"14 s left", "Resend"). The button itself is **not** in this repository: it is the countdown style of `CYLAnimatedItemView`,
in the `CYLAnimatedItem` pod of [CYLTabBarController](https://github.com/ChenYilong/CYLTabBarController). This repository
only configures it. These rules are adapted from CYLTabBarController's `AGENTS.md`; where the two differ, this file wins here.

- `README.md`: usage for app developers. `docs/`: one document per feature (start with [docs/Countdown-Button.md](docs/Countdown-Button.md)).
- `SNSCodeTimerDemo/`: the app (Swift). `SNSCodeTimerDemoTests/`: its tests.

When code, `docs/` and `README.md` disagree, code wins, then `docs/`. Fix the wrong one in the same change, then the skill that repeats it.

## Skills

`.agents/skills` holds the skills; `.claude/skills` only points there. They are the `cyl-*` skills of CYLTabBarController
that apply to this project, rewritten for it (the plus button, theme, tab animation and HarmonyOS skills are left out).

| Skill | Use it when |
|:---|:---|
| `cyl-new-project` | Creating a new app or demo on `CYLAnimatedItem`, or changing this app's structure |
| `cyl-xcode-compat` | Touching the `.xcodeproj`, the deployment target, the Podfile, the scene manifest |
| `cyl-api-map` | Finding which `CYLAnimatedItemView` API does what, before writing or adding any |
| `cyl-docs` | Adding a feature, editing `README.md` or `docs/` |
| `cyl-verify` | Building, testing, running the simulator, reporting what could not be verified |

## Keep the skills current

Every new API use, feature, limit or demo updates, in the same change: the `docs/` file, `README.md`, and the skills it affects
(at least a row in `cyl-api-map`). The goal: someone can start a new project from these skills alone.

## Reading the bilingual docs and comments

The documents in `docs/` and the code comments are bilingual. AI agents read only the English part:

- `[EN]` starts the English part, `[CN]` the Chinese part. Read what starts with `[EN]`; skip `[CN]`.
- **`docs/` and `README.md`**: tables have `中文 | English` columns: read the right column only. A heading written as
  `## [CN]…` is followed by its `## [EN]…` twin: read the `[EN]` one.
- **Code comments**: read the `[EN]` block; the `[CN]` block runs until the next `[EN]`, the next tag or the end of the comment.
- **Exception**: text with no English version (an older comment in Chinese only) is read as is.
- **Writing is not affected**: new text is still written in both languages.

## Documentation

Every new feature and user-visible change ships with bilingual documentation in `docs/` and `README.md`, as two-column tables
(`中文 | English`). Full rules: the `cyl-docs` skill.

- **Record every task in `docs/` before starting it.** Find the most relevant document (create one only when none fits) and add a
  `TODO` entry with the task's full context, the requirements, and the user's prompt quoted verbatim. When the task is finished,
  change the entry to `DONE` with the result and its evidence (commits, tests, screenshots). If the work is interrupted, the next
  session finds the context again.

## Code rules

- **All new code is Swift, here and in the component (owner, 2026-11-20).** `CYLAnimatedItemView` is Swift (`CYLAnimatedItem/Swift/CYLAnimatedItemView.swift` in CYLTabBarController, on `feat/cross-platform-components` and branches from it); add component features there, never in an Objective-C file. Before editing the component, check which branch holds its Swift version (`git ls-tree -r --name-only <branch> | grep CYLAnimatedItemView`).
- **Pure Swift.** No Objective-C, no bridging header, no `.m` / `.h` in the app and its tests. Swift 5 language mode
  (`SWIFT_VERSION = 5.0`; `ENV['SWIFT_VERSION'] = '5'` in the Podfile). Public and internal declarations use Swift Markup
  documentation comments (`/** … */`), bilingual.
- **The core is the component, not this app.** The countdown logic (the end date, the background, the title, the width, the
  tick, the accessibility) lives in `CYLAnimatedItemView` of CYLTabBarController. This app sets texts and icons and reacts to
  the delegate. When you fix a bug or add behavior, change the component first so that every app gets it; fix only this app
  when the component cannot (ask the owner first, and record why in `docs/Countdown-Button.md`). Never copy the component's
  code into this repository.
- **Public API of the component**: never remove or change one; add new API. Use what `cyl-api-map` lists before adding any.
- **No warnings**: fix every build and static-analyzer warning you meet, in the app, the tests and the Podfile.
- **Naming: keep the project's prefixes.** Every type, protocol and file-private function of this project starts with `CYL`
  (`CYLSNSCodeButtonViewController`, `cylLocalizedString`), and the file is named after its main type. Every method and property in
  an extension of a system type starts with `cyl_`. A file brought in from elsewhere is renamed the same way, with a credit to the
  source in a comment.
- **Comments are bilingual**: `[EN]` / `[CN]` blocks; mark fixes with `FIX: issue #N`. A comment written in Chinese is tagged
  `[CN]` and followed directly by its English translation tagged `[EN]`, in the same comment style. Comments that only contain a
  person's name, and commented-out code, need no translation.
- **No Chinese text in code**: every user-visible string goes through `cylLocalizedString("<original Chinese text>")`, which reads
  the table `CYLSMSCode` of the app (`<language>.lproj/CYLSMSCode.strings`, in `en` and `zh-Hans`). The Chinese original is the
  key, so a language without a table still shows it; values with a number use `String(format:)` with `%ld`. Resource identifiers
  (an image asset name) are the only other literals. Every key goes into **all** `.lproj` folders, with the same specifiers.
- **Accessibility is required.** Every control and text is an accessibility element with a meaningful label, trait and state,
  and a stable `accessibilityIdentifier` (`cyl-sms-code-button`); purely decorative views are hidden. The component provides the
  label (the visible title, which includes the seconds left), the "not enabled" trait while counting, and an announcement when the
  time is up; do not undo them. Tests and simulator checks find elements by accessibility label or identifier first (XCUITest
  queries, `axe describe-ui`); coordinates only as a last resort, and a control that cannot be found that way is a bug to fix.
- **Dynamic Type and Dark Mode** work: system fonts and semantic colors (`.label`, `.systemBackground`), no fixed white or black.
- **Examples import only `import CYLAnimatedItem`.**

## Depending on CYLAnimatedItem

The Podfile always uses the **latest commit of CYLTabBarController**, which can sit on any branch, not only `master`.

1. **Find the latest commit before every build.** Never reuse a commit found earlier. Run `scripts/latest-cyl-commit.sh`: it
   fetches every branch of `https://github.com/ChenYilong/CYLTabBarController.git` and prints the newest commit by commit
   timestamp (`<sha> <date> <branch>`); `--sha` prints the sha only and `--podfile` prints the Podfile lines.
2. **Depend on that commit** (the pod is `CYLAnimatedItem`, from the same repository; a subspec the same way):
   `pod 'CYLAnimatedItem', :git => 'https://github.com/ChenYilong/CYLTabBarController.git', :commit => '<sha>'`.
   Never a version number, a branch or a tag. Put the new sha into the Podfile, run `pod install`, then build ("repin").
3. Say in the reply which commit (sha, date, branch) a build used. If it cannot be fetched (offline), say so, keep the sha in the
   Podfile and report that it may not be the latest.
4. A feature this app needs that the component lacks is added to the component (in CYLTabBarController, on its own branch, with
   its tests and documents), pushed, and then pinned here. Do not wait for a release.

## Xcode project

- **Top of the Podfile**: `platform :ios, '15.0'`, `ENV['SWIFT_VERSION'] = '5'`, `project 'SNSCodeTimerDemo.xcodeproj'`.
- **Bottom of the Podfile**: a `post_install` hook that sets `IPHONEOS_DEPLOYMENT_TARGET` to `15.0` on every pod target (only one
  `post_install` per Podfile).
- **App icon and launch screen** exist: `Images.xcassets/AppIcon.appiconset` (`ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon`) and
  `Base.lproj/LaunchScreen.storyboard` (`UILaunchStoryboardName`), copied from CYLTabBarController's ObjC example. A launch
  screen setting alone is not enough: without the storyboard the app runs letterboxed.
- **UIScene life cycle** (`UIApplicationSceneManifest`, `CYLSceneDelegate`): required since the iOS 27 SDK.
- **Project format**: keep `objectVersion = 46`, `compatibilityVersion = "Xcode 3.2"`, explicit file lists (no folder sync),
  deployment target below 27, so CI on Xcode 26 opens it. Check before committing any `.xcodeproj` change. Details: `cyl-xcode-compat`.
- Run `pod install` after a Podfile change and open `SNSCodeTimerDemo.xcworkspace`. Never commit `Pods/` or any `*.lock`.

## Verify, and where tests run

- **Verify before pushing**: build, run the unit tests, and run the app on the simulator for a visual change. **Say plainly what
  could not be verified** (for example: a cloud Linux session has no Xcode, no simulator and no CocoaPods, so nothing is compiled
  or run there). Never call a visual change fixed from a build alone. Details: `cyl-verify`.
- **Clean before every build and run**: an empty derived data folder (delete it, or pass a new `-derivedDataPath`) and
  `pod install` again after a new commit pin. A reused build tests an old binary.
- **The background case** (issue #1) cannot be seen on the simulator reliably: test it on a real device (start the countdown,
  lock the screen or send the app to the background, return after a known time). The unit tests move the component's clock
  (`countdownDateProvider`) instead of waiting.
- **Screenshots** (the README's before and after): original resolution, never scaled down; labeled with platform, OS version,
  simulator or device model, Xcode / iOS SDK, the pinned commit of CYLTabBarController, and the time taken; stored in
  `docs/assets/` and referenced from the document and the README.

## Git and pull requests

- **Commit messages**: English only (no Chinese anywhere in the subject, body or trailers; quote a Chinese prompt in the task's
  document in `docs/` instead). Commitizen style `{type}{scope}: {emoji}{subject}`, subject at most 64 characters:
  `feat: ✨`, `fix: 🐛`, `docs: 📝`, `chore: 🔧`, `refactor: ♻️`, `test: 💍`. Details and pending work in the body.
- **Every commit message carries the author line** `By  @ChenYilong <luohanchenyilong@163.com>` (two spaces after `By`) on its
  own line in the body, after the description and before trailers such as `Co-Authored-By:` and `Claude-Session:`.
- **Before every commit**: `touch .git/hooks/NO_AUTO_SYNC` (so the vault's auto sync does not commit in the middle of it);
  record each incomplete or unverified item under a `TODO` heading in the commit body and in `docs/Countdown-Button.md`;
  search `docs/` and `README.md` for stale notes (`TODO`, `Linux`, "no simulator", "no screenshots") and settle each one.
- Check before every push:
  `git log -1 --format=%B | python3 -c "import re,sys; sys.exit(1 if re.search('[一-鿿]', sys.stdin.read()) else 0)"`
  prints nothing.
- **Never commit `._*` files** (macOS AppleDouble files): `.gitignore` excludes them; delete them before git commands with
  `find . -name '._*' -not -path './.git/*' -delete`.
- **Never commit `*.lock` files** (`Podfile.lock`) or `Pods/`.
- On any branch other than `master`, commit and push as soon as the work is written, without asking; on `master`, ask first.
  Branch from the latest `master` for each issue or feature. Open a pull request for a branch with commits when the owner asks
  (a cloud session opens one only on request); the PR body closes the issue (`Closes #N`).
- Before merging, squash the PR into one commit and push with `--force-with-lease` (never a plain force push).
- After a fix, comment on the issue (in the issue's language) with the changes, the commit link and an invitation to try the
  latest version.

## Commands

```sh
scripts/latest-cyl-commit.sh                 # the newest CYLTabBarController commit, any branch
pod install                                  # after changing the commit in the Podfile
xcodebuild -workspace SNSCodeTimerDemo.xcworkspace -scheme SNSCodeTimerDemo -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -derivedDataPath "$(mktemp -d)" test
```
