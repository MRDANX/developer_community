<template>
  <div id="homePage">
    <!-- <transition name="fade" mode="out-in"> -->
    <keep-alive>
      <router-view />
    </keep-alive>
    <!-- </transition> -->
    <ul class="fixed-nav">
      <router-link tag="li" to="/subject" class="fa fa-home" />
      <router-link tag="li" to="/comment" class="fa fa-comments" />
      <router-link tag="li" to="/search" class="fa fa-search" />
      <router-link tag="li" to="/setting" class="fa fa-user" />
    </ul>
  </div>
</template>

<script>
  export default {
    name: "layoutPage"
  };

</script>

<style lang='less'>
  .fade-enter-active,
  .fade-leave-active {
    transition: all .3s;
    position: absolute;
  }

  .fade-enter,
  .fade-leave-to {
    opacity: 0;
  }

  #homePage {
    width: 100%;
    background-color: #F5F6FA;
    ul.fixed-nav {
      display: flex;
      justify-content: space-around;
      position: fixed;
      left: 0;
      bottom: 0;
      z-index: 99;
      width: 100vw;
      height: 9vh;
      font-size: 5vh;
      background-color: white;
      box-shadow: 0 -2px 10px #CCCC99;
      li {
        color: #C8CBD4;
        position: relative;
        line-height: 9vh;
        transition: all .2s;
        &:nth-child(3) {
          font-size: 4.5vh;
        }
        &.router-link-active {
          color: #0080FF;
        }
      }
    }
  }

</style>
