<template>
  <div class="hover:shadow-lg group block rounded-lg px-8 py-6 border border-gray-200">
    <div class="flex space-x-4">

      <div class="flex flex-initial items-center">
        <img img src="@/assets/book.svg" alt="Обложка книги" class="flex-none object-cover" width="100" height="100" />
      </div>

      <div class="flex-auto px-6 py-4 space-y-2">
        <h2>
          <router-link class="text-xl font-bold text-black hover:underline hover:text-indigo-700"
            :to="{ name: 'EditBook', params: { book_uid: book.book_uid }}">
            {{ book.name }}
          </router-link>
        </h2>     

        <div v-if="book.author" class="flex-wrap text-base text-gray-500 font-normal">
          Автор: 
          <router-link class="text-gray-700 hover:text-gray-900"
            :to="{ name: 'AuthorInfo', params: { author_uid: book.author.author_uid }}">
            {{ book.author.last_name }} {{ book.author.first_name }} {{ book.author.middle_name }}
          </router-link>
        </div>

        <div v-if="!book.author && book.genre" class="flex-wrap text-base text-gray-500 font-normal">
          Жанр: <span class="text-gray-700"> {{ book.genre }} </span>
        </div>
      </div>

      <div class="rounded-full items-center flex pr-4">
        <router-link class="whitespace-nowrap inline-flex items-center justify-center text-center px-4 py-2 rounded-md shadow-sm text-base font-medium text-indigo-600 border border-indigo-400 hover:border-indigo-500 hover:text-indigo-700"
          :to="{ name: 'EditBook', params: { book_uid: book.book_uid }}">
          Редактировать
        </router-link>
      </div>
      
    </div>
  </div>

</template>
<script>

export default {
  props: ['book'],
}

</script>
