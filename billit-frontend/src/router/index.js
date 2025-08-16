import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    component: () => import('../views/Home.vue')
  },
  {
    path: '/invoices',
    component: () => import('../views/InvoicesView.vue')
  },
  {
    path: '/expenses',
    component: () => import('../views/ExpensesView.vue')
  },
  {
    path: '/login',
    component: () => import('../views/Login.vue')
  }
]


const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  const publicPages = ['/login']
  const authRequired = !publicPages.includes(to.path)
  const token = localStorage.getItem('authToken')
  if (authRequired && !token) {
    return next('/login')
  }
  next()
})

export default router
