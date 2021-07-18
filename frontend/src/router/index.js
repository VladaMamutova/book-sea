import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'Home',
    component: () => import("../views/Home.vue")    
  },
  {
    path: '/sign_in',
    name: 'SignIn',
    component: () => import("../views/SignIn.vue")    
  },
  {
    path: '/profile',
    name: 'MyProfile',
    component: () => import("../views/MyProfile.vue"),
  },
  {
    path: '/books',
    name: 'Books',
    component: () => import("../views/books/Books.vue"),
    props: (route) => ({ name: route.query.name, author: route.query.name })
  },
  {
    path: '/books/new',
    name: 'NewBook',
    component: () => import("../views/admin/books/NewBook.vue")
  },
  {
    path: '/books/:book_uid/edit',
    name: 'EditBook',
    component: () => import("../views/admin/books/EditBook.vue")
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
    props: (route) => ({ library_prop: route.params.library_prop })
  },
  {
    path: '/library/book/:book_uid',
    name: 'BookLibraries',
    component: () => import("../views/library/BookLibraries.vue"),
    props: (route) => ({ book: route.params.book })
  },
  {
    path: '/users',
    name: 'Users',
    component: () => import("../views/admin/users/Users.vue")    
  },
  {
    path: '/reports',
    name: 'Reports',
    component: () => import("../views/admin/reports/Reports.vue")
  },
  {
    path: '/*',
    name: 'NotFound',
    component: () => import("../views/NotFound.vue"),
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
