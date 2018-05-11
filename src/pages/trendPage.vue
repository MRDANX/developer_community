<template>
  <div class="trend-page">
    <div class="trend-nav">
      <ul class="nav-content" :class="['active'+currentIndex]">
        <li :class="{active:currentIndex==index}" v-for="(tab,index) in navTabs" :key="index" @click="currentIndex=index">{{tab}}</li>
      </ul>
      <div class="nav-edit">
        <router-link to="/createTrend" class="fa fa-edit" tag="i"></router-link>
      </div>
    </div>
    <transition :name="slideDirection">
      <component :is="currentView" />
    </transition>
  </div>
</template>

<script>
  import topicTrend from "@/components/trendPage/topicTrend";
  import usersTrend from "@/components/trendPage/usersTrend";
  import recommendTrend from "@/components/trendPage/recommendTrend";
  export default {
    name: 'trendPage',
    data() {
      return {
        navTabs: ['话题', '推荐', '动态'],
        currentIndex: 1,
        slideDirection: 'slide-left'
      }
    },
    computed: {
      currentView() {
        switch (this.currentIndex) {
          case 0:
            return 'topicTrend';
          case 1:
            return 'recommendTrend';
          case 2:
            return 'usersTrend';
          default:
            return 'recommendTrend';
        }
      }
    },
    watch: {
      currentIndex(newIndex, oldIndex) {
        if (newIndex > oldIndex) {
          this.slideDirection = 'slide-left';
        } else if (newIndex < oldIndex) {
          this.slideDirection = 'slide-right';
        }
      }
    },
    components: {
      usersTrend,
      topicTrend,
      recommendTrend
    }
  }
</script>

<style lang="less" scoped>
  .slide-left-enter-active,
  .slide-left-leave-active {
    transition: all .5s;
    position: absolute;
  }

  .slide-left-leave-to {
    transform: translateX(-100%);
  }

  .slide-left-enter {
    transform: translateX(100%);
  }

  .slide-right-enter-active,
  .slide-right-leave-active {
    transition: all .5s;
    position: absolute;
  }

  .slide-right-leave-to {
    transform: translateX(100%);
  }

  .slide-right-enter {
    transform: translateX(-100%);
  }

  div.trend-page {
    width: 100vw;
    position: relative;
    div.trend-nav {
      width: 100%;
      background-color: #0080FF;
      height: 7vh;
      text-align: center;
      line-height: 7vh;
      position: relative;
      .nav-content {
        display: flex;
        justify-content: center;
        align-items: center;
        color: rgba(255, 255, 255, 0.7);
        li {
          width: 20vw;
          box-sizing: border-box;
          padding: 0 5vw;
          font-size: 4vw;
          font-weight: bold;
          &.active {
            color: #FFFFFF;
          }
        }
        &::after {
          content: '';
          width: 20vw;
          height: 0.8vw;
          box-shadow: 0 0 1vw #666666;
          position: absolute;
          bottom: 0;
          transition: all .6s cubic-bezier(0.18, 0.89, 0.34, 1.14);
          background-color: #FFFFFF;
        }
        &.active0::after {
          left: 20vw;
        }
        &.active1::after {
          left: 40vw;
        }
        &.active2::after {
          left: 60vw;
        }
      }
      .nav-edit {
        position: absolute;
        top: 0;
        right: 2vw;
        width: 10vw;
        height: 100%;
        color: #FFFFFF;
        font-size: 6.5vw;
        text-align: center;
      }
    }
    .trend-content {}
  }
</style>