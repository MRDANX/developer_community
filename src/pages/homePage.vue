<template>
  <div id="homePage">
      <nav>nav</nav>
      <side-bar></side-bar>
      <!-- auto set the router view according to the name property -->
      <router-view></router-view>
      welcome to {{userName}} blog.
  </div>
</template>

<script>
import { mapState } from "vuex";
import sideBar from "@/components/sideBar";
export default {
  name: "homePage",
  data() {
    return {
    //   //the alternative values are 'articleList' or 'articleDetail'
    //   currentView: "articleList"
    };
  },
  computed: {
    ...mapState("home", ["userName"])
  },
  components:{
      sideBar
  },
  created() {
    this.$store.dispatch("home/initializeHomePage");
  }
};
</script>

<style>

</style>
