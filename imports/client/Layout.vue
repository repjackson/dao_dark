<template>
  <div>
    <div v-blaze="'nav'"></div>
    <!-- Our navbar wasn't migrated. Let me leave it as is. -->
    <component v-if="type === 'vue'" :is="body ? body : not-found"></component>
    <!-- We load it as a Vue component if type === 'vue'. -->
    <div v-else-if="body" v-blaze="body"></div>
    <!-- Else we just load it as a Blaze template. -->
    <layout-footer></layout-footer>
    <!-- We have migrated the footer, so just import it as a Vue component. -->
  </div>
</template>
<script>
  // import LayoutFooter from './layoutFooter.vue';
  // import YourPageComponent from '../pages/vue/yourPage.vue'; 
  // Import other page components there,

  export default {
    props: {
      type: { type: String },
      body: { type: String },
    },
    components: { /* and add them there. */ },
  };
</script>
