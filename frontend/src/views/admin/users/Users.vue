<template>
  <div class="container mx-auto px-16 py-6">
    <div class="flex flex-col">
      <div class="flex justify-center">

        <div class="group block rounded-lg px-16 py-8 border border-gray-200 shadow">
          <h1 class="text-3xl font-bold text-gray-900 text-center">Регистрация пользователя</h1>
          <div class="text-red-500 text-base text-lg text-center mt-6" v-if="error">{{ error }}</div
          >
          <form @submit.prevent="signUp" class="flex justify-center space-x-6 m-8">
            <div class="flex-grow h-16">
              <label for="login" class="text-gray-600 text-lg font-normal text-center">Логин</label>
              <input id="login" v-model="login" type="text" class="mt-2 appearance-none block w-full focus:border-indigo-300 focus:ring-1 focus:ring-indigo-300 focus:outline-none w-full text-base text-grey-darker placeholder-gray-400 border border-gray-300 rounded-md py-2 px-6" placeholder="Например, ivanov" required autocomplete="on">
            </div>
            <div class="flex-grow h-16">
              <label for="password" class="text-gray-600 text-lg font-normal text-center">Пароль</label>
              <input id="password" v-model="password" type="password" class="mt-2 appearance-none block w-full focus:border-indigo-300 focus:ring-1 focus:ring-indigo-300 focus:outline-none w-full text-base text-grey-darker placeholder-gray-400 border border-gray-300 rounded-md py-2 px-6" placeholder="********" required autocomplete="off">
            </div>
            <div class="flex-grow h-16">
              <label for="password_confirmation" class="text-gray-600 text-lg font-normal text-center">Подтверждение пароля</label>
              <input type="password" v-model="password_confirmation" id="password_confirmation" class="mt-2 appearance-none block w-full focus:border-indigo-300 focus:ring-1 focus:ring-indigo-300 focus:outline-none w-full text-base text-grey-darker placeholder-gray-400 border border-gray-300 rounded-md py-2 px-6" placeholder="********" required autocomplete="off">
              <div v-if="password_confirmation !== ''">
                <div class="text-green-500 text-base text-lg text-center mt-2" v-if="password === password_confirmation">Пароли совпадают</div>
                <div class="text-red-500 text-base text-lg text-center mt-2" v-else>Пароли не совпадают</div>
              </div>
            </div>

            <div class="mt-8 text-center flex justify-between">
              <button type="submit" class="whitespace-nowrap inline-flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-xl font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none cursor-pointer">
                Добавить
              </button>
            </div>
          </form>
        </div>
      </div>

      <div class="flex justify-center mt-6">
        <table class="min-w-max w-full table-auto">
          <thead style="outline: 4px solid transparent;">
            <tr class="bg-gray-200 text-gray-500 uppercase text-md leading-normal">
              <th class="td-round-left py-3 px-6 text-center">Пользователь</th>
              <th class="py-3 px-6 text-center">Рейтинг</th>
              <th class="py-3 px-6 text-center">Баллы</th>
              <th class="py-3 px-6 text-center">Лимит книг</th>
            </tr>
          </thead>
          <tbody class="text-gray-700 text-lg">
            <tr style="line-height: 10px; color: transparent;">-</tr>
            <tr v-for="user in users" :key="user.user_uid" class="border-b border-gray-200 hover:bg-gray-100">
              <td class="py-3 px-6 text-center whitespace-nowrap"><span>{{ user.login || user.user_uid }}</span></td>
              <td class="py-3 px-6 text-center">
                <span class="bg-orange-200 text-orange-600 py-1 px-3 rounded-full uppercase text-md">
                  {{ user.status }}
                </span>
              </td>
              <td class="py-3 px-6 text-center">
                <span class="bg-green-200 text-green-600 py-1 px-3 rounded-full text-md">
                  {{ user.score }}
                </span>
              </td>
              <td class="py-3 px-6 text-center">
                <span class="bg-indigo-200 text-indigo-600 py-1 px-3 rounded-full text-md">
                  {{ user.limit }}
                </span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

    </div>
  </div>
</template>

<script>

export default {
  name: 'Users',
  data () {
    return {
      login: '',
      password: '',
      password_confirmation: '',
      users: [],
      error: ''
    }
  },
  created () {
     if (!localStorage.signedIn && localStorage.role != "admin") {
      this.$router.replace('/')
    } else {
      this.getUsers()
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.message) || text
    },
    getUsers () {
      this.$http.secured.get('/users/rating')
        .then(response => { this.users = response.data })
        .catch()
    },
    signUp () {
      if (this.password === this.password_confirmation) {
        this.$http.secured.post('/sign-up', { login: this.login, password: this.password })
          .then(this.signUpSuccessful())
          .catch(error => this.signUpFailed(error))
      }
    },
    signUpSuccessful () {
      this.error = ''
      this.$router.go()
    },
    signUpFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.message) || 'Не удалось создать новый аккаунт. Пожалуйста, повторите позже'
      if (error.response.data.details) {
        this.add_error += '. Details: ' + error.response.data.details
      }
    }
  }
}
</script>
