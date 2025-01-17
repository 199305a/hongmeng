import NavBar from '../../components/NavBar';
import { getWindowTopHeight, rvp } from '../../utils/responsive';
import SearchFilter from '../../views/RentRoomList/SearchFilter';
import WaterfallFlow from '../../views/RentRoomList/WaterfallFlow'

@Entry
@Component
struct RentRoomList {
  @State message: string = 'Hello World';
  build() {
    Stack() {

      Column() {
        WaterfallFlow()
      }.padding({ top: getWindowTopHeight() + rvp(44 + 44) })
      Column() {
        NavBar({ title: '租房列表' })
        SearchFilter()
      }.padding({ top: getWindowTopHeight() })

    }.height('100%').alignContent(Alignment.TopStart)
  }
}