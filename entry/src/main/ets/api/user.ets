import { IUserInfo, LoginParams, PhoneParams, TokenResponse } from '../model/UserData';
import { http } from '../utils/http';

// 发送验证码
export const sendSMSCodeApi = (phone: string): Promise<string> => {
  const params: PhoneParams = { phone }
  return http.post<string>('/sendSMSCode',params)
}

// 登录
export const loginApi = (phone: string, code: string) : Promise<TokenResponse>=> {

  const params: LoginParams = { phone,code }
  return http.post<TokenResponse>('/login',params)
}

// 获取用户数据
export const getUserInfoApi = () : Promise<IUserInfo> => {
  return http.get<IUserInfo>('/auth/user/userInfo')
}