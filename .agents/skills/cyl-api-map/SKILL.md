---
name: cyl-api-map
description: "Map of the CYLAnimatedItemView API used by SMSCodeButton: the countdown style, its states, texts, delegate and clock, and where each is documented and tested. Use before writing countdown code, instead of guessing or adding a new API."
---

# API map

The countdown button is `CYLAnimatedItemView` (`import CYLAnimatedItem`). Its header is the public API:
`CYLTabBarController/CYLAnimatedItem/CYLAnimatedItemView.h` in https://github.com/ChenYilong/CYLTabBarController (the commit the
Podfile pins). Guide: `docs/Animated-Item.md`, "Countdown style", in that repository. This app's own document: `docs/Countdown-Button.md`.

| I want to… | Use (Swift) | Notes |
|:---|:---|:---|
| Make the view a countdown button | `style = .countdown` | rounded border, light background, title and widths managed |
| Texts | `countdownIdleTitle`, `countdownRunningTitleFormat` (one `%ld`), `countdownFinishedTitle` | defaults are English; pass `cylLocalizedString(...)` |
| Icons | `image` (idle and finished), `countdownImage` (running) | static images; no animation engine needed |
| Running title color | `countdownRunningTitleColor` | gray by default; the README look is `.label` |
| Length | `countdownDuration` (60), `startCountdown(withDuration:)` | the second form for a server's "retry after" |
| Start | `startCountdown()`, or `startsCountdownOnTap = true` | on tap it starts after the delegate's `animatedItemViewDidTap` |
| Stop with no finish callback | `resetCountdown()` | |
| Read the state | `countdownState` (`.idle`, `.running`, `.finished`), `countdownRemainingSeconds`, `countdownEndDate` | |
| React | `CYLAnimatedItemViewDelegate`: `animatedItemViewDidTap`, `animatedItemViewDidStartCountdown`, `animatedItemView(_:didTickCountdown:)`, `animatedItemViewDidFinishCountdown` | all optional |
| Test without waiting | `countdownDateProvider = { date }` and `refreshCountdown()` | |
| Accessibility | nothing to do: label is the visible title; "not enabled" while counting; an announcement at the end | set `accessibilityIdentifier` |

Not here: anything about animations (Lottie, PAG, Rive, GIF, SVGA): this app adds only `CYLAnimatedItem` Core, so images are static.
If a needed API is missing, add it to the component (AGENTS.md, "Depending on CYLAnimatedItem"), not to this app.
