<template>
  <scroll :enableLoadMore='true' :loadMore="loadMore" ref="recommendScroll">
    <div class="recommend-trend">
      <div class="slide-trend">
        <slider>
          <router-link :to="{path:'/trendDetail',query:{
        trendID:trend.trendID}}" tag="div" class="slide-trend-item" v-for="(trend,index) in slideTrend" :key="index">
            <div class="slide-trend-item-content">
              <div class="slide-trend-item-head">
                <i class="fa fa-dot-circle-o"></i>
                <span>热门动态</span>
              </div>
              <div class="slide-trend-text">
                {{trend.content}}
              </div>
            </div>
            <div class="slide-trend-image" v-if="trend.images">
              <img :src="trend.images.split(',')[0]" />
            </div>
          </router-link>
        </slider>
      </div>
      <ul class="trend-list">
        <trend v-for="(trend,index) in trendList" :key="index" :trend="trend" @askLogin="$refs.recommendScroll.showHint('请先登录')"
          @updateCurrentTrend="updateSpecifiedTrend(index)" @showSharePanel="$emit('showSharePanel',$event)" />
      </ul>
      <loading v-if="showLoading" />
    </div>
  </scroll>
</template>

<script>
  import scroll from "@/components/common/scroll";
  import loading from "@/components/common/loading";
  import slider from "@/components/trendPage/slider";
  import trend from "@/components/trendPage/trend";
  export default {
    name: 'recommendTrend',
    data() {
      return {
        trendList: [],
        slideTrend: [],
        showLoading: false
      }
    },
    mounted() {
      this.showLoading = true;
      this.$axios({
        method: 'get',
        url: '/api/getTrendList',
        params: {
          startIndex: 0,
          number: 5
        }
      }).then(result => {
        this.trendList = result.data;
        this.showLoading = false;
      });
      this.$axios({
        method: 'get',
        url: '/api/getTrendList',
        params: {
          startIndex: this.slideTrend.length,
          number: 5,
          orderBy: 'favors'
        }
      }).then(result => {
        this.slideTrend = result.data;
      });
    },
    methods: {
      loadMore() {
        return new Promise((resolve, reject) => {
          this.$axios({
            method: 'get',
            url: '/api/getTrendList',
            params: {
              startIndex: this.trendList.length,
              number: 5
            }
          }).then(result => {
            if (result.data.length == 0) {
              reject({
                errno: 0,
                text: 'No more data!'
              });
            }
            this.trendList = this.trendList.concat(result.data);
            resolve();
          });
        });
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
      }
    },
    components: {
      slider,
      scroll,
      trend,
      loading
    }
  }

</script>

<style lang="less" scoped>
  .recommend-trend {
    width: 100vw;
    .slide-trend {
      width: 100vw;
      height: 28vw;
      margin: 3vw auto 0;
      .slide-trend-item {
        width: 96vw;
        height: 100%;
        margin: 0 2vw;
        box-sizing: border-box;
        padding: 2vw 3vw;
        background-color: #FFFFFF;
        box-shadow: 1vw 1vw 1vw #CCCCCC, -1vw 1vw 1vw #CCCCCC;
        display: flex;
        justify-content: space-between;
        align-items: center;
        .slide-trend-item-content {
          display: flex;
          flex-direction: column;
          justify-content: space-between;
          margin-right: 2vw;
          min-height: 16vw;
          .slide-trend-item-head {
            font-size: 4.5vw;
            font-weight: bold;
            margin-bottom: 2vw;
            i {
              color: #0080FF;
            }
          }
          .slide-trend-text {
            font-size: 4vw;
            display: -webkit-box;
            -webkit-box-orient: vertical;
            -webkit-line-clamp: 3;
            overflow: hidden;
          }
        }
        .slide-trend-image {
          max-width: 30vw;
          min-width: 30vw;
          height: 24vw;
          overflow: hidden;
          position: relative;
          img {
            position: absolute;
            left: 50%;
            top: 0;
            transform: translateX(-50%);
            height: 24vw;
          }
        }
      }
    }
    .trend-list {
      font-size: 4vw;
      overflow: hidden;
    }
  }

</style>
