<template>
  <nav :class="['h-full flex flex-col gap-2 pt-6 transition-all', collapsed ? 'w-16' : 'w-64']">
    <SidebarLink to="/dashboard" icon="home" label="Dashboard" :collapsed="collapsed" />
    <SidebarLink to="/invoices" icon="document-text" label="Invoices" :collapsed="collapsed" />
    <SidebarLink to="/expenses" icon="credit-card" label="Expenses" :collapsed="collapsed" />
    <SidebarLink to="/analytics" icon="chart-bar" label="Analytics" :collapsed="collapsed" />
    <SidebarLink to="/settings" icon="cog" label="Settings" :collapsed="collapsed" />
  </nav>
</template>

<script setup>
import { ref, onMounted, defineComponent, computed } from 'vue'
import { useRoute } from 'vue-router'

const collapsed = ref(window.innerWidth < 768)
function handleResize() {
  collapsed.value = window.innerWidth < 768
}
onMounted(() => {
  window.addEventListener('resize', handleResize)
})

const icons = {
  home: 'M3 12l2-2m0 0l7-7 7 7M13 5v6h6',
  'document-text': 'M9 12h6m-6 4h6M7 8h10M5 20h14a2 2 0 002-2V7a2 2 0 00-2-2H7a2 2 0 00-2 2v11a2 2 0 002 2z',
  'credit-card': 'M2 7a2 2 0 012-2h16a2 2 0 012 2v10a2 2 0 01-2 2H4a2 2 0 01-2-2V7zm0 0h20',
  'chart-bar': 'M3 3v18h18M9 17V9m4 8V5m4 8v-4',
  cog: 'M12 15.5A3.5 3.5 0 1112 8.5a3.5 3.5 0 010 7zm7.5-3.5a7.5 7.5 0 01-15 0m15 0a7.5 7.5 0 01-15 0'
}

const SidebarLink = defineComponent({
  props: {
    to: String,
    icon: String,
    label: String,
    collapsed: Boolean
  },
  setup(props) {
    const route = useRoute()
    const isActive = computed(() => route.path === props.to)
    return { isActive, icons }
  },
  template: `
    <router-link
      :to="to"
      class="flex items-center gap-3 px-4 py-2 rounded-lg transition-colors"
      :class="[isActive ? 'bg-indigo-100 text-indigo-700 font-semibold' : 'text-gray-700 hover:bg-gray-100', collapsed ? 'justify-center px-2' : '']"
    >
      <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
        <path :d="icons[icon]" stroke-linecap="round" stroke-linejoin="round" />
      </svg>
      <span v-if="!collapsed">{{ label }}</span>
    </router-link>
  `
})
</script>
