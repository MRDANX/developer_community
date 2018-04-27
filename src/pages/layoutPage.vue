<template>
  <div id="homePage">
    <keep-alive>
      <router-view />
    </keep-alive>
    <ul class="fixed-nav">
      <router-link tag="li" to="/home" class="fa fa-home" />
      <router-link tag="li" to="/comment" class="fa fa-comments" />
      <router-link tag="li" to="/search" class="fa fa-search" />
      <router-link tag="li" to="/setting" class="fa fa-user" />
    </ul>
  </div>
</template>

<script>
  export default {
    name: "homePage"
  };

</script>

<style lang='less' scoped>
  #homePage {
    width: 100%;
    height: 800px;
    background-color: #f1f1f1;
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
        color: #8d8d77;
        position: relative;
        line-height: 9vh;
        &:nth-child(3) {
          font-size: 4.5vh;
        }
      }
    }
  }

</style>
