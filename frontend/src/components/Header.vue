<template>
  <header class="bg-grey-lighter">
    <div class="container mx-auto px-6 py-4 sm:px-6 md:space-x-10 border-b-2 border-gray-100 flex flex-wrap items-center justify-end">
      <a href="/" class="flex-1 flex items-center">
        <img class="h-16 w-auto sm:h-16" src="@/assets/book_lover.svg" alt="">

        <p class="uppercase text-base font-mono pl-4 font-bold no-underline text-indigo-600">Book Sea</p>
      </a>
      
      <nav class="md:flex space-x-10">
        <router-link to="/books" class="text-base font-medium text-gray-700 hover:text-gray-900">Книги</router-link>
        <router-link to="/books" class="text-base font-medium text-gray-700 hover:text-gray-900">Библиотеки</router-link>
      </nav>

      <div class="md:flex items-center justify-end md:flex-1 lg:w-0">
        <a href="#" class="whitespace-nowrap text-base font-medium text-gray-500 hover:text-gray-900">
          Вход
        </a>
        <a href="#" class="ml-8 whitespace-nowrap inline-flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-base font-medium text-white bg-indigo-600 hover:bg-indigo-700">
          Регистрация
        </a>
      </div>
    </div>
  </header>
</template>

<script>
export default {
  name: 'Header',
  created () {
    //this.signedIn()
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    // signedIn () {
    //   return localStorage.signedIn
    // },
    // signOut () {
    //   this.$http.secured.delete('/signin')
    //     .then(response => {
    //       delete localStorage.csrf
    //       delete localStorage.signedIn
    //       this.$router.replace('/')
    //     })
    //     .catch(error => this.setError(error, 'Cannot sign out'))
    // }
  }
}
</script>
