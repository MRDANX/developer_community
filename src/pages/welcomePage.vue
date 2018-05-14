<template>
  <!-- modify this page to summary page if there is time left at the end -->
  <div id="welcomePage">
    <img src="/static/images/logo.png">
    <h1>{{ msg }}</h1>
    <h2>
      <!-- turn to home page of user's blog -->
      <keep-alive>
        <router-link :to="{name:'subject', params:{subject:'index'}}">Enter</router-link>
      </keep-alive>
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
    background-color: #f1f1f1;
    width: 100vw;
    height: 100vh;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
  }

  li {
    display: inline-block;
    margin: 0 10px;
  }

  a {
    color: #42b983;
  }

  h1 {
    margin: 5vh 0;
    font-size: 9vw;
  }

  h2 {
    font-size: 8vw;
  }

  h2 a {
    font-size: 8vw;
  }

</style>
