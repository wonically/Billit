<template>
  <TransitionRoot as="template" :show="open">
    <Dialog as="div" class="fixed inset-0 z-50 overflow-y-auto" @close="onClose">
      <div class="flex items-center justify-center min-h-screen px-4">
        <TransitionChild
          as="template"
          enter="ease-out duration-300"
          enter-from="opacity-0"
          enter-to="opacity-100"
          leave="ease-in duration-200"
          leave-from="opacity-100"
          leave-to="opacity-0"
        >
          <DialogOverlay class="fixed inset-0 bg-black bg-opacity-30" />
        </TransitionChild>
        <span class="inline-block align-middle h-screen" aria-hidden="true">&#8203;</span>
        <TransitionChild
          as="template"
          enter="ease-out duration-300"
          enter-from="opacity-0 scale-95"
          enter-to="opacity-100 scale-100"
          leave="ease-in duration-200"
          leave-from="opacity-100 scale-100"
          leave-to="opacity-0 scale-95"
        >
          <div class="inline-block bg-white dark:bg-gray-800 rounded-lg px-6 py-8 shadow-xl w-full max-w-md align-middle">
            <DialogTitle class="text-lg font-semibold mb-4">
              <slot name="title">Modal Title</slot>
            </DialogTitle>
            <div class="mb-4">
              <slot />
            </div>
            <div class="flex justify-end gap-2">
              <slot name="actions">
                <button @click="onClose" class="px-4 py-2 rounded bg-gray-200 hover:bg-gray-300 dark:bg-gray-700 dark:hover:bg-gray-600">Close</button>
              </slot>
            </div>
          </div>
        </TransitionChild>
      </div>
    </Dialog>
  </TransitionRoot>
</template>

<script setup>
import { Dialog, DialogOverlay, DialogTitle, TransitionRoot, TransitionChild } from '@headlessui/vue'
import { defineProps, defineEmits } from 'vue'

const props = defineProps({
  open: { type: Boolean, required: true }
})
const emit = defineEmits(['close'])

function onClose() {
  emit('close')
}
</script>

<style scoped>
/* Add any custom modal styles here */
</style>
