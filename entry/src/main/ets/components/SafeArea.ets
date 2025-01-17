import { rvp } from "../utils/responsive";

@Component
export default struct SafeArea {
  build() {
    Column() {

    }.margin({top:SafeAreaEdge.TOP +rvp(34)})
  }
}