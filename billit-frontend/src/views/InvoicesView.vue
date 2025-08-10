<template>
  <div>
    <h2>Invoices</h2>
    <Table>
      <thead>
        <tr>
          <th>Client</th>
          <th>Invoice Date</th>
          <th>Due Date</th>
          <th>Total</th>
          <th>Status</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="invoice in invoices" :key="invoice.id">
          <td>{{ invoice.client_name }}</td>
          <td>{{ invoice.invoice_date }}</td>
          <td>{{ invoice.due_date }}</td>
          <td>{{ invoice.total }}</td>
          <td>{{ invoice.status }}</td>
          <td>
            <button type="button" @click="editInvoice(invoice.id)">Edit</button>
            <button type="button" @click="deleteInvoice(invoice.id)">Delete</button>
          </td>
        </tr>
      </tbody>
    </Table>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { Table } from '@headlessui/vue'

const invoices = ref([])

async function fetchInvoices() {
  const res = await fetch('/invoices')
  invoices.value = await res.json()
}

function editInvoice(id) {
  // Placeholder for edit logic
}

function deleteInvoice(id) {
  // Placeholder for delete logic
}

onMounted(fetchInvoices)
</script>
