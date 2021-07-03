<template>
  <div class="container mx-auto item-center px-16 pt-6 pb-16">
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

    <div v-if="libraries" class="group block rounded-lg px-16 py-8 border border-gray-200 shadow mt-12">
      <h1 class="text-3xl font-bold text-gray-900 text-center">Добавление в библиотеку</h1>
      <form @submit.prevent="addToLibrary">
        <div class="text-red-500 text-base text-lg text-center mt-6" v-if="add_error">{{ add_error }}</div>
        <div class="text-blue-500 text-base text-lg text-center mt-6" v-if="add_info">{{ add_info }}</div>

        <div class="mt-8">
          <label for="add_to_library" class="text-gray-600 text-xl font-normal text-center">Библиотека</label>
          <select id="add_to_library" v-model="add_library_uid" class="mt-2 appearance-none block w-full focus:border-indigo-200 focus:bg-white focus:outline-none w-full text-xl text-gray-900 bg-gray-200 border border-gray-300 rounded-md py-2 px-6 cursor-pointer" required autocomplete="off">
            <option disabled value="" class="text-gray-600">Выберите библиотеку</option>
            <option :value="add_library.library_uid" v-for="add_library in libraries" :key="add_library.library_uid">
              {{ add_library.name }}, г. {{add_library.city }}
            </option>
          </select>
        </div>

        <div class="mt-8">
          <label for="book_number" class="text-gray-600 text-xl font-normal text-center">Количество экземпляров</label>
          <input id="book_number" v-model="book_number" type="number" min="1" class="mt-2 appearance-none block w-full focus:border-indigo-300 focus:ring-1 focus:ring-indigo-300 focus:outline-none w-full text-xl text-grey-darker border border-gray-300 rounded-md py-2 px-6" required autocomplete="off">
        </div>

        <div class="mt-8 flex justify-center">
          <button type="submit" class="whitespace-nowrap inline-flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-xl font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none cursor-pointer">
            Добавить в библиотеку
          </button>
        </div>
      </form>
    </div>

    <div v-if="book_libraries" class="group block rounded-lg px-16 py-8 border border-gray-200 shadow mt-12">
      <h1 class="text-3xl font-bold text-gray-900 text-center">Удаление из библиотеки</h1>
      <form @submit.prevent="removeFromLibrary">
        <div class="text-red-500 text-base text-lg text-center mt-6" v-if="remove_error">{{ remove_error }}</div>
        <div class="text-blue-500 text-base text-lg text-center mt-6" v-if="remove_info">{{ remove_info }}</div>

        <div class="mt-8">
          <label for="remove_from_library" class="text-gray-600 text-xl font-normal text-center">Библиотека</label>
          <select id="remove_from_library" v-model="remove_library_uid" class="mt-2 appearance-none block w-full focus:border-indigo-200 focus:bg-white focus:outline-none w-full text-xl text-gray-900 bg-gray-200 border border-gray-300 rounded-md py-2 px-6 cursor-pointer" required autocomplete="off">
            <option disabled value="" class="text-gray-600">Выберите библиотеку</option>
            <option :value="book_library.library.library_uid" v-for="book_library in book_libraries" :key="book_library.library.library_uid">
              {{ book_library.library.name }}, г. {{ book_library.library.city }}
            </option>
          </select>
        </div>

        <div class="mt-8">
          <label for="available_count" class="text-gray-600 text-xl font-normal text-center">Доступное количество экземпляров</label>
          <input id="available_count" :value="getBookAvailableCount(remove_library_uid)" type="number" min="0" disabled class="mt-2 bg-gray-200 appearance-none block w-full focus:border-indigo-300 focus:ring-1 focus:ring-indigo-300 focus:outline-none w-full text-xl text-grey-darker border border-gray-300 rounded-md py-2 px-6" required autocomplete="off">
        </div>

        <div class="mt-8 flex justify-center">
          <button type="submit" class="whitespace-nowrap inline-flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-xl font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none cursor-pointer">
            Удалить из библиотеки
          </button>
        </div>
      </form>
    </div>

    <div class="mt-12 flex flex-col items-center justify-center">
      <div class="text-red-500 text-base text-lg text-center mb-4" v-if="error">{{ error }}</div>
      <button @click.prevent="removeBook()" title="Книга автоматически будет удалена из всех библиотек" class="whitespace-nowrap inline-flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-xl font-medium text-red-500 bg-gray-100 hover:bg-gray-200 focus:outline-none cursor-pointer">
        Удалить книгу
      </button>
    </div>
  </div>
</template>

<script>

export default {
  name: 'EditBook',
  data () {
    return {
      book: {},
      libraries: [],
      add_library_uid: '',
      book_number: 1,
      book_libraries: [],
      remove_library_uid: '',
      available_count: 0,
      error: '',
      add_error: '',
      add_info: '',
      remove_error: '',
      remove_info: ''
    }
  },
  created () {
     if (!localStorage.signedIn && localStorage.role != "admin") {
      this.$router.replace('/')
    } else {
      this.book_uid = this.$route.params.book_uid
      this.$http.secured.get('/books/'+ this.book_uid)
        .then(response => { this.book = response.data; })
        .catch(error => this.setError(error, 'Не удалось получить информацию о книге'))
      this.$http.secured.get('/library')
        .then(response => { this.libraries = response.data })
        .catch()
      this.$http.secured.get('/library/book/'+ this.book_uid)
        .then(response => { this.book_libraries = response.data; })
        .catch()
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.message) || text
    },
    setAddError (error) {
      this.add_info = ''
      this.add_error = 'Не удалось добавить книгу в библиотеку'
      if (error.response && error.response.data && error.response.data.message) {
        this.add_error += '. ' + error.response && error.response.data && error.response.data.message
        if (error.response.data.details) {
          this.add_error += '. Details: ' + error.response.data.details
        }
      }
    },
    setRemoveError (error) {
      this.remove_info = ''
      this.remove_error = 'Не удалось удалить книгу из библиотеки'
      if (error.response && error.response.data && error.response.data.message)
        this.remove_error += '. Не удалось удалить книгу из библиотеки'
    },
    getBookAvailableCount(library_uid) {
      let library_index = this.book_libraries.findIndex(book_library => book_library.library.library_uid === library_uid)
      if (library_index !== -1)
        this.available_count = this.book_libraries[library_index].available_count
      else
        this.available_count = ''

      return this.available_count
    },
    setBookAvailableCount(library_uid, available_count) {
      let library_index = this.book_libraries.findIndex(book_library => book_library.library.library_uid === library_uid)
      if (library_index !== -1) {
        this.book_libraries[library_index].available_count = available_count
        if (library_uid === this.remove_library_uid) 
          this.available_count = available_count
        this.getBookAvailableCount(library_uid)
      } else {
        let library_index = this.libraries.findIndex(library => library.library_uid === library_uid)
        if (library_index !== -1) {
          this.book_libraries.push({library: this.libraries[library_index], available_count: this.available_count})
        }
      }
    },
    addToLibrary() {
      if (!this.add_library_uid)
        return

      this.$http.secured.post('/library/' + this.add_library_uid + '/book/' + this.book_uid, { number: this.book_number })
        .then(response => {
          this.available_count = response.data.available_count;
          this.setBookAvailableCount(this.add_library_uid, this.available_count)
          this.add_error = ''
          let library_index = this.libraries.findIndex(library => library.library_uid === this.add_library_uid)
          this.add_info = this.libraries[library_index].name + ' пополнилась книгой \"' + this.book.name + '\" в количестве ' + this.book_number + ' экземпляров'
        })
        .catch(error => this.setAddError(error))
    },
    removeFromLibrary() {
      if (!this.remove_library_uid)
        return

      this.$http.secured.delete('/library/' + this.remove_library_uid + '/book/' + this.book_uid)
        .then(response => {
          let library_index = this.book_libraries.findIndex(book_library => book_library.library.library_uid === this.remove_library_uid)
          this.book_libraries.splice(library_index, 1);
          this.remove_error = '';
          library_index = this.libraries.findIndex(library => library.library_uid === this.remove_library_uid);
          this.remove_info = this.libraries[library_index].name + ' больше не содержит ни одного экземпляра книги \"' + this.book.name + '\"'
          this.remove_library_uid = ''
        })
        .catch(error => this.setRemoveError(error))
    },
    removeBook() {
      this.$http.secured.delete('/books/' + this.book_uid)
        .then(response => {
          this.$router.back()
        })
        .catch(error => this.setError(error), 'Не удалось удалить книгу')
    }
  }
}
</script>
