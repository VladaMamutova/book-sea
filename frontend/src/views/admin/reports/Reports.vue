<template>
  <div class="container mx-auto px-16 py-6">
    <div class="flex flex-col">
      <div class="flex justify-center">
        <Nav>
          <NavItem href="#" :isActive="genrePopularityReport" @click.native="switchTab">Популярность жанров</NavItem>
          <NavItem href="#" :isActive="!genrePopularityReport" @click.native="switchTab">Возврат книг</NavItem>
        </Nav>
      </div>
      <div class="flex justify-center mt-6">
        <GenreTable v-if="genrePopularityReport"></GenreTable>
        <UserBooksTable v-else></UserBooksTable>
      </div>
    </div>
  </div>
</template>

<script>
import Nav from '@/components/admin/reports/Nav.vue'
import NavItem from '@/components/admin/reports/NavItem.vue'
import GenreTable from '../../../components/admin/reports/GenreTable.vue'
import UserBooksTable from '../../../components/admin/reports/UserBooksTable.vue'

export default {
  components: {
    Nav,
    NavItem,
    GenreTable,
    UserBooksTable
  },
  data() {
    return {
      genrePopularityReport: true
    }
  },
  methods: {
    switchTab () {
      this.genrePopularityReport = !this.genrePopularityReport
    }
  }
}
</script>
