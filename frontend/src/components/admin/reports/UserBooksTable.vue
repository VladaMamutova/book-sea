<template>
    <table class="min-w-max w-full table-auto">
      <thead style="outline: 4px solid transparent;">
        <tr class="bg-gray-200 text-gray-500 uppercase text-md leading-normal">
          <th class="td-round-left py-3 px-6 text-center">Пользователь</th>
          <th class="py-3 px-6 text-center">Читает сейчас</th>
          <th class="py-3 px-6 text-center">Сдано в срок</th>
          <th class="py-3 px-6 text-center">Возврат в плохом состоянии</th>
          <th class="py-3 px-6 text-center">Потеряно</th>
          <th class="td-round-right py-3 px-6 text-center">Всего книг</th>
        </tr>
      </thead>
      <tbody class="text-gray-700 text-lg">
        <tr style="line-height: 10px; color: transparent;">-</tr>
        <tr v-for="(item, index) in items" :key="index" class="border-b border-gray-200 hover:bg-gray-100">
          <td class="py-3 px-6 text-center whitespace-nowrap"><span>{{ item.login || item.user_uid }}</span></td>
          <td class="py-3 px-6 text-center">
            <span class="bg-orange-200 text-orange-600 py-1 px-3 rounded-full text-md">
              {{ item.new }}
            </span>
          </td>
          <td class="py-3 px-6 text-center">
            <span class="bg-green-200 text-green-600 py-1 px-3 rounded-full text-md">
              {{ item.in_time_count }}
            </span>
          </td>
          <td class="py-3 px-6 text-center">
            <span class="bg-gray-300 text-gray-700 py-1 px-3 rounded-full text-md">
              {{ item.bad_condition }}
            </span>
          </td>
          <td class="py-3 px-6 text-center">
            <span class="bg-pink-200 text-pink-600 py-1 px-3 rounded-full text-md">
              {{ item.lost }}
            </span>
          </td>
          <td class="py-3 px-6 text-center">
            <span class="bg-indigo-200 text-indigo-600 py-1 px-3 rounded-full text-md">
              {{ item.count_all }}
            </span>
          </td>
        </tr>
      </tbody>
    </table>
</template>

<script>

export default {
  name: 'UserBooksTable',
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
      this.$http.secured.get('/reports/books-return')
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
