import Avatar from '../../components/Avatar'

import { rvp } from '../../utils/responsive'
import { router } from '@kit.ArkUI'
import { lg, sm } from '../../utils/responsive/responsiveFontSize'
import { IUserInfo } from '../../model/UserData'

@Component
export default struct UserInfo {
  @State avatarSrc: string = ''
  @Link userInfo: IUserInfo
  goLoginPhone() {
    router.pushUrl({ url: 'pages/Login/LoginPhone' })
  }
  build() {
    Row({ space: rvp(10) }) {
      Avatar({ src: this.userInfo.avatar || this.avatarSrc, avatarSize: rvp(60) }).onClick(this.goLoginPhone.bind(this))
      Column({ space: rvp(4) }) {
        Text(this.userInfo.nickname || '登录/注册').fontSize(lg()).fontColor($r('app.color.white')).fontWeight(700)
        if (!this.userInfo.nickname) {
          Text('点击登录注册').fontSize(sm()).fontColor($r('app.color.white'))
        }
      }.alignItems(HorizontalAlign.Start).onClick(this.goLoginPhone.bind(this))
    }.margin({ top: rvp(11) }).width('100%')
  }
}