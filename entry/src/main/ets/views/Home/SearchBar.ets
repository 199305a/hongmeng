import { PADDING } from '../../constants/size'
import { rvp } from '../../utils/responsive'

@Component
export default struct SearchBar {
  @Prop bgColor: string;
  @Prop fontColor: ResourceColor;

  build() {
      Row(){
        Text("北京").fontSize(rvp(14)).fontColor(this.fontColor)
        Row() {
          Image($r("app.media.search")).imageStyles(rvp(18)).margin({ right: rvp(10) })
          TextInput({ placeholder: '公司/地铁/小区，马上搜索' })
            .layoutWeight(1)
            .height('100%')
            .fontSize(rvp(12))
            .placeholderFont({ size: rvp(12) })
            .padding(0)
            .backgroundColor($r('app.color.white'))
            .stateStyles({
              pressed: textInputStyles
            })
          Column() {
          }.width(rvp(1)).height(rvp(18)).backgroundColor('#D7D7D7').margin({ left: rvp(10) })

          Image($r("app.media.position")).imageStyles(rvp(18)).margin({ left: rvp(16) })
        }
        .width(rvp(244))
        .height(rvp(38))
        .backgroundColor($r('app.color.white'))
        .padding({ left: PADDING, right: PADDING })
        .border({
          width: rvp(1),
          radius: rvp(52),
          color: '#D7D7D7'
        })
        SymbolGlyph($r('sys.symbol.message')).fontColor([this.fontColor])
      }
      .width('100%')
      .padding({
        left: PADDING,
        right: PADDING,
        top: rvp(4),
        bottom: rvp(4)
      })
      .justifyContent(FlexAlign.SpaceBetween)
      .backgroundColor(this.bgColor)
  }
}

@Extend(Image)
function imageStyles(size: number) {
  .width(rvp(size)).height(rvp(size)).objectFit(ImageFit.Fill)
}

@Styles
function textInputStyles() {
  .backgroundColor('#fff')
}