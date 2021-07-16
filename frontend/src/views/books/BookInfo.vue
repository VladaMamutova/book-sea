<template>
  <div class="container mx-auto px-16 py-6">
    <div class="text-red-500 text-base text-xl text-center py-20" v-if="error">{{ error }}</div>

    <div v-if="!error" class="group block rounded-lg px-24 py-12 border border-gray-200">
      <div class="flex space-x-4">

        <div class="flex flex-initial items-center">
          <img img src="@/assets/book.svg" alt="Обложка книги" class="flex-none object-cover" width="140" height="140" />
        </div>
    
        <div class="flex-auto px-12 py-6 space-y-3">
          <h1 v-if="book.name" class="text-3xl font-bold text-black">
            {{ book.name }}
          </h1>     

          <div v-if="book.author" class="flex-wrap flex-inline text-xl text-gray-500 font-normal">
            Автор:
            <router-link class="text-gray-700 hover:text-gray-900"
              :to="{ name: 'AuthorInfo', params: { author_uid: book.author.author_uid }}">
              {{ book.author.last_name }} {{ book.author.first_name }} {{ book.author.middle_name }}
            </router-link>
          </div>

          <div v-if="book.genre" class="flex-wrap text-xl text-gray-500 font-normal">
            Жанр: <span class="text-gray-700"> {{ book.genre }} </span>
          </div>
        </div>
        
        <div class="rounded-full items-center flex pr-4" :title="can_find ? '' : 'Войдите, чтобы найти книгу в библиотеке'">
          <router-link class="whitespace-nowrap inline-flex items-center justify-center px-4 py-2 rounded-md shadow-sm text-xl font-medium text-indigo-600 border border-indigo-400 hover:border-indigo-500 hover:text-indigo-700"
            :to="{ name: 'BookLibraries', params: { book_uid: book_uid, book: book }}"
            :disabled="!can_find"
            :event="can_find ? 'click' : ''">
            Найти в библиотеках
          </router-link>
        </div>
        
      </div>
    </div>
  </div>
</template>

<script>

export default {
  name: 'BookInfo',
  data () {
    return {
      book_uid: {
        type: String,
        required: true
      },
      book: {
        type: Object
      },
      error: '',
      can_find: false
    }
  },
  created () {
    this.book_uid = this.$route.params.book_uid
    this.$http.plain.get('/books/'+ this.book_uid)
      .then(response => { this.book = response.data; })
      .catch(error => this.setError(error, 'Что-то пошло не так... Попробуйте позже'))
    this.can_find = localStorage.signedIn
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.message) || text
    },
  }
}
</script>
