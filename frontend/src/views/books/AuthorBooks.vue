<template>
  <div class="container mx-auto item-center px-16 py-6">
    <h1 class="text-3xl font-bold text-black text-center">
      {{ author.first_name }} {{ author.middle_name }} {{ author.last_name }}
    </h1>

    <div class="flex-wrap text-xl mt-6 text-gray-700 font-normal text-center">
      {{ author.info }}
    </div>
    
    <List v-if="author.books" class="mt-12">
      <BookItem v-for="book in author.books" :key="book.book_uid" :book="book" />
    </List>

  </div>
</template>

<script>

import List from '@/components/List.vue'
import BookItem from '@/components/books/BookItem.vue'

export default {
  name: 'AuthorBooks',
  components: {
    List,
    BookItem
  },
  data () {
    return {
      author_uid: '',
      author: {},
      error: '',
    }
  },
  created () {
    this.author_uid = this.$route.params.author_uid
    this.$http.plain.get('/author/'+ this.author_uid + '/books')
      .then(response => { this.author = response.data; })
      .catch(error => this.setError(error, 'Что-то пошло не так... Попробуйте позже'))
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.message) || text
    },
  }
}
</script>
