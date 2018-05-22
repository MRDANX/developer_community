<template>
  <scroll ref="usersTrendScroll">
    <div class="users-trend">
      <ul v-if="userInfo.userID" class="users-trend-list">
        <li v-if="userInfo.followee.length==0" class="none-followee">
          <span>你还没有关注任何用户哦!</span>
        </li>
        <li v-if="trendList.length==0" class="none-trend">
          <span>你关注的用户还没发表任何动态哦!</span>
        </li>
        <trend v-for="(trend,index) in trendList" :key="index" :trend="trend" ref="trends" @updateCurrentTrend="updateSpecifiedTrend(index)"
          @showSharePanel="$emit('showSharePanel',$event)" />
      </ul>
      <div v-else class="ask-for-login">
        <i class="fa fa-coffee"></i>
        <p>需要您登录，登录后使用更多功能</p>
        <router-link to="setting" tag="div" class="login-register-button" ref="loginRegisterButton">登录/注册</router-link>
      </div>
    </div>
    <loading v-if="showLoading" />
  </scroll>
</template>

<script>
  import scroll from "@/components/common/scroll";
  import trend from "@/components/trendPage/trend";
  import loading from "@/components/common/loading";
  import {
    mapState
  } from "vuex";
  export default {
    name: 'usersTrend',
    data() {
      return {
        trendList: [],
        showLoading: false
      }
    },
    mounted() {
      let loginRegisterButton = this.$refs.loginRegisterButton;
      if (loginRegisterButton) {
        this.$activeFeedback(loginRegisterButton.$el);
      }
      if (!this.userInfo.userID) {
        this.$refs.usersTrendScroll._disable();
        return;
      }
      this.showLoading = true;
      this.$axios({
        method: 'get',
        url: '/getUsersTrend',
        params: {
          followerUserID: this.userInfo.userID
        }
      }).then(result => {
        // console.log(result);
        this.trendList = result.data;
        this.showLoading = false;
      })
    },
    computed: {
      ...mapState('user', ['userInfo'])
    },
    methods: {
      updateSpecifiedTrend(index) {
        const trendID = this.trendList[index].trendID;
        this.$axios({
          method: 'get',
          url: '/getSpecifiedTrend',
          params: {
            trendID
          }
        }).then(result => {
          if (result.data) {
            this.trendList.splice(index, 1, result.data[0]);
          }
        })
      }
    },
    components: {
      trend,
      scroll,
      loading
    }
  }

</script>

<style lang="less" scoped>
  .users-trend {
    width: 100vw;
    .users-trend-list {
      .none-followee,
      .none-trend {
        text-align: center;
        margin-top: 10vh;
        color: #999999;
        width: 100vw;
        height: 50vw;
        font-size: 6vw;
        background-image: url("/static/images/common/none-follow.svg");
        background-size: 100% 100%;
        position: relative;
        span {
          position: absolute;
          bottom: 3vw;
          left: 50%;
          transform: translateX(-50%);
          white-space: nowrap;
        }
      }
      .none-trend {
        background-image: url("/static/images/common/none-trend.svg");
      }
    }
    .ask-for-login {
      width: 100vw;
      height: 84vh;
      position: relative;
      display: flex;
      flex-direction: column;
      padding-top: 20vh;
      box-sizing: border-box;
      justify-content: flex-start;
      align-items: center;
      font-size: 4vw;
      i.fa {
        font-size: 20vw;
        color: #CCCCCC;
      }
      p {
        margin: 3vw 0;
      }
      .login-register-button {
        padding: 0 3vw;
        width: 20vw;
        height: 10vw;
        line-height: 10vw;
        border-radius: 5px;
        text-align: center;
        background-color: #0080FF;
        color: #FFFFFF;
        &.active {
          transition: all .1s;
          transform: scale(0.8);
        }
      }
    }
  }

</style>
