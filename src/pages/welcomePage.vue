<template>
  <!-- modify this page to summary page if there is time left at the end -->
  <div id="welcomePage">
    <img src="@/assets/logo.png">
    <h1>{{ msg }}</h1>
    <h2>
      <!-- turn to home page of user's blog -->
      <router-link :to="{name:'homePage', params:{userID}}">Enter</router-link>
    </h2>
  </div>
</template>

<script>
  import {
    mapState
  } from "vuex";
  export default {
    name: "welcomePage",
    data() {
      return {
        userID: 1
      };
    },
    computed: {
      ...mapState("welcome", ["msg"])
    }
  };

</script>
<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
  #welcomePage {
    font-family: "Avenir", Helvetica, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    text-align: center;
    color: #2c3e50;
    position: absolute;
    top: 0;
    background-color: #f1f1f1;
    padding: 10vh 0 0;
    width: 100vw;
  }

  li {
    display: inline-block;
    margin: 0 10px;
  }

  a {
    color: #42b983;
  }

  h1 {
    margin: 1em 0;
    font-size: 9vw;
  }

</style>
