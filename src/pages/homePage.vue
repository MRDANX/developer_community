<template>
  <div id="homePage">
    <!-- <span @click="togglePopup">showPopup</span>
    <mt-popup v-model="popupVisible" position="right" class="popup">
      <mt-button @click="togglePopup" type="primary" size="normal">close</mt-button>
    </mt-popup> -->
    <!-- <nav>nav</nav> -->
    <!-- <section class="home-content"> -->
    <!-- <transition-group name="flip" tag="section" class="home-content"> -->
    <!-- <side-bar class="side-bar"></side-bar> -->
    <!-- auto set the router view according to the route -->
    <!-- <transition name="fade" mode="out-in"> -->
    <!-- <keep-alive> -->
    <!-- <router-view class="article-container"></router-view> -->
    <!-- </keep-alive> -->
    <!-- </transition> -->
    <!-- </transition-group> -->
    <!-- </section> -->
    <!-- <footer>welcome to {{userName}} blog.</footer> -->
    <transition>
      <keep-alive>
        <router-view></router-view>
      </keep-alive>
    </transition>
    <nav class="fixed-nav"></nav>
  </div>
</template>

<script>
  import {
    mapState
  } from "vuex";

  export default {
    name: "homePage",
    data() {
      return {};
    },
    computed: {
      ...mapState("home", ["userName"])
    },
    created() {
      this.$store.dispatch("home/initializeHomePage");
    }
  };

</script>

<style lang='less' scoped>
  #homePage {
    width: 100%;
    height: 800px;
    background-color: #f1f1f1;
    position: absolute;
    top: 0;
    nav.fixed-nav {
      position: fixed;
      left: 0;
      bottom: 0;
      z-index: 99;
      width: 100vw;
      height: 8vh;
      text-align: center;
      font-size: 5vw;
      background-color: #bacac6;
    }
  }

</style>
