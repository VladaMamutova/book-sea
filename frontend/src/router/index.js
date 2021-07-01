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
  },
  {
    path: '/books/:book_uid',
    name: 'BookInfo',
    component: () => import("../views/BookInfo.vue")
  },
  {
    path: '/author/:author_uid',
    name: 'AuthorInfo',
    component: () => import("../views/AuthorInfo.vue")
  },
  {
    path: '/author/:author_uid/books',
    name: 'AuthorBooks',
    component: () => import("../views/AuthorBooks.vue")
  },
  {
    path: '/library/:library_uid/books',
    name: 'LibraryBooks',
    component: () => import("../views/LibraryBooks.vue"),
    props: (route) => ({ library: route.params.library })
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
