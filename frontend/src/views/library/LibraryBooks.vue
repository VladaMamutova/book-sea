<template>
  <div class="container mx-auto item-center px-16 py-6">
    <h1 class="text-3xl font-bold text-black text-center">
      {{ library.name }}
    </h1>

    <div class="flex-wrap text-lg mt-2 text-gray-700 font-normal text-center">
      г. {{ library.city }}, {{ library.address }}
    </div>

    <List class="mt-6">
      <LibraryBookItem v-for="library_book in library_books" :key="library_book.book_uid" :library_book="library_book" />
    </List>

  </div>
</template>

<script>

import List from '@/components/List.vue'
import LibraryBookItem from '@/components/libraries/LibraryBookItem.vue'

export default {
  name: 'LibraryBooks',
  props: {
    library: {
      type: Object,
      required: true
    }
  },
  components: {
    List,
    LibraryBookItem
  },
  data () {
    return {
      library_books: [],
      error: '',
    }
  },
  created () {
    this.$http.plain.get('/library/' + this.library.library_uid + '/books')
      .then(response => { this.library_books = response.data })
      .catch(error => this.setError(error, 'Что-то пошло не так... Попробуйте позже'))
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.message) || text
    },
  }
}
</script>
