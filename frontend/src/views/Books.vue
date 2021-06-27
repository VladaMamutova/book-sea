<template>
  <div class="max-w-2xl m-auto py-8">
    <div class="text-red-500 text-base text-xl text-center py-20" v-if="error">{{ error }}</div>
    <!--<h3 class="font-mono font-regular text-3xl mb-4">Add a new artist</h3>
    <form action="" @submit.prevent="addArtist">
      <div class="mb-6">
        <input class="input"
          autofocus autocomplete="off"
          placeholder="Type an arist name"
          v-model="newArtist.name" />
      </div>
      <input type="submit" value="Add Artist" class="font-sans font-bold px-4 rounded cursor-pointer no-underline bg-green hover:bg-green-dark block w-full py-4 text-white items-center justify-center" />
    </form> -->
    
    <List>
      <BookItem v-for="book in books" :key="book.book_uid" :book="book" />
    </List>

  </div>
</template>

<script>

import List from '@/components/List.vue'
import BookItem from '@/components/books/BookItem.vue'

export default {
  name: 'Books',
  components: {
    List,
    BookItem
  },
  data () {
    return {
      books: [],
      // newArtist: [],
      error: ''
      // editedArtist: ''
    }
  },
  created () {
    // if (!localStorage.signedIn) {
    //   this.$router.replace('/')
    // } else {
    this.$http.plain.get('/books')
      .then(response => { this.books = response.data })
      .catch(error => this.setError(error, 'Что-то пошло не так... Попробуйте позже'))
    // }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.message) || text
    } // ,
    // addArtist () {
    //   const value = this.newArtist
    //   if (!value) {
    //     return
    //   }
    //   this.$http.secured.post('/api/v1/artists/', { artist: { name: this.newArtist.name } })

    //     .then(response => {
    //       this.artists.push(response.data)
    //       this.newArtist = ''
    //     })
    //     .catch(error => this.setError(error, 'Cannot create artist'))
    // },
    // removeArtist (artist) {
    //   this.$http.secured.delete(`/api/v1/artists/${artist.id}`)
    //     .then(response => {
    //       this.artists.splice(this.artists.indexOf(artist), 1)
    //     })
    //     .catch(error => this.setError(error, 'Cannot delete artist'))
    // },
    // editArtist (artist) {
    //   this.editedArtist = artist
    // },
    // updateArtist (artist) {
    //   this.editedArtist = ''
    //   this.$http.secured.patch(`/api/v1/artists/${artist.id}`, { artist: { title: artist.name } })
    //     .catch(error => this.setError(error, 'Cannot update artist'))
    // }
  }
}
</script>
