//
//  CYLSceneDelegate.swift
//  SNSCodeTimerDemo
//
//  Created by CHENYI LONG on 14-11-23.
//  Copyright (c) 2014年 CHENYI LONG. All rights reserved.
//

import UIKit

/**
 * [EN] Puts the demo page in the window of each scene.
 * [CN] 在每个 scene 的窗口中放置示例页面。
 */
final class CYLSceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = CYLSNSCodeButtonViewController()
        window.makeKeyAndVisible()
        self.window = window
    }
}
