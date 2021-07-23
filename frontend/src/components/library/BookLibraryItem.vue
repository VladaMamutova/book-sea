<template>
  <div>
    <div class="text-red-500 text-base text-lg text-center mt-6 pb-4" v-if="error">{{ error }}</div>

    <div class="hover:shadow-lg group block rounded-lg px-8 py-6 border border-gray-200">
      <div class="flex space-x-4">

      <div class="flex-auto py-4 space-y-2">
          <h2>
            <router-link class="text-xl font-bold text-black hover:underline hover:text-indigo-700"
              :to="{ name: 'LibraryBooks', params: { library_uid: library.library_uid, library_prop: library }}">
              {{ library.name }}
            </router-link>
          </h2>

          <div class="flex-wrap text-base text-gray-700 font-normal">
            г. {{ library.city }}, {{ library.address }}
          </div>
        </div>

        <div v-if="available_count > 0 && !is_taken" :title="can_take ? '' : 'Войдите, чтобы взять книгу в библиотеке'" class="rounded-full items-center flex pr-4">
          <button class="whitespace-nowrap inline-flex items-center justify-center px-4 py-2 rounded-md shadow-sm text-base font-medium text-indigo-600 border border-indigo-400 hover:border-indigo-500 hover:text-indigo-700"
            :disabled="!can_take"
            :event="can_take ? 'click' : ''"
            @click.prevent="take_book">
            Взять в библиотеке
          </button>
        </div>

        <router-link to="/profile" v-else-if="is_taken" class="items-center flex pr-4 text-green-500  hover:text-green-700">
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
</template>

<script>

export default {
  name: 'BookLibraryItem',
  props: {
    library: {
      type: Object,
      required: true
    },
    library: {
      type: Object,
      required: true
    },
    available_count: {
      type: Number,
      required: true
    },
    book_uid: {
      type: String
    }
  },
  data () {
    return {
      is_taken: false,
      take_date: '',
      error: '',
      can_take: false
    }
  },
  created () {
    this.can_take = localStorage.signedIn
  },
  methods: {
    take_book () {
      this.$http.secured.post('/library/' + this.library.library_uid + '/book/' + this.book_uid + '/take', {})
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
