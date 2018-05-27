<template>
  <div class="login-panel">
    <div class="user-avatar">
      <img :src="storedAvatar||'/static/images/avatar/default-avatar.png'" alt="">
    </div>
    <div class="input-area">
      <text-input v-model="userToken" inputType="text" hint="手机/邮箱" @pressEnter="requestLogin" />
      <text-input v-model="password" inputType="password" hint="密  码" @pressEnter="requestLogin" />
      <button class="login-button" @click="requestLogin" ref="loginButton">登录</button>
      <button class="register-button" ref="registerButton" @click="showRegister=true">注册</button>
    </div>
    <hint v-model="hintText" />
    <loading v-if="showLoading" :verticalMove="-5" color="#FFFFFF" />
    <slide-out id="register" v-model="showRegister" title="用户注册">
      <scroll>
        <register v-model="showRegister" />
      </scroll>
    </slide-out>
  </div>
</template>

<script>
  import register from "@/components/settingPage/register";
  import textInput from "@/components/common/textInput";
  import slideOut from "@/components/common/slideOut";
  import scroll from "@/components/common/scroll";
  export default {
    name: 'login',
    data() {
      return {
        userToken: '',
        password: '',
        hintText: '',
        showRegister: false,
        showLoading: false
      }
    },
    computed: {
      storedAvatar() {
        if (localStorage.getItem('avatar')) {
          return localStorage.getItem('avatar');
        }
      }
    },
    mounted() {
      this.$activeFeedback(this.$refs.loginButton);
      this.$activeFeedback(this.$refs.registerButton);
    },
    methods: {
      requestLogin() {
        let userToken = this.userToken,
          password = this.password,
          phoneReg = /\d{11}/,
          emailReg = /[\dA-Za-z]+@\w+\.\w+/,
          tokenType;
        //check user's input according to phone or email regular expression,or remind user that the format of input is wrong when no regExp is matched
        if (userToken.match(phoneReg)) {
          tokenType = 'phone';
        } else if (userToken.match(emailReg)) {
          tokenType = 'email';
        } else {
          this.hintText = '手机或邮箱格式有误!';
          return;
        }
        let qs = require('qs');
        this.showLoading = true;
        //request login
        this.$axios({
          method: 'post',
          url: '/api/requestLogin',
          data: qs.stringify({
            tokenType,
            userToken,
            password
          })
        }).then(result => {
          let data = result.data;
          if (data.errno && data.errno == 404) {
            this.hintText = data.text;
            this.showLoading = false;
            return;
          }
          //remind user that login successfully and register user's information into vuex by committing mutation to vuex
          this.showLoading = false;
          this.hintText = '登录成功!';
          setTimeout(() => {
            //register userInfo to vuex's user module
            this.$store.commit('user/registerUserInfo', data);
            //close current login panel
            this.$emit('input', false);
          }, 1000);
        })
      }
    },
    components: {
      scroll,
      slideOut,
      register,
      textInput,
    }
  }

</script>

<style lang="less" scoped>
  .login-panel {
    width: 100vw;
    height: 93vh;
    display: flex;
    flex-flow: column nowrap;
    align-items: center;
    justify-content: space-around; // background-image: url("/static/images/login_bg.jpg");
    // background-size: cover;
    .user-avatar {
      min-width: 40vw;
      min-height: 40vw;
      width: 40vw;
      height: 40vw;
      overflow: hidden;
      border-radius: 50%;
      position: relative;
      img {
        // width: 100%;
        position: absolute;
        left: 50%;
        transform: translateX(-50%);
        height: 100%;
      }
    }
    .input-area {
      width: 70vw;
      /deep/ .text-input {
        &::after {
          background-color: #FFFFFF;
        }
        input,
        .input-hint {
          color: #F1F1F1;
        }
        span.fa-stack {
          color: #0080FF;
        }
        span.visibility {
          color: #FAFAFA;
        }
      }
      .login-button,
      .register-button {
        display: block;
        width: 90%;
        height: 8vw;
        outline: none;
        border: none;
        border-radius: ~'8%/50%';
        margin: 8vw auto;
        font-size: 5vw;
        background-color: #4c96fd;
        box-shadow: 0 0 5px #5790c8;
        color: #FFFFFF;
        transform: scale(1);
        &.active {
          transition: all .05s;
          transform: scale(0.9);
        }
      }
    }
  }

  #register {
    /deep/ .wrapper {
      height: 93vh;
    }
  }

</style>
