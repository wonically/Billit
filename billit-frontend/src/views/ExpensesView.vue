<template>
  <div>
    <h2>Expenses</h2>
    <div class="filters" style="display: flex; gap: 1rem; margin-bottom: 1rem; align-items: center;">
      <div>
        <label for="start_date">Start Date</label>
        <input id="start_date" type="date" v-model="filters.start_date" @change="onFilterChange" />
      </div>
      <div>
        <label for="end_date">End Date</label>
        <input id="end_date" type="date" v-model="filters.end_date" @change="onFilterChange" />
      </div>
      <div>
        <label for="category">Category</label>
        <Listbox v-model="filters.category" @change="onFilterChange">
          <ListboxButton>{{ selectedCategoryLabel }}</ListboxButton>
          <ListboxOptions>
            <ListboxOption v-for="cat in categories" :key="cat.value" :value="cat.value">
              {{ cat.label }}
            </ListboxOption>
          </ListboxOptions>
        </Listbox>
      </div>
    </div>
    <Table>
      <thead>
        <tr>
          <th>Description</th>
          <th>Amount</th>
          <th>Date</th>
          <th>Category</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="expense in expenses" :key="expense.id">
          <td>{{ expense.description }}</td>
          <td>{{ expense.amount }}</td>
          <td>{{ expense.expense_date }}</td>
          <td>{{ expense.category }}</td>
          <td>
            <button type="button" @click="editExpense(expense.id)">Edit</button>
            <button type="button" @click="deleteExpense(expense.id)">Delete</button>
          </td>
        </tr>
      </tbody>
    </Table>
  </div>
</template>

<script setup>
import { ref, onMounted, computed, watch } from 'vue'
import { Table, Listbox, ListboxButton, ListboxOptions, ListboxOption } from '@headlessui/vue'

const expenses = ref([])

const categories = [
  { value: '', label: 'All' },
  { value: 'travel', label: 'Travel' },
  { value: 'meals', label: 'Meals' },
  { value: 'office', label: 'Office' },
  { value: 'software', label: 'Software' },
  { value: 'other', label: 'Other' }
]

const filters = ref({
  start_date: '',
  end_date: '',
  category: ''
})

const selectedCategoryLabel = computed(() => {
  const found = categories.find(c => c.value === filters.value.category)
  return found ? found.label : 'All'
})

async function fetchExpenses() {
  const params = new URLSearchParams()
  if (filters.value.start_date) params.append('start_date', filters.value.start_date)
  if (filters.value.end_date) params.append('end_date', filters.value.end_date)
  if (filters.value.category) params.append('category', filters.value.category)
  const res = await fetch(`/expenses?${params.toString()}`)
  expenses.value = await res.json()
}

function onFilterChange() {
  fetchExpenses()
}

function editExpense(id) {
  // Placeholder for edit logic
}

function deleteExpense(id) {
  // Placeholder for delete logic
}

onMounted(fetchExpenses)
</script>
