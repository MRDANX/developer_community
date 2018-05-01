<template>
  <div class="slide-out" :class="[slideToDirection,{active:showOut}]">
    <div :class="['slide-out-header',slideToDirection]">
      <i :class="['fa',directionIcon]" @click="$emit('hide')" ref="goBackButton"></i>
      <span>{{title}}</span>
    </div>
    <slot></slot>
  </div>
</template>

<script>
  export default {
    name: 'slideOut',
    props: {
      title: {
        type: String,
        default: 'header'
      },
      showOut: {
        type: Boolean,
        default: false
      },
      slideToDirection: {
        type: String,
        default: 'toLeft'
      }
    },
    computed: {
      //display the corresponding Icon according to the prop slideToDirection
      directionIcon() {
        let toDirection = '';
        switch (this.slideToDirection) {
          case 'toLeft':
            return 'fa-arrow-left';
            break;
          case 'toRight':
            return 'fa-arrow-right';
            break;
          case 'toUp':
            return 'fa-arrow-up';
            break;
          case 'toDown':
            return 'fa-arrow-down';
            break;
          default:
            return 'fa-arrow-left';
            break;
        }
      }
    },
    mounted() {
      let goBackButton = this.$refs.goBackButton;
      if (goBackButton) {
        goBackButton.addEventListener('touchstart', () => {
          goBackButton.classList.add('active')
        });
        goBackButton.addEventListener('touchend', () => {
          goBackButton.classList.remove('active')
        });
      }
    }
  }

</script>

<style lang="less" scoped>
  .slide-out {
    position: fixed;
    top: 0;
    left: 0;
    transition: all 0.3s ease-out;
    width: 100vw;
    height: 100vh;
    background-color: #F1F1F1;
    z-index: 100;
    &.toLeft {
      transform: translateX(100%) translateY(0);
    }
    &.toRight {
      transform: translateX(-100%) translateY(0);
    }
    &.toUp {
      transform: translateX(0) translateY(100%);
    }
    &.toDown {
      transform: translateX(0) translateY(-100%);
    }
    &.active {
      transform: translateX(0) translateY(0);
    }
    .slide-out-header {
      width: 100vw;
      height: 7vh;
      background-color: #0080FF;
      color: #ffffff;
      font-size: 3.5vh;
      line-height: 7vh;
      display: flex;
      align-items: center;
      i {
        margin: 0 5vw;
        transition: all .1s;
      }
      &.toRight {
        flex-direction: row-reverse;
      }
      &.toLeft {
        flex: row;
      }
      &.toRight>i,
      &.toLeft>i {
        transform: translateX(0) rotateY(0deg) scaleX(1.3);
        &.active {
          transform: translateX(50%) rotateY(180deg) scaleX(1.3);
        }
      }
      &.toUp,
      &.toDown {
        flex-direction: row-reverse;
      }
      &.toUp>i,
      &.toDown>i {
        transform: rotateX(0) scaleY(1.3);
        &.active {
          transform: rotateX(180deg) scaleY(1.3);
        }
      }
    }
  }

</style>
