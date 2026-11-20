/**
 * [EN] The example page: one "Get code" button in the middle. The button is `cyl-animated-item` in its countdown style, and all
 *      the countdown logic (the end time, the background, the title, the width, the cache) is in that component; this page only
 *      sets texts and icons in the wxml, and sends the code on `itemtap`, after which the countdown starts.
 * [CN] 示例页面：中间一个「获取验证码」按钮。按钮是倒计时样式的 `cyl-animated-item`，所有倒计时逻辑（结束时间、后台、标题、宽度、缓存）
 *      都在该组件中；本页面只在 wxml 中设置文本与图标，并在 `itemtap` 时发送验证码，之后倒计时开始。
 */
const { cylSmsTexts } = require('../../utils/cyl_sms_texts')

Page({
  data: {
    texts: cylSmsTexts('en'),
  },

  onLoad() {
    let language = 'en'
    try {
      const info = typeof wx.getAppBaseInfo === 'function' ? wx.getAppBaseInfo() : wx.getSystemInfoSync()
      language = info.language || language
    } catch {
      language = 'en'
    }
    this.setData({ texts: cylSmsTexts(language) })
  },

  /**
   * [EN] A tap on the button: send the code here. The countdown starts right after this handler (`starts-countdown-on-tap`).
   * [CN] 点击按钮：在这里发送验证码。倒计时在本处理函数之后开始（`starts-countdown-on-tap`）。
   */
  onGetCode() {
    console.info(this.data.texts.sendingCode)
  },
})
