<template>
  <div class="container mx-auto px-16 py-6">
    <div class="text-red-500 text-base text-xl text-center py-20" v-if="error">{{ error }}</div>
    <div class="text-gray-400 text-base text-xl text-center py-20" v-if="!error && libraries.length == 0">По данному запросу ничего не найдено</div>
    
    <List>
      <LibraryItem v-for="library in libraries" :key="library.library_uid" :library="library" />
    </List>
  </div>
</template>

<script>

import List from '@/components/List.vue'
import LibraryItem from '@/components/libraries/LibraryItem.vue'

export default {
  name: 'Libraries',
  components: {
    List,
    LibraryItem
  },
  data () {
    return {
      libraries: [],
      error: '',
    }
  },
  created () {
    this.$http.plain.get('/library')
      .then(response => { this.libraries = response.data })
      .catch(error => this.setError(error, 'Что-то пошло не так... Попробуйте позже'))
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.message) || text
    },
  }
}
</script>
