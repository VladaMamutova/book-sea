<template>
  <div class="hover:shadow-lg group block rounded-lg px-8 py-6 border border-gray-200">
    <div class="flex space-x-4">

      <div class="flex flex-initial items-center">
        <img img src="@/assets/book.svg" alt="Обложка книги" class="flex-none object-cover" width="100" height="100" />
      </div>
  
      <div class="flex-auto px-6 py-4 space-y-1.5">
        <h2 class="text-xl font-semibold text-black">
          {{ book.name }}
        </h2>     

        <div class="flex-wrap text-base text-gray-700 font-normal">
          {{ book.author.last_name }} {{ book.author.first_name }} {{ book.author.middle_name }}
        </div>
      </div>
      
      <div class="rounded-full bg-amber-50 text-amber-900 items-center flex pr-4">
        <a href="#" class="whitespace-nowrap inline-flex items-center justify-center px-4 py-2 rounded-md shadow-sm text-base font-medium text-indigo-600 border border-indigo-400 hover:border-indigo-500 hover:text-indigo-700">
          Подробнее
        </a>
      </div>
      
    </div>
  </div>

</template>
<script>

export default {
  props: ['book'],
}

</script>
