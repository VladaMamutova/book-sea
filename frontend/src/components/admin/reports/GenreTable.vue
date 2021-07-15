<template>
    <table class="min-w-max w-full table-auto">
      <thead style="outline: 4px solid transparent;">
        <tr class="bg-gray-200 text-gray-600 uppercase text-md leading-normal">
          <th class="td-round-left py-3 px-6 text-center">Жанр</th>
          <th class="td-round-right py-3 px-6 text-center">Количество книг</th>
        </tr>
      </thead>
      <tbody class="text-gray-600 text-lg">
        <tr style="line-height: 10px; color: transparent;">-</tr>
        <tr v-for="(item, index) in items" :key="index" class="border-b border-gray-200 hover:bg-gray-100">
          <td class="py-3 px-6 text-center whitespace-nowrap"><span>{{ item.genre }}</span></td>
          <td class="py-3 px-6 text-center">
            <span class="bg-indigo-200 text-indigo-600 py-1 px-3 rounded-full text-md">
              {{ item.book_count }}
            </span>
          </td>
        </tr>
      </tbody>
    </table>
</template>

<script>

export default {
  name: 'GenreTable',
  data () {
    return {
      items: [],
      error: ''
    }
  },
  created () {
    this.getItems()
  },
  methods: {
    getItems () {
      this.$http.secured.get('/reports/books-genre')
      .then(response => {
        this.error = ''
        this.items = response.data
      })
      .catch(error => {
        this.error = (error.response && error.response.data && error.response.data.message) || 'Не удалось получить статистику. Попробуйте позже'
      })
    }
  }
}
</script>
