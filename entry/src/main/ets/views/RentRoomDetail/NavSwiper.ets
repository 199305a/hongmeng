import { md } from '../../utils/responsive/responsiveFontSize'

import type { IHousePictureItem, IHousePictureList } from '../../model/RentRoomData'
import { rvp } from '../../utils/responsive'
import { BasicDataItem, BasicDataSource } from '../../model/BasicDataSource'


@Component
export default struct NavSwiper {
  @Link @Watch('handleHousePictureListChange') housePictureList: IHousePictureList
  @State housePictureListDataSource: BasicDataSource<BasicDataItem> = new BasicDataSource()
  @State currentTabIndex: number = 0
  scroller: Scroller = new Scroller()
  @State isGoCurrentTabIndexImage: boolean = false

  handleHousePictureListChange() {
    const list = this.housePictureList.reduce<BasicDataItem[]>((p, c, index) => {
      return [...p, ...c.picList.map(pic => {
        return {
          url: pic,
          currentTabIndex: index
        } as  BasicDataItem;
      })];
    },[])
    console.log(JSON.stringify(list));
    this.housePictureListDataSource.pushDataList(list );
  }

  setCurrentTabIndex(index: number) {
    this.currentTabIndex = index;
    this.goCurrentTabIndexImage()
  }

  goCurrentTabIndexImage() {
    const index = this.housePictureListDataSource.data.findIndex(pic => {
      return pic.currentTabIndex === this.currentTabIndex
    })
    this.scroller.scrollTo({
      xOffset: rvp(318) * index + rvp(10) * (index - 1),
      yOffset: 0,
      animation: {
        duration: 500,
        curve: Curve.EaseIn
      }
    })
    this.isGoCurrentTabIndexImage = true;
    setTimeout(() => {
      this.isGoCurrentTabIndexImage = false;
    }, 500)
  }

  handleListScrollIndex(start: number) {
    if (this.isGoCurrentTabIndexImage) return;
    const pic = this.housePictureListDataSource.getData(start);
    if (pic) {
      this.currentTabIndex = pic.currentTabIndex;
    }
  }



  @Builder NavBar() {
    List({ space: rvp(16) }) {
      ListItem() {
      }

      ForEach(this.housePictureList, (pic: IHousePictureItem, index: number) => {
        ListItem() {
          Column({ space: rvp(4) }) {
            Text(pic.spaceName + `(${pic.picList.length})`)
              .fontSize(md())
              .fontColor(this.currentTabIndex === index ? $r('app.color.black') : $r('app.color.gray_second'))
            if (this.currentTabIndex === index) {
              Divider().width(rvp(16)).height(rvp(2)).color($r('app.color.primary'))
            }
          }
        }.onClick(this.setCurrentTabIndex.bind(this, index))
      }, (pic:IHousePictureItem) => pic.spaceName)
      ListItem() {
      }
    }.listDirection(Axis.Horizontal).width('100%')
  }

  @Builder PicList() {
    List({ space: rvp(10), scroller: this.scroller }) {
      ListItem() {
      }.width(rvp(6))

      LazyForEach(this.housePictureListDataSource, (pic:BasicDataItem) => {
        ListItem() {
          Image(pic.url).width(rvp(318)).height(rvp(192)).objectFit(ImageFit.Fill)
        }
      },( pic:BasicDataItem) => pic.url)

      ListItem() {
      }.width(rvp(6))
    }.width('100%').listDirection(Axis.Horizontal).onScrollIndex(this.handleListScrollIndex.bind(this))
  }

  build() {
    Column({ space: rvp(16) }) {
      this.NavBar()
      this.PicList()
    }.margin({ top: rvp(44 + 16) }).width('100%')
  }
}