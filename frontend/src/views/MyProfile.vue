<template>
  <div class="container mx-auto item-center px-16 py-6">
    <div class="flex justify-center space-x-4">
      <div class="flex justify-center text-center">
    
        <div class="flex-auto px-12 py-6 space-y-3">
          <h1 class="text-2xl uppercase font-bold text-black text-center">
            Мой профиль
          </h1>     

          <div class="pt-6 flex-wrap flex-inline text-xl text-gray-500 font-normal">
            Логин: <span class="text-gray-700"> {{ userLogin() }} </span>
          </div>

          <div v-if="rating" class="flex-wrap text-xl text-gray-500 font-normal">
            Рейтинг: <span class="text-yellow-600 font-medium uppercase"> {{ rating.status }} </span>
          
          <span v-if="rating" class="flex-wrap text-xl text-gray-500 font-normal">
            (<span > {{ rating.score }} </span> баллов)
          </span>
          </div>
          <div v-if="rating" class="flex-wrap text-xl text-gray-500 font-normal">
            Лимит: <span class="text-yellow-600 font-medium uppercase"> {{ rating.limit }} </span> <span class="text-gray-700"> книг </span>
          </div>
        </div>
      </div>
     </div>
    
    <h3 class="text-xl uppercase mt-10 font-bold text-black text-center">
      Мои книги
    </h3>

    <div v-if="taken_books.length === 0" class="text-gray-400 text-base text-xl text-center py-10">Нет взятых книг</div>

    <List class="mt-10">
      <TakenBookItem v-for="taken_book in taken_books" :key="taken_book.taken_book_uid" :taken_book_prop="taken_book"/>
    </List>

  </div>
</template>

<script>

import List from '@/components/List.vue'
import TakenBookItem from '@/components/library/TakenBookItem.vue'

export default {
  components: {
    List,
    TakenBookItem
  },
  data () {
    return {
      rating: {},
      taken_books: [],
    }
  },
  created () {
    console.log(!localStorage.signedIn)
    console.log(localStorage.role != "user")
    if (!localStorage.signedIn && localStorage.role != "user") {
      this.$router.replace('/')
    } else {
      this.$http.secured.get('/rating/user')
        .then(response => { this.rating = response.data })
        .catch()

      this.$http.secured.get('/library/user/books')
        .then(response => { this.taken_books = response.data })
        .catch()
    }
  },
  methods: {
    userLogin: function () {
      return localStorage.userLogin
    },
  }
}
</script>
