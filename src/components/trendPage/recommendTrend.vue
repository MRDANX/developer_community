<template>
  <scroll :enableLoadMore='true' :enableRefresh="true" :refresh="refresh" :loadMore="loadMore" ref="recommendScroll">
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
      <transition-group name="show" class="trend-list" tag="ul">
        <trend v-for="(trend,index) in trendList" :key="'trend'+trend.trendID" :trend="trend" @askLogin="$refs.recommendScroll.showHint('请先登录')"
          @updateCurrentTrend="updateSpecifiedTrend(index)" @showSharePanel="$emit('showSharePanel',$event)" />
      </transition-group>
      <loading v-if="showLoading" />
    </div>
  </scroll>
</template>

<script>
  import scroll from "@/components/common/scroll";
  import loading from "@/components/common/loading";
  import slider from "@/components/trendPage/slider";
  import trend from "@/components/trendPage/trend";
  import {
    differenceBy
  } from 'lodash';
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
      // this.showLoading = true;
      // this.$axios({
      //   method: 'get',
      //   url: '/api/getTrendList',
      //   params: {
      //     startIndex: 0,
      //     number: 5
      //   }
      // }).then(result => {
      //   this.trendList = result.data;
      //   this.showLoading = false;
      // });
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
      //return a promise which excute asychronized action to refresh data
      refresh() {
        return new Promise((resolve, reject) => {
          this.$axios.get('/api/getTrendList', {
            params: {
              startIndex: 0,
              number: 5
            }
          }).then(result => {
            let filteredData = differenceBy(result.data, this.trendList, 'trendID');
            setTimeout(() => {
              if (filteredData.length == 0) {
                reject({
                  errno: 0,
                  text: '已经是最新的了!'
                });
              }
              this.trendList = result.data;
              resolve();
            }, 500);

          }).catch(err => {
            if (err.response) {
              this.hintText = err.response;
              console.log('error.response: ', err.response);
            } else if (err.request.readyState == 4 && err.request.status == 0) {
              this.hintText = '请求超时';
              console.warn('Request timeout!');
            } else {
              console.error(err);
            }
          });
        })
      },
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
  .show-enter-active {
    transition: all .5s;
  }

  .show-enter {
    transform: scale(0.8);
    opacity: 0;
  }

  .show-leave-active {
    position: absolute !important;
    transition: all .5s;
  }

  .show-leave-to {
    transform-origin: center top;
    transform: scale(0.1);
    opacity: 0;
  }

  .show-move {
    transition: all .5s;
  }

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
