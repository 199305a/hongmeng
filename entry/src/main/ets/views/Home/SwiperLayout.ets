import type { IBannerItem, BannerListDataSource } from '../../model/HomeData'
import {rvp} from '../../utils/responsive'
@Component
export default struct SwiperLayout {
  @StorageProp('windowTopHeight') windowTopHeight: number = 0;

  @ObjectLink bannerList: BannerListDataSource

  build() {
    Swiper() {
      LazyForEach(this.bannerList, (banner: IBannerItem) => {
        Image(banner.imageURL).width('100%').height(rvp(175) + px2vp(this.windowTopHeight)).objectFit(ImageFit.Fill)
      }, (item: IBannerItem) => item.id + '')
    }
    .width('100%')
    .autoPlay(true)
    .indicator(new DotIndicator()
      .color($r('app.color.indicator_color'))
      .selectedColor($r('app.color.indicator_active_color')))
  }
}