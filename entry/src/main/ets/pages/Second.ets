import { router } from '@kit.ArkUI';

@Entry
@Component
struct Second {
  @State message: string = "Hi there"

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontSize(FontWeight.Bold)
        Button() {
          Text('Back')
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
        }
        .type(ButtonType.Capsule)
        .margin({
          top: 20
        })
        .backgroundColor('#0D9FFB')
        .width('40%')
        .height('5%')
        .onClick(() => {
          router.back();
        })
      }
      .width('100%')
    }
  }
}