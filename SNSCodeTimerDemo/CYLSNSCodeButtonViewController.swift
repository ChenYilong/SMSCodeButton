//
//  CYLSNSCodeButtonViewController.swift
//  SNSCodeTimerDemo
//
//  Created by CHENYI LONG on 14-11-23.
//  Copyright (c) 2014年 CHENYI LONG. All rights reserved.
//

import UIKit
import CYLAnimatedItem

/**
 * [EN] The demo page: one "Get code" button in the middle. The button is `CYLAnimatedItemView` in its countdown style, and
 *      all the countdown logic (the end date, the background, the title, the width, the accessibility) is in that component;
 *      this page only sets texts and icons, starts it on a tap and sends the code.
 * [CN] 示例页面：中间一个「获取验证码」按钮。按钮是倒计时样式的 `CYLAnimatedItemView`，所有倒计时逻辑（结束时间、后台、标题、
 *      宽度、无障碍）都在该组件中；本页面只设置文本与图标，点击时开始倒计时并发送验证码。
 */
final class CYLSNSCodeButtonViewController: UIViewController, CYLAnimatedItemViewDelegate {
    /** [EN] The button. [CN] 按钮。 */
    let sendButton = CYLAnimatedItemView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpSendButton()
    }

    private func setUpSendButton() {
        sendButton.style = .countdown
        sendButton.image = UIImage(named: "timerBtn_imageView_normal")
        sendButton.countdownImage = UIImage(named: "timerBtn_imageView_selected")
        sendButton.countdownIdleTitle = cylLocalizedString("获取验证码")
        sendButton.countdownRunningTitleFormat = cylLocalizedString("还剩%ld秒")
        sendButton.countdownFinishedTitle = cylLocalizedString("重新获取")
        sendButton.countdownRunningTitleColor = .label
        sendButton.countdownDuration = 60
        sendButton.startsCountdownOnTap = true
        sendButton.delegate = self
        sendButton.accessibilityIdentifier = "cyl-sms-code-button"
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sendButton)
        NSLayoutConstraint.activate([
            sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    /**
     * [EN] A tap on the button: send the code here. The countdown starts right after this method.
     * [CN] 点击按钮：在这里发送验证码。倒计时在本方法之后开始。
     */
    func animatedItemViewDidTap(_ itemView: CYLAnimatedItemView) {
        NSLog("%@", cylLocalizedString("发送验证码"))
    }
}
