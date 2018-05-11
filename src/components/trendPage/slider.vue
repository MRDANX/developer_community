<template>
	<div class="slider-wrapper" ref="sliderWrapper">
		<div class="slider-content">
			<slot></slot>
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
      }
    },
    mounted() {
      this.$nextTick(() => {
        this.slider = new BScroll(this.$refs.sliderWrapper, {
          scrollX: true,
          scrollY: false,
          click: true,
          momentum: false,
          // snap: {
          // 	stepX:414,
          //   loop: true,
          //   threshold: 0.3,
          //   speed: this.speed,
          // }
        });
        this.slider.on('flick', () => {
          console.log(this.slider.directionX);
					

        })
      });
    }
  }
</script>

<style lang="less" scoped>
  .slider-wrapper {
    width: 100%;
    height: 100%;
    .slider-content {
      width: fit-content;
      height: 100%;
      display: flex;
    }
  }
</style>