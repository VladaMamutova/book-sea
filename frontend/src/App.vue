<template>
  <div id="app">
      <header class="bg-grey-lighter">
        <div class="container mx-auto px-6 py-4 sm:px-6 md:space-x-10 border-b-2 border-gray-200 flex flex-wrap items-center justify-end">
          <a href="/" class="flex-1 flex items-center">
            <img class="h-16 w-auto sm:h-16" src="@/assets/book_lover.svg" alt="">
            <p class="uppercase text-lg pl-4 font-black no-underline text-indigo-600">Book Sea</p>
          </a>
          
          <nav class="md:flex space-x-10">
            <router-link to="/books" class="text-lg font-medium text-gray-700 hover:text-gray-900">Книги</router-link>
            <router-link to="/library" class="text-lg font-medium text-gray-700 hover:text-gray-900">Библиотеки</router-link>
            <router-link to="/reports" v-if="isAdmin" class="text-lg font-medium text-gray-700 hover:text-gray-900">Статистика</router-link>
          </nav>

          <div v-if="!signedIn && !isSignedIn()" class="md:flex items-center justify-end md:flex-1 lg:w-0">
            <router-link to="/sign_in" class="whitespace-nowrap text-lg font-medium text-gray-500 hover:text-gray-900">Вход</router-link>
            <router-link to="/sign_up" class="ml-8 whitespace-nowrap inline-flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-lg font-medium text-white bg-indigo-600 hover:bg-indigo-700">Регистрация</router-link>
          </div>
          <div v-else class="md:flex items-center justify-end md:flex-1 lg:w-0">
            <router-link to="/profile" v-if="!isAdmin" class="flex whitespace-nowrap text-lg font-medium text-gray-500 hover:text-gray-900 cursor-pointer">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
              </svg>
              {{ userLogin() }}
            </router-link>
            <div v-else class="flex whitespace-nowrap text-lg font-medium text-gray-500 hover:text-gray-900 cursor-pointer">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
              </svg>
              {{ userLogin() }}
            </div>

            <a href="#" @click.prevent="signOut" title="Выйти" class="h-6 w-6 ml-6 text-gray-500 hover:text-gray-900 cursor-pointer">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
              </svg>
            </a>

          </div>
        </div>
      </header>
    <router-view/>
  </div>
</template>

<script>
export default {
  name: 'App',
  data () {
    return {
      signedIn: false,
      isAdmin: false
    }
  },
  created() {
    this.signedIn = localStorage.signedIn
    this.isAdmin = localStorage.role === "admin"
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    isSignedIn: function () {
      this.signedIn = localStorage.signedIn
      this.isAdmin = localStorage.role === "admin"
      return this.signedIn
    },
    userLogin: function () {
      return localStorage.userLogin
    },
    signOut () {
      delete localStorage.token
      delete localStorage.signedIn
      delete localStorage.userLogin
      delete localStorage.role
      this.isSignedIn()
      this.$router.replace('/')
    }
  }
}
</script>
