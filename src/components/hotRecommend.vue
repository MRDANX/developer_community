<template>
  <li class="hot-recommend" v-if="isShow&&recommendArticles.length!=0">
    <div class="header">
      <div>
        <!-- fa-h-square -->
        <span class="fa fa-free-code-camp"></span>
        <span>热门推荐</span>
      </div>
      <div>
        <span class="fa fa-refresh" ref="refresh" @click="refresh"></span>
        <span class="fa fa-close" @click="isShow=false"></span>
      </div>
    </div>
    <ul class="content">
      <li v-for="(article,index) in recommendArticles" :key="index">
        <h4>{{article.title}}</h4>
        <div>
          <div>
            <i class="fa fa-heart"></i>
            <span>{{article.favors}}</span>
          </div>
          <div>
            <i class="fa fa-user"></i>
            <span>{{article.author}}</span>
          </div>
          <div>
            <i class="fa fa-clock-o"></i>
            <span>{{article.date|dateFormat}}</span>
          </div>
        </div>
      </li>
    </ul>
  </li>
</template>

<script>
  export default {
    name: 'hotRecommend',
    props: {
      recommendArticles: {
        type: Array,
        default: () => []
      }
    },
    data() {
      return {
        isShow: true
      }
    },
    filters: {
      dateFormat(time) {
        let dayMilli, days, hoursMilli, hours, minutesMilli, minutes, secondMill, seconds;
        dayMilli = Date.now() - new Date(time).getTime();
        days = Math.floor(dayMilli / (24 * 3600 * 1000));
        hoursMilli = dayMilli % (24 * 3600 * 1000);
        hours = Math.floor(hoursMilli / (3600 * 1000));
        minutesMilli = hoursMilli % (3600 * 1000);
        minutes = Math.floor(minutesMilli / (60 * 1000));
        secondMill = minutesMilli % (60 * 1000);
        seconds = Math.floor(secondMill / 1000);
        if (days) {
          return days + '天前';
        } else if (hours) {
          return hours + '小时前';
        } else if (minutes) {
          return minutes + '分前';
        } else if (seconds) {
          return seconds + '秒前';
        } else {
          return 'something went wrong!';
        }
      }
    },
    methods: {
      refresh() {
        this.$refs.refresh.classList.add('refreshing');
      }
    }
  }

</script>

<style lang="less" scoped>
  .hot-recommend {
    width: 100%;
    background-color: #FFFFFF;
    margin: 1vw 0 3vw;
    box-shadow: 0 1px 5px #CCCCCC;
    .header {
      width: 100%;
      display: flex;
      justify-content: space-between;
      color: #0080BB;
      padding: 2vw 3vw;
      box-sizing: border-box;
      font-size: 4.5vw;
      >div:first-of-type {
        span {
          margin-right: 2vw;
        }
      }
      >div:last-of-type {
        color: #777777;
        span {
          margin-left: 5vw;
          transition: transform 3s;
          &.refreshing {
            color: #0080BB;
            transform: rotate(360deg);
          }
        }
      }

    }
    .content {
      li {
        padding: 5vw 0;
        padding: 3vw;
        box-sizing: border-box;
        box-shadow: 0 0px 1px rgba(0, 0, 0, 0.1);
        h4 {
          font-weight: normal;
          font-size: 4vw;
        }
        >div {
          display: flex;
          justify-content: flex-start;
          color: #777777;
          align-content: center;
          margin: 3vw 0;
          font-size: 3.5vw;
          >div {
            margin-right: 5vw;
            i {
              margin-right: 1vw;
            }
          }
        }
      }
    }
  }

</style>
