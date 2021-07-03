<template>
  <div class="hover:shadow-lg group block rounded-lg px-8 py-6 border border-gray-200">
    <div class="flex space-x-4">

    <div class="flex-auto py-4 space-y-2">
        <h2>
          <router-link class="text-xl font-bold text-black hover:underline hover:text-indigo-700"
            :to="{ name: 'LibraryBooks', params: { library_uid: library.library_uid, library: library }}">
            {{ library.name }}
          </router-link>
        </h2>

        <div class="flex-wrap text-base text-gray-700 font-normal">
          г. {{ library.city }}, {{ library.address }}
        </div>
      </div>
           
      <div v-if="available_count > 0" class="rounded-full items-center flex pr-4">
        <a href="#" class="whitespace-nowrap inline-flex items-center justify-center px-4 py-2 rounded-md shadow-sm text-base font-medium text-indigo-600 border border-indigo-400 hover:border-indigo-500 hover:text-indigo-700">
          Взять в библиотеке
        </a>
      </div>
      <div v-else class="items-center flex pr-4 font-medium text-gray-500">
        Нет в наличии
      </div>
      
    </div>
  </div>

</template>

<script>

export default {
  name: 'BookLibraryItem',
  props: {
    library: {
      type: Object,
      required: true
    },
    available_count: {
      type: Number,
      required: true
    }
  }
}

</script>
