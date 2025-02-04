import { getServiceDataApi } from '../../api/service';
import { IColor } from '../../model/HomeData';

import Bg from '../../views/Service/Bg';
import ScrollContainer from '../../components/ScrollContainer';
import NavBar from '../../views/Service/NavBar';
import ServiceTabs from '../../views/Service/ServiceTabs';
import { PADDING } from '../../constants/size';
import VIP from '../../views/Service/VIP';
import { IVipServiceList,IHomeServiceList,IServiceActivity,ICleaningServiceInfoList } from '../../model/ServiceData';
import {rvp,getWindowTopHeight} from '../../utils/responsive'
import DomesticService from '../../views/Service/DomesticService';
import ServiceCalendar from '../../views/Service/ServiceCalendar';

@Component
export default struct Service {
  @State vipServiceList: IVipServiceList = [];
  @State homeServiceList: IHomeServiceList = [];
  @State serviceActivity: IServiceActivity =  {
    "name": '',
    "img": '',
    "title": '',
    "subTitle": '',
  };
  @State serviceTabImage: string = ''
  @State cleaningServiceInfo: ICleaningServiceInfoList = []

  @Prop @Watch('handleIsActiveTabChange') isActiveTab: boolean

  aboutToAppear(): void {
    this.getServiceData()
  }

  async getServiceData() {
    const serviceData = await getServiceDataApi();
    this.vipServiceList = serviceData.vipServiceList;
    this.homeServiceList = serviceData.homeServiceList;
    this.serviceActivity = serviceData.serviceActivity;
    this.serviceTabImage = serviceData.newcomerZone.img;
    this.cleaningServiceInfo = serviceData.cleaningServiceInfo;
  }

  @Builder
  navBuilder($$: IColor) {
    NavBar($$)
  }

  @Builder
  contentBuilder() {
    Stack() {
      Bg()
      Column() {
        VIP({ vipServiceList: this.vipServiceList })
        DomesticService({ homeServiceList: this.homeServiceList })
        ServiceCalendar({ serviceActivity: this.serviceActivity })
        ServiceTabs({ serviceTabImage: this.serviceTabImage, cleaningServiceInfo: this.cleaningServiceInfo })
      }.padding({ left: rvp(PADDING), right: rvp(PADDING), top: getWindowTopHeight() })
    }.alignContent(Alignment.TopStart)
  }

  build() {
    ScrollContainer({
      navBuilder: this.navBuilder,
      contentBuilder: () => {
        this.contentBuilder()
      }
    })
  }

  handleIsActiveTabChange(changedPropertyName: string) {
  }
}