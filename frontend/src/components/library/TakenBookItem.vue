<template>
  <div class="hover:shadow-lg group block rounded-lg px-8 py-6 border border-gray-200">
    <div class="flex space-x-4">

      <div class="flex flex-initial items-center">
        <img img src="@/assets/book.svg" alt="Обложка книги" class="flex-none object-cover" width="100" height="100" />
      </div>
  
      <div class="flex-auto px-6 py-4 space-y-2">
        <h2 v-if="taken_book.name">
          <router-link class="text-xl font-bold text-black hover:underline hover:text-indigo-700"
            :to="{ name: 'BookInfo', params: { book_uid: taken_book.book_uid }}">
            {{ taken_book.name }}
          </router-link>
        </h2>

        <div v-if="taken_book.author" class="flex-wrap text-base text-gray-500 font-normal">
          Автор: 
          <router-link class="text-gray-700 hover:text-gray-900"
            :to="{ name: 'AuthorInfo', params: { author_uid: taken_book.author.author_uid }}">
            {{ taken_book.author.last_name }} {{ taken_book.author.first_name }} {{ taken_book.author.middle_name }}
          </router-link>
        </div>

        <div v-if="taken_book.library" class="flex-wrap text-base text-gray-500 font-normal">
          Библиотека: <span class="text-gray-700">{{ taken_book.library }}</span>
        </div>

        <div v-if="taken_book.take_date" class="flex-wrap text-base text-gray-500 font-normal">
          Дата взятия: <span class="text-gray-700">{{ taken_book.take_date }}</span>
        </div>

        <div v-if="return_date" class="flex-wrap text-base text-gray-500 font-normal">
          Дата сдачи: <span class="text-gray-700">{{ return_date }}</span>
        </div>
      </div>
      
      <div v-if="!is_returning && !return_date" class="rounded-full items-center flex pr-4">
        <button @click.prevent="start_returning" class="whitespace-nowrap inline-flex items-center justify-center px-4 py-2 rounded-md shadow-sm text-base font-medium text-indigo-600 border border-indigo-400 hover:border-indigo-500 hover:text-indigo-700">
          Вернуть в библиотеку
        </button>
      </div>

      <div v-if="return_date" class="flex items-center pr-4">
        <div>
          <div class="flex flex-inline justify-end">
            Срок сдачи: 
            <div class="font-medium pl-1">
              <span v-if="return_in_time" class="text-green-500">вовремя</span>
              <span v-else class="text-red-500">просрочен</span>
            </div>
          </div>
          <div class="flex flex-inline mt-1 justify-end">
            Состояние книги: 
            <div class="font-medium pl-1">
              <span v-if="return_status === 'bad_condition'" class="text-red-500">плохое</span>
              <span v-else-if="return_status === 'lost'" class="text-red-500">потеряна</span>
              <span v-else class="text-green-500">хорошее</span>
            </div>
          </div>
          </div>
      </div>
    </div>

    <div v-if="is_returning" class="mt-2">
      <h1 class="text-xl font-bold text-gray-900 text-center">Возврат книги</h1>
      <form @submit.prevent="return_book">
        <div class="text-red-500 text-base text-lg text-center mt-6" v-if="error">{{ error }}</div>

        <div class="flex p-4 mt-2 items-center">
          <label for="status" class="flex-initial text-gray-600 text-base font-normal text-center pr-8">Комментарий</label>
  
          <div class="flex-grow">
            <select id="status" v-model="status" class="appearance-none block focus:border-indigo-200 focus:bg-white focus:outline-none w-full text-base text-gray-900 bg-gray-200 border border-gray-300 rounded-md py-2 px-6 cursor-pointer" required autocomplete="off">
              <option value="used">хорошее состояние</option>
              <option value="bad_condition">плохое состояние</option>
              <option value="lost">потеряна</option>
            </select>
          </div>
          
          <div class="rounded-full flex-initial pl-6">
            <button class="whitespace-nowrap inline-flex text-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-base font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none cursor-pointer">
              Вернуть в библиотеку
            </button>
          </div>
        </div>

      </form>
    </div>

  </div>
</template>
<script>

export default {
  name: 'TakenBookItem',
  props: {
    taken_book_prop: {
      type: Object,
      required: true
    }
  },
  data () {
    return {
      taken_book: {},
      is_returning: false,
      status: 'used',
      error: '',
      return_date: '',
      return_status: '',
      return_in_time: ''
    }
  },
  created() {
    this.taken_book = this.taken_book_prop
  },
  methods: {
    start_returning () {
      this.is_returning = true
    },
    return_book () {
       this.$http.secured.post('/library/' + this.taken_book.library_uid + '/book/' + this.taken_book.book_uid + '/return', { status: this.status })
        .then(response => {
          this.error = ''

          this.return_date = response.data.return_date
          this.return_status = response.data.status
          this.return_in_time = response.data.in_time

          this.$parent.$parent.$data.rating.score = response.data.rating_score
          if (response.data.rating_operation !== 'none') {
            this.$parent.$parent.$data.rating.status = response.data.rating_status
            this.$parent.$parent.$data.rating.limit = response.data.book_limit
          }

          this.is_returning = false
        })
        .catch(error => {
          if (error.response.status === 409)
            this.error = "Превышен лимит взятых книг. Перейдите в профиль для более подробной информации"
          else
            this.error = (error.response && error.response.data && error.response.data.message) || 'Не вернуть книгу. Попробуйте позже'
        })
    }
  }
}

</script>
