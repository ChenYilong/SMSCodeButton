import { CYLAnimatedItemController, CYLAnimatedItemStyle, CYLAnimatedItemView } from 'cylanimateditem';
import { hilog } from '@kit.PerformanceAnalysisKit';

/**
 * [EN] The example page: one "Get code" button in the middle. The button is `CYLAnimatedItemView` in its countdown style, and all
 *      the countdown logic (the end time, the background, the title, the width, the cache) is in that component; this page only
 *      sets texts and icons, starts it on a tap and sends the code. The texts come from the string resources (en, zh_CN).
 * [CN] 示例页面：中间一个「获取验证码」按钮。按钮是倒计时样式的 `CYLAnimatedItemView`，所有倒计时逻辑（结束时间、后台、标题、宽度、缓存）
 *      都在该组件中；本页面只设置文本与图标，点击时开始倒计时并发送验证码。文本来自字符串资源（en、zh_CN）。
 */
@Entry
@Component
struct Index {
  private controller: CYLAnimatedItemController = new CYLAnimatedItemController();

  /** [EN] The text of a string resource. [CN] 字符串资源的文本。 */
  private text(resource: Resource): string {
    return getContext(this).resourceManager.getStringSync(resource);
  }

  build() {
    Column() {
      CYLAnimatedItemView({
        itemStyle: CYLAnimatedItemStyle.Countdown,
        image: $r('app.media.cyl_sms_envelope'),
        countdownImage: $r('app.media.cyl_sms_clock'),
        countdownIdleTitle: this.text($r('app.string.cyl_sms_get_code')),
        countdownRunningTitleFormat: this.text($r('app.string.cyl_sms_seconds_left')),
        countdownFinishedTitle: this.text($r('app.string.cyl_sms_resend')),
        countdownRunningTitleColor: '#000000',
        countdownDuration: 60,
        startsCountdownOnTap: true,
        // [EN] Keeps the countdown, so it continues after the app was ended in the background and started again. One key per
        //      thing counted: use one per phone number in a real app.
        // [CN] 保存倒计时，使其在 App 于后台被结束后再次启动时继续。每个被计时的对象一个 key：真实 App 中每个手机号一个。
        countdownCacheKey: 'cyl-sms-code',
        controller: this.controller,
        itemId: 'cyl-sms-code-button',
        itemDescription: this.text($r('app.string.cyl_sms_button_hint')),
        sizesToContent: true,
        // [EN] A tap on the button: send the code here. The countdown starts right after this callback.
        // [CN] 点击按钮：在这里发送验证码。倒计时在本回调之后开始。
        onItemTap: () => {
          hilog.info(0x0000, 'CYLSMSCode', '%{public}s', this.text($r('app.string.cyl_sms_sending_code')));
        }
      })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor($r('sys.color.ohos_id_color_background'))
  }
}
