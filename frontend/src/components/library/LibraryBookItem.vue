<template>
  <div>
    <div class="text-red-500 text-base text-lg text-center mt-6 pb-4" v-if="error">{{ error }}</div>

    <div class="hover:shadow-lg group block rounded-lg px-8 py-6 border border-gray-200">
      <div class="flex space-x-4">

        <div class="flex flex-initial items-center">
          <img img src="@/assets/book.svg" alt="Обложка книги" class="flex-none object-cover" width="100" height="100" />
        </div>
    
        <div class="flex-auto px-6 py-4 space-y-2">
          <h2 v-if="library_book.name">
            <router-link v-if="isAdmin" class="text-xl font-bold text-black hover:underline hover:text-indigo-700"
              :to="{ name: 'EditBook', params: { book_uid: library_book.book_uid }}">
              {{ library_book.name }}
            </router-link>

             <router-link v-else class="text-xl font-bold text-black hover:underline hover:text-indigo-700"
              :to="{ name: 'BookInfo', params: { book_uid: library_book.book_uid }}">
              {{ library_book.name }}
            </router-link>
          </h2>

          <div v-if="library_book.author" class="flex-wrap text-base text-gray-500 font-normal">
            Автор: 
            <router-link class="text-gray-700 hover:text-gray-900"
              :to="{ name: 'AuthorInfo', params: { author_uid: library_book.author.author_uid }}">
              {{ library_book.author.last_name }} {{ library_book.author.first_name }} {{ library_book.author.middle_name }}
            </router-link>
          </div>
        </div>

        <div v-if="isAdmin" class="flex items-center">
          <div v-if="library_book.available_count > 0" class="items-center flex pr-4 font-medium text-indigo-600">
            <span class="text-indigo-600 pr-2"> {{library_book.available_count }} </span>
            экземпляров
          </div>
          <div v-else class="items-center flex pr-4 font-medium text-gray-500">
            Нет в наличии
          </div>
        </div>

        <div v-else class="flex items-center">
          <div v-if="library_book.available_count > 0 && !is_taken" :title="can_take ? '' : 'Войдите, чтобы взять книгу в библиотеке'" class="rounded-full flex pr-4">
            <button class="whitespace-nowrap inline-flex items-center justify-center px-4 py-2 rounded-md shadow-sm text-base font-medium text-indigo-600 border border-indigo-400 hover:border-indigo-500 hover:text-indigo-700"
              :disabled="!can_take"
              :event="can_take ? 'click' : ''"
              @click.prevent="take_book">
              Взять в библиотеке
            </button>
          </div>

          <router-link to="/profile" v-else-if="is_taken" class="items-center flex pr-4 text-green-500 hover:text-green-700">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
            </svg>
            <span class="whitespace-nowrap inline-flex items-center justify-center p-2 text-base font-medium">
              Книга заказана {{take_date}}
            </span>
          </router-link>

          <div v-else class="items-center flex pr-4 font-medium text-gray-500">
            Нет в наличии
          </div>
        </div>
      </div>
    </div>
  </div>

</template>
<script>

export default {
  name: 'LibraryBookItem',
  props: {
    book_uid: {
      type: String,
      required: true
    },
    library_uid: {
      type: String,
      required: true
    },
    library_book: {
      type: Object,
      required: true
    }
  },
  created() {
    this.isAdmin = localStorage.role === "admin"
    this.can_take = localStorage.signedIn     
  },
  data () {
    return {
      isAdmin: false,
      is_taken: false,
      take_date: '',
      error: '',
      can_take: false
    }
  },
  methods: {
    take_book () {
      this.$http.secured.post('/library/' + this.library_uid + '/book/' + this.book_uid + '/take', {})
        .then(response => {
          this.error = ''
          this.is_taken = true
          this.take_date = response.data.take_date
        })
        .catch(error => {
          if (error.response.status === 409)
            this.error = "Превышен лимит взятых книг. Перейдите в профиль для более подробной информации"
          else
            this.error = (error.response && error.response.data && error.response.data.message) || 'Не удалось заказать книгу. Попробуйте позже'
        })
    }
  }
}

</script>
