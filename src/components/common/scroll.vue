<template>
  <div class="wrapper" ref="wrapper">
    <transition-group name="smooth-slide" tag="div" appear>
      <div class="top-refresh" v-if="enableRefresh&&isPullingDown" :class="{positionChange:!isPullingDownRelease}" :key="1">
        <i class="fa fa-spinner fa-pulse" v-if="isPullingDownRelease"></i>
        <span v-else class="loading-tips" ref="refreshTips">松开刷新</span>
      </div>
      <div :key="2" class="slot">
        <slot></slot>
        <!-- <ul class="content">
          <li v-for="item in testData" :key="item">
            {{item}}
          </li>
        </ul> -->
      </div>
      <div class="bottom-load" v-if="enableLoadMore&&isPullingUp" :key="3">
        <span class="fa fa-spinner fa-spin" ref="loadMoreTips"></span>
      </div>
    </transition-group>
    <!-- scroll to top button -->
    <span v-if="enableScrollToTopButton" class="fa fa-arrow-circle-up scrollToTop" :class="{active:showScrollToTopButton}" @click="_scrollToTop"
      ref="scrollToTopButton"></span>
    <hint v-model="hintText">{{hintText}}</hint>
  </div>
</template>

<script>
  import BScroll from 'better-scroll'
  export default {
    name: 'scroll',
    props: {
      loadMore: {
        type: Function,
        default: () => {}
      },
      refresh: {
        type: Function,
        default: () => {}
      },
      enableRefresh: {
        type: Boolean,
        default: false
      },
      enableLoadMore: {
        type: Boolean,
        default: false
      },
      enableScrollToTopButton: {
        type: Boolean,
        default: false
      },
      nowScrollToTop: {
        type: Boolean,
        default: false
      }
    },
    data() {
      return {
        isPullingDown: false,
        isPullingDownRelease: false,
        isPullingUp: false,
        showScrollToTopButton: false,
        _enableLoadMore: false,
        hintText: ''
      }
    },
    created() {
      this._enableLoadMore = this.enableLoadMore;
    },
    mounted() {
      //initialize scroll after DOM mounted
      this.$nextTick(() => {
        this._initScroll();
        //simulate to pull down at first time to initialize
        this.isPullingDown = true;
        this._pullingDownReleased();
      });
      //add listener for scroll to top button to show the shrink/grow animation
      let scrollToTopButton = this.$refs.scrollToTopButton;
      if (scrollToTopButton) {
        scrollToTopButton.addEventListener('touchstart', () => {
          scrollToTopButton.classList.add('shrink');
        });
        scrollToTopButton.addEventListener('touchend', () => {
          scrollToTopButton.classList.remove('shrink');
        });
      }
      //refresh scroll when resize the visible window
      window.addEventListener('resize', () => {
        this._refresh();
      })
    },
    activated() {
      this._refresh();
    },
    updated() {
      if (this.nowScrollToTop) {
        this._scrollToTop();
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
            probeType: 2, //dispatch scroll event in real time
            click: true,
            mouseWheel: true
          });
          //check out whether to show the button to scroll to top
          if (this.enableScrollToTopButton) {
            this.scroll.on('scrollEnd', pos => {
              if (pos.y < -100) {
                this.showScrollToTopButton = true;
              } else {
                this.showScrollToTopButton = false;
              }
            });
          }

          //excute the handler when scrolling when enable refreshing
          if (this.enableRefresh) {
            this.scroll.on('scroll', (pos) => {
              if (pos.y > 10) {
                this._pullingDown(pos);
              }
            });
          }
          //excute the handler when release touch
          this.scroll.on('touchEnd', (pos) => {
            if (pos.y > 50) {
              this._pullingDownReleased(pos);
            } else if (pos.y <= (this.scroll.maxScrollY - 50)) {
              this._loadMore(pos);
            }
          });
        } else {
          this.scroll._refresh();
        }
      },
      _refresh() {
        this.$nextTick(() => {
          this.scroll && this.scroll.refresh();
        });
      },
      _disable() {
        this.scroll && this.scroll.disable();
      },
      _enable() {
        this.scroll && this.scroll.enable();
      },
      _scrollToTop() {
        this.scroll && this.scroll.scrollTo(0, 0, 800);
      },
      _scrollToBottom() {
        this.scroll && this.scroll.scrollTo(0, this.scroll.maxScrollY, 500);
      },
      _pullingDown(pos) {
        //show up the top refreshing when pulling down
        this.isPullingDown = true;
        this.isPullingDownRelease = false;
        //dynamically calculate the fontSize of the refreshing tips
        let refreshTips = this.$refs.refreshTips;
        if (refreshTips) {
          refreshTips.style.fontSize = ((pos.y / 30) + 3) + 'vw';
          if (pos.y < 80) {
            refreshTips.style.color = '#0099CC';
            refreshTips.innerHTML = '松开刷新(◕ᴗ◕✿)';
          } else if (pos.y > 80 && pos.y < 140) {
            refreshTips.style.color = '#0066CC';
            refreshTips.innerHTML = '( • ̀ω•́ )✧';
          } else {
            refreshTips.style.color = '#003399';
            refreshTips.innerHTML = '(▼へ▼メ)';
          }
        }
      },
      _pullingDownReleased(pos) {
        if (this.enableRefresh) {
          //execute pull down refresh data procedure if the position y greater than 50
          this._disable();
          this.isPullingDownRelease = true;
          //excute the passed refresh method with asychronized action and then reset and refresh scroll
          this.refresh().then(() => {
            this.isPullingDown = false;
            this._refresh();
            this._enable();
          }).catch(err => {
            if (err.errno == 0) {
              this.isPullingDown = false;
              this._enable();
              this.hintText = err.text;
              // console.log(err.text);
            } else {
              console.dir(err);
            }
          });
        }
      },
      _loadMore(pos) {
        //enable scroll's load more data when _enableLoadMore is true             
        if (this._enableLoadMore) {
          //execute pull up load more data procedure if the position y less than maxScrollY -30
          this._disable();
          this.isPullingUp = true;
          //scroll to bottom after refreshing the scroll to animate fluently
          new Promise((resolve, reject) => {
            resolve(this._refresh());
          }).then(() => {
            this._scrollToBottom();
          }).catch(err => {
            console.log(err);
          });
          //excute the passed loadMore method with asychronized action and then reset and refresh scroll
          this.loadMore().then(() => {
            this.isPullingUp = false;
            this._refresh();
            this._enable();
          }).catch(err => {
            if (err.errno == 0) {
              console.log(err.text);
              // this._refresh();
              let loadMoreTips = this.$refs.loadMoreTips;
              loadMoreTips.setAttribute('class', '');
              loadMoreTips.style.fontSize = '6vw';
              loadMoreTips.innerHTML = '没有更多了~';
              this._refresh();
              this._enable();
              //disable action of load more data
              this._enableLoadMore = false;
            } else {
              this.hintText = err;
              console.log(err);
              this._refresh();
              this._enable();
              //disable action of load more data
              this._enableLoadMore = false;
            }
          });
        }
      },
      reenableLoadMore() {
        let loadMoreTips = this.$refs.loadMoreTips;
        if (loadMoreTips) {
          loadMoreTips.setAttribute('class', 'fa fa-spinner fa-spin');
          loadMoreTips.style.fontSize = '';
          loadMoreTips.innerHTML = '';
        }
        this._refresh();
        //reenable action of load more data
        this.isPullingUp = false;
        this._enableLoadMore = true;
      },
      disableLoadMore() {
        this._enableLoadMore = false;
      },
      showHint(text) {
        this.hintText = text;
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
    height: 84vh; // position: relative;
    overflow: hidden;
    div.top-refresh,
    div.slot,
    div.bottom-load {
      position: relative;
      transition: all .5s;
      padding-bottom: 1.5vw;
    }
    .top-refresh {
      text-align: center;
      font-size: 10vw;
      color: #00A0FF;
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
      height: 15vw;
      line-height: 10vw;
      text-align: center;
      font-size: 8vw;
      color: #999999;
      // span{
      //   position: relative;
      //   right: 5%;
      // }
      
    }
    .scrollToTop {
      position: absolute;
      right: 3vw;
      bottom: -10vw;
      font-size: 10vw;
      color: #666666;
      border-radius: 50%;
      transition: all .5s;
      z-index: -1;
      &::after {
        content: '';
        width: 80%;
        height: 80%;
        border-radius: 50%;
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        background-color: #FFFFFF;
        z-index: -1;
      }
      &.active {
        bottom: 10vw;
        z-index: 99;
      }
      &.shrink {
        transition: all .1s;
        transform: scale(0.8);
      }
    }
  }

</style>
