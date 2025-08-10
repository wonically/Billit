<template>
  <div>
    <div class="kpi-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 1.5rem; margin-bottom: 2rem;">
      <Card>
        <div class="card-header"><h3>Total Revenue</h3></div>
        <div class="card-body" style="font-size: 2rem; font-weight: bold;">{{ kpisLoading ? 'Loading...' : kpis.total_revenue }}</div>
      </Card>
      <Card>
        <div class="card-header"><h3>Total Expenses</h3></div>
        <div class="card-body" style="font-size: 2rem; font-weight: bold;">{{ kpisLoading ? 'Loading...' : kpis.total_expenses }}</div>
      </Card>
      <Card>
        <div class="card-header"><h3>Overdue Invoices</h3></div>
        <div class="card-body" style="font-size: 2rem; font-weight: bold;">{{ kpisLoading ? 'Loading...' : kpis.overdue_invoice_count }}</div>
      </Card>
    </div>
    <Card>
      <div class="card-header">
        <h3>Revenue Over Time</h3>
      </div>
      <div class="card-body" style="height: 350px;">
        <div v-if="loading" style="display: flex; align-items: center; justify-content: center; height: 100%;">
          Loading...
        </div>
        <BarChart v-else :width="600" :height="300" :data="chartData">
          <XAxis dataKey="month" />
          <YAxis />
          <Tooltip />
          <Bar dataKey="revenue" fill="#4F46E5" />
        </BarChart>
      </div>
    </Card>
    <Card style="margin-top: 2rem;">
      <div class="card-header">
        <h3>Expense Split</h3>
      </div>
      <div class="card-body" style="height: 350px;">
        <div v-if="loadingExpense" style="display: flex; align-items: center; justify-content: center; height: 100%;">
          Loading...
        </div>
        <PieChart v-else :width="600" :height="300">
          <Pie :data="expenseData" dataKey="total" nameKey="category" cx="50%" cy="50%" outerRadius="120" fill="#4F46E5" label />
          <Tooltip />
        </PieChart>
      </div>
    </Card>
    <Card style="margin-top: 2rem;">
      <div class="card-header">
        <h3>Invoice Status</h3>
      </div>
      <div class="card-body" style="height: 350px;">
        <div v-if="loadingStatus" style="display: flex; align-items: center; justify-content: center; height: 100%;">
          Loading...
        </div>
        <PieChart v-else :width="600" :height="300">
          <Pie :data="statusData" dataKey="count" nameKey="status" cx="50%" cy="50%" innerRadius="70" outerRadius="120" fill="#4F46E5" label />
          <Tooltip />
        </PieChart>
      </div>
    </Card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { Card } from '@headlessui/vue'
import { BarChart, Bar, XAxis, YAxis, Tooltip, PieChart, Pie } from 'recharts'

const chartData = ref([])
const loading = ref(true)
const expenseData = ref([])
const loadingExpense = ref(true)
const statusData = ref([])
const loadingStatus = ref(true)
const kpis = ref({ total_revenue: 0, total_expenses: 0, overdue_invoice_count: 0 })
const kpisLoading = ref(true)

async function fetchKPIs() {
  kpisLoading.value = true
  const res = await fetch('/analytics/kpis')
  kpis.value = await res.json()
  kpisLoading.value = false
}

async function fetchRevenue() {
  loading.value = true
  const res = await fetch('/analytics/monthly_revenue')
  chartData.value = await res.json()
  loading.value = false
}

async function fetchExpenseSplit() {
  loadingExpense.value = true
  const res = await fetch('/analytics/expense_category_breakdown')
  expenseData.value = await res.json()
  loadingExpense.value = false
}

async function fetchStatusSummary() {
  loadingStatus.value = true
  const res = await fetch('/invoices/status_summary')
  statusData.value = await res.json()
  loadingStatus.value = false
}

onMounted(() => {
  fetchKPIs()
  fetchRevenue()
  fetchExpenseSplit()
  fetchStatusSummary()
})
</script>
