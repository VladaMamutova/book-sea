<template>
  <li>
    <a
      :href="href"
      :class="['block px-4 py-2 rounded-md text-lg text-gray-500', { 'text-indigo-700 bg-indigo-200': isActive }]"
    >
      <slot></slot>
    </a>
  </li>
</template>

<script>
export default {
  props: {
    href: {
      type: String,
      required: true,
    },
    isActive: Boolean,
  }
}
</script>
