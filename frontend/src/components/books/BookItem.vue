<template>
  <article class="p-4 flex space-x-4">
    <img src="@/assets/book.svg" alt="Обложка книги" class="flex-none w-18 h-18 object-cover" width="100" height="100" />
    <div class="min-w-0 relative flex-auto sm:pr-20 lg:pr-0 xl:pr-20">
      <h2 class="text-lg font-semibold text-black mb-0.5">
        {{ book.name }}
      </h2>

      <dl class="flex flex-wrap text-sm font-medium whitespace-pre">

        <div class="flex-none w-full mt-0.5 font-normal">
          <dt class="inline">Автор: </dt>
          <dd class="inline text-black">{{ book.author.last_name }} {{ book.author.first_name }} {{ book.author.middle_name }}</dd>
        </div>
        <div class="absolute top-0 right-0 rounded-full bg-amber-50 text-amber-900 px-2 py-0.5 hidden sm:flex lg:hidden xl:flex items-center space-x-1">
          <a href="#" class="ml-8 whitespace-nowrap inline-flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-base font-medium text-white bg-indigo-600 hover:bg-indigo-700">
            Подробнее
          </a>
        </div>
      </dl>
    </div>

 </article>
</template>
<script>

export default {
  props: ['book'],
}

</script>
