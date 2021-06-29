import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

const routes = [
  {
    path: '/books',
    name: 'Books',
    component: () => import("../views/Books.vue"),
    props: (route) => ({ name: route.query.name, author: route.query.name })
  },
  {
    path: '/libraries',
    name: 'Libraries',
    component: () => import("../views/Libraries.vue")
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
