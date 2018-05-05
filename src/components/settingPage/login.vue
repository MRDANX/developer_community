<template>
  <div class="login-panel">
    <div class="user-avatar">
      <img src="/static/images/avatar/default-avatar.png" alt="">
    </div>
    <div class="input-area">
      <text-input v-model="userName" inputType="text" hint="用户名" />
      <text-input v-model="password" inputType="password" hint="密　码" />
      <button class="login-button" @click="requestLogin">登录</button>
      <button class="signup-button">注册</button>
    </div>
    <hint v-model="hintText">{{hintText}}</hint>
  </div>
</template>

<script>
  import textInput from "@/components/common/textInput";
  import hint from "@/components/common/hint";
  export default {
    name: 'login',
    data() {
      return {
        userName: '',
        password: '',
        hintText: ''
      }
    },
    methods: {
      requestLogin() {
        let userName = this.userName,
          password = this.password;
        let qs = require('qs');
        this.$axios({
          method: 'post',
          url: '/requestLogin',
          data: qs.stringify({
            userName,
            password
          })
        }).then(result => {
          let data = result.data;
          if (data.errno && data.errno == 404) {
            this.hintText = data.text;
            return;
          }
          this.hintText = '登录成功!';
          setTimeout(() => {
            this.$store.commit('user/registerUserInfo', data);
            this.$emit('input', false);
          }, 1500);
        })
      }
    },
    components: {
      textInput,
      hint
    }
  }

</script>

<style lang="less" scoped>
  .login-panel {
    width: 100vw;
    height: 93vh; // background-color: #F1F1F1;
    // background-image: url("/static/images/login_bg.png");
    // background-size: cover;
    // background-position-y: -7vh;
    display: flex;
    flex-flow: column nowrap;
    align-items: center;
    .user-avatar {
      width: 40vw;
      height: 40vw;
      overflow: hidden;
      border-radius: 50%;
      img {
        width: 100%;
        height: 100%;
      }
    }
    .input-area {
      width: 60vw;
      .login-button,
      .signup-button {
        display: block;
        width: 90%;
        height: 8vw;
        outline: none;
        border: none;
        border-radius: ~'8%/50%';
        margin: 5vw auto;
        font-size: 5vw;
        background-color: #4c96fd;
        box-shadow: 0 0 5px #5790c8;
        color: #FFFFFF;
      }
    }
  }

</style>
