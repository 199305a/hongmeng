import { getCityListApi, getDistrictListApi, getProvinceListApi } from "../../api/rentRoom"
import { BORDER_RADIUS_S, PADDING } from "../../constants/size"
import { ICityItem, ICityList, IDistrictItem, IDistrictList,
  IProvinceItem,
  IProvinceList,
  IRentPriceItem,
  ISortItem,
  ISortListData,
  LocationData,
  paymentTypeData,
  rentPriceData} from "../../model/RentRoomData"
import { rvp } from "../../utils/responsive"
import { globalEmitter } from '../../utils/emitter'
import { md, sm } from '../../utils/responsive/responsiveFontSize'
import { print } from "@kit.BasicServicesKit"

@Component
export default struct SearchFilter {
  @State searchTypeList: string[] = ['地区', '租金', '付款方式', '排序']
  @State currentSearchType: string = ''
  // 3. 地区数据
  @State locationData: LocationData = {
    provinceList: [],
    cityList: [],
    districtList: [],
    provinceCode: '',
    cityCode: '',
    districtCode: '',
    isSearch: false,
    searchProvinceCode: '',
    searchCityCode: '',
    searchDistrictCode: '',
    searchDistrictName: ''
  }
  // 11.9
  @State rentPriceData: rentPriceData = {
    rentPriceList: [
      {
        id: 1,
        minRent: '0',
        maxRent: '0',
        text: '不限'
      },
      {
        id: 2,
        minRent: '0',
        maxRent: '1500',
        text: '1500元以下'
      },
      {
        id: 3,
        minRent: '1500',
        maxRent: '2500',
        text: '1500-2500元'
      },
      {
        id: 4,
        minRent: '2500',
        maxRent: '3500',
        text: '2500-3500元'
      },
      {
        id: 5,
        minRent: '3500',
        maxRent: '4500',
        text: '3500-4500元'
      },
      {
        id: 6,
        minRent: '4500',
        maxRent: '6000',
        text: '4500-6000元'
      },
      {
        id: 7,
        minRent: '6000',
        maxRent: '8000',
        text: '6000-8000元'
      },
      {
        id: 8,
        minRent: '8000',
        maxRent: '10000',
        text: '8000-10000元'
      },
      {
        id: 9,
        minRent: '10000',
        maxRent: '0',
        text: '10000元以上'
      }
    ],
    searchRentPrice:{
      text:''
    },
    isSearch:false
  }

  getSearchTypeName(item: string) {
    if (item === '地区') {
      return this.locationData.searchDistrictName || item
    } else if (item === '租金') {
      return this.rentPriceData.searchRentPrice.text || item
    }
    return item
  }
  getSearchTypeNameColor(item: string) {
    if (item === '地区') {
      return this.locationData.searchDistrictName ? $r('app.color.primary') : $r('app.color.black')
    } else if (item === '租金') {
      return this.rentPriceData.searchRentPrice.text ? $r('app.color.primary') : $r('app.color.black')
    }
    return item
  }

  chooseSearchType(searchType: string) {
    if (this.currentSearchType === searchType) {
      this.currentSearchType = ''
      return;
    }

    if (searchType === '地区') {
      this.locationData.isSearch = false
      this.locationClose()
      this.getProvinceList()
    }else if (searchType === '租金') {
      this.rentPriceData.isSearch = false
      this.rentPriceClose()
    }
    this.currentSearchType = searchType
  }
  rentPriceClose(){

  }


  // 获取省市区数据方法
  async getProvinceList() {
    const provinceList = await getProvinceListApi()
    this.locationData.provinceList = provinceList as []
    this.locationData.provinceCode = this.locationData.provinceCode || provinceList[0].code;
    this.getCityList()
  }
  async getCityList() {
    const cityList = await getCityListApi(this.locationData.provinceCode)
    this.locationData.cityList = cityList as  [];
    this.locationData.cityCode = this.locationData.cityCode || cityList[0].code;
    this.getDistrictList()
  }
  async getDistrictList() {
    const districtList = await getDistrictListApi(this.locationData.cityCode)
    this.locationData.districtList = districtList as []
    this.locationData.districtCode = this.locationData.districtCode || districtList[0].code;
  }

  handleProvinceChange(provinceCode: string) {
    this.locationData.provinceCode = provinceCode;
    this.locationData.cityCode = ''
    this.locationData.districtCode = ''
    this.getCityList()
  }
  handleCityChange(cityCode: string) {
    this.locationData.cityCode = cityCode
    this.locationData.districtCode = ''
    this.getDistrictList()
  }
  handleDistrictChange(districtCode: string) {
    this.locationData.districtCode = districtCode;
  }


  locationSearch() {
    globalEmitter.emit('searchOptionsChange', {
      provinceCode: this.locationData.provinceCode,
      cityCode: this.locationData.cityCode,
      districtCode: this.locationData.districtCode,
    })
    this.locationData.isSearch = true;
    this.locationClose()
  }
  locationClose() {
    this.currentSearchType = ''
    if (this.locationData.isSearch) {
      this.locationData.searchProvinceCode = this.locationData.provinceCode
      this.locationData.searchCityCode = this.locationData.cityCode
      this.locationData.searchDistrictCode = this.locationData.districtCode

      const data = this.locationData.districtList as IProvinceList;
      if (data && Array.isArray(data)) {
        const district = data.find(item => item.code === this.locationData.districtCode);
        this.locationData.searchDistrictName = district ? district.name : '';
      } else {
        this.locationData.searchDistrictName = '';
      }
    } else {
      this.locationData.provinceCode = this.locationData.searchProvinceCode
      this.locationData.cityCode = this.locationData.searchCityCode
      this.locationData.districtCode = this.locationData.searchDistrictCode
    }
  }

  locationReset() {
    this.locationData.provinceCode = ''
    this.locationData.cityCode = ''
    this.locationData.districtCode = ''
    this.getProvinceList()
  }
  @Builder
  LocationRender() {
    Row() {
      List() {
        ForEach(this.locationData.provinceList, (item: IProvinceItem) => {
          ListItem() {
            Row() {
              Text(item.name)
                .fontSize(rvp(12))
                .fontColor(item.code === this.locationData.provinceCode ? $r('app.color.primary') :
                $r('app.color.black'))
            }
            .width('100%')
            .padding({
              left: rvp(16),
              right: rvp(16),
              top: rvp(6),
              bottom: rvp(6)
            }).onClick( this.handleProvinceChange.bind(this, item.code))
          }
        }, (item: IProvinceItem) => item.code)
      }.width(rvp(120)).height('100%').backgroundColor($r('app.color.bg_gray')).scrollBar(BarState.Off)

      List() {
        ForEach(this.locationData.cityList, (item: ICityItem) => {
          ListItem() {
            Row() {
              Text(item.name)
                .fontSize(rvp(12))
                .fontColor(item.code === this.locationData.cityCode ? $r('app.color.primary') : $r('app.color.black'))
            }
            .width('100%')
            .padding({
              left: rvp(16),
              right: rvp(16),
              top: rvp(6),
              bottom: rvp(6)
            })
          }.onClick(this.handleCityChange.bind(this, item.code))
        }, (item: ICityItem) => item.code)
      }.width(rvp(120)).height('100%').backgroundColor('#EBEBEB').scrollBar(BarState.Off)

      List() {
        ForEach(this.locationData.districtList, (item: IDistrictItem) => {
          ListItem() {
            Row() {
              Text(item.name)
                .fontSize(rvp(12))
                .fontColor(item.code === this.locationData.districtCode ? $r('app.color.primary') :
                $r('app.color.black'))
            }
            .width('100%')
            .padding({
              left: rvp(16),
              right: rvp(16),
              top: rvp(6),
              bottom: rvp(6)
            })
          }.onClick(this.handleDistrictChange.bind(this, item.code))
        }, (item: IDistrictItem) => item.code)
      }.width(rvp(120)).height('100%').backgroundColor('#E6E6E6').scrollBar(BarState.Off)
    }.height(rvp(240)).width('100%').backgroundColor($r('app.color.white'))

    Row({ space: rvp(22) }) {
      Button('重置')
        .buttonStyles(rvp(95), '#F0F0F0', $r('app.color.gray_second')).onClick(this.locationReset.bind(this))
      Button('查看房源')
        .buttonStyles(rvp(211), '#67C0A8', $r('app.color.white'))
    }.height(rvp(58)).width('100%').backgroundColor($r('app.color.white')).justifyContent(FlexAlign.Center).onClick(this.locationSearch.bind(this))

    Row() {
    }.width('100%').layoutWeight(1).backgroundColor('rgba(0, 0, 0, 0.7)').onClick(this.locationClose.bind(this))
  }

  @Builder RentPriceRender() {
    Column() {
      Grid() {
        ForEach(this.rentPriceData.rentPriceList, (rentPrice: IRentPriceItem) => {
          GridItem() {
            Text(rentPrice.text)
              .textStyles(false)
          }
        }, (rentPrice:IRentPriceItem) => rentPrice.id.toString())
      }
      .columnsTemplate('1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr')
      .height(rvp(194 - 58))

      Row({ space: rvp(22) }) {
        Button('重置')
          .buttonStyles(rvp(95), '#F0F0F0', $r('app.color.gray_second'))
        Button('查看房源')
          .buttonStyles(rvp(211), '#67C0A8', $r('app.color.white'))
      }.height(rvp(58)).width('100%').backgroundColor($r('app.color.white')).justifyContent(FlexAlign.Center)
    }
    .height(rvp(202))
    .width('100%')
    .backgroundColor($r('app.color.white'))
    .padding({ left: rvp(PADDING), right: rvp(PADDING) })

    Row() {
    }.width('100%').layoutWeight(1).backgroundColor('rgba(0, 0, 0, 0.7)')
  }
  // 付款方式
  @State paymentTypeData: paymentTypeData = {
    paymentTypeList: ['月付', '季付', '半年付', '年付'],
    isSearch: false,
    paymentType: '',
    searchPaymentType: ''
  }
  handlePaymentTypeChange(paymentType: string) {
    this.paymentTypeData.paymentType = paymentType
  }
  paymentTypeSearch() {
    globalEmitter.emit('searchOptionsChange', {
      paymentType: this.paymentTypeData.searchPaymentType
    })
    this.paymentTypeData.isSearch = true;
    this.paymentTypeClose()
  }

  paymentTypeClose() {
    this.currentSearchType = ''
    if (this.paymentTypeData.isSearch) {
      this.paymentTypeData.searchPaymentType = this.paymentTypeData.paymentType
    } else {
      this.paymentTypeData.paymentType = this.paymentTypeData.searchPaymentType
    }
  }
  paymentTypeReset() {
    this.paymentTypeData.paymentType = ''
  }

  @Builder
  PaymentTypeRender() {
    Column() {
      Grid() {
        ForEach(this.paymentTypeData.paymentTypeList, ( paymentType:string) => {
          GridItem() {
            Text(paymentType)
              .textStyles(this.paymentTypeData.paymentType === paymentType)
              .onClick(this.handlePaymentTypeChange.bind(this, paymentType))
          }
        }, (paymentType:string) => paymentType)
      }
      .columnsTemplate('1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr')
      .height(rvp(100))

      Row({ space: rvp(22) }) {
        Button('重置')
          .buttonStyles(rvp(95), '#F0F0F0', $r('app.color.gray_second'))
          .onClick(this.paymentTypeReset.bind(this))
        Button('查看房源')
          .buttonStyles(rvp(211), '#67C0A8', $r('app.color.white'))
          .onClick(this.paymentTypeSearch.bind(this))
      }.height(rvp(58)).width('100%').backgroundColor($r('app.color.white')).justifyContent(FlexAlign.Center)
    }
    .height(rvp(158))
    .width('100%')
    .backgroundColor($r('app.color.white'))
    .padding({ left: rvp(PADDING), right: rvp(PADDING) })

    Row() {
    }.width('100%').layoutWeight(1).backgroundColor('rgba(0, 0, 0, 0.7)').onClick(this.paymentTypeClose.bind(this))
  }
  // 排序
  @State sortData: ISortListData = {
    sortList: [
      {
        id: 1,
        icon: $r('app.media.sort'),
        text: '综合排序',
        orderBy: '',
        orderType: ''
      },
      {
        id: 2,
        icon: $r('app.media.rent'),
        text: '价格从低到高',
        orderBy: 'price',
        orderType: 'asc'
      },
      {
        id: 3,
        icon: $r('app.media.rent'),
        text: '价格从高到低',
        orderBy: 'price',
        orderType: 'desc'
      },
      {
        id: 4,
        icon: $r('app.media.area'),
        text: '面积从大到小',
        orderBy: 'area',
        orderType: 'desc'
      },
      {
        id: 5,
        icon: $r('app.media.area'),
        text: '面积从小到大',
        orderBy: 'area',
        orderType: 'asc'
      },
    ],
    sort: {
      id: 1,
      icon: $r('app.media.sort'),
      text: '综合排序',
      orderBy: '',
      orderType: ''
    },
  }

  handleSortChange(sort: ISortItem) {
    this.sortData.sort = sort
    this.sortSearch()
  }
  sortSearch() {
    globalEmitter.emit('searchOptionsChange', {
      orderBy: this.sortData.sort.orderBy,
      orderType: this.sortData.sort.orderType,
    })
    this.sortClose()
  }
  sortClose() {
    this.currentSearchType = ''
    this.sortReset()
  }
  sortReset() {
    this.sortData.sort = {} as ISortItem
    console.log(`${this.sortData}`);
  }


  @Builder SortRender() {
    Column() {
      Column() {
        ForEach(this.sortData.sortList, (sort: ISortItem) => {
          Row({ space: rvp(8) }) {
            Image(sort.icon).width(rvp(16))
            Text(sort.text)
              .fontSize(sm())
              .fontColor(this.sortData.sort.id === sort.id ? '#67C0A8' : $r('app.color.gray_second'))
          }.height(rvp(34)).onClick(this.handleSortChange.bind(this, sort))
        }, (sort:ISortItem)=> sort.id.toString())
      }.padding({ left: rvp(20), top: rvp(8), bottom: rvp(16) }).alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .backgroundColor($r('app.color.white'))
    .padding({ left: rvp(PADDING), right: rvp(PADDING) })
    .alignItems(HorizontalAlign.Start)
    Row() {
    }.width('100%').layoutWeight(1).backgroundColor('rgba(0, 0, 0, 0.7)').onClick(this.sortClose.bind(this))
  }

  build() {
    Column() {
      Row() {
        ForEach(this.searchTypeList, (item: string) => {
          Row({ space: rvp(6) }) {
            Text(this.getSearchTypeName(item))
              .fontSize(sm())
              .fontColor(this.getSearchTypeNameColor(item))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .constraintSize({
                maxWidth: rvp(60),
              })
            Image($r('app.media.arrow_down_3')).imageStyles()
          }.width('25%').height('100%').justifyContent(FlexAlign.Center).onClick(() => {
            this.chooseSearchType(item)
          })
        }, (item: string) => item)
      }.width('100%').height(rvp(44)).justifyContent(FlexAlign.SpaceBetween)

      if (this.currentSearchType === '地区') {
        this.LocationRender()
      }
      if (this.currentSearchType === '租金') {
        this.RentPriceRender()
      }
      if (this.currentSearchType === '付款方式') {
        this.PaymentTypeRender()
      }
      if (this.currentSearchType === '排序') {
        this.SortRender()
      }
    }
  }
}

@Extend(Image)
function imageStyles() {
  .width(rvp(6)).height(rvp(3)).objectFit(ImageFit.Fill)
}

@Extend(Button)
function buttonStyles(width: number, bgColor: string | Resource, fontColor: string | Resource) {
  .type(ButtonType.Normal)
  .width(width)
  .height(rvp(26))
  .borderRadius(rvp(BORDER_RADIUS_S))
  .fontSize(rvp(12))
  .backgroundColor(bgColor)
  .fontColor(fontColor)
}

@Extend(Text)
function textStyles(active: boolean) {
  .fontSize(rvp(12))
  .fontColor(active ? $r('app.color.white') : $r('app.color.gray_second'))
  .width(rvp(94))
  .height(rvp(26))
  .backgroundColor(active ? '#67C0A8' : $r('app.color.bg_gray'))
  .borderRadius(rvp(BORDER_RADIUS_S))
  .textAlign(TextAlign.Center)
}