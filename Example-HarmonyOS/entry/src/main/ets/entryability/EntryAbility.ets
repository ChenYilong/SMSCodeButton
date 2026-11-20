import { UIAbility } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';

/**
 * [EN] The example's ability: one window showing pages/Index (the "Get code" button).
 * [CN] 示例的 Ability：一个窗口显示 pages/Index（「获取验证码」按钮）。
 */
export default class EntryAbility extends UIAbility {
  onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/Index', (error: Error | undefined) => {
      if (error) {
        hilog.error(0x0000, 'CYLSMSCode', 'loadContent failed: %{public}s', JSON.stringify(error));
      }
    });
  }
}
