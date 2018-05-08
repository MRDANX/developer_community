<template>
	<div id="carousel" class="wrapper" ref="carousel">
		<div class="content" ref="content">
			<slot></slot>
		</div>
		<ul class="dots" v-if="showDot">
			<li class="dot" v-for="(dot,index) in dots" :class="{active:currentPageIndex==index}" :key="index"></li>
		</ul>
	</div>
</template>

<script>
  import BScroll from 'better-scroll';
  export default {
    name: 'carousel',
    props: {
      autoPlay: {
        type: Boolean,
        default: false
      },
      loop: {
        type: Boolean,
        default: false
      },
      interval: {
        type: Number,
        default: 3000
      },
      showDot: {
        type: Boolean,
        default: false
      }
    },
    data() {
      return {
        dots: [],
        currentPageIndex: 0
      }
    },
    activated() {
      if (this.carousel) {
        this.carousel.enable();
        if (this.autoPlay) {
          this._play();
        }
      }
    },
    deactivated() {
      if (this.carousel) {
        clearTimeout(this.timer);
        this.carousel.disable();
      }
    },
    mounted() {
      this.$nextTick(() => {
        this.carousel = new BScroll(this.$refs.carousel, {
          scrollX: true,
          scrollY: false,
          click: true,
          momentum: false,
          snap: {
            loop: this.loop,
            threshold: 0.1,
            speed: 500,
            easing: {
              style: 'cubic-bezier(0.25, 0.46, 0.45, 0.94)',
              fn: function(t) {
                return t * (2 - t)
              }
            }
          },
          bounce: false,
          stopPropagation: true
        });
        this.carousel.on('scrollEnd', () => {
          let pageIndex = this.carousel.getCurrentPage().pageX;
          this.currentPageIndex = pageIndex;
          if (this.autoPlay) {
            this._play();
          }
        });
        // this.carousel.on('touchEnd', () => {
        //   if (this.autoPlay) {
        //     this._play();
        //   }
        // });
        this.carousel.on('beforeScrollStart', () => {
          if (this.autoPlay) {
            clearTimeout(this.timer);
          }
        });
        if (this.showDot) {
          this.dots = new Array(this.$refs.content.children.length - 2);
        }
        if (this.autoPlay) {
          this._play();
        }
      });
    },
    methods: {
      _play() {
        clearTimeout(this.timer);
        this.timer = setTimeout(() => {
          this.carousel.next();
        }, this.interval);
      }
    }
  }
</script>

<style lang="less">
  #carousel {
    width: 100%;
    height: 100%;
    position: relative;
    .content {
      width: fit-content;
      height: 100%;
      display: flex;
      .item {
        width: 100vw;
        height: 100%;
        text-align: center;
      }
    }
    .dots {
      position: absolute;
      width: fit-content;
      bottom: 3vw;
      left: 0;
      right: 0;
      margin: auto;
      display: flex;
      justify-content: space-around;
      .dot {
        width: 3vw;
        height: 3vw;
        border-radius: 50%;
        background-color: rgba(255, 255, 255, 0.5);
        transition: all .5s;
        margin: 0 2vw;
        &.active {
          width: 6vw;
          background-color: rgba(255, 255, 255, 0.9);
          border-radius: ~'30%/50%';
        }
      }
    }
  }
</style>