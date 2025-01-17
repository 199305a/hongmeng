import type { IBookInfo, IBookRentRoomList } from '../model/BookRentRoomList'
import { http } from '../utils/http'

// 预约看房
export const bookRentRoomApi = (bookInfo: IBookInfo):Promise<IBookInfo> => {

  return http.post<IBookInfo>('/auth/house/reservation', bookInfo)
}

// 获取预约租房列表
export const getBookRentRoomListApi = ():Promise<IBookRentRoomList> => {
  return http.get<IBookRentRoomList>('/auth/house/history')
}