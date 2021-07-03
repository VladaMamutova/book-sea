<template>
  <div class="container max-w-xl mx-auto py-6">
    <div class="group block rounded-lg px-16 py-8 border border-gray-200 shadow">
      <h1 class="text-3xl font-bold text-gray-900 text-center">Добавление книги</h1>
      <form @submit.prevent="createBook">
        <div class="text-red-500 text-base text-lg text-center mt-6" v-if="error">{{ error }}</div>

        <div class="mt-8">
          <label for="name" class="text-gray-600 text-xl font-normal text-center">Название</label>
          <input id="name" v-model="name" type="text" class="mt-2 appearance-none block w-full focus:border-indigo-300 focus:ring-1 focus:ring-indigo-300 focus:outline-none w-full text-xl text-grey-darker border border-gray-300 rounded-md py-2 px-6" required autocomplete="off">
        </div>

        <div class="mt-5">
          <label for="author" class="text-gray-600 text-xl font-normal text-center">Автор</label>
          <select id="author" v-model="author" class="mt-2 appearance-none block w-full focus:border-indigo-200 focus:bg-white focus:outline-none w-full text-xl text-gray-900 bg-gray-200 border border-gray-300 rounded-md py-2 px-6 cursor-pointer" required autocomplete="off">
            <option disabled value="" class="text-gray-600">Выберите автора</option>
            <option :value="author.first_name + ' ' + author.middle_name + ' ' + author.last_name"
              v-for="author in authors" :key="author.author_uid">
              {{ author.first_name }} {{ author.middle_name }} {{ author.last_name }}
            </option>
          </select>
        </div>

        <div class="mt-5">
          <label for="genre" class="text-gray-600 text-xl font-normal text-center">Жанр</label>
          <select id="genre" v-model="genre" class="mt-2 appearance-none block w-full focus:border-indigo-200 focus:bg-white focus:outline-none w-full text-xl text-gray-900 bg-gray-200 border border-gray-300 rounded-md py-2 px-6 cursor-pointer" required autocomplete="off">
            <option disabled value="" class="text-gray-600">Выберите жанр</option>
            <option :value="genre.name" v-for="genre in genres" :key="genre.id">
              {{ genre.name }}
            </option>
          </select>
        </div>

        <div class="mt-8 flex justify-center">
          <button type="submit" class="whitespace-nowrap inline-flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-xl font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none cursor-pointer">
            Добавить
          </button>
        </div>
      </form>

    </div>
  </div>
</template>

<script>
export default {
  name: 'AddBook',
  data () {
    return {
      authors: [],
      genres: [],
      name: '',
      author: '',
      genre: '',
      error: '',
      info: ''
    }
  },
  created () {
    if (!localStorage.signedIn && localStorage.role != "admin") {
      this.$router.replace('/')
    } else {
      this.$http.secured.get('/authors')
        .then(response => { this.authors = response.data })
        .catch()

      this.$http.secured.get('/genres')
        .then(response => { this.genres = response.data })
        .catch()
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.message) || text
    },
    createBook () {
      let authorParams = this.author.split(/(\s+)/).filter( function(e) { return e.trim().length > 0; } );
      let authorObj = {
        first_name: authorParams[0],
        last_name: authorParams[2]
      }
      if (authorParams[1] != 'null')
        authorObj['middle_name'] = authorParams[1]

      let newBook = {
        name: this.name,
        author: authorObj,
        genre: this.genre
      }

      this.$http.secured.post('/books', newBook)
      .then(response => {
        this.$router.replace({name: "EditBook", params: {book_uid: response.data.book_uid}})
      })
      .catch(error => this.setError(error, 'Возникла ошибка при добавлении новой книги'))
    }
  }
}
</script>
