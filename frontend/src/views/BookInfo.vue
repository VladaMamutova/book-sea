<template>
  <div class="container mx-auto px-16 py-6">
    <div class="text-red-500 text-base text-xl text-center py-20" v-if="error">{{ error }}</div>

    <div v-if="!error" class="group block rounded-lg px-24 py-12 border border-gray-200">
      <div class="flex space-x-4">

        <div class="flex flex-initial items-center">
          <img img src="@/assets/book.svg" alt="Обложка книги" class="flex-none object-cover" width="140" height="140" />
        </div>
    
        <div class="flex-auto px-12 py-6 space-y-3">
          <h2 v-if="book.name" class="text-3xl font-semibold text-black">
            {{ book.name }}
          </h2>     

          <div v-if="book.author" class="flex-wrap text-xl text-gray-700 font-normal">
            Автор: {{ book.author.last_name }} {{ book.author.first_name }} {{ book.author.middle_name }}
          </div>

          <div v-if="book.genre" class="flex-wrap text-xl text-gray-700 font-normal">
            Жанр: {{ book.genre }}
          </div>
        </div>
        
        <div class="rounded-full bg-amber-50 text-amber-900 items-center flex pr-4">
          <a href="#" class="whitespace-nowrap inline-flex items-center justify-center px-4 py-2 rounded-md shadow-sm text-xl font-medium text-indigo-600 border border-indigo-400 hover:border-indigo-500 hover:text-indigo-700">
            Найти в библиотеках
          </a>
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
       book: {
        type: Object
      },
      error: ''
    }
  },
  created () {
    this.$http.plain.get('/books/'+ this.$route.params.book_uid)
      .then(response => { this.book = response.data; })
      .catch(error => this.setError(error, 'Что-то пошло не так... Попробуйте позже'))
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.message) || text
    },
  }
}
</script>
