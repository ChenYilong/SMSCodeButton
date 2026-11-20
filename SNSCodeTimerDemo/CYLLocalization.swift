//
//  CYLLocalization.swift
//  SNSCodeTimerDemo
//
//  Created by CHENYI LONG on 14-11-24.
//  Copyright (c) 2014年 CHENYI LONG. All rights reserved.
//

import Foundation

/**
 * [EN] The localized text for `key`, from this app's table `CYLSMSCode` (`<language>.lproj/CYLSMSCode.strings`). The key is
 *      the original Chinese text, so a language without a table still shows it. Every text of the app goes through here:
 *      no Chinese string literal is used any other way.
 * [CN] `key` 的本地化文本，来自本 App 的表 `CYLSMSCode`（`<language>.lproj/CYLSMSCode.strings`）。key 是中文原文，所以没有对应
 *      语言的表时仍显示原文。App 中的所有文本都通过这里：不以其他方式使用中文字符串字面量。
 */
func cylLocalizedString(_ key: String) -> String {
    return NSLocalizedString(key, tableName: "CYLSMSCode", bundle: Bundle.main, value: key, comment: "")
}
