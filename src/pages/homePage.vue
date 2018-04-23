<template>
  <div id="homePage">
      welcome to {{userName}} blog.
  </div>
</template>

<script>
import { mapState } from "vuex";
export default {
  name:'homePage',
  data(){
      return {

      }
  },
  computed:{
      ...mapState('home',['userName'])
  },
  created(){
      this.$store.dispatch('home/initializeHomePage');
  }
}
</script>

<style>

</style>
