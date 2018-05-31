<template>
  <div class="my-favorite-trend" ref="wrapper">
    <div class="trend-head">
      <i class="fa fa-arrow-left" @click="$router.go(-1)"></i>
      <span>我喜欢的动态</span>
    </div>
    <transition-group name="animate" class="article-list" tag="ul" v-if="trendList.length!=0">
      <trend v-for="(trend,index) in trendList" :key="index" :trend="trend" @updateCurrentTrend="updateSpecifiedTrend(index)" @showSharePanel="_showSharePanel($event)"
      />
    </transition-group>
    <div v-else class="none-trend">
      <span>你还没有点赞过任何动态喔!</span>
    </div>
    <slide-out slideToDirection="toUp" v-model="showSharePanel" class="share-panel" :showModal="true">
      <share-panel/>
    </slide-out>
    <loading v-if="showLoading" />
    <hint v-model="hintText" />
  </div>
</template>

<script>
  import {
    mapState
  } from "vuex";
  import trend from '@/components/trendPage/trend';
  import {
    throttle
  } from 'lodash';
  import sharePanel from "@/components/common/sharePanel";
  import slideOut from "@/components/common/slideOut";
  export default {
    name: 'myFavoriteTrend',
    data() {
      return {
        trendList: [],
        showLoading: false,
        hintText: '',
        hasMore: true,
        showSharePanel: false,
        userID: 0
      }
    },
    mounted() {
      window.addEventListener('scroll', throttle(this.checkScrollToBottom, 200));
    },
    activated() {
      if (this.userInfo.userID != this.userID) {
        this.trendList = [];
        this.userID = this.userInfo.userID;
      }
      this.getTrendList();
    },
    methods: {
      getTrendList() {
        let tmpList = this.userInfo.favoriteTrend,
          favoriteList = [];
        for (let i = 0; i < tmpList.length; i++) {
          favoriteList.unshift(tmpList[i].trendID);
        }
        if (favoriteList.length > 0) {
          this.showLoading = true;
          this.$axios({
            method: 'get',
            url: '/api/getMyFavoriteTrend',
            params: {
              trendIDList: JSON.stringify(favoriteList),
              startIndex: this.trendList.length,
              number: 5
            }
          }).then(result => {
            let response = result.data;
            if (response.trendList.length < 5) {
              this.hasMore = false;
            }
            if (response.status == 200) {
              this.trendList = this.trendList.concat(response.trendList);
            }
            this.showLoading = false;
          });
        }
      },
      updateSpecifiedTrend(index) {
        const trendID = this.trendList[index].trendID;
        this.$axios({
          method: 'get',
          url: '/api/getSpecifiedTrend',
          params: {
            trendID
          }
        }).then(result => {
          if (result.data) {
            this.trendList.splice(index, 1, result.data[0]);
          }
        })
      },
      checkScrollToBottom() {
        let scrollHeight = document.documentElement.scrollHeight || document.body.scrollHeight;
        let scrollTop = document.documentElement.scrollTop || window.pageYOffset || document.body.scrollTop;
        let innerHeight = window.innerHeight;
        if (scrollTop + innerHeight >= scrollHeight - 20) {
          if (this.hasMore) {
            this.getTrendList();
          } else {
            this.hintText = '没有更多了~';
          }
        }
      },
      _showSharePanel(trendID) {
        this.showSharePanel = true;
      }
    },
    computed: {
      ...mapState('user', ['userInfo'])
    },
    components: {
      trend,
      slideOut,
      sharePanel
    }
  }

</script>

<style lang="less" scoped>
  .animate-enter-active {
    transition: all .6s !important;
  }

  .animate-enter {
    transform: translateY(-50%) scale(0.5);
    opacity: 0;
  }

  .animate-move {
    transition: all .5s !important;
  }

  .my-favorite-trend {
    background-color: #F5F6FA;
    width: 100vw;
    height: fit-content;
    min-height: 100vh;
    .trend-head {
      width: 100vw;
      height: 12vw;
      background-color: #0080FF;
      line-height: 12vw;
      color: #FFFFFF;
      padding: 0 3vw;
      box-sizing: border-box;
      font-size: 5vw;
      position: fixed;
      top: 0;
      left: 0;
      z-index: 99;
      i.fa {
        margin-right: 2vw;
      }
    }
    .article-list {
      margin-top: 15vw;

    }
  }

  .none-trend {
    text-align: center;
    margin-top: 12vw;
    color: #999999;
    width: 100vw;
    height: 50vw;
    font-size: 6vw;
    background-image: url("/static/images/common/none-data.svg");
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

</style>
