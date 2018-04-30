<template>
  <div class="wrapper" ref="wrapper">
    <transition-group name="smooth-slide" tag="div" appear>
      <div class="top-refresh" v-if="isPullingDown" :class="{positionChange:!isPullingDownRelease}" :key="1">
        <i class="fa fa-spinner fa-pulse" v-if="isPullingDownRelease"></i>
        <span v-else class="loading-tips" ref="refreshTips">释放刷新</span>
      </div>
      <div :key="2" class="slot">
        <slot></slot>
        <!-- <ul class="content">
          <li v-for="item in testData" :key="item">
            {{item}}
          </li>
        </ul> -->
      </div>
      <div class="bottom-load" ref="bottomLoad" v-if="isPullingUp" :key="3">
        <span class="fa fa-spinner fa-spin" ref="loadMoreTips"></span>
      </div>
    </transition-group>
    <span class="fa fa-arrow-circle-up scrollToTop" :class="{active:showScrollToTopButton}" @click="_scrollToTop" ref="scrollToTopButton"></span>
  </div>
</template>

<script>
  import BScroll from 'better-scroll'
  export default {
    name: 'scroll',
    props: {
      data: {
        type: Array,
        default: () => []
      },
      loadMore: {
        type: Function,
        default: () => {}
      },
      refresh: {
        type: Function,
        default: () => {}
      },
      enableScrollToTopButton: {
        type: Boolean,
        default: false
      },
      scrollToTop: {
        type: Boolean,
        default: false
      }
    },
    data() {
      return {
        isPullingDown: false,
        isPullingDownRelease: false,
        isPullingUp: false,
        showScrollToTopButton: false
      }
    },
    mounted() {
      //initialize scroll after DOM mounted
      this.$nextTick(() => {
        this._initScroll();
      });
      //add listener for scroll to top button to show the shrink/grow animation
      let scrollToTopButton = this.$refs.scrollToTopButton;
      scrollToTopButton.addEventListener('touchstart', () => {
        scrollToTopButton.classList.add('shrink');
      });
      scrollToTopButton.addEventListener('touchend', () => {
        scrollToTopButton.classList.remove('shrink');
      });
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

          //excute the handler when scrolling
          this.scroll.on('scroll', (pos) => {
            let refreshTips = this.$refs.refreshTips;
            if (pos.y > 10) {
              //show up the top refreshing when pulling down
              this.isPullingDown = true;
              this.isPullingDownRelease = false;
              //dynamically calculate the fontSize of the refreshing tips
              if (refreshTips) {
                refreshTips.style.fontSize = ((pos.y / 30) + 3) + 'vw';
                if (pos.y < 80) {
                  refreshTips.style.color = '#0099CC';
                  refreshTips.innerHTML = '释放刷新(◕ᴗ◕✿)';
                } else if (pos.y > 80 && pos.y < 140) {
                  refreshTips.style.color = '#0066CC';
                  refreshTips.innerHTML = '( • ̀ω•́ )✧';
                } else {
                  refreshTips.style.color = '#003399';
                  refreshTips.innerHTML = '(▼へ▼メ)';
                }
              }
            }
          });
          //excute the handler when release touch
          this.scroll.on('touchEnd', (pos) => {
            if (pos.y > 50) {
              //execute pull down refresh data procedure if the position y greater than 50
              this.scroll.disable();
              this.isPullingDownRelease = true;
              //excute the passed refresh method with asychronized action and then reset and refresh scroll
              this.refresh().then(() => {
                this.isPullingDown = false;
                this._refresh();
                this._enable();
              }).catch(err => {
                console.log(err);
              });
            } else if (pos.y <= (this.scroll.maxScrollY - 50)) {
              //execute pull up load more data procedure if the position y less than maxScrollY -30
              this.scroll.disable();
              this.isPullingUp = true;
              //scroll to bottom after refreshing the scroll to animate fluently
              new Promise((resolve, reject) => {
                resolve(this._refresh());
              }).then(() => {
                this.scroll.scrollTo(0, this.scroll.maxScrollY, 500);
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
                  let loadMoreTips = this.$refs.loadMoreTips;
                  loadMoreTips.setAttribute('class', '');
                  loadMoreTips.style.fontSize = '6vw';
                  loadMoreTips.innerHTML = '没有更多了！';
                  this._refresh();
                  this._enable();
                }

              });
            } else {
              //reset the status of pulling
              // this.isPullingUp = false;
              this.isPullingDown = false;
              this.isPullingDownRelease = false;
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
      }
    },
    watch: {
      scrollToTop(toTop) {
        if (toTop) {
          this._scrollToTop();

        }
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
      color: #0099CC;
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
    .scrollToTop {
      position: fixed;
      right: 3vw;
      bottom: 0vw;
      font-size: 10vw;
      color: #666666;
      background-color: #FFFFFF;
      box-shadow: 0 0 5vw #FFFFFF;
      border-radius: 50%;
      transition: all .3s;
      &.active {
        bottom: 20vw;
      }
      &.shrink {
        transition: all .1s;
        transform: scale(0.8);
      }
    }

  }

</style>
