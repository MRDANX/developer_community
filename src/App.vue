<template>
  <transition :name="slideDirection">
    <keep-alive exclude="articleDetail">
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
          this.slideDirection = 'outter-slide-right';
          this.$router.isBack = false;
        } else {
          this.slideDirection = 'outter-slide-left';
        }
        if (from.name == 'createArticle' || from.name == 'createTrend' || from.name == 'articleDetail' || from.name ==
          'userDetail' || from.name == 'subjectDetail') {
          this.slideDirection = 'outter-slide-right';
        }
        if (from.path == '/') {
          this.slideDirection = '';
        }
      }
    }
  };

</script>

<style>
  .outter-slide-left-enter-active {
    transition: all .5s;
    position: absolute;
    z-index: 99;
  }

  .outter-slide-left-enter {
    transform: translateX(100%);
  }

  .outter-slide-left-leave-active {
    transition: all 0s .5s;
    position: absolute;
    z-index: -1;
  }

  .outter-slide-left-leave-to {
    opacity: 0;
  }

  .outter-slide-right-leave-active {
    transition: all .5s;
    position: absolute;
    top: 0;
    z-index: 100;
  }

  .outter-slide-right-leave-to {
    transform: translateX(100%);
  }

  .outter-slide-right-enter-active {
    transition: all 0s;
    position: absolute;
    top: 0;
    z-index: -1;
  }

  .outter-slide-right-enter {
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

  html {
    -ms-overflow-style: none;
    overflow: -moz-scrollbars-none;
  }

  html::-webkit-scrollbar {
    width: 0px;
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
