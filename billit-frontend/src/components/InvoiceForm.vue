<template>
  <form>
    <div>
      <label for="client">Client</label>
      <Listbox v-model="form.clientId">
        <ListboxButton>{{ selectedClientName }}</ListboxButton>
        <ListboxOptions>
          <ListboxOption v-for="client in clients" :key="client.id" :value="client.id">
            {{ client.name }}
          </ListboxOption>
        </ListboxOptions>
      </Listbox>
    </div>

    <div>
      <label for="invoiceDate">Invoice Date</label>
      <input id="invoiceDate" type="date" v-model="form.invoiceDate" />
    </div>

    <div>
      <label for="dueDate">Due Date</label>
      <input id="dueDate" type="date" v-model="form.dueDate" />
    </div>

    <div>
      <label for="tax">Tax Rate (%)</label>
      <input id="tax" type="number" v-model="form.tax" min="0" step="0.01" />
    </div>

    <div>
      <label for="discount">Discount Amount</label>
      <input id="discount" type="number" v-model="form.discount" min="0" step="0.01" />
    </div>

    <div>
      <h3>Line Items</h3>
      <div v-for="(item, idx) in lineItems" :key="idx">
        <input type="text" v-model="item.description" placeholder="Description" />
        <input type="number" v-model.number="item.quantity" min="1" placeholder="Quantity" />
        <input type="number" v-model.number="item.unitPrice" min="0" step="0.01" placeholder="Unit Price" />
        <button type="button" @click="removeLineItem(idx)">Remove</button>
      </div>
      <button type="button" @click="addLineItem">Add Item</button>
    </div>

    <div>
      <h3>Totals</h3>
      <div>Subtotal: {{ subtotal }}</div>
      <div>Tax: {{ tax }}</div>
      <div>Total: {{ total }}</div>
    </div>
  </form>
</template>

<script setup>
import { ref, computed } from 'vue'
import { Listbox, ListboxButton, ListboxOptions, ListboxOption } from '@headlessui/vue'

const clients = ref([
  // Example: { id: 1, name: 'Client A' }
])

const form = ref({
  clientId: null,
  invoiceDate: '',
  dueDate: '',
  tax: '',
  discount: ''
})

const lineItems = ref([])

function addLineItem() {
  lineItems.value.push({ description: '', quantity: 1, unitPrice: 0 })
}

function removeLineItem(idx) {
  lineItems.value.splice(idx, 1)
}

const selectedClientName = computed(() => {
  const client = clients.value.find(c => c.id === form.value.clientId)
  return client ? client.name : 'Select client'
})

const subtotal = computed(() => {
  return lineItems.value.reduce((sum, item) => {
    return sum + (Number(item.quantity) * Number(item.unitPrice))
  }, 0)
})

const tax = computed(() => {
  const rate = Number(form.value.tax) || 0
  return subtotal.value * (rate / 100)
})

const total = computed(() => {
  const discount = Number(form.value.discount) || 0
  return subtotal.value + tax.value - discount
})
</script>
