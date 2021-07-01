import Vue from 'vue'
import App from './App.vue'
import router from './router'
import VueAxios from 'vue-axios'
import { sessionAxiosInstance, plainAxiosInstance, securedAxiosInstance } from './backend/axios'

import "./assets/styles/index.css"

Vue.config.productionTip = false

Vue.use(VueAxios, {
  session: sessionAxiosInstance,
  plain: plainAxiosInstance,
  secured: securedAxiosInstance
})

new Vue({
  router,
  sessionAxiosInstance,
  plainAxiosInstance,
  securedAxiosInstance,
  render: h => h(App)
}).$mount('#app')
