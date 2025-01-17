import { getRentRoomDetailApi } from '../../api/rentRoom';

import ScrollContainer from '../../components/ScrollContainer';
import {
  GetRoomDetailParams,
  IDiscountsList,
  IDistanceInfo,
  IHouseholdList,
  IHousePictureList,
  IMetaInfoList,
  IRentInfoList,
  IRentRoomDetail,
  IRentTerm,
  ISupportList
} from '../../model/RentRoomData';
import { router } from '@kit.ArkUI';
import NavSwiper from '../../views/RentRoomDetail/NavSwiper';
import NavBar from '../../views/RentRoomDetail/NavBar';
import RentPrice from '../../views/RentRoomDetail/RentPrice';
import { BORDER_RADIUS_S, PADDING } from '../../constants/size';
import { rvp } from '../../utils/responsive';
import DiscountsList from '../../views/RentRoomDetail/DiscountsList';
import MetaInfo from '../../views/RentRoomDetail/MetaInfo';
import TagList from '../../views/RentRoomDetail/TagLit';
import { ITagList } from '../../model/RoomRecommendDataSource';
import RentTerm from '../../views/RentRoomDetail/RentTerm';
import RentInfo from '../../views/RentRoomDetail/RentInfo';
import HouseholdItem from '../../views/RentRoomDetail/HouseholdItem';
import SupportList from '../../views/RentRoomDetail/SupportList';
import { sm } from '../../utils/responsive/responsiveFontSize';
import SafeArea from '../../components/SafeArea';
import Book from '../../views/RentRoomDetail/Book';
import BookInfo from '../../views/BookInfo';

@Entry
@Component
struct RentRoomDetail {
  @State housePictureList: IHousePictureList = []
  @State room: Partial<IRentRoomDetail> = {
    rentPriceListing: '',
    rentPriceUnit: '',
    rentPriceUnitListing: ''
  }
  @State discountsList: IDiscountsList = []
  @State metaInfoList: IMetaInfoList = []
  @State distanceInfo: Partial<IDistanceInfo> = {}
  @State tagList: ITagList = []
  @State rentTerm: Partial<IRentTerm> = {}
  @State rentInfoList: IRentInfoList = []
  @State householdList: IHouseholdList = []
  @State supportList: ISupportList = []
  @State show: boolean = false
  @State roomId: string  = ''
  aboutToAppear() {
    this.getRentRoomDetail()

  }

  async getRentRoomDetail() {
    const params: GetRoomDetailParams = router.getParams() as GetRoomDetailParams
    this.room = await getRentRoomDetailApi(params.id)
    console.log(params.id);
    console.log(params.id);
    this.roomId = params.id;
    this.housePictureList = this.room.housePicture as IHousePictureList
    this.discountsList = this.room.discounts as IDiscountsList
    this.metaInfoList = this.room.metaInfo as IMetaInfoList
    this.distanceInfo = this.room.distance_info as IDistanceInfo
    this.tagList = this.room.tags as ITagList
    this.rentTerm = this.room.rentTerm as IRentTerm
    this.rentInfoList = this.room.rentInfo as IRentInfoList
    this.householdList = this.room.householdItem as IHouseholdList
    this.supportList = this.room.support as ISupportList
  }

  @Builder
  NavBarRender() {
    NavBar()
  }

  @Builder
  ContentRender() {
    Row() {
      SafeArea()
    }.backgroundColor($r('app.color.white'))

    Column() {
      NavSwiper({ housePictureList: $housePictureList })
      Column() {
        RentPrice({ rentPriceListing: this.room.rentPriceUnitListing, rentPriceUnit: this.room.rentPriceUnit })
        DiscountsList({ discountsList: $discountsList })
        MetaInfo({ metaInfoList: $metaInfoList, distanceInfo: $distanceInfo })
        TagList({ tagList: $tagList })
        RentTerm({ rentTerm: $rentTerm })
        RentInfo({ rentInfoList: $rentInfoList })
        HouseholdItem({ householdList: $householdList })
        SupportList({ supportList: $supportList })
        Button('查看全部内容')
          .type(ButtonType.Normal)
          .width('100%')
          .height(rvp(44))
          .fontSize(sm())
          .fontColor('#ABA9AC')
          .margin({ top: rvp(25) })
          .backgroundColor($r('app.color.white'))
          .border({ width: 1, color: '#F5F5F5', radius: rvp(BORDER_RADIUS_S) })
      }.padding({ left: rvp(PADDING), right: rvp(PADDING) })
    }.backgroundColor($r('app.color.white')).padding({ bottom: rvp(50) })
  }

  build() {
    Stack() {

      ScrollContainer({
        navBuilder: this.NavBarRender.bind(this),
        contentBuilder: this.ContentRender.bind(this),
      })

      Book({ show: $show })
      BookInfo({ show: $show,roomId:this.roomId })


    }.height('100%').alignContent(Alignment.Bottom)
  }
}