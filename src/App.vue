<template>
  <transition :name="slideDirection" >
    <keep-alive>
      <router-view/>
    </keep-alive>
  </transition>
</template>

<script>
  export default {
    name: "App",
    data() {
      return {
        slideDirection: ''
      }
    },
    watch: {
      '$route' (to, from) {
        let isBack = this.$router.isBack;
        if (isBack) {
          this.slideDirection = 'slide-right';
          this.$router.isBack = false;
        } else {
          this.slideDirection = 'slide-left';
        }
        if (from.path == '/createArticle' || from.path == '/createTrend') {
          this.slideDirection = 'slide-right';
        }
      }
    }
  };
</script>

<style>
  .slide-left-enter-active {
    transition: all .5s;
    position: absolute;
    z-index: 99;
  }

  .slide-left-enter {
    transform: translateX(100%);
  }

  .slide-left-leave-active {
    transition: all 5s;
    position: absolute;
    z-index: -1;
  }

  .slide-left-leave-to {
    opacity: 0;
  }

  .slide-right-leave-active {
    transition: all .5s;
    position: absolute;
    top: 0;
    z-index: 100;
  }

  .slide-right-leave-to {
    transform: translateX(100%);
  }

  .slide-right-enter-active {
    transition: all .1s;
    position: absolute;
    top: 0;
    z-index: -1;
  }

  .slide-right-enter {
    opacity: 0;
  }

  html,
  body,
  h1,
  h2,
  h3,
  h4,
  h5,
  ul,
  li,
  p {
    padding: 0;
    margin: 0;
  }

  html,
  body {
    background-color: #f1f1f1;
  }

  ul {
    list-style-type: none;
    padding: 0;
  }

  h1,
  h2 {
    font-weight: normal;
  }
</style>