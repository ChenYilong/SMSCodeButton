package com.cyl.smscode

import android.os.Bundle
import android.util.Log
import android.view.Gravity
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import com.cyl.animateditem.CYLAnimatedItemGestureListener
import com.cyl.animateditem.CYLAnimatedItemStyle
import com.cyl.animateditem.CYLAnimatedItemView

/**
 * [EN] The example page: one "Get code" button in the middle. The button is `CYLAnimatedItemView` in its countdown style, and
 *      all the countdown logic (the end time, the background, the title, the width, the cache) is in that component; this page
 *      only sets texts and icons, starts it on a tap and sends the code.
 * [CN] 示例页面：中间一个「获取验证码」按钮。按钮是倒计时样式的 `CYLAnimatedItemView`，所有倒计时逻辑（结束时间、后台、标题、宽度、缓存）
 *      都在该组件中；本页面只设置文本与图标，点击时开始倒计时并发送验证码。
 */
class CYLSMSCodeActivity : AppCompatActivity() {
    /**
     * [EN] The button. [CN] 按钮。
     */
    lateinit var sendButton: CYLAnimatedItemView
        private set

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val root = FrameLayout(this)
        sendButton = makeSendButton()
        root.addView(sendButton, FrameLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT, Gravity.CENTER))
        setContentView(root)
    }

    private fun makeSendButton(): CYLAnimatedItemView = CYLAnimatedItemView(this).apply {
        style = CYLAnimatedItemStyle.Countdown
        image = ContextCompat.getDrawable(context, R.drawable.cyl_sms_envelope)
        countdownImage = ContextCompat.getDrawable(context, R.drawable.cyl_sms_clock)
        countdownIdleTitle = getString(R.string.cyl_sms_get_code)
        countdownRunningTitleFormat = getString(R.string.cyl_sms_seconds_left)
        countdownFinishedTitle = getString(R.string.cyl_sms_resend)
        countdownRunningTitleColor = ContextCompat.getColor(context, android.R.color.black)
        countdownDuration = 60
        // [EN] Tests give the clock before the cache is read. [CN] 测试在读取缓存之前提供时钟。
        countdownClock = clock
        startsCountdownOnTap = true
        // [EN] Keeps the countdown, so it continues after the process was ended in the background and started again. One key per
        //      thing counted: use one per phone number in a real app.
        // [CN] 保存倒计时，使其在进程于后台被结束后再次启动时继续。每个被计时的对象一个 key：真实 App 中每个手机号一个。
        countdownCacheKey = COUNTDOWN_CACHE_KEY
        tag = SEND_BUTTON_TAG
        gestureListener = object : CYLAnimatedItemGestureListener {
            /**
             * [EN] A tap on the button: send the code here. The countdown starts right after this method.
             * [CN] 点击按钮：在这里发送验证码。倒计时在本方法之后开始。
             */
            override fun onItemTapped(item: CYLAnimatedItemView) {
                Log.i(LOG_TAG, getString(R.string.cyl_sms_sending_code))
            }
        }
    }

    companion object {
        /**
         * [EN] The cache key of the countdown. [CN] 倒计时的缓存 key。
         */
        const val COUNTDOWN_CACHE_KEY = "cyl-sms-code"

        /**
         * [EN] The view tag of the button, for tests and UI automation. [CN] 按钮的 view tag，供测试与 UI 自动化使用。
         */
        const val SEND_BUTTON_TAG = "cyl-sms-code-button"

        /**
         * [EN] The clock in epoch millis for tests; null (default) is the system clock. [CN] 供测试使用的 epoch 毫秒时钟；null（默认）为系统时钟。
         */
        var clock: (() -> Long)? = null

        private const val LOG_TAG = "CYLSMSCode"
    }
}
