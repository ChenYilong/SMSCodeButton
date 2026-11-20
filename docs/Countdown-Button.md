# [CN]倒计时按钮（短信验证码）
# [EN]Countdown button (SMS verification code)

| 中文 | English |
|:---|:---|
| 本 App 是纯 Swift 的示例：一个「获取验证码」按钮，点击后倒计时，结束后可重新获取。按钮不在本仓库：它是 [CYLTabBarController](https://github.com/ChenYilong/CYLTabBarController) 中 `CYLAnimatedItem` pod 的 `CYLAnimatedItemView` 的倒计时样式（`style = .countdown`），全部逻辑在该组件中，本 App 只设置文本与图标。 | This app is a pure Swift demo: a "Get code" button that counts down after a tap and can be tapped again at the end. The button is not in this repository: it is the countdown style (`style = .countdown`) of `CYLAnimatedItemView` in the `CYLAnimatedItem` pod of [CYLTabBarController](https://github.com/ChenYilong/CYLTabBarController); all the logic is in that component, and this app only sets texts and icons. |
| 组件文档：[Animated-Item.md，倒计时样式](https://github.com/ChenYilong/CYLTabBarController/blob/claude/cylanimateditemview-countdown-lha9jq/docs/Animated-Item.md)。Podfile 固定的 commit：`c6b4afded3a6a8a73a8ce718d5cdd1d7223bc7ec`（2026-11-20，分支 `claude/cylanimateditemview-countdown-lha9jq`）。 | Component guide: [Animated-Item.md, "Countdown style"](https://github.com/ChenYilong/CYLTabBarController/blob/claude/cylanimateditemview-countdown-lha9jq/docs/Animated-Item.md). Commit pinned in the Podfile: `c6b4afded3a6a8a73a8ce718d5cdd1d7223bc7ec` (2026-11-20, branch `claude/cylanimateditemview-countdown-lha9jq`). |

## [CN]目录
## [EN]Contents

| 中文 | English |
|:---|:---|
| [任务记录](#cn任务记录) | [Task log](#entask-log) |
| [用法](#cn用法) | [Usage](#enusage) |
| [issue 列表](#cnissue-列表) | [Issues](#enissues) |
| [改写前后](#cn改写前后) | [Before and after](#enbefore-and-after) |
| [验证状态](#cn验证状态) | [Verification status](#enverification-status) |
| [TODO](#cntodo) | [TODO](#entodo) |

## [CN]任务记录
## [EN]Task log

| 中文 | English |
|:---|:---|
| 本条按用户要求使用英文（见右列）。 | DONE in part (2026-11-20, branch `claude/cylanimateditemview-countdown-lha9jq`; nothing compiled or run, see TODO). User prompt, verbatim: "第一步：复制CYLTabBarController相关 instructions与相关skills改造为适应本项目的版本复制一份过来。第二：将项目转写 为纯swift 代码，第三：commit依赖 使用CYLTabBarController中的CYLAnimatedItemView组件 ，改造CYLAnimatedItemView组件，新增倒计时样式。 更新后，repin在其本项目使用新增接口完成需求。要求效果与readme描述一致。但核心代码都在CYLAnimatedItemView组件中。 实现过程中，阅读并fix 关闭issue：https://github.com/ChenYilong/SMSCodeButton/issues/1" (English: step 1, copy CYLTabBarController's instructions and skills, adapted to this project; step 2, rewrite the project in pure Swift; step 3, depend on `CYLAnimatedItemView` by commit, add a countdown style to it, repin, and build the feature here on the new API so that it matches the README, with the core code inside the component; read and fix issue #1 on the way). **Result**: (1) `AGENTS.md`, `CLAUDE.md` and five skills in `.agents/skills`; (2) the Objective-C sources are gone, the app is Swift (`CYLAppDelegate`, `CYLSceneDelegate`, `CYLSNSCodeButtonViewController`, `CYLLocalization`), with UIScene, a launch screen, an app icon and `en` / `zh-Hans` texts; (3) the countdown style was added to the Swift `CYLAnimatedItemView` (`CYLAnimatedItem/Swift/CYLAnimatedItemView.swift`, CYLTabBarController commit `c6b4afd`), and the Podfile pins that commit. Follow-up from the owner, verbatim: "所有新增代码应为swift CYLAnimatedItemViewy里已经有swift版本，你改错地方了" (English: all new code must be Swift; `CYLAnimatedItemView` already has a Swift version, I changed the wrong place): the first attempt, in an Objective-C file, was dropped and redone in Swift (it was on an older branch; the Swift version lives on `feat/cross-platform-components`). |

## [CN]用法
## [EN]Usage

| 中文 | English |
|:---|:---|
| 见 `SNSCodeTimerDemo/CYLSNSCodeButtonViewController.swift`：创建 `CYLAnimatedItemView`，设置 `style = .countdown`、图标、三个文本、`startsCountdownOnTap = true`、代理，然后用 Auto Layout 放入页面。点击时先调用代理的 `animatedItemViewDidTap(_:)`（在这里发送验证码），随后开始倒计时。 | See `SNSCodeTimerDemo/CYLSNSCodeButtonViewController.swift`: create a `CYLAnimatedItemView`, set `style = .countdown`, the icons, the three texts, `startsCountdownOnTap = true` and the delegate, and add it with Auto Layout. A tap calls the delegate's `animatedItemViewDidTap(_:)` first (send the code there), then the countdown starts. |
| 要在服务器接受请求之后才开始，关闭 `startsCountdownOnTap`，在请求成功后调用 `startCountdown()`（或 `startCountdown(withDuration:)`，使用服务器返回的重试间隔）。 | To start only after the server accepted the request, turn `startsCountdownOnTap` off and call `startCountdown()` (or `startCountdown(withDuration:)` with the server's retry interval) when the request succeeds. |
| 与 README 一致的外观：待机时橙色信封与「获取验证码」，倒计时中灰色时钟与黑色「还剩N秒」（按钮不可用），结束后「重新获取」。 | The look of the README: idle, the orange envelope and "Get code"; running, the gray clock and the black "N s left" (the button is disabled); finished, "Resend". |

## [CN]issue 列表
## [EN]Issues

| 中文 | English |
|:---|:---|
| 项目：[ChenYilong/SMSCodeButton](https://github.com/ChenYilong/SMSCodeButton/issues)。 | Repository: [ChenYilong/SMSCodeButton](https://github.com/ChenYilong/SMSCodeButton/issues). |

| Issue | 中文描述 / English description | 状态 / Status |
|:---|:---|:---|
| [#1](https://github.com/ChenYilong/SMSCodeButton/issues/1) | 进入后台的这段时间没有记上，回来后剩余秒数不变 / Time spent in the background is not counted: the seconds left are the same on return. Comment: "模拟器测不出来，得用真机测" (the simulator cannot show it, use a real device). | DONE in code (commit `c6b4afd` of CYLTabBarController: an end date, read again when the app returns), **TODO** the real device test |
| [#1](https://github.com/ChenYilong/SMSCodeButton/issues/1) (comment) | 读秒时一闪一闪；改为 `UIButtonTypeCustom` 可解决 / The button flickers while counting; `UIButtonTypeCustom` avoids it. | DONE in code (the component is a `UIControl`, only its label's text changes; the width is fixed to the widest title), **TODO** a look on the simulator and a device |
| [#1](https://github.com/ChenYilong/SMSCodeButton/issues/1) (owner's comment, 2026-11-20) | 倒计时应与本地时钟对齐，前后台切换时以本地时钟为准更新数字；记录最长倒计时，回前台时本地时钟超过最长时长则关闭倒计时，恢复可再次倒计时的可响应状态；必要时增加本地缓存以支持恢复 / Align with the local clock and update on every switch; record the longest duration and close the countdown when the clock is past it, back to a responding state that can count down again; add a local cache if needed to restore. | DONE in code (commit `c6b4afd`: the end, start and duration are recorded; a past or set-back clock closes the countdown and enables the button; `countdownCacheKey` keeps it in `UserDefaults`, and this app sets it), **TODO** tests run, real device |

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
| 本条按用户要求使用英文（见右列）。 | TODO (2026-11-20): on a Mac, (1) `scripts/latest-cyl-commit.sh`, repin if a newer commit exists, `pod install`; (2) build into an empty derived data folder, fix any warning or error (the Swift code and the project file were never compiled); (3) run `SNSCodeTimerDemoTests` and CYLTabBarController's `CYLAnimatedItemViewTests`; (4) run on the simulator and take screenshots (idle, running, finished; light and dark; `en` and `zh-Hans`) into `docs/assets/` and the README; (5) test issue #1 on a real device and close the issue with a comment in Chinese (the issue's language) with the commit link; (6) the component's countdown style exists on iOS only: Android, HarmonyOS and the WeChat Mini Program ports of `CYLAnimatedItemView` have none; (7) the component has no localization table of its own: its default texts are English. |
