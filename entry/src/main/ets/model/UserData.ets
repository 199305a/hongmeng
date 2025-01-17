export interface  PhoneParams {
  "phone":string
}

export interface  LoginParams {
  "phone":string,
  "code":string,
}

export interface  TokenResponse {
  "token":string
}

export interface IUserInfo {
  "id": number
  "nickname": string
  "avatar": string
}