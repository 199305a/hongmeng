import axios, { AxiosError, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'
import showToast from '../showToast';

const request = axios.create({
  baseURL: 'http://14.103.140.254:6060',
  // baseURL: 'http://budai.store:6060',
  timeout: 20000
})

request.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  const token = AppStorage.get('token') as string;
  if (token) {
    config.headers.token = token;
  }
  return config;
})


request.interceptors.response.use((response: AxiosResponse) => {
  if (response.data.code === 200) {
    return response.data.data;
  } else {
    showToast(response.data.message)
    return Promise.reject(response.data.message);
  }
}, (error: AxiosError) => {
  console.log(error.config?.data)
  showToast(`${error.response?.data!}` ?? "")
  return Promise.reject(error.message)
})

export  default  class Http {
  get<T>(url:string,params?:object){
    return request.get<null,T>(url, {
      params
    })
  }

  post<T>(url:string,params?:object){
    return request.post<null,T>(url,params)
  }
  put<T>(url:string,params?:object){
    return request.put<null,T>(url,params)
  }
  delete<T>(url:string,params?:object){
    return request.delete<null,T>(url,params)
  }
}