<template>
  <div class="container mx-auto px-6 py-6">
    <div class="grid grid-cols-3 gap-12">

      <div>
        <div class="grid gap-4 min-w-min w-96">
          <p class="text-gray-400 text-base font-medium text-center">Поиск книги</p>
          <input name="name" v-model="search_params.name" class="focus:border-indigo-300 focus:ring-1 focus:ring-indigo-300 focus:outline-none w-full text-base text-black placeholder-gray-400 border border-gray-300 rounded-md py-2 pl-6" type="text" aria-label="Название" placeholder="Название" />
          <input name="author" v-model="search_params.author" class="focus:border-indigo-300 focus:ring-1 focus:ring-indigo-300 focus:outline-none w-full text-base text-black placeholder-gray-400 border border-gray-300 rounded-md py-2 pl-6" type="text" aria-label="Автор" placeholder="Автор" />
          <a class="whitespace-nowrap inline-flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-base font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none"
            @click.prevent="findBooks()">
            Найти
          </a>
        </div>
      </div>

      <div class="col-span-2">
        <div class="text-red-500 text-base text-xl text-center py-20" v-if="error">{{ error }}</div>
        <div class="text-gray-400 text-base text-xl text-center py-20" v-if="!error && books.length == 0">По данному запросу ничего не найдено</div>
        
        <List>
          <BookItem v-for="book in books" :key="book.book_uid" :book="book" />
        </List>
      </div>

    </div>
  </div>
</template>

<script>

import List from '@/components/List.vue'
import BookItem from '@/components/books/BookItem.vue'

export default {
  name: 'Books',
  components: {
    List,
    BookItem
  },
  data () {
    return {
      books: [],
      error: '',
      search_params: {
        name: '',
        author: ''
      }
    }
  },
  created () {
    // if (!localStorage.signedIn) {
    //   this.$router.replace('/')
    // } else {
    this.search_params.name = this.$route.query.name
    this.search_params.author = this.$route.query.author

    this.$http.plain.get('/books', {params: this.$route.query })
      .then(response => { this.books = response.data })
      .catch(error => this.setError(error, 'Что-то пошло не так... Попробуйте позже'))
    // }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.message) || text
    },
    findBooks() {
      this.$router.replace({ name: 'Books', query: this.search_params })

      this.$http.plain.get('/books', {params: this.search_params })
      .then(response => { this.books = response.data })
      .catch(error => this.setError(error, 'Что-то пошло не так... Попробуйте позже'))
    }
  }
}
</script>
