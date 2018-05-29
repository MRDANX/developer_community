<template>
  <div class="setting">
    <ul v-if="userInfo.userID" class="setting-list" ref="list1">
      <li>
        <span>邮箱</span>
        <span>{{userInfo.email||''}}</span>
      </li>
      <li>
        <span>手机号</span>
        <span>{{userInfo.phone||''}}</span>
      </li>
      <li >
        <span>修改账号密码</span>
      </li>
    </ul>
    <ul class="setting-list" ref="list2">
      <li>
        <span>清除缓存</span>
        <span>330 KB</span>
      </li>
      <li>
        <span>推送消息设置</span>
        <span>推送消息</span>
      </li>
      <li>
        <span>移动网络下首页不显示图片</span>
        <span>开关</span>
      </li>
      <li>
        <span>自动检查粘贴板快速分享</span>
        <span>开关</span>
      </li>
      <li class="margin-top">
        <span>关于</span>
      </li>
    </ul>
    <div class="logout" ref="logout" v-if="userInfo.userID" @click="logout">
      <i class="fa fa-sign-out"></i>退出登录</div>
    <div class="product">开发者社区1.0 • 程丹雄</div>
    <div class="modify-password">

    </div>
    <hint v-model="hintText" />
    <loading v-if="showLoading" :verticalMove="-20" />
  </div>
</template>

<script>
  import {
    mapState
  } from "vuex";
  export default {
    name: 'setting',
    data() {
      return {
        hintText: '',
        showLoading: false
      }
    },
    computed: {
      ...mapState('user', ['userInfo'])
    },
    mounted() {
      let logout = this.$refs.logout;
      if (logout) {
        this.$activeFeedback(logout);
      }
      let list1 = this.$refs.list1.children;
      for (let i = 0; i < list1.length; i++) {
        this.$activeFeedback(list1[i]);
      }
      let list2 = this.$refs.list2.children;
      for (let i = 0; i < list2.length; i++) {
        this.$activeFeedback(list2[i]);
      }
    },
    methods: {
      logout() {
        this.showLoading = true;
        setTimeout(() => {
          this.$store.commit('user/unregisterUserInfo');
          this.hintText = '已成功退出登录!';
          this.showLoading = false;
        }, 1000);
      }
    }
  }

</script>

<style lang="less" scoped>
  .setting {
    width: 100vw;
    overflow: hidden;
    .setting-list {
      width: 100%;
      margin: 5vw 0;
      li {
        width: 100%;
        height: 12vw;
        background-color: #FFFFFF;
        box-shadow: 0 0 1px #CCCCCC;
        padding: 0 3vw;
        box-sizing: border-box;
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-size: 5vw;
        &.margin-top {
          margin-top: 5vw;
        }
        &.active {
          background-color: #DDDDDD;
        }
      }
    }
    .logout {
      width: 60vw;
      height: 12vw;
      margin: 10vw auto;
      text-align: center;
      font-size: 5vw;
      line-height: 12vw;
      border-radius: 5px;
      color: #0080FF;
      border: 1px solid #0080FF;
      background-color: transparent;
      i.fa {
        margin-right: 3vw;
      }
      &.active {
        background-color: #0080FF;
        color: #FFFFFF;
      }
    }
    .product {
      width: 100vw;
      text-align: center;
      font-size: 4vw;
      color: #666666;
    }
  }

</style>
