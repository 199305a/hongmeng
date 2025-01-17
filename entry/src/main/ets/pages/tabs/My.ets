import Bg from '../../views/My/Bg'
import ScrollContainer from '../../components/ScrollContainer'
import NavBar from '../../views/My/NavBar'
import { IColor } from '../../model/HomeData'
import UserInfo from '../../views/My/UserInfo'
import { PADDING } from '../../constants/size'
import { getWindowTopHeight, rvp } from '../../utils/responsive'
import TimePlan from '../../views/My/TimePlan'
import Order from '../../views/My/Order'
import PlanList from '../../views/My/PlanList'
import { IUserInfo } from '../../model/UserData'
import { getUserInfoApi } from '../../api/user'
import SafeArea from '../../components/SafeArea'

@Component
export default struct My {
  @Prop @Watch('handleIsActiveTabChange') isActiveTab: boolean
  @State userInfo: IUserInfo = {
    id: 0,
    avatar: '',
    nickname: ''
  }

  aboutToAppear() {
    if (this.isActiveTab) {
      this.getUserInfo()
    }
  }

  async handleIsActiveTabChange() {
    if (this.isActiveTab) {
      const token = AppStorage.get('token') as string;
      if (token) {
        this.getUserInfo()
      }
    }
  }

  async getUserInfo() {
    this.userInfo = await getUserInfoApi()
  }



  @Builder
  navBuilder($$:IColor) {
    NavBar($$)
  }

  @Builder
  contentBuilder() {
    Stack() {
      Bg()
      Column() {
        SafeArea()
        UserInfo({ userInfo: $userInfo })
        TimePlan()
        Order()
        PlanList()
      }.padding({ left: rvp(PADDING), right: rvp(PADDING), top: rvp(44) + getWindowTopHeight() })
    }.width('100%').align(Alignment.TopStart)
  }

  build() {
    ScrollContainer({
      contentBuilder: () => {
        this.contentBuilder()
      },
      navBuilder: this.navBuilder,
    })
  }


}