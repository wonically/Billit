<template>
  <form @submit.prevent="submitForm">
    <div>
      <label for="description">Description</label>
      <input id="description" type="text" v-model="form.description" />
    </div>

    <div>
      <label for="amount">Amount</label>
      <input id="amount" type="number" v-model="form.amount" min="0" step="0.01" />
    </div>

    <div>
      <label for="date">Date</label>
      <input id="date" type="date" v-model="form.date" />
    </div>

    <div>
      <label for="category">Category</label>
      <Listbox v-model="form.category">
        <ListboxButton>{{ selectedCategoryLabel }}</ListboxButton>
        <ListboxOptions>
          <ListboxOption v-for="cat in categories" :key="cat" :value="cat">
            {{ cat }}
          </ListboxOption>
        </ListboxOptions>
      </Listbox>
    </div>

    <div>
      <label for="receipt">Receipt</label>
      <input id="receipt" type="file" @change="handleFile" />
    </div>

    <button type="submit">Submit</button>
  </form>
</template>

<script setup>
import { ref, computed } from 'vue'
import { Listbox, ListboxButton, ListboxOptions, ListboxOption } from '@headlessui/vue'

const categories = ['office', 'travel', 'utilities', 'other']

const form = ref({
  description: '',
  amount: '',
  date: '',
  category: '',
  receipt: null
})

const selectedCategoryLabel = computed(() => form.value.category || 'Select category')

function handleFile(e) {
  form.value.receipt = e.target.files[0]
}

async function submitForm() {
  const data = new FormData()
  data.append('expense[description]', form.value.description)
  data.append('expense[amount]', form.value.amount)
  data.append('expense[date]', form.value.date)
  data.append('expense[category]', form.value.category)
  if (form.value.receipt) {
    data.append('expense[receipt]', form.value.receipt)
  }

  const method = form.value.id ? 'PATCH' : 'POST'
  const url = form.value.id ? `/expenses/${form.value.id}` : '/expenses'

  await fetch(url, {
    method,
    body: data
  })
}
</script>
