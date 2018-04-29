<template>
  <div class="wrapper" ref="wrapper">
    <transition-group name="smooth-slide" tag="div" appear>
      <!-- <transition name="test"> -->
      <!-- :class="{positionChange:!isPullingDownRelease}" -->
      <div class="top-refresh" v-if="isPullingDown" :class="{positionChange:!isPullingDownRelease}" :key="1">
        <i class="fa fa-spinner fa-pulse" v-if="isPullingDownRelease"></i>
        <span v-else class="loading-tips" ref="loadingTips">释放刷新</span>
      </div>
      <!-- </transition> -->
      <!-- <ul class="content">
        <li v-for="item in testData" :key="item">
          {{item}}
        </li>
      </ul> -->
      <div :key="2" class="slot">
        <slot></slot>
      </div>
      <div class="bottom-load" ref="bottomLoad" v-if="isPullingUp" :key="3">
        <i class="fa fa-spinner fa-spin"></i>
      </div>
    </transition-group>
  </div>
</template>

<script>
  import BScroll from 'better-scroll'
  export default {
    name: 'scroll',
    props: {
      isPullingDown: {
        type: Boolean,
        default: false
      },
      isPullingDownRelease: {
        type: Boolean,
        default: false
      },
      isPullingUp: {
        type: Boolean,
        default: false
      },
      requireRefresh: {
        type: Object,
        default: () => {}
      },
      data: {
        type: Array,
        default: () => []
      }
    },
    mounted() {
      this.$nextTick(() => {
        this._initScroll();
      });
    },
    watch: {
      data() {
        this._refresh();
      },
      requireRefresh({
        pullingUp,
        pullingDown
      }) {
        let promise = new Promise((resolve, reject) => {
          resolve(this._refresh());
        });
        if (pullingUp) {
          promise.then(() => {
            console.log('scroll to bottom');
            this.scroll.scrollTo(0, this.scroll.maxScrollY, 500);
            // this.scroll&&this.scroll.enable();
          })
        } else if (pullingDown) {
          promise.then(() => {
            this.scroll.scrollTo(0, 0, 500);
            // this.scroll&&this.scroll.enable();
          })
        }
      }
    },
    methods: {
      _initScroll() {
        //return directively if the wrapper element isn't existed
        if (!this.$refs.wrapper) {
          console.error('wrapper is not existed.');
          return;
        }
        //create and initialize scroll if it's not existed
        if (!this.scroll) {
          this.scroll = new BScroll(this.$refs.wrapper, {
            probeType: 2 //dispatch scroll event in real time
          });
          //excute the handler when scrolling
          this.scroll.on('scroll', (pos) => {
            let loadingTips = this.$refs.loadingTips;
            if (pos.y > 10) {
              //show up the top refreshing when pulling down
              this.$emit('checkPullingDown');
              // this.isPullingDown = true;
              // this.isPullingDownRelease = true;
              //dynamically calculate the fontSize of the refreshing tips
              if (loadingTips) {
                loadingTips.style.fontSize = ((pos.y / 30) + 3) + 'vw';
                if (pos.y < 50) {
                  loadingTips.style.color = '#999999';
                  loadingTips.innerHTML = '释放刷新(◕ᴗ◕✿)';
                } else if (pos.y > 50 && pos.y < 100) {
                  loadingTips.style.color = '#00FF00';
                  loadingTips.innerHTML = '过分啦( • ̀ω•́ )✧';
                } else {
                  loadingTips.style.color = '#FF0000';
                  loadingTips.innerHTML = '快放手(▼へ▼メ)';
                }
              }
            }
          });
          //excute the handler when release touch
          this.scroll.on('touchEnd', (pos) => {
            if (pos.y > 50) {
              //execute pull down refresh data procedure if the position y greater than 50
              // this.isPullingDown = false;
              //asynchronized code here
              this.$emit('refresh');
              // setTimeout(() => {
              //   this.testData.unshift('pullDown: ' + (this.testData.length + 1));
              //   this.isPullingDownRelease = false;
              // }, 1500);
            } else if (pos.y <= (this.scroll.maxScrollY - 30)) {
              //execute pull up load more data procedure if the position y less than maxScrollY -30
              this.$emit('loadMore');
              // this.isPullingUp = true;
              //asynchronized code here
              // setTimeout(() => {
              //   this.testData = this.testData.concat([55, 56, 57, 58, 59, 60]);
              //   this.isPullingUp = false;
              // }, 1500);
            } else {
              //reset the status of pulling
              this.$emit('resetStatus');
              // this.isPullingUp = false;
              // this.isPullingDown = false;
              // this.isPullingDownRelease = false;
            }
          });
        } else {
          this.scroll.refresh();
        }
      },
      _refresh() {
        this.$nextTick(() => {
          // this.scroll&&this.scroll.disable();
          this.scroll && this.scroll.refresh();
          // console.log(this.scroll.maxScrollY);
        });
      }
    }
  }

</script>

<style lang="less" scoped>
  .smooth-slide-leave-active {
    position: absolute !important;
    left: 0;
    right: 0;
    margin: auto;
  }

  .smooth-slide-leave-to {
    opacity: 0;
    transform: translateY(-100%);
  }

  div.wrapper {
    width: 100vw;
    height: 84vh;
    position: relative;
    div.top-refresh,
    div.slot,
    div.bottom-load {
      position: relative;
      transition: all .5s;
    }
    .top-refresh {
      text-align: center;
      font-size: 10vw;
      color: #999999;
      &.positionChange {
        position: absolute;
        top: -12vw;
        left: 0;
        right: 0;
        margin: auto;
      }
      .loading-tips {
        font-size: 3vw;
        transition: color 1s;
      }
    }
    .bottom-load {
      text-align: center;
      font-size: 8vw;
      color: #999999;
    }
  }

</style>
