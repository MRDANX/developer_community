<template>
  <div id="layout">
    <keep-alive>
      <router-view />
    </keep-alive>
    <ul class="fixed-nav">
      <router-link to="/subject" class="fa fa-home" tag="li" ref="subject" />
      <router-link to="/trend" class="fa fa-comments" tag="li" ref="trend" />
      <li class="create-wrapper" @click="createToggle=!createToggle">
        <div class="create-mask"></div>
        <span class="fa-stack fa-lg" ref="create">
          <i class="fa fa-circle fa-stack-2x"></i>
          <i class="fa fa-plus fa-stack-1x" :class="{active:createToggle}"></i>
        </span>
        <div class="create-trend" :class="{activeToggle:createToggle}" @click="goCreate('createTrend')">
          <!-- <i class="fa fa-gratipay" ref="createTrend"></i> -->
          <img src="/static/images/common/publish-trend2.svg" alt="" ref="createTrend">
        </div>
        <div class="create-article" :class="{activeToggle:createToggle}" @click="goCreate('createArticle')">
          <i class="fa fa-telegram" ref="createArticle"></i>
          <!-- <img src="/static/images/common/publish-article.svg" alt="" ref="createArticle"> -->
        </div>
      </li>
      <router-link to="/search" class="fa fa-search" tag="li" ref="search" />
      <router-link to="/setting" class="fa fa-user" tag="li" ref="setting" />
    </ul>
    <hint v-model="hintText" />
  </div>
</template>

<script>
  import {
    mapState
  } from "vuex";
  export default {
    name: "layoutPage",
    data() {
      return {
        createToggle: false,
        hintText: ''
      }
    },

    mounted() {
      this.$activeFeedback(this.$refs.subject.$el);
      this.$activeFeedback(this.$refs.trend.$el);
      this.$activeFeedback(this.$refs.create);
      this.$activeFeedback(this.$refs.search.$el);
      this.$activeFeedback(this.$refs.setting.$el);
      this.$activeFeedback(this.$refs.createArticle);
      this.$activeFeedback(this.$refs.createTrend);
    },
    computed: mapState('user', ['userInfo']),
    methods: {
      goCreate(name) {
        if (!this.userInfo.userID) {
          this.hintText = '请先登录!';
          return;
        }
        this.$router.push({
          name
        });
      }
    }
  };

</script>

<style lang='less' scoped>
  #layout {
    width: 100vw;
    height: 100vh;
    background-color: #F5F6FA;
    ul.fixed-nav {
      display: flex;
      justify-content: space-between;
      position: fixed;
      left: 0;
      bottom: 0;
      z-index: 99;
      width: 100vw;
      height: 9vh;
      font-size: 5vh;
      background-color: #FFFFFF;
      box-shadow: 0 -2px 10px #C8CBD4;
      li {
        color: #C8CBD4;
        position: relative;
        line-height: 9vh;
        background-color: #FFFFFF;
        transition: color .3s;
        width: 20vw;
        text-align: center;
        z-index: 99;
        &:nth-child(4) {
          font-size: 4.5vh;
        }
        &.router-link-active {
          color: #0080FF;
        }
        &.fa.active {
          background-color: #F0F0F0;
        }
      }
      li.create-wrapper {
        position: relative;
        color: #0080FF;
        z-index: 97;
        >span.fa-stack {
          position: absolute;
          top: -50%;
          left: 50%;
          font-size: 10vw;
          transform: translateX(-50%) scale(1);
          transition: all .2s;
          z-index: 97;
          i.fa-plus {
            color: #FFFFFF;
            transition: all .8s;
            transform: rotate(0);
          }
          i.fa-plus.active {
            transform: rotate(45deg);
          } // &::before {
          //   content: '';
          //   position: absolute;
          //   width: 10vw;
          //   height: 10vw;
          //   border-radius: 50%;
          //   left: 50%;
          //   top: 50%;
          //   margin-top: -5vw;
          //   margin-left: -5vw;
          //   box-shadow: 0 -5px 10px 10px #0080FF;
          // }
          &.active {
            transform: translateX(-50%) scale(0.9);
          }
        }
        .create-mask {
          position: absolute;
          top: 0;
          left: 0;
          bottom: 0;
          right: 0;
          background-color: #FFFFFF;
          z-index: 96;
        }
        .create-article,
        .create-trend {
          width: 8vw;
          display: flex;
          position: absolute;
          top: -100%;
          left: 50%;
          border-radius: 50%;
          transform-origin: 50% 10.5vh;
          z-index: 95;
          .fa {
            font-size: 8vw;
            position: relative;
            transition: all .1s;
            transform: scale(1);
            &.active {
              transform: scale(0.9);
            }
          }
        }
        .create-trend {
          transform: translateX(-50%) rotate(-150deg);
          transition: transform .7s;
          width: 8vw;
          height: 8vw;
          &::after {
            content: '';
            width: 80%;
            height: 80%;
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%,-50%);
            background-color: #FFFFFF;
            border-radius: 50%;
            z-index: -1;
          }
          img {
            height: 100%;
            transition: all .1s;
            transform: scale(1);
            &.active {
              transform: scale(0.9);
            }
          }
          &.activeToggle {
            z-index: 98;
            transition: transform .9s, z-index .1s .9s;
            transform: translateX(-50%) rotate(-45deg);
          }
        }
        .create-article {
          transform: translateX(-50%) rotate(-180deg);
          transition: transform .9s;
          i.fa::after {
            content: '';
            width: 80%;
            height: 80%;
            position: absolute;
            left: 50%;
            top: 50%;
            transform: translate(-50%,-50%);
            background: white;
            z-index: -1;
            border-radius: 50%;
          }
          &.activeToggle {
            z-index: 98;
            transition: transform .8s, z-index .1s .8s;
            transform: translateX(-50%) rotate(0deg);
          }
        }
      }
    }
  }

</style>
