<script setup>
import { ref, onMounted } from 'vue'

const isDark = ref(false)

function applyTheme() {
  if (isDark.value) {
    document.documentElement.classList.add('dark')
    localStorage.setItem('theme', 'dark')
  } else {
    document.documentElement.classList.remove('dark')
    localStorage.setItem('theme', 'light')
  }
}

function toggleTheme() {
  isDark.value = !isDark.value
  applyTheme()
}

onMounted(() => {
  const saved = localStorage.getItem('theme')
  isDark.value = saved === 'dark'
  applyTheme()
})
</script>

<template>
  <button
    @click="toggleTheme"
    class="px-3 py-2 rounded bg-gray-200 dark:bg-gray-700 text-gray-800 dark:text-gray-100 transition"
  >
    {{ isDark ? '🌙 Dark' : '☀️ Light' }}
  </button>
</template>