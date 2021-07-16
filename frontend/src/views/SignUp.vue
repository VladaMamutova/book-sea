<template>
  <div class="max-w-lg m-auto my-20">
    <div class="group block rounded-lg px-16 py-8 border border-gray-200 shadow">
      <h1 class="text-3xl font-bold text-gray-900 text-center">Регистрация</h1>
      <form @submit.prevent="signUp">
        <div class="text-red-500 text-base text-lg text-center mt-6" v-if="error">{{ error }}</div>

        <div class="mt-8">
          <label for="login" class="text-gray-600 text-lg font-normal text-center">Логин</label>
          <input id="login" v-model="login" type="text" class="mt-2 appearance-none block w-full focus:border-indigo-300 focus:ring-1 focus:ring-indigo-300 focus:outline-none w-full text-base text-grey-darker placeholder-gray-400 border border-gray-300 rounded-md py-2 px-6" placeholder="Например, ivanov" required autocomplete="on">
        </div>

        <div class="mt-5">
          <label for="password" class="text-gray-600 text-lg font-normal text-center">Пароль</label>
          <input id="password" v-model="password" type="password" class="mt-2 appearance-none block w-full focus:border-indigo-300 focus:ring-1 focus:ring-indigo-300 focus:outline-none w-full text-base text-grey-darker placeholder-gray-400 border border-gray-300 rounded-md py-2 px-6" placeholder="********" required autocomplete="off">
        </div>

        <div class="mt-5">
          <label for="password_confirmation" class="text-gray-600 text-lg font-normal text-center">Подтверждение пароля</label>
          <input type="password" v-model="password_confirmation" id="password_confirmation" class="mt-2 appearance-none block w-full focus:border-indigo-300 focus:ring-1 focus:ring-indigo-300 focus:outline-none w-full text-base text-grey-darker placeholder-gray-400 border border-gray-300 rounded-md py-2 px-6" placeholder="********" required autocomplete="off">
          <div v-if="password_confirmation !== ''">
            <div class="text-green-500 text-base text-lg text-center mt-2" v-if="password === password_confirmation">Пароли совпадают</div>
            <div class="text-red-500 text-base text-lg text-center mt-2" v-else>Пароли не совпадают</div>
          </div>
        </div>

        <div class="mt-8 text-center flex justify-between">
          <router-link to="/sign_in" class="self-center text-xl text-gray-700 font-medium hover:underline hover:text-gray-900">Войти</router-link>

          <button type="submit" class="whitespace-nowrap inline-flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-xl font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none cursor-pointer">
            Зарегистрироваться
          </button>
        </div>
      </form>

    </div>
  </div>
</template>

<script>
export default {
  name: 'SignUp',
  data () {
    return {
      login: '',
      password: '',
      password_confirmation: '',
      error: ''
    }
  },
  created () {
    this.checkSignedIn()
  },
  updated () {
    this.checkSignedIn()
  },
  methods: {
    signUp () {
      if (this.password === this.password_confirmation) {
        // this.$http.plain.post('/sign-up', { login: this.login, password: this.password })
        //   .then(response => this.signIpSuccessful(response))
        //   .catch(error => this.signUpFailed(error))
      }
    },
    signUpSuccessful (response) {
      // this.error = ''
      // this.$router.push('/books')
    },
    signUpFailed (error) {
      // this.error = (error.response && error.response.data && error.response.data.message) || 'Неверный логин или пароль'
    },
    checkSignedIn () {
      if (localStorage.signedIn) {
        this.$router.push('/books')
      }
    }
  }
}
</script>
