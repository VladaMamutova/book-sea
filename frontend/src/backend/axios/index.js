import axios from 'axios'

const SESSION_URL = 'http://localhost:8680'
const GATEWAY_URL = 'http://localhost:8580'

const sessionAxiosInstance = axios.create({
  baseURL: SESSION_URL,
  withCredentials: false,
  headers: {
    'Content-Type': 'application/json'
  }
})

const plainAxiosInstance = axios.create({
  baseURL: GATEWAY_URL,
  withCredentials: false, // if true: 'Access-Control-Allow-Credentials' header which must be 'true'
  headers: {
    'Content-Type': 'application/json'
  }
})

const securedAxiosInstance = axios.create({
  baseURL: GATEWAY_URL,
  withCredentials: false,
  headers: {
    'Content-Type': 'application/json'
  }
})

securedAxiosInstance.interceptors.request.use(config => {
  const method = config.method.toUpperCase()
  if (method !== 'OPTIONS') {
    config.headers = {
      ...config.headers,
      Authorization: `Bearer ${localStorage.token}`
    }
  }
  return config
})

securedAxiosInstance.interceptors.response.use(null, error => {
  if (error.response && error.response.config &&
     (error.response.status === 401 || error.response.status === 403)) {
       
    // TODO: запрос на обновление токена.
    // return plainAxiosInstance.post('/refresh', {}, { headers: { 'Bearer': localStorage.token } })
    //   .then(response => {
    //     localStorage.token = response.data.token
    //     localStorage.signedIn = true
    //     // After another successfull refresh - repeat original request
    //     let retryConfig = error.response.config
    //     retryConfig.headers['Bearer'] = localStorage.token
    //     return plainAxiosInstance.request(retryConfig)
    //   }).catch(error => {
        delete localStorage.token
        delete localStorage.signedIn
        delete localStorage.userLogin
        delete localStorage.role
        location.replace('/sign_in')
        return Promise.reject(error)
      // })
  } else {
    return Promise.reject(error)
  }
})

export { sessionAxiosInstance, plainAxiosInstance, securedAxiosInstance }
