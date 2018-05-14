<template>
	<div class="slider-wrapper" ref="sliderWrapper">
		<div class="slider-content">
			<slot></slot>
		</div>
		<div class="friendly-hint" v-if="timer">
			<i class="fa fa-angle-double-left"></i>
		</div>
	</div>
</template>

<script>
  import BScroll from 'better-scroll';
  export default {
    name: 'slider',
    props: {
      loop: {
        type: Boolean,
        default: false
      },
      speed: {
        type: Number,
        default: 300
      },
      autoPlay: {
        type: Boolean,
        default: false
      }
    },
    data() {
      return {
        timer: null
      }
    },
    mounted() {
      this.$nextTick(() => {
        this.slider = new BScroll(this.$refs.sliderWrapper, {
          scrollX: true,
          scrollY: false,
          click: true,
          momentum: false,
          snap: {
            loop: this.loop,
            threshold: 0.3,
            speed: this.speed,
          }
        });
        if (!this.autoPlay) {
          this.timer = setTimeout(() => {
            this.slider.scrollBy(-10, 0, 500);
          }, 1500);
          this.slider.on('beforeScrollStart', () => {
            this.timer = clearTimeout(this.timer);
          });
        }
        if (this.autoPlay) {
          this.timer = null;
					this._play();
					this.slider.on('beforeScrollStart', () => {
            clearTimeout(this.autoPlayTimer);
          });
          this.slider.on('scrollEnd', () => {
            this._play();
          });
        }
      });
    },
    methods: {
      _play() {
        clearTimeout(this.autoPlayTimer);
        this.autoPlayTimer = setTimeout(() => {
          this.slider.next();
        }, 2500);
      }
    }
  }
</script>

<style lang="less" scoped>
  .slider-wrapper {
    width: 100%;
    height: 100%;
    position: relative;
    .slider-content {
      width: fit-content;
      height: 100%;
      display: flex;
    }
    .friendly-hint {
      position: absolute;
      right: 3vw;
      top: 0;
      height: 100%;
      display: flex;
      align-items: center;
      i.fa {
        font-size: 10vw;
        color: #CCCCCC;
        animation: friendlyHint 2s ease 1.5s infinite;
      }
    }
  }

  @keyframes friendlyHint {
    0% {
      transform: translateX(0);
      opacity: 1;
    }
    50% {
      transform: translateX(-10px);
      opacity: 0.3;
    }
    100% {
      transform: translateX(0);
      opacity: 1;
    }
  }
</style>