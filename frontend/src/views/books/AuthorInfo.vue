<template>
  <div class="container items-center mx-auto px-16 py-6">
    <div class="text-red-500 text-base text-xl text-center py-20" v-if="error">{{ error }}</div>

      <div v-if="!error" class="flex-row justify-center space-y-6 rounded-lg px-24 py-12 border border-gray-200">
    
      <h1 class="text-3xl font-bold text-black text-center">
        {{ author.last_name }} {{ author.first_name }} {{ author.middle_name }}
      </h1>

      <div class="flex-wrap text-xl text-gray-700 font-normal text-center">
        {{ author.info }}
      </div>

      <div class="flex justify-center">
        <div class="rounded-full items-center flex">
          <router-link class="flex flex-wrap whitespace-nowrap items-center mt-4 px-4 py-2 rounded-md shadow-sm text-xl font-medium text-indigo-600 border border-indigo-400 hover:border-indigo-500 hover:text-indigo-700"
            :to="{ name: 'AuthorBooks', params: { author_uid: author_uid }}">
            Найти книги автора
          </router-link>
        </div>
      </div>
        
    </div>
  </div>
</template>

<script>

export default {
  name: 'AuthorInfo',
  data () {
    return {
      author_uid: {
        type: String
      },
      author: {
        type: Object
      },
      error: ''
    }
  },
  created () {
    this.author_uid = this.$route.params.author_uid
    this.$http.plain.get('/author/'+ this.author_uid)
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
