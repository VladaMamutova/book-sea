<template>
  <div class="hover:shadow-lg group block rounded-lg px-8 py-6 border border-gray-200">
    <div class="flex space-x-4">

      <div class="flex flex-initial items-center">
        <img img src="@/assets/book.svg" alt="Обложка книги" class="flex-none object-cover" width="100" height="100" />
      </div>
  
      <div class="flex-auto px-6 py-4 space-y-2">
        <h2 v-if="library_book.name">
          <router-link class="text-xl font-semibold text-black hover:underline hover:text-indigo-700"
            :to="{ name: 'BookInfo', params: { book_uid: library_book.book_uid }}">
            {{ library_book.name }}
          </router-link>
        </h2>     

        <div v-if="library_book.author" class="flex-wrap">
          <router-link class="text-base text-gray-700 font-normal hover:text-gray-900"
            :to="{ name: 'AuthorInfo', params: { author_uid: library_book.author.author_uid }}">
            {{ library_book.author.last_name }} {{ library_book.author.first_name }} {{ library_book.author.middle_name }}
          </router-link>
        </div>
      </div>
      
      <div class="rounded-full items-center flex pr-4">
        <a href="#" class="whitespace-nowrap inline-flex items-center justify-center px-4 py-2 rounded-md shadow-sm text-base font-medium text-indigo-600 border border-indigo-400 hover:border-indigo-500 hover:text-indigo-700">
          Взять в библиотеке
        </a>
      </div>
      
    </div>
  </div>

</template>
<script>

export default {
  name: 'LibraryBookItem',
  props: {
    library_book: {
      type: Object,
      required: true
    }
  }
}

</script>
