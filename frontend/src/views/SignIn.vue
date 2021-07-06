<template>
  <div class="max-w-lg m-auto my-20">
    <div class="group block rounded-lg px-16 py-8 border border-gray-200 shadow">
      <h1 class="text-3xl font-bold text-gray-900 text-center">Вход</h1>
      <form @submit.prevent="signIn">
        <div class="text-red-500 text-base text-lg text-center mt-6" v-if="error">{{ error }}</div>

        <div class="mt-8">
          <label for="login" class="text-gray-600 text-lg font-normal text-center">Логин</label>
          <input id="login" v-model="login" type="text" class="mt-2 appearance-none block w-full focus:border-indigo-300 focus:ring-1 focus:ring-indigo-300 focus:outline-none w-full text-base text-grey-darker placeholder-gray-400 border border-gray-300 rounded-md py-2 px-6" placeholder="Например, ivanov" required autocomplete="on">
        </div>

        <div class="mt-5">
          <label for="password" class="text-gray-600 text-lg font-normal text-center">Password</label>
          <input id="password" v-model="password" type="password" class="mt-2 appearance-none block w-full focus:border-indigo-300 focus:ring-1 focus:ring-indigo-300 focus:outline-none w-full text-base text-grey-darker placeholder-gray-400 border border-gray-300 rounded-md py-2 px-6" placeholder="********" autocomplete="off">
        </div>
        
        <div class="mt-8 text-center flex justify-between">
          <router-link to="/sign_in" class="self-center text-xl text-gray-700 font-medium hover:underline hover:text-gray-900">Зарегистрироваться</router-link>

          <button type="submit" class="whitespace-nowrap inline-flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-xl font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none cursor-pointer">
            Войти
          </button>
        </div>
      </form>

    </div>
  </div>
</template>

<script>
export default {
  name: 'SignIn',
  data () {
    return {
      login: '',
      password: '',
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
    signIn () {
      this.$http.session.post('/auth', { }, {
        auth: { // "auth" parameter for Basic Auth
          username: this.login,
          password: this.password
        }})
        .then(response => this.signInSuccessful(response))
        .catch(error => this.signInFailed(error))
    },
    signInSuccessful (response) {
      if (!response.data.token) {
        this.signInFailed(response)
        return
      }
      localStorage.token = response.data.token
      localStorage.signedIn = true
      localStorage.userLogin = this.login
      localStorage.role = response.data.role
      this.error = ''
      // if (localStorage.role == "admin")
      //   this.$router.push('/admin/books')
      // else
        this.$router.push('/books')
    },
    signInFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.message) || 'Неверный логин или пароль'
      delete localStorage.token
      delete localStorage.signedIn
      delete localStorage.userLogin
      delete localStorage.role
    },
    checkSignedIn () {
      if (localStorage.signedIn) {
      // if (localStorage.role == "admin")
      //   this.$router.push('/admin/books')
      // else
        this.$router.push('/books')
      }
    }
  }
}
</script>
