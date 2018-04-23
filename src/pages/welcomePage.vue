<template>
  <!-- 后期若有时间，此页面改为博文汇总页面 -->
  <div id="welcomePage">
    <img src="@/assets/logo.png">
    <h1>{{ msg }}</h1>
    <h2>
      <!-- 跳转进入用户博客首页， -->
      <router-link :to="{name:'homePage', params:{userId}}">Enter</router-link>
    </h2>
  </div>
</template>

<script>
import { mapState } from "vuex";
export default {
  name: "welcomePage",
  data() {
    return {
      userId: 1
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
  margin-top: 60px;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
