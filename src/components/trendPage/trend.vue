<template>
  <li class="trend-item">
    <div class="trend-head">
      <router-link class="user-avatar" :to="'/userDetail/'+trend.userID" tag="div">
        <img :src="trend.avatar" />
      </router-link>
      <router-link :to="'/userDetail/'+trend.userID" class="user-info" tag="div">
        <p class="user-name">{{trend.userName}}</p>
        <p class="user-meta">{{trend.job}} @ {{trend.company||'公司'}} • {{trend.date|timeFromNow}}</p>
      </router-link>
      <div class="user-follow" :class="{isFollowee}">
        <div class="not-follow" @click="toggleFollow">
          <i class="fa fa-plus"></i>
          <span>关注</span>
        </div>
        <div class="has-follow" @click="toggleFollow">
          <i class="fa fa-check"></i>
          <span>已关注</span>
        </div>
      </div>
    </div>
    <div class="trend-content" ref="trendContent">
      <p class="trend-text" v-html="trend.content"></p>
      <div class="trend-image-set" v-if="trend.images">
        <img :src="image" v-for="(image,index) in trend.images.split(',')" :key="index">
      </div>
    </div>
    <div class="trend-foot" ref="trendFoot">
      <div class="trend-favor" :class="{isFavorite}" @click="toggleFavor">
        <i class="fa" :class="[isFavorite?'fa-thumbs-up':'fa-thumbs-o-up']"></i>
        <span>{{trend.favors||'赞'}}</span>
      </div>
      <div class="trend-comment">
        <i class="fa fa-commenting-o"></i>
        <span>{{trend.commentNum||'评论'}}</span>
      </div>
      <div class="trend-share" @click="$emit('showSharePanel',trend.trendID)">
        <i class="fa fa-share-alt"></i>
      </div>
    </div>
  </li>
</template>

<script>
  import {
    mapState
  } from "vuex";
  export default {
    name: 'trend',
    props: {
      trend: {
        type: Object,
        default: () => {}
      }
    },
    data() {
      return {
        favorLock: false,
        followLock: false
      }
    },
    mounted() {
      let trendContent = this.$refs.trendContent;
      let trendFoot = this.$refs.trendFoot;
      if (trendContent) {
        this.$activeFeedback(trendContent);
      }
      if (trendFoot) {
        for (let i = 0; i < trendFoot.children.length; i++) {
          const element = trendFoot.children[i];
          this.$activeFeedback(element)
        }
      }
    },
    computed: {
      ...mapState('user', ['userInfo']),
      isFavorite() {
        const favoriteTrend = this.userInfo.favoriteTrend,
          trendID = this.trend.trendID;
        //check whether user has logined and show the corresponding style of favor button 
        if (favoriteTrend) {
          for (let i = 0; i < favoriteTrend.length; i++) {
            if (trendID == favoriteTrend[i].trendID) {
              return true;
            }
          }
        }
        return false;
      },
      isFollowee() {
        const followee = this.userInfo.followee,
          userID = this.trend.userID;
        if (followee) {
          for (let i = 0; i < followee.length; i++) {
            if (userID == followee[i].userID) {
              return true;
            }
          }
        }
        return false;
      }
    },
    methods: {
      toggleFavor() {
        if (!this.userInfo.userID) {
          this.$emit('askLogin');
          return;
        }
        const trendID = this.trend.trendID,
          isFavorite = !this.isFavorite;
        if (!this.favorLock) {
          this.favorLock = true;
          this.$store.dispatch('user/toggleTrendFavor', {
            trendID,
            isFavorite
          }).then(result => {
            this.$emit('updateCurrentTrend');
            setTimeout(() => {
              this.favorLock = false;
            }, 300);
          }).catch(err => {
            console.log(err);
          });
        }
      },
      toggleFollow() {
        if (!this.userInfo.userID) {
          this.$emit('askLogin');
          return;
        }
        const followeeUserID = this.trend.userID,
          wantFollow = !this.isFollowee;
        if (!this.followLock) {
          this.followLock = true;
          this.$store.dispatch('user/toggleUserFollow', {
            followeeUserID,
            wantFollow
          }).then(result => {
            this.$emit('updateCurrentTrend');
            setTimeout(() => {
              this.followLock = false;
            }, 300);
          }).catch(err => {
            console.log(err);
          });
        }
      }
    }
  }

</script>

<style lang="less" scoped>
  .trend-item {
    margin: 3vw 0;
    background-color: #FFFFFF;
    border-top: 1px solid #F1F1F1;
    border-bottom: 1px solid #F1F1F1;
    .trend-head {
      padding: 3vw;
      display: flex;
      justify-content: space-between;
      align-items: center;
      height: 10vw;
      .user-avatar {
        height: 10vw;
        width: 10vw;
        border-radius: 50%;
        overflow: hidden;
        img {
          height: 100%;
        }
      }
      .user-info {
        flex-grow: 1;
        margin-left: 3vw;
        .user-name {
          font-weight: bold;
        }
        .user-meta {
          padding: 1vw 0;
          font-size: 3.5vw;
          color: #666666;
        }
      }
      .user-follow {
        padding: 1vw 2vw;
        background-color: #0080FF;
        color: #FFFFFF;
        border-radius: 1vw;
        height: 6vw;
        line-height: 6vw;
        width: 14vw;
        text-align: center;
        transition: all .5s;
          overflow: hidden;
        .not-follow {
          display: block;
        }
        .has-follow {
          display: none;
          white-space: nowrap;
        }
        &.isFollowee {
          background-color: #6A03F2;
          width: 18vw;
          .not-follow {
            display: none;
          }
          .has-follow {
            display: block;
          }
        }
      }
    }
    .trend-content {
      padding: 3vw;
      &.active {
        background-color: #F1F1F1;
      }
      .trend-text {
        display: -webkit-box;
        -webkit-box-orient: vertical;
        -webkit-line-clamp: 3;
        overflow: hidden;
      }
      .trend-image-set {
        display: flex;
        flex-wrap: wrap;
        margin-top: 3vw;
        img {
          height: 20vw;
          margin: 0 1vw 1vw 0;
        }
      }
    }
    .trend-foot {
      display: flex;
      justify-content: space-between;
      align-items: center;
      border-top: 1px solid #F0F0F0;
      height: 10vw;
      color: #666666;
      font-size: 5vw;
      >div {
        flex: 1 1 30vw;
        height: 10vw;
        line-height: 10vw;
        text-align: center;
        &.active {
          background-color: #F1F1F1;
        }
      }
      .trend-favor.isFavorite {
        color: #0080FF;
        .fa {
          transform-origin: left bottom;
          animation: trendFavorite 1s;
        }
      }
    }
  }

  @keyframes trendFavorite {
    0% {
      transform: rotate(0) scale(1);
    }
    50% {
      transform: rotate(-15deg) scale(1.1);
    }
    100% {
      transform: rotate(0) scale(1);
    }
  }

</style>
