import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

const routes = [
  {
    path: '/books',
    name: 'Books',
    component: () => import("../views/books/Books.vue"),
    props: (route) => ({ name: route.query.name, author: route.query.name })
  },
  {
    path: '/library',
    name: 'Libraries',
    component: () => import("../views/library/Libraries.vue")
  },
  {
    path: '/books/:book_uid',
    name: 'BookInfo',
    component: () => import("../views/books/BookInfo.vue")
  },
  {
    path: '/author/:author_uid',
    name: 'AuthorInfo',
    component: () => import("../views/books/AuthorInfo.vue")
  },
  {
    path: '/author/:author_uid/books',
    name: 'AuthorBooks',
    component: () => import("../views/books/AuthorBooks.vue")
  },
  {
    path: '/library/:library_uid/books',
    name: 'LibraryBooks',
    component: () => import("../views/library/LibraryBooks.vue"),
    props: (route) => ({ library: route.params.library })
  },
  {
    path: '/library/book/:book_uid',
    name: 'BookLibraries',
    component: () => import("../views/library/BookLibraries.vue"),
    props: (route) => ({ book: route.params.book })
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
