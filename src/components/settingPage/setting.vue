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
      <li class="modify-password" @click.self="showModifyPanel=!showModifyPanel">
        <span>修改账号密码</span>
      </li>
      <li class="modify-panel" :class="{activated:showModifyPanel}">
        <div>
          <span>　原密码:</span>
          <input type="password" v-model="oldPassword">
        </div>
        <div>
          <span>　新密码:</span>
          <input type="password" v-model="newPassword">
        </div>
        <div>
          <span>确认密码:</span>
          <input type="password" v-model="confirmPassword">
        </div>
        <div class="button-group">
          <div @click.self="resetModifyPanel" ref="cancel" class="cancel">取消</div>
          <div ref="confirm" class="confirm" @click.self="confirmModify">确认</div>
        </div>
      </li>
    </ul>

    <ul class="setting-list" ref="list2">
      <!-- <li>
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
      </li> -->
      <li class="margin-top">
        <span>关于</span>
      </li>
    </ul>
    <div class="logout" ref="logout" v-if="userInfo.userID" @click="logout">
      <i class="fa fa-sign-out"></i>退出登录</div>
    <div class="product">开发者社区1.0 • 程丹雄</div>
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
        showLoading: false,
        showModifyPanel: false,
        oldPassword: '',
        newPassword: '',
        confirmPassword: '',
        consistent: false
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
      let cancel = this.$refs.cancel,
        confirm = this.$refs.confirm;
      if (cancel) {
        this.$activeFeedback(cancel);
      }
      if (confirm) {
        this.$activeFeedback(confirm);
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
      },
      confirmModify() {
        if (!this.consistent) {
          this.hintText = '两次输入密码不一致，请重新修改!';
          return;
        }
        let jwt = require('jsonwebtoken');
        let token = this.userInfo.token;
        let storePassword = jwt.decode(token, 'developer_community').password;
        if (this.oldPassword != storePassword) {
          this.hintText = '原密码错误，请重新输入!';
          return;
        }
        this.showLoading = true;
        let qs = require('qs');
        let userID = this.userInfo.userID,
          phone = this.userInfo.phone,
          encodedPassword = jwt.sign({
            password: this.newPassword
          }, 'developer_community');
        this.$axios({
          method: 'post',
          url: '/api/modifyPassword',
          data: qs.stringify({
            userID,
            phone,
            token,
            encodedPassword
          })
        }).then(result => {
          this.showLoading = false;
          let response = result.data;
          if (response.errno) {
            this.hintText = response.text;
            return;
          }
          if (response.success) {
            this.$store.commit('user/updateToken', response.token);
            // this.$store.dispatch('user/retrieveUserInfo');
          }
          this.hintText = response.text;

          this.resetModifyPanel();
        })
      },

      resetModifyPanel() {
        this.oldPassword = '';
        this.newPassword = '';
        this.confirmPassword = '';
        this.showModifyPanel = false;
      }
    },
    watch: {
      newPassword(newVal, oldVal) {

        if (newVal == this.confirmPassword) {
          this.consistent = true;
        } else {
          this.consistent = false;
        }
      },
      confirmPassword(newVal, oldVal) {
        if (newVal == this.newPassword) {
          this.consistent = true;
        } else {
          this.consistent = false;
        }
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
        &.modify-panel {
          width: 100%;
          height: 0;
          overflow: hidden;
          background-color: #FFFFFF;
          transition: all .5s;
          flex-direction: column;
          padding: 3vw 0;
          opacity: 0;
          &.activated {
            opacity: 1;
            height: 45vw;
          }
          input {
            margin-left: 3vw;
          }
          .button-group {
            display: flex;
            justify-content: space-between;
            width: 50vw;
            >div {
              padding: 1vw 3vw;
              border: 1px solid #0080FF;
              color: #0080FF;
              border-radius: 5px;

              &.confirm.active,
              &.cancel.active {
                background-color: #0080FF;
                color: #FFFFFF
              }
            }
          }
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
