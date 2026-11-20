/**
 * [EN] The texts of the example, in English and Simplified Chinese, as the iOS table CYLSMSCode, the Android `strings.xml` and the
 *      HarmonyOS string resources. `cylSmsTexts(language)` picks the table by the language of WeChat (zh_CN, zh_TW and zh_HK read
 *      as Chinese; anything else as English). The `%d` in `secondsLeft` is replaced by the component. Pure functions without any wx
 *      API, tested in Node (test/cyl_sms_texts.test.js).
 * [CN] 示例的文本，英文与简体中文，与 iOS 的 CYLSMSCode 表、Android 的 `strings.xml` 以及鸿蒙的字符串资源相同。`cylSmsTexts(language)`
 *      按微信的语言选择表（zh_CN、zh_TW、zh_HK 为中文；其他为英文）。`secondsLeft` 中的 `%d` 由组件替换。不使用任何 wx API 的纯函数，
 *      在 Node 中测试（test/cyl_sms_texts.test.js）。
 */
const CYL_SMS_TEXTS = {
  en: {
    getCode: 'Get code',
    secondsLeft: '%d s left',
    resend: 'Resend',
    sendingCode: 'Sending the code',
  },
  zh: {
    getCode: '获取验证码',
    secondsLeft: '还剩%d秒',
    resend: '重新获取',
    sendingCode: '发送验证码',
  },
}

/** [EN] The texts for a WeChat language such as "zh_CN" or "en". [CN] 微信语言（例如 "zh_CN" 或 "en"）对应的文本。 */
function cylSmsTexts(language) {
  return /^zh/i.test(String(language || '')) ? CYL_SMS_TEXTS.zh : CYL_SMS_TEXTS.en
}

module.exports = { CYL_SMS_TEXTS, cylSmsTexts }
