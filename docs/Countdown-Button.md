# [CN]倒计时按钮（短信验证码）
# [EN]Countdown button (SMS verification code)

| 中文 | English |
|:---|:---|
| 本 App 是纯 Swift 的示例：一个「获取验证码」按钮，点击后倒计时，结束后可重新获取。按钮不在本仓库：它是 [CYLTabBarController](https://github.com/ChenYilong/CYLTabBarController) 中 `CYLAnimatedItem` pod 的 `CYLAnimatedItemView` 的倒计时样式（`style = .countdown`），全部逻辑在该组件中，本 App 只设置文本与图标。 | This app is a pure Swift demo: a "Get code" button that counts down after a tap and can be tapped again at the end. The button is not in this repository: it is the countdown style (`style = .countdown`) of `CYLAnimatedItemView` in the `CYLAnimatedItem` pod of [CYLTabBarController](https://github.com/ChenYilong/CYLTabBarController); all the logic is in that component, and this app only sets texts and icons. |
| 组件文档：[Animated-Item.md，倒计时样式](https://github.com/ChenYilong/CYLTabBarController/blob/claude/cylanimateditemview-countdown-lha9jq/docs/Animated-Item.md)。Podfile 与 `CYL_COMMIT` 固定的 commit：`bc6a03ea26142896e1cce479c1c16f22cb0ca201`（2026-11-20，分支 `claude/cylanimateditemview-countdown-lha9jq`）。 | Component guide: [Animated-Item.md, "Countdown style"](https://github.com/ChenYilong/CYLTabBarController/blob/claude/cylanimateditemview-countdown-lha9jq/docs/Animated-Item.md). Commit pinned in the Podfile and `CYL_COMMIT`: `bc6a03ea26142896e1cce479c1c16f22cb0ca201` (2026-11-20, branch `claude/cylanimateditemview-countdown-lha9jq`). |

## [CN]目录
## [EN]Contents

| 中文 | English |
|:---|:---|
| [任务记录](#cn任务记录) | [Task log](#entask-log) |
| [用法](#cn用法) | [Usage](#enusage) |
| [各平台示例](#cn各平台示例) | [Platform examples](#enplatform-examples) |
| [issue 列表](#cnissue-列表) | [Issues](#enissues) |
| [改写前后](#cn改写前后) | [Before and after](#enbefore-and-after) |
| [验证状态](#cn验证状态) | [Verification status](#enverification-status) |
| [TODO](#cntodo) | [TODO](#entodo) |

## [CN]任务记录
## [EN]Task log

| 中文 | English |
|:---|:---|
| 本条按用户要求使用英文（见右列）。 | DONE in part (2026-11-20, branch `claude/cylanimateditemview-countdown-lha9jq`; nothing compiled or run, see TODO). User prompt, verbatim: "第一步：复制CYLTabBarController相关 instructions与相关skills改造为适应本项目的版本复制一份过来。第二：将项目转写 为纯swift 代码，第三：commit依赖 使用CYLTabBarController中的CYLAnimatedItemView组件 ，改造CYLAnimatedItemView组件，新增倒计时样式。 更新后，repin在其本项目使用新增接口完成需求。要求效果与readme描述一致。但核心代码都在CYLAnimatedItemView组件中。 实现过程中，阅读并fix 关闭issue：https://github.com/ChenYilong/SMSCodeButton/issues/1" (English: step 1, copy CYLTabBarController's instructions and skills, adapted to this project; step 2, rewrite the project in pure Swift; step 3, depend on `CYLAnimatedItemView` by commit, add a countdown style to it, repin, and build the feature here on the new API so that it matches the README, with the core code inside the component; read and fix issue #1 on the way). **Result**: (1) `AGENTS.md`, `CLAUDE.md` and five skills in `.agents/skills`; (2) the Objective-C sources are gone, the app is Swift (`CYLAppDelegate`, `CYLSceneDelegate`, `CYLSNSCodeButtonViewController`, `CYLLocalization`), with UIScene, a launch screen, an app icon and `en` / `zh-Hans` texts; (3) the countdown style was added to the Swift `CYLAnimatedItemView` (`CYLAnimatedItem/Swift/CYLAnimatedItemView.swift`, CYLTabBarController commit `d5de500`), and the Podfile pins that commit. Follow-up from the owner, verbatim: "所有新增代码应为swift CYLAnimatedItemViewy里已经有swift版本，你改错地方了" (English: all new code must be Swift; `CYLAnimatedItemView` already has a Swift version, I changed the wrong place): the first attempt, in an Objective-C file, was dropped and redone in Swift (it was on an older branch; the Swift version lives on `feat/cross-platform-components`). |
| 本条按用户要求使用英文（见右列）。 | TODO (2026-11-20, branch `claude/cylanimateditemview-countdown-lha9jq`): repin the commit and add an example for every platform. User prompt, verbatim: "repin commit ，在SMSCodeButton中增加各个平台example" (English: repin the commit, and add the platform examples to SMSCodeButton). **Scope**: the platforms that have the countdown style of `CYLAnimatedItemView`: Android, HarmonyOS, WeChat Mini Program (iOS is the app that exists). **Acceptance**: 100 = every example builds and runs on its emulator or device, with screenshots and the issue #1 checks; 60 = every example is complete in code, pinned to the commit, documented, with the Linux checks that are possible. **Findings so far**: the newest commit on any branch (`d29cf50`, `feat/cross-platform-components`) does not contain the countdown style, so it was merged into the countdown branch first and the pin is the merge commit. |

## [CN]用法
## [EN]Usage

| 中文 | English |
|:---|:---|
| 见 `SNSCodeTimerDemo/CYLSNSCodeButtonViewController.swift`：创建 `CYLAnimatedItemView`，设置 `style = .countdown`、图标、三个文本、`startsCountdownOnTap = true`、代理，然后用 Auto Layout 放入页面。点击时先调用代理的 `animatedItemViewDidTap(_:)`（在这里发送验证码），随后开始倒计时。 | See `SNSCodeTimerDemo/CYLSNSCodeButtonViewController.swift`: create a `CYLAnimatedItemView`, set `style = .countdown`, the icons, the three texts, `startsCountdownOnTap = true` and the delegate, and add it with Auto Layout. A tap calls the delegate's `animatedItemViewDidTap(_:)` first (send the code there), then the countdown starts. |
| 要在服务器接受请求之后才开始，关闭 `startsCountdownOnTap`，在请求成功后调用 `startCountdown()`（或 `startCountdown(withDuration:)`，使用服务器返回的重试间隔）。 | To start only after the server accepted the request, turn `startsCountdownOnTap` off and call `startCountdown()` (or `startCountdown(withDuration:)` with the server's retry interval) when the request succeeds. |
| 与 README 一致的外观：待机时橙色信封与「获取验证码」，倒计时中灰色时钟与黑色「还剩N秒」（按钮不可用），结束后「重新获取」。 | The look of the README: idle, the orange envelope and "Get code"; running, the gray clock and the black "N s left" (the button is disabled); finished, "Resend". |

## [CN]各平台示例
## [EN]Platform examples

| 中文 | English |
|:---|:---|
| 每个平台一个示例，都只有一个「获取验证码」按钮，即该平台 `CYLAnimatedItemView` 的倒计时样式；倒计时逻辑都在组件中，示例只设置文本、图标与缓存 key，点击时发送验证码，之后倒计时开始。外观与 README 一致：待机为橙色信封与「获取验证码」，倒计时中为灰色时钟与黑色「还剩N秒」（按钮不可用），结束后「重新获取」。 | One example per platform, each with a single "Get code" button, the countdown style of that platform's `CYLAnimatedItemView`; the countdown logic is in the component, and an example sets the texts, the icons and the cache key, sends the code on a tap, after which the countdown starts. The look is the README's: idle, the orange envelope and "Get code"; running, the gray clock and the black "N s left" (the button is disabled); finished, "Resend". |
| 版本固定：所有平台使用 `CYL_COMMIT` 中的同一个 CYLTabBarController commit。iOS 由 Podfile 固定；其他平台由 `scripts/sync-cyl-components.sh` 在该 commit 上稀疏检出组件（`.cyl-components/`，git 忽略）。重新固定：`scripts/repin-cyl-commit.sh`（默认最新 commit，拒绝没有 Swift `CYLAnimatedItemView` 的 commit），之后 iOS 执行 `pod install`，其他平台执行 `scripts/sync-cyl-components.sh`。同步脚本拒绝没有倒计时样式的 commit。 | Pinning: every platform uses the one CYLTabBarController commit in `CYL_COMMIT`. iOS pins it in the Podfile; the others get the components from `scripts/sync-cyl-components.sh`, a sparse checkout at that commit (`.cyl-components/`, ignored by git). To repin: `scripts/repin-cyl-commit.sh` (the newest commit by default; it refuses a commit without the Swift `CYLAnimatedItemView`), then `pod install` on iOS and `scripts/sync-cyl-components.sh` for the others. The sync script refuses a commit without the countdown style. |
| 注意（2026-11-20）：任意分支上最新的 commit 是 `feat/cross-platform-components` 的 `d29cf50`，它不含倒计时样式；因此先把它合并进倒计时分支，固定的是合并后的 commit `bc6a03e`。以后别的分支领先时也要这样做，否则按「最新 commit」固定会让示例失去倒计时 API。 | Note (2026-11-20): the newest commit on any branch was `d29cf50` of `feat/cross-platform-components`, which has no countdown style, so it was merged into the countdown branch and the pin is the merge commit `bc6a03e`. Do the same whenever another branch gets ahead: pinning "the newest commit" would otherwise take the countdown API away from the examples. |
| iOS：`SNSCodeTimerDemo/`（Swift，`pod 'CYLAnimatedItem'`），`import CYLAnimatedItem`。 | iOS: `SNSCodeTimerDemo/` (Swift, `pod 'CYLAnimatedItem'`), `import CYLAnimatedItem`. |
| Android：`Example-Android/`（Kotlin，Gradle 项目，`:cylanimateditem` 模块的源码来自 `.cyl-components`）。页面 `CYLSMSCodeActivity`；文本在 `values/strings.xml` 与 `values-zh-rCN/strings.xml`；Robolectric 测试 `CYLSMSCodeActivityTest`。运行：`scripts/sync-cyl-components.sh`，然后 `cd Example-Android && gradle :app:installDebug`（需要 Android SDK 与 Gradle 8.x）。 | Android: `Example-Android/` (Kotlin, a Gradle project; the `:cylanimateditem` module is built from the sources in `.cyl-components`). The page is `CYLSMSCodeActivity`; the texts are in `values/strings.xml` and `values-zh-rCN/strings.xml`; the Robolectric test is `CYLSMSCodeActivityTest`. Run: `scripts/sync-cyl-components.sh`, then `cd Example-Android && gradle :app:installDebug` (Android SDK and Gradle 8.x needed). |
| HarmonyOS：`Example-HarmonyOS/`（ArkTS，`entry` 模块依赖 `cylanimateditem`，同步脚本把它复制到示例目录）。页面 `pages/Index.ets`；文本在 `resources/base` 与 `resources/zh_CN` 的 `string.json`。运行：`scripts/sync-cyl-components.sh`，用 DevEco Studio 打开 `Example-HarmonyOS` 并运行（模拟器不需要签名）。 | HarmonyOS: `Example-HarmonyOS/` (ArkTS; the `entry` module depends on `cylanimateditem`, which the sync script copies into the example). The page is `pages/Index.ets`; the texts are in `string.json` of `resources/base` and `resources/zh_CN`. Run: `scripts/sync-cyl-components.sh`, open `Example-HarmonyOS` in DevEco Studio and run (the emulator needs no signing). |
| 微信小程序：`Example-MiniProgram/`（JavaScript，组件由同步脚本复制到 `miniprogram/cyl/`）。页面 `pages/index`；文本 `utils/cyl_sms_texts.js`（中、英）；测试 `npm test`（含与真实组件连接的页面测试）。运行：`cd Example-MiniProgram && npm run setup`，用微信开发者工具打开 `Example-MiniProgram`。 | WeChat Mini Program: `Example-MiniProgram/` (JavaScript; the component is copied to `miniprogram/cyl/` by the sync script). The page is `pages/index`; the texts are `utils/cyl_sms_texts.js` (Chinese, English); test with `npm test` (including a page test against the real component). Run: `cd Example-MiniProgram && npm run setup`, then open `Example-MiniProgram` in the WeChat developer tools. |
| 图标：`assets/cyl_sms_envelope.png`、`assets/cyl_sms_clock.png` 由 iOS 的 xcassets 用 `scripts/convert-ios-png.py` 转换（iOS 的 PNG 带 `CgBI` 块，其他平台无法读取），再复制到各平台。 | Icons: `assets/cyl_sms_envelope.png` and `assets/cyl_sms_clock.png` were converted from the iOS xcassets with `scripts/convert-ios-png.py` (iOS PNGs carry a `CgBI` chunk that the other platforms cannot read) and copied to each platform. |
| 在 Linux 上的验证（2026-11-20）：小程序 `npm test` 通过（3 项，包含用页面 wxml 的属性驱动真实组件：点击、后台 46 秒后剩 14 秒、重启后接续、结束）；同步与重新固定脚本在真实仓库上运行通过。**未验证**：Android 工程（没有 Android SDK，Gradle 离线无法解析插件）、鸿蒙工程（没有 DevEco Studio）、小程序在开发者工具与真机上的表现；三者的截图也没有。 | Verified on Linux (2026-11-20): the mini program's `npm test` passes (3 tests, including the real component driven by the page's wxml attributes: a tap, 46 s in the background leave 14 s, a restart continues, the end); the sync and repin scripts ran against the real repository. **Not verified**: the Android project (no Android SDK; Gradle cannot resolve its plugins offline), the HarmonyOS project (no DevEco Studio), the mini program in the developer tools and on a device; there are no screenshots of any of them. |

## [CN]issue 列表
## [EN]Issues

| 中文 | English |
|:---|:---|
| 项目：[ChenYilong/SMSCodeButton](https://github.com/ChenYilong/SMSCodeButton/issues)。 | Repository: [ChenYilong/SMSCodeButton](https://github.com/ChenYilong/SMSCodeButton/issues). |

| Issue | 中文描述 / English description | 状态 / Status |
|:---|:---|:---|
| [#1](https://github.com/ChenYilong/SMSCodeButton/issues/1) | 进入后台的这段时间没有记上，回来后剩余秒数不变 / Time spent in the background is not counted: the seconds left are the same on return. Comment: "模拟器测不出来，得用真机测" (the simulator cannot show it, use a real device). | DONE in code (commit `d5de500` of CYLTabBarController: an end date, read again when the app returns), **TODO** the real device test |
| [#1](https://github.com/ChenYilong/SMSCodeButton/issues/1) (comment) | 读秒时一闪一闪；改为 `UIButtonTypeCustom` 可解决 / The button flickers while counting; `UIButtonTypeCustom` avoids it. | DONE in code (the component is a `UIControl`, only its label's text changes; the width is fixed to the widest title), **TODO** a look on the simulator and a device |
| [#1](https://github.com/ChenYilong/SMSCodeButton/issues/1) (owner's comment, 2026-11-20) | 倒计时应与本地时钟对齐，前后台切换时以本地时钟为准更新数字；记录最长倒计时，回前台时本地时钟超过最长时长则关闭倒计时，恢复可再次倒计时的可响应状态；必要时增加本地缓存以支持恢复 / Align with the local clock and update on every switch; record the longest duration and close the countdown when the clock is past it, back to a responding state that can count down again; add a local cache if needed to restore. | DONE in code (commit `d5de500`: the end, start and duration are recorded; a past or set-back clock closes the countdown and enables the button; `countdownCacheKey` keeps it in `UserDefaults`, and this app sets it), **TODO** tests run, real device |

| 中文 | English |
|:---|:---|
| 两个问题都在组件（核心）中修复，而不是在本示例中；组件的单元测试 `CYLAnimatedItemViewTests` 使用手动拨动的时钟，本 App 的 `SNSCodeTimerDemoTests` 验证「后台 46 秒后剩 14 秒」。issue 在真机验证之后才能关闭。 | Both are fixed in the core, the component, not in this example. The component's unit tests (`CYLAnimatedItemViewTests`) run on a clock they move, and this app's `SNSCodeTimerDemoTests` check "14 s left after 46 s in the background". The issue can be closed once a real device confirms it. |

## [CN]改写前后
## [EN]Before and after

| 中文 | English |
|:---|:---|
| 旧：Objective-C 的 `SNSCodeCountdownButton`（`UIButton` 子类），靠 `NSTimer` 每秒减 1，进入后台的处理被注释掉；`drawRect:` 里重复设置图片与标题；`UIImage+ResizeImg` 拉伸背景图。 | Before: Objective-C `SNSCodeCountdownButton` (a `UIButton` subclass) decremented a counter with an `NSTimer` every second, its background handling was commented out, `drawRect:` set images and titles again and again, and `UIImage+ResizeImg` stretched background images. |
| 新：Swift；按钮是 `CYLAnimatedItemView`（倒计时样式），结束时间为日期，不再有定时器累减、`drawRect:` 与背景图；文本通过 `cylLocalizedString` 本地化（`en`、`zh-Hans`）；UIScene；Dynamic Type、深色模式与无障碍由组件提供。 | After: Swift; the button is a `CYLAnimatedItemView` (countdown style), the end is a date, with no counter, no `drawRect:` and no background images; the texts are localized through `cylLocalizedString` (`en`, `zh-Hans`); UIScene; Dynamic Type, Dark Mode and accessibility come from the component. |
| 外观差异：旧版的渐变背景图换成系统的次级背景色与细边框；README 中的两张截图是旧版的效果，新版截图待在 Mac 上补拍。 | A difference in the look: the old gradient background images are replaced by the system secondary background color and a thin border; the two screenshots in the README show the old version, and screenshots of the new one are still to be taken on a Mac. |

## [CN]验证状态
## [EN]Verification status

| 中文 | English |
|:---|:---|
| 本次改动在云端 Linux 会话中编写，没有 Xcode、模拟器与 CocoaPods：**没有编译，没有运行测试，没有运行 `pod install` 或 `pod lib lint`，没有截图**。已做的检查：组件文档与 skills 的脚本（`update-docs-navigation.py`、`sync-agent-skills.py --check`、`check-public-api-comments.py`）通过；`project.pbxproj` 括号配对、所有引用的 ID 均已定义；所有 `CYLSMSCode.strings` 的 key 相同。 | This change was written in a cloud Linux session with no Xcode, no simulator and no CocoaPods: **nothing was compiled, no test was run, `pod install` and `pod lib lint` were not run, and there are no screenshots**. Checked: the component repository's documentation and skill scripts (`update-docs-navigation.py`, `sync-agent-skills.py --check`, `check-public-api-comments.py`) pass; `project.pbxproj` braces balance and every referenced ID is defined; every `CYLSMSCode.strings` table has the same keys. |

## [CN]TODO
## [EN]TODO

| 中文 | English |
|:---|:---|
| 本条按用户要求使用英文（见右列）。 | TODO (2026-11-20): on a Mac, (1) `scripts/latest-cyl-commit.sh`, repin if a newer commit exists, `pod install`; (2) build into an empty derived data folder, fix any warning or error (the Swift code and the project file were never compiled); (3) run `SNSCodeTimerDemoTests` and CYLTabBarController's `CYLAnimatedItemViewTests`; (4) run on the simulator and take screenshots (idle, running, finished; light and dark; `en` and `zh-Hans`) into `docs/assets/` and the README; (5) test issue #1 on a real device and close the issue with a comment in Chinese (the issue's language) with the commit link; (6) DONE in code (2026-11-20, CYLTabBarController commit `d5de500`): the countdown style now exists on Android, HarmonyOS and the WeChat Mini Program too (their state machines are tested on Linux; their views are not built); this app is iOS only; (7) the component has no localization table of its own: its default texts are English. |
| 本条按用户要求使用英文（见右列）。 | TODO (2026-11-20), platform examples: (1) build and run `Example-Android` (Gradle sync, `:app:testDebugUnitTest`, an emulator), `Example-HarmonyOS` (`hvigorw assembleHap`, the emulator) and `Example-MiniProgram` (the developer tools) and fix what the first build shows; (2) screenshots of each (idle, running, finished) into `docs/assets/` and the README, labeled as the screenshot rules say; (3) issue #1 on a device for each platform (background, lock screen, process kill); (4) the Android example reads the component from `.cyl-components` (a Gradle project dir outside the project): check that Gradle accepts it, or copy the module as the other two do; (5) the HarmonyOS example's `getContext(this)` and `resourceManager.getStringSync(Resource)` and the `file:` dependency on the copied module are untested. |
