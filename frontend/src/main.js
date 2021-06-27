import Vue from 'vue'
import App from './App.vue'
import router from './router'
import VueAxios from 'vue-axios'
import { plainAxiosInstance } from './backend/axios' // securedAxiosInstance

import "./assets/styles/index.css"

Vue.config.productionTip = false

Vue.use(VueAxios, {
  // secured: securedAxiosInstance,
  plain: plainAxiosInstance
})

new Vue({
  router,
  plainAxiosInstance,
  render: h => h(App)
}).$mount('#app')
