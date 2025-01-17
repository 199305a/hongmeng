import { rvp } from '../utils/responsive';
import { sm } from '../utils/responsive/responsiveFontSize';

@Component
export default struct Empty {
  @Prop title: string;

  build() {
    Column({ space: rvp(19) }) {
      Image($r('app.media.blank')).width(rvp(150)).height(rvp(140)).objectFit(ImageFit.Fill)
      Text(this.title).fontSize(sm())
    }.width('100%')
  }
}