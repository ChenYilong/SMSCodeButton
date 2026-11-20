//
//  SNSCodeTimerDemoTests.swift
//  SNSCodeTimerDemoTests
//
//  Created by CHENYI LONG on 14-11-23.
//  Copyright (c) 2014年 CHENYI LONG. All rights reserved.
//

import XCTest
import CYLAnimatedItem
@testable import SNSCodeTimerDemo

/**
 * [EN] The demo page uses the countdown style of `CYLAnimatedItemView`. The countdown itself (the background, the width, the
 *      ticks) is tested in CYLTabBarController's `CYLAnimatedItemViewTests`; here: the page sets it up as the README
 *      describes, and a countdown on a moved clock gives the texts of the README's screenshots.
 * [CN] 示例页面使用 `CYLAnimatedItemView` 的倒计时样式。倒计时本身（后台、宽度、tick）在 CYLTabBarController 的
 *      `CYLAnimatedItemViewTests` 中测试；这里测试：页面按 README 的描述设置按钮，以及在拨动的时钟上倒计时得到 README 截图中的文本。
 */
final class SNSCodeTimerDemoTests: XCTestCase {
    private var now = Date(timeIntervalSince1970: 1_000)

    override func tearDown() {
        // [EN] The countdown is cached: a test must not leave one for the next. [CN] 倒计时会被缓存：测试不能给下一个测试留下倒计时。
        makeController().sendButton.resetCountdown()
        super.tearDown()
    }

    private func makeController() -> CYLSNSCodeButtonViewController {
        let controller = CYLSNSCodeButtonViewController()
        controller.loadViewIfNeeded()
        controller.sendButton.countdownDateProvider = { [unowned self] in self.now }
        return controller
    }

    func testTheButtonIsACountdownItemWithTheReadmeTexts() {
        let button = makeController().sendButton
        XCTAssertEqual(button.style, .countdown)
        XCTAssertEqual(button.countdownState, .idle)
        XCTAssertEqual(button.title, cylLocalizedString("获取验证码"))
        XCTAssertNotNil(button.image, "the envelope")
        XCTAssertNotNil(button.countdownImage, "the clock")
        XCTAssertTrue(button.startsCountdownOnTap)
        XCTAssertEqual(button.accessibilityIdentifier, "cyl-sms-code-button")
    }

    func testATapStartsTheCountdownAndTheTimeInTheBackgroundCounts() {
        let button = makeController().sendButton
        button.sendActions(for: .touchUpInside)
        XCTAssertEqual(button.countdownState, .running)
        XCTAssertFalse(button.isEnabled)
        XCTAssertEqual(button.title, String(format: cylLocalizedString("还剩%ld秒"), 60))

        // [EN] Issue #1: 46 seconds pass with the app in the background; the README's "14 seconds left" shows on return.
        // [CN] issue #1：App 在后台度过 46 秒；返回时显示 README 中的「还剩14秒」。
        now = now.addingTimeInterval(46)
        NotificationCenter.default.post(name: UIApplication.willEnterForegroundNotification, object: nil)
        XCTAssertEqual(button.title, String(format: cylLocalizedString("还剩%ld秒"), 14))

        now = now.addingTimeInterval(14)
        button.refreshCountdown()
        XCTAssertEqual(button.countdownState, .finished)
        XCTAssertTrue(button.isEnabled)
        XCTAssertEqual(button.title, cylLocalizedString("重新获取"))
    }

    /**
     * [EN] The owner's rule on issue #1: a clock past the longest duration closes the countdown and the button can be tapped
     *      again; a restart takes a cached countdown up again.
     * [CN] 所有者对 issue #1 的要求：本地时钟超过最长时长时关闭倒计时，按钮可再次点击；重启后接续缓存的倒计时。
     */
    func testAPastClockClosesTheCountdownAndARestartTakesItUpAgain() {
        let button = makeController().sendButton
        button.sendActions(for: .touchUpInside)

        // [EN] A new controller, as after the app was ended in the background: the countdown continues. [CN] 新的控制器，相当于 App 在后台被结束后重启：倒计时继续。
        now = now.addingTimeInterval(20)
        let restarted = makeController().sendButton
        XCTAssertEqual(restarted.countdownState, .running)
        XCTAssertEqual(restarted.title, String(format: cylLocalizedString("还剩%ld秒"), 40))

        now = now.addingTimeInterval(100_000)
        restarted.refreshCountdown()
        XCTAssertEqual(restarted.countdownState, .finished)
        XCTAssertTrue(restarted.isEnabled)
    }
}
