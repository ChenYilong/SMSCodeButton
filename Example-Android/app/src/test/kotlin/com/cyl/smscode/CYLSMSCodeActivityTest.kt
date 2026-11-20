package com.cyl.smscode

import com.cyl.animateditem.CYLAnimatedItemCountdownState
import com.cyl.animateditem.CYLAnimatedItemStyle
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertTrue
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.Robolectric
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config

/**
 * [EN] The example page uses the countdown style of `CYLAnimatedItemView`. The countdown itself (the background, the width, the
 *      ticks, the cache) is tested in CYLTabBarController's `cylanimateditem` module; here: the page sets it up as the README
 *      describes, and a countdown on a moved clock gives the texts of the README's screenshots.
 * [CN] 示例页面使用 `CYLAnimatedItemView` 的倒计时样式。倒计时本身（后台、宽度、tick、缓存）在 CYLTabBarController 的
 *      `cylanimateditem` 模块中测试；这里测试：页面按 README 的描述设置按钮，以及在拨动的时钟上倒计时得到 README 截图中的文本。
 */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34])
class CYLSMSCodeActivityTest {
    private var now = 1_000_000L

    private fun makeActivity(): CYLSMSCodeActivity {
        CYLSMSCodeActivity.clock = { now }
        return Robolectric.buildActivity(CYLSMSCodeActivity::class.java).setup().get()
    }

    @After
    fun tearDown() {
        // [EN] The countdown is cached: a test must not leave one for the next. [CN] 倒计时会被缓存：测试不能给下一个测试留下倒计时。
        makeActivity().sendButton.resetCountdown()
        CYLSMSCodeActivity.clock = null
    }

    @Test
    fun theButtonIsACountdownItemWithTheReadmeTexts() {
        val button = makeActivity().sendButton
        assertEquals(CYLAnimatedItemStyle.Countdown, button.style)
        assertEquals(CYLAnimatedItemCountdownState.Idle, button.countdownState)
        assertEquals("Get code", button.title)
        assertNotNull(button.image)
        assertNotNull(button.countdownImage)
        assertTrue(button.startsCountdownOnTap)
        assertEquals(CYLSMSCodeActivity.SEND_BUTTON_TAG, button.tag)
    }

    @Test
    fun aTapStartsTheCountdownAndTheTimeInTheBackgroundCounts() {
        val button = makeActivity().sendButton
        button.performClick()
        assertEquals(CYLAnimatedItemCountdownState.Running, button.countdownState)
        assertFalse(button.isEnabled)
        assertEquals("60 s left", button.title)

        // [EN] Issue #1: 46 seconds pass with the app in the background; the README's "14 seconds left" shows on return.
        // [CN] issue #1：App 在后台度过 46 秒；返回时显示 README 中的「还剩14秒」。
        now += 46_000
        button.refreshCountdown()
        assertEquals("14 s left", button.title)

        now += 14_000
        button.refreshCountdown()
        assertEquals(CYLAnimatedItemCountdownState.Finished, button.countdownState)
        assertTrue(button.isEnabled)
        assertEquals("Resend", button.title)
    }

    @Test
    fun aRestartTakesTheCachedCountdownUpAgainAndAPastClockClosesIt() {
        makeActivity().sendButton.performClick()
        now += 20_000
        val restarted = makeActivity().sendButton
        assertEquals(CYLAnimatedItemCountdownState.Running, restarted.countdownState)
        assertEquals("40 s left", restarted.title)

        now += 100_000_000
        restarted.refreshCountdown()
        assertEquals(CYLAnimatedItemCountdownState.Finished, restarted.countdownState)
        assertTrue(restarted.isEnabled)
    }
}
