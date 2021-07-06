<template>
  <div class="container mx-auto item-center px-16 py-6">
    <div class="flex justify-center space-x-4">
      <div class="flex justify-center">
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
      </div>
     </div>
    
    <List v-if="!error" class="mt-12">
      <BookLibraryItem v-for="book_library in book_libraries" :key="book_library.library.library_uid"
        :library="book_library.library" :available_count="book_library.available_count" :book_uid="book_uid"/>
    </List>

  </div>
</template>

<script>

import List from '@/components/List.vue'
import BookLibraryItem from '@/components/library/BookLibraryItem.vue'

export default {
  name: 'BookLibraries',
  props: {
    book: {
      type: Object,
      required: true
    }
  },
  components: {
    List,
    BookLibraryItem
  },
  data () {
    return {
      book_uid: '',
      book_libraries: [],
      error: '',
    }
  },
  created () {
    this.book_uid = this.$route.params.book_uid
    this.$http.secured.get('/library/book/'+ this.book_uid)
      .then(response => { this.book_libraries = response.data; })
      .catch(error => this.setError(error, 'Не удалось загрузить список библиотек... Попробуйте позже'))
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.message) || text
    },
  }
}
</script>
