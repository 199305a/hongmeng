import SwiperLayout from '../../views/Home/SwiperLayout'

import SearchBar from '../../views/Home/SearchBar';
import { getHomeDataApi } from '../../api/home';
import type { IColor, INavList, IPlanList, ITileList } from '../../model/HomeData';
import { BannerListDataSource } from '../../model/HomeData';
import NavList from '../../views/Home/NavList';
import { PADDING } from '../../constants/size';
import TileList from '../../views/Home/TileList';
import PlanList from '../../views/Home/PlanList';
import Ad from '../../views/Home/Ad';
import RoomRecommend from '../../views/Home/RoomRecommend';
import ScrollContainer from '../../components/ScrollContainer';

import { window } from '@kit.ArkUI';
import { BreakpointSystem } from '../../common/BreakpointSystem'


@Component
export default struct Home {
  @State bannerList: BannerListDataSource = new BannerListDataSource()
  // 首页数据
  @State navList: INavList = [];
  @State tileList: ITileList = [];
  @State planList: IPlanList = [];
  @State adPicture: string = '';
  scrollY: number = 0;
  @State bgColor: string = 'rgba(255, 255, 255, 0)'
  @State fontColor: string = 'rgb(255, 255, 255)'

  @StorageProp('currentBreakpoint') currentBreakpoint: string = 'sm'
  private breakpointSystem: BreakpointSystem = new BreakpointSystem()

  // 组件生命周期
 async aboutToAppear() {
   this.breakpointSystem.register()
   await  this.getHomeData()
  }

  aboutToDisappear() {
    this.breakpointSystem.unregister()
  }
  onPageShow(): void {
    window.getLastWindow(getContext(), (err, data) => {
      let win: window.Window;
      if (err.code) {
        console.error("error code :" + JSON.stringify(err.code))
        return;
      }
      try {
        win = data;
        //设置窗口为全屏模式
        win.setWindowLayoutFullScreen(true);
        // 设置状态栏
        win.setWindowSystemBarProperties({
          // 设置状态栏颜色为其他颜色
          statusBarColor: '#00ff00',
          // 设置状态栏文本颜色为白色
          statusBarContentColor: '#353535'
        })
        console.info('带状态栏沉浸式窗口设置完成')
      } catch (expextion) {
        console.error("error cause :" + JSON.stringify(expextion))
      }
    })
  }


  getHomeData = async () => {
    const homeData = await getHomeDataApi()
    this.bannerList.setList(homeData.bannerList)
    this.navList = homeData.navList;
    this.tileList = homeData.tileList;
    this.planList = homeData.planList;
    this.adPicture = homeData.adPicture;
  }



  @Builder
  contentBuilder() {
    SwiperLayout({ bannerList: this.bannerList })
    Column() {
      NavList({ navList: this.navList })
      TileList({ tileList: this.tileList })
      PlanList({ planList: this.planList })
      Ad({ adPicture: this.adPicture })
    }.padding({ left: PADDING, right: PADDING })

    RoomRecommend()
  }

  @Builder
  navBuilder($$: IColor) {
    SearchBar({ bgColor: $$.bgColor, fontColor: $$.fontColor });
  }

  build() {
    ScrollContainer({
      contentBuilder: () => {
        this.contentBuilder()
      },
      navBuilder: this.navBuilder
    })
  }
}