<template>
  <div class="max-w-md m-auto py-10">
    <!-- <div class="text-red" v-if="error">{{ error }}</div>
    <h3 class="font-mono font-regular text-3xl mb-4">Add a new artist</h3>
    <form action="" @submit.prevent="addArtist">
      <div class="mb-6">
        <input class="input"
          autofocus autocomplete="off"
          placeholder="Type an arist name"
          v-model="newArtist.name" />
      </div>
      <input type="submit" value="Add Artist" class="font-sans font-bold px-4 rounded cursor-pointer no-underline bg-green hover:bg-green-dark block w-full py-4 text-white items-center justify-center" />
    </form> -->

    <hr class="border border-grey-light my-6" />

    <ul class="list-reset mt-4">
      <li class="py-4" v-for="book in books" :key="book.book_uid" :book="book">

        <div class="flex items-center justify-between flex-wrap">
          <p class="block flex-1 font-mono font-semibold flex items-center ">
            <svg class="fill-current text-indigo w-6 h-6 mr-2" viewBox="0 0 20 20" width="20" height="20"><title>Книга</title><path d="M448 360V24c0-13.3-10.7-24-24-24H96C43 0 0 43 0 96v320c0 53 43 96 96 96h328c13.3 0 24-10.7 24-24v-16c0-7.5-3.5-14.3-8.9-18.7-4.2-15.4-4.2-59.3 0-74.7 5.4-4.3 8.9-11.1 8.9-18.6zM128 134c0-3.3 2.7-6 6-6h212c3.3 0 6 2.7 6 6v20c0 3.3-2.7 6-6 6H134c-3.3 0-6-2.7-6-6v-20zm0 64c0-3.3 2.7-6 6-6h212c3.3 0 6 2.7 6 6v20c0 3.3-2.7 6-6 6H134c-3.3 0-6-2.7-6-6v-20zm253.4 250H96c-17.7 0-32-14.3-32-32 0-17.6 14.4-32 32-32h285.4c-1.9 17.1-1.9 46.9 0 64z"></path></svg>
            {{ book.name }}
          </p>
          <!--<button class="bg-tranparent text-sm hover:bg-blue hover:text-white text-blue border border-blue no-underline font-bold py-2 px-4 mr-2 rounded"
          @click.prevent="editArtist(artist)">Edit</button>

          <button class="bg-transprent text-sm hover:bg-red text-red hover:text-white no-underline font-bold py-2 px-4 rounded border border-red"
          @click.prevent="removeArtist(artist)">Delete</button> -->
        </div>
          <!-- <div v-if="artist == editedArtist">
          <form action="" @submit.prevent="updateArtist(artist)">
            <div class="mb-6 p-4 bg-white rounded border border-grey-light mt-4">
              <input class="input" v-model="artist.name" />
              <input type="submit" value="Update" class=" my-2 bg-transparent text-sm hover:bg-blue hover:text-white text-blue border border-blue no-underline font-bold py-2 px-4 rounded cursor-pointer">
            </div>
          </form>
        </div> -->
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  name: 'Books',
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
      .catch(error => this.setError(error, 'Something went wrong'))
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
