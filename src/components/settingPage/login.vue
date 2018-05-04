<template>
  <div class="login-panel">
    <div class="user-avatar">
      <img src="/static/images/avatar/default-avatar.png" alt="">
    </div>
    <div class="input-area">
      <text-input v-model="userName" inputType="text" hint="用户名" />
      <text-input v-model="password" inputType="password" hint="密　码" />
    </div>
    <div>

    </div>
  </div>
</template>

<script>
  import textInput from "@/components/common/textInput";
  export default {
    name: 'login',
    data() {
      return {
        userName: '',
        password: ''
      }
    },
    components: {
      textInput
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
      img {
        width: 100%;
        height: 100%;
      }
    }
    .input-area {
      width: 60vw;
      height: 50vh;
    }
  }

</style>
