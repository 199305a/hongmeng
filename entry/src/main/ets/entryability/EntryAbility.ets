import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    // windowStage.loadContent('pages/RentRoom/RentRoomList', (err) => {
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });

    const windowClass = await windowStage.getMainWindow();
    // 1. 设置全屏
    windowClass.setWindowLayoutFullScreen(true);
    // 2. 设置状态栏颜色
    windowClass.setWindowSystemBarProperties({
      statusBarContentColor: '#FFFFFF',
      navigationBarContentColor: '#FFFFFF'
    })
    AppStorage.setOrCreate('windowStage',windowStage);
    // 3. 获取状态栏高度并存储起来
    const avoidArea = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
    AppStorage.setOrCreate('windowTopHeight', avoidArea.topRect.height);
    AppStorage.setOrCreate('windowBottomHeight', avoidArea.bottomRect.height);
    // 4. 获取屏幕宽高并存储起来
    const properties = windowClass.getWindowProperties()
    AppStorage.setOrCreate('windowHeight', properties.windowRect.height);
    AppStorage.setOrCreate('windowWidth', properties.windowRect.width);
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}