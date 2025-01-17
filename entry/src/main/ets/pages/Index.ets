import Home from './tabs/Home';
import See from './tabs/See';
import Service from './tabs/Service';
import Discover from './tabs/Discover';
import My from './tabs/My';
// import { xs } from '../../utils/responsive/responsiveFontSize';
import type { IColors } from '../model/ColorsData'
import { getWindowBottomHeight,rvp } from '../utils/responsive';
import { router } from '@kit.ArkUI';
import { TabIndex } from '../model/IndexData';

// 必须放在入口页面
PersistentStorage.persistProp('token', '')

@Entry
@Component
struct Index {

  @StorageLink('navBarFontColor') navBarFontColor: string = ''
  @StorageLink('navBarBgColor') navBarBgColor: string = ''
  // 当前 tab 高亮的下标
  @State currentIndex: number = 0;
  colors: IColors = []

  aboutToAppear() {
    const params = router.getParams() as TabIndex
    if (params) {
      this.currentIndex = params.currentIndex
    }
  }


  @Builder TabBuilder(index:number,text:string,icon:Resource,activeIcon:Resource){
    Column(){
      Image(this.currentIndex === index ? activeIcon:icon).width(rvp(28))
      Text(text).fontSize(rvp(10)).fontColor(this.currentIndex === index ? $r('app.color.black'): '#a0a0a0').height(rvp(15))
    }.width('100%').height('100%').justifyContent(FlexAlign.Center)
  }

  build() {
    Column() {
      Tabs({barPosition:BarPosition.End,index:this.currentIndex}){
        TabContent() {
          Home()
        }.tabBar(this.TabBuilder(0, '首页', $r('app.media.tabbar_home'), $r('app.media.tabbar_home_active')))

        TabContent() {
          See()
        }.tabBar(this.TabBuilder(1, '想看', $r('app.media.tabbar_see'), $r('app.media.tabbar_see_active')))

        TabContent() {
          Service({ isActiveTab: this.currentIndex === 2 })
        }.tabBar(this.TabBuilder(2, '服务', $r('app.media.tabbar_service'), $r('app.media.tabbar_service_active')))

        TabContent() {
          Discover({ isActiveTab: this.currentIndex === 3 })
        }.tabBar(this.TabBuilder(3, '发现', $r('app.media.tabbar_discover'), $r('app.media.tabbar_discover_active')))

        TabContent() {
          My({ isActiveTab: this.currentIndex === 4 })
        }.tabBar(this.TabBuilder(4, '我的', $r('app.media.tabbar_my'), $r('app.media.tabbar_my_active')))
      }
      .vertical(false)
      .barMode(BarMode.Fixed)
      .onChange((index:number)=>{
        // 将上个页面color存储起来
        this.colors[this.currentIndex] = {
          navBarBgColor: this.navBarBgColor,
          navBarFontColor: this.navBarFontColor
        }
        // 将当前页面的color赋值上去
        this.navBarFontColor = this.colors[index]?.navBarFontColor || 'rgb(255, 255, 255)'
        this.navBarBgColor = this.colors[index]?.navBarBgColor || 'rgba(255, 255, 255, 0)'

        this.currentIndex = index
      })
      .barHeight(rvp(50) + getWindowBottomHeight()) // 设置 tab 导航栏的高度，默认 56
      .scrollable(false)
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.white'))
    }
    .height('100%')

  }
}