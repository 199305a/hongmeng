export interface IBookRentRoomItem {
  "id": number|string
  "userId": number
  "houseId": string
  "date": string
  "name": string
  "img": string
  "title": string
  "subTitle": string
  "distanceInfo": string
  "rentPrice": string
  "comment": string
}

export type IBookRentRoomList = IBookRentRoomItem[]

export interface IBookInfo {
  "name": string
  "date": string
  "houseId": string
  "phone": string
  "comment": string
  "id": number,
  "userId": number,
}