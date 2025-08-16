<script setup>
import { ref, computed, onMounted } from 'vue'
import Sidebar from './components/Sidebar.vue'
import ThemeToggle from './components/ThemeToggle.vue'

const sidebarOpen = ref(false)
const showMobileNav = computed(() => window.innerWidth < 768)
const showSidebar = computed(() => window.innerWidth >= 768 || sidebarOpen.value)

function toggleSidebar() {
  sidebarOpen.value = !sidebarOpen.value
}

function handleResize() {
  if (window.innerWidth >= 768) {
    sidebarOpen.value = false
  }
}

onMounted(() => {
  window.addEventListener('resize', handleResize)
})
</script>

<template>
  <div class="min-h-screen bg-gray-50">
    <nav
      class="bg-white shadow-md px-4 py-3 flex items-center justify-between md:hidden"
      v-if="showMobileNav"
    >
      <div class="text-xl font-bold">Billit</div>
        <ThemeToggle />
      <button @click="toggleSidebar" class="text-gray-500 focus:outline-none">
        <svg v-if="!sidebarOpen" xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none"
          viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
            d="M4 6h16M4 12h16M4 18h16" />
        </svg>
        <svg v-else xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none"
          viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
            d="M6 18L18 6M6 6l12 12" />
        </svg>
      </button>
    </nav>
    <div class="flex">
      <aside
        :class="[
          'bg-white shadow-md h-screen md:w-64 w-full fixed md:static top-0 left-0 z-40 transition-transform duration-200',
          sidebarOpen ? 'translate-x-0' : '-translate-x-full md:translate-x-0'
        ]"
        v-if="showSidebar"
      >
        <Sidebar />
      </aside>
      <main
        :class="[
          'flex-1 transition-all duration-200',
          'p-4 md:p-8',
          sidebarOpen && !showSidebar ? 'ml-0' : 'md:ml-64'
        ]"
      >
        <div class="max-w-7xl mx-auto">
          <router-view />
        </div>
      </main>
    </div>
  </div>
</template>

<style>
body {
  @apply bg-gray-50;
}
</style>
