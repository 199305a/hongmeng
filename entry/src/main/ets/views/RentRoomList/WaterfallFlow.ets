import { getRentRoomListApi } from '../../api/rentRoom';
import { IGetRentRoomListParams, IRentRoomItem, RentRoomListDataSource } from '../../model/RentRoomData';
import { ITagItem } from '../../model/RoomRecommendDataSource';

import { BORDER_RADIUS } from '../../constants/size';
import { rvp } from '../../utils/responsive';
import { globalEmitter } from '../../utils/emitter';
import Empty from '../../components/Empty';
import { router } from '@kit.ArkUI';

@Component
export default struct WaterfallFlow {
  @State roomRoomListDataSource: RentRoomListDataSource = new RentRoomListDataSource([])
  @State total: number = 0
  @State searchOptions: IGetRentRoomListParams = {
    "page": 1,
    "limit": 10,
    "provinceCode": "",
    "cityCode": "",
    "districtCode": "",
    "minRent": "",
    "maxRent": "",
    // "paymentType": "",
    // "orderBy": "",
    // "orderType": ""
  }

  aboutToAppear() {
    this.getRentRoomList();
    this.registerGlobalEmitter();
  }

  registerGlobalEmitter() {
    globalEmitter.on('searchOptionsChange', async (searchOptions: Partial<IGetRentRoomListParams>) => {
      this.searchOptions.page = 1;
      this.searchOptions.limit = 10;
      if (searchOptions.provinceCode) {
        this.searchOptions.provinceCode = searchOptions.provinceCode;
      }
      if (searchOptions.cityCode) {
        this.searchOptions.cityCode = searchOptions.cityCode;
      }
      if (searchOptions.districtCode) {
        this.searchOptions.districtCode = searchOptions.districtCode;
      }
      this.getRentRoomList()
    })
  }

  async getRentRoomList() {
    const res = await getRentRoomListApi(this.searchOptions)
    this.roomRoomListDataSource.pushDataList(res.records)
    this.total = res.total
  }

  loadMore = () => {
    this.searchOptions.page++;
    this.getRentRoomList()
  }

  @Builder
  footer() {
    Row({ space: rvp(5) }) {
      LoadingProgress().width(rvp(20)).height(rvp(20)).color($r('app.color.gray'))
      Text('加载数据中...').fontSize(rvp(12)).fontColor($r('app.color.gray'))
    }.width('100%').backgroundColor($r('app.color.white')).justifyContent(FlexAlign.Center)
  }
  goRentRoomDetail(id: string) {
    router.pushUrl({
      url: 'pages/RentRoom/RentRoomDetail',
      params: {
        id
      }
    })
  }
  build() {
    if (this.total > 0) {
      WaterFlow({
        footer: () => {
          this.footer()
        }
      }) {
        LazyForEach(this.roomRoomListDataSource, (room: IRentRoomItem) => {
          FlowItem() {
            Stack() {
              Column() {
                if (room.activity) {
                  Column() {
                    Row() {
                      Image(room.activity.icon).width(rvp(26))
                      Text(room.activity.title).fontSize(rvp(14)).fontWeight(700)
                    }

                    Text(room.activity.title)
                      .fontColor(room.activity.textColor)
                      .backgroundColor(room.activity.textBackGroundColor)
                      .padding({
                        top: rvp(4),
                        bottom: rvp(4),
                        left: rvp(8),
                        right: rvp(8)
                      })
                      .borderRadius(rvp(21))
                      .fontSize(rvp(10))
                      .margin({ top: rvp(3) })
                    Image(room.housePicture)
                      .width('100%')
                      .height(rvp(170))
                      .borderRadius(rvp(BORDER_RADIUS))
                      .objectFit(ImageFit.Fill)
                      .margin({ top: rvp(5) })
                  }.padding({ left: rvp(10), right: rvp(10), top: rvp(10) }).alignItems(HorizontalAlign.Start)
                } else {
                  Image(room.housePicture).width('100%').height(rvp(120)).objectFit(ImageFit.Fill).borderRadius({
                    topLeft: rvp(BORDER_RADIUS),
                    topRight: rvp(BORDER_RADIUS)
                  })
                }
                Column() {
                  Row() {
                    Text() {
                      Span(room.rentPriceListing).fontSize(rvp(14)).fontColor('#E03810')
                      Span(room.rentPriceUnit).fontSize(rvp(12)).fontColor('#E03810')
                    }.height(rvp(22))

                    Text(room.rentArea + '㎡').fontSize(rvp(10)).fontColor($r('app.color.gray'))
                  }.width('100%').justifyContent(FlexAlign.SpaceBetween)

                  Text(room.houseTitle)
                    .fontSize(rvp(12))
                    .margin({ top: rvp(1) })
                    .height(rvp(19))
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                  Row({ space: rvp(6) }) {
                    ForEach(room.tags.slice(0, 2), (tag: ITagItem, index) => {
                      Text(tag.name)
                        .padding({
                          top: rvp(1),
                          bottom: rvp(1),
                          left: rvp(6),
                          right: rvp(6),
                        })
                        .fontColor(index === 0 ? $r('app.color.white') : '#B3B3B3')
                        .backgroundColor(index === 0 ? $r('app.color.primary') : $r('app.color.bg_gray'))
                        .fontSize(rvp(10))
                    }, (tag: ITagItem) => tag.name)
                  }.width('100%').margin({ top: rvp(9) })
                }.padding(rvp(12)).alignItems(HorizontalAlign.Start).height(rvp(90))
              }.width('100%').alignItems(HorizontalAlign.Start)

              if (!room.activity) {
                Image($r('app.media.room_text_bg')).width('100%').height(rvp(120))
                Row({ space: rvp(6) }) {
                  Image($r('app.media.location')).width(rvp(12)).height(rvp(14))
                  Text(room.address).fontSize(rvp(10)).fontColor($r('app.color.white'))
                }.margin({ left: rvp(8), top: rvp(99) })
              }
            }
            .alignContent(Alignment.TopStart)
            .backgroundColor($r('app.color.white'))
            .borderRadius(rvp(BORDER_RADIUS))
            .height('100%')
            .width(rvp(165))
          }.height(room.activity ? rvp(320) : rvp(210)).onClick(this.goRentRoomDetail.bind(this, room.id))
        }, (room: IRentRoomItem) => room.id)
      }
      .columnsTemplate("1fr 1fr")
      .columnsGap(rvp(10))
      .rowsGap(rvp(10))
      .backgroundColor($r('app.color.bg_gray'))
      .width('100%')
      .layoutWeight(1)
      .layoutDirection(FlexDirection.Column)
      .padding({ left: rvp(10), right: rvp(10), top: rvp(10) })
      .onReachEnd(this.loadMore)
    }else  {
      Column() {
        Empty({ title: '抱歉，没有搜索到你想要的房子。' }).margin({ top: -rvp(138) })
      }.height('100%').justifyContent(FlexAlign.Center)
    }

  }
}