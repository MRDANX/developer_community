<template>
<div id="homePage">
  <nav>nav</nav>
  <section class="home-content">
    <side-bar class="side-bar"></side-bar>
    <!-- auto set the router view according to the route -->
    <router-view class="article-container"></router-view>
  </section>
  <footer>welcome to {{userName}} blog.</footer>
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
  components: {
    sideBar
  },
  created() {
    this.$store.dispatch("home/initializeHomePage");
  }
};
</script>

<style lang='less' scoped>
#homePage {
  display: flex;
  flex-direction: column;
  nav {
    width: 100%;
    height: 80px;
    background-color: #e0eee8;
    text-align: center;
    font-size: 30px;
  }
  section.home-content {
    display: flex;
    flex-direction: row;
    justify-content: center;
    margin: 30px 0;
    .side-bar {
      width: 18%;
      height: 800px;
      background-color: #3de1ad;
      margin-right: 10px;
    }
    .article-container {
      width: 60%;
      height: 800px;
      background-color: #7fecad;
      margin-left: 10px;
      border-radius: 30px;
      overflow: hidden;
    }
  }
  footer {
    width: 100%;
    height: 100px;
    text-align: center;
    font-size: 30px;
    background-color: #bacac6;
  }
}
</style>
