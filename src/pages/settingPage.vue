<template>
  <div class="setting-page">
    <div class="nav">
      <h2>我</h2>
    </div>
    <scroll>
      <ul class="content">
        <li class="user-info" ref="userInfo" @click="showUserOrLogin=true">
          <div>
            <div class="avatar">
              <img :src="userInfo.avatar" v-if="userInfo.avatar" />
              <i class="fa fa-user-circle-o" v-else></i>
            </div>
            <div class="user-name">
              <span>{{userInfo.userName||'登录/注册'}}</span>
              <span class="job-company">{{userInfo.job||'添加职位'}} @ {{userInfo.company||'添加公司'}}</span>
            </div>
            <i class="fa fa-angle-right arrow-right"></i>
          </div>
        </li>
        <li class="user-action">
          <ul ref="actions">
            <li>
              <i class="fa fa-bell" style="color:#0076FE"></i>
              <span class="text">消息中心</span>
            </li>
            <li @click="goto('/myFavoriteArticle')">
              <i class="fa fa-heart" style="color:#6CBD45"></i>
              <span class="text">我喜欢的文章</span>
              <span>{{userInfo.favoriteArticle&&userInfo.favoriteArticle.length||'0'}} 篇</span>
            </li>
            <li>
              <i class="fa fa-eye" style="color:#CC3333"></i>
              <span class="text">阅读过的文章</span>
              <span>0 篇</span>
            </li>
            <li @click="goto('/originalArticle')">
              <i class="fa fa-file-text" style="color:#0080FF"></i>
              <span class="text">原创文章管理</span>
              <span>{{userInfo.originalArticle&&userInfo.originalArticle.length||0}} 篇</span>
            </li>
            <li @click="goto('/myFavoriteTrend')">
              <i class="fa fa-thumbs-up" style="color:#FF9900"></i>
              <span class="text">赞过的动态</span>
              <span>{{userInfo.favoriteTrend&&userInfo.favoriteTrend.length||0}} 个</span>
            </li>
            <li>
              <i class="fa fa-list" style="color:#0099FF"></i>
              <span class="text">收藏集</span>
              <span>{{userInfo.collection&&userInfo.collection.length||'0'}} 个</span>
            </li>
          </ul>
        </li>
        <li class="others">
          <ul>
            <li ref="feedback">
              <i class="fa  service"></i>
              <span>意见反馈</span>
            </li>
            <li ref="setting" @click="showOtherSetting=true">
              <i class="fa fa-cog"></i>
              <span>设置</span>
            </li>
          </ul>
        </li>
      </ul>
    </scroll>
    <slide-out id="userInfo" v-model="showUserOrLogin" :class="userInfo.userID?'hide-login-panel':'login-background'" :title="userInfo.userID?'个人主页':'用户登录'">
      <component :is="showComponent" v-model="showUserOrLogin" />
    </slide-out>
    <slide-out id="otherSetting" v-model="showOtherSetting" title="设置">
      <scroll>
        <setting />
      </scroll>
    </slide-out>
    <hint v-model="hintText" />
  </div>
</template>

<script>
  import {
    mapState
  } from "vuex";
  import scroll from "@/components/common/scroll";
  import slideOut from "@/components/common/slideOut";
  import login from "@/components/settingPage/login";
  import userInfo from "@/components/settingPage/userInfo";
  import setting from "@/components/settingPage/setting";
  export default {
    name: "settingPage",
    data() {
      return {
        showUserOrLogin: false,
        showOtherSetting: false,
        hintText: ''
      };
    },
    computed: {
      ...mapState("user", ["userInfo"]),
      showComponent() {
        return this.userInfo.userID ? "userInfo" : "login";
      }
    },
    mounted() {
      //add active effect for clicking
      this.$activeFeedback(this.$refs.userInfo);
      let actions = this.$refs.actions.children;
      for (let i = 0; i < actions.length; i++) {
        this.$activeFeedback(actions[i]);
      }
      this.$activeFeedback(this.$refs.feedback);
      this.$activeFeedback(this.$refs.setting);
    },
    methods: {
      goto(path) {
        if (!this.userInfo.userID) {
          this.hintText = '请先登录';
          return;
        }
        this.$router.push(path);
      }
    },
    components: {
      scroll,
      slideOut,
      login,
      userInfo,
      setting
    }
  };

</script>

<style lang="less" scoped>
  div.setting-page {
    width: 100vw;
    position: relative;
    color: #333333;
    div.nav {
      width: 100%;
      background-color: #0080ff;
      height: 12vw;
      text-align: center;
      color: #ffffff;
      line-height: 11vw;
      font-size: 4vw;
    }
    ul.content {
      >li {
        background-color: #ffffff;
        margin: 3vw 0;
        &.active {
          background-color: rgba(0, 0, 0, 0.1);
        }
      }
      .user-info {
        padding: 3vw;
        i.fa-user-circle-o {
          font-size: 16vw;
          color: #777777;
          text-align: center;
          line-height: 20vw;
          height: 100%;
        }
        i.arrow-right {
          font-size: 10vw;
          color: #cccccc;
        }
        >div {
          width: 100%;
          font-size: 6vw;
          display: flex;
          justify-content: space-between;
          align-items: center;
          div.avatar {
            height: 20vw;
            width: 20vw;
            overflow: hidden;
            border-radius: 50%;
            text-align: center;
            position: relative;
            img {
              // width: 100%;
              position: absolute;
              left: 50%;
              transform: translateX(-50%);
              height: 100%;
            }
          }
          div.user-name {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            text-indent: 5vw;
            span {
              margin-top: 0.5vw;
            }
            span.job-company {
              font-size: 4vw;
            }
          }
        }
      }
      .user-action,
      .others {
        li {
          padding: 2vh 3vw;
          box-sizing: border-box;
          box-shadow: 0 0 0.5vw #eeeeee;
          display: flex;
          align-items: center;
          &.active {
            background-color: rgba(0, 0, 0, 0.1);
          }
          i {
            font-size: 6vw;
            width: 6vw;
            margin-right: 5vw;
            &.service {
              background-image: url('/static/images/common/service.svg');
              background-size: 100% 100%;
              height: 6vw;
            }
          }
          span {
            font-size: 4.5vw;
          }
          span.text {
            flex-grow: 1;
          }
        }
      }
      .others {
        li {
          i.fa-telegram {
            color: #99cc33;
          }
          i.fa-cog {
            color: #66cc99;
          }
        }
      }
    }
    .hide-login-panel,
    .login-background {
      /deep/ .slide-out {
        background-color: #F5F6FF;
        background-image: url("/static/images/login_bg.jpg");
        background-size: cover;
      }
      /deep/ .slide-out-header {
        color: #D0D0D0;
        i.active::after {
          background-color: rgba(255, 255, 255, 0.5);
        }
      }
    }

    #otherSetting {
      /deep/ .slide-out {
        background-color: #f6f6f6;
      }
      /deep/ .slide-out-header {
        background-color: #0080FF;
        color: #FFFFFF;
        i.active::after {
          background-color: rgba(255, 255, 255, 0.5);
        }
      }
    }
    #otherSetting {
      /deep/ .wrapper {
        height: 93vh;
      }
    }
  }

</style>
