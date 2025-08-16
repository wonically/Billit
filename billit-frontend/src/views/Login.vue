<template>
  <div class="flex flex-col items-center justify-center h-full py-16">
    <h1 class="text-2xl font-bold mb-4">Login</h1>
    <form @submit.prevent="login" class="w-full max-w-sm bg-white dark:bg-gray-800 p-6 rounded shadow">
      <div class="mb-4">
        <label class="block mb-1 font-medium" for="email">Email</label>
        <input v-model="email" id="email" type="email" class="w-full px-3 py-2 border rounded" required />
      </div>
      <div class="mb-6">
        <label class="block mb-1 font-medium" for="password">Password</label>
        <input v-model="password" id="password" type="password" class="w-full px-3 py-2 border rounded" required />
      </div>
      <button type="submit" class="w-full px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">Login</button>
      <div v-if="error" class="mt-4 text-red-600">{{ error }}</div>
    </form>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const email = ref('')
const password = ref('')
const error = ref('')
const router = useRouter()

async function login() {
  error.value = ''
  try {
    const res = await fetch('http://localhost:3000/api/users/sign_in', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: JSON.stringify({ user: { email: email.value, password: password.value } })
    })
    const data = await res.json()
    if (!res.ok) {
      // Show server error message if available
      error.value = data.error || data.message || 'Invalid credentials'
      return
    }
    if (!data.token) {
      error.value = 'No token received from server.'
      return
    }
    localStorage.setItem('authToken', data.token)
    router.push('/')
  } catch (e) {
    error.value = e.message
  }
}
</script>

<style scoped>
/* Add any custom styles for the login page here */
</style>
