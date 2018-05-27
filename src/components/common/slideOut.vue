<template>
  <div class="slide-out-wrapper">
    <div class="modal" key="modal" v-if="value&&showModal" @click="$emit('input',false)"></div>
    <transition :name="slideToDirection" class="wrapper">
      <div :class="['slide-out',slideToDirection]" v-if="value" key="content">
        <div :class="['slide-out-header',slideToDirection]" v-if="title">
          <i :class="['fa',directionIcon]" @touchstart="touchstart" @touchend="touchend" ref="goBackButton" @click="$emit('input',false);"></i>
          <span v-if="title">{{title}}</span>
        </div>
        <slot></slot>
      </div>
    </transition>
  </div>
</template>

<script>
  export default {
    name: 'slideOut',
    props: {
      //v-model show out value
      value: {
        type: Boolean,
        default: false
      },
      title: {
        type: String,
        default: ''
      },
      slideToDirection: {
        type: String,
        default: 'toLeft'
      },
      showModal: {
        type: Boolean,
        default: false
      }
    },
    methods: {
      touchstart() {
        this.$refs.goBackButton.classList.add('active');
      },
      touchend() {
        this.$refs.goBackButton.classList.remove('active');
        this.$emit('input',false);
      }
    },
    computed: {
      //display the corresponding Icon according to the prop slideToDirection
      directionIcon() {
        let toDirection = '';
        switch (this.slideToDirection) {
          case 'toLeft':
            return 'fa-angle-left';
            break;
          case 'toRight':
            return 'fa-angle-right';
            break;
          case 'toUp':
            return 'fa-angle-up';
            break;
          case 'toDown':
            return 'fa-angle-down';
            break;
          default:
            return 'fa-angle-left';
            break;
        }
      }
    }
  }

</script>

<style lang="less" scoped>
  .toRight-enter,
  .toRight-leave-to {
    transform: translateX(-100%);
  }

  .toLeft-enter,
  .toLeft-leave-to {
    transform: translateX(100%);
  }

  .toUp-enter,
  .toUp-leave-to {
    transform: translateY(100%);
  }

  .toDown-enter,
  .toDown-leave-to {
    transform: translateY(-100%);
  }
  .modal {
    position: fixed;
    top: 0;
    left: 0;
    width: 100vw;
    height: 100vh;
    z-index: 100;
    background-color: rgba(0, 0, 0, 0.5);
  }

  .slide-out {
    position: fixed;
    margin: auto;
    width: fit-content;
    height: fit-content;
    z-index: 101;
    transition: all .3s ease-out;
    &.toRight {
      top: 0;
      bottom: 0;
      left: 0;
    }
    &.toLeft {
      top: 0;
      bottom: 0;
      right: 0;
    }
    &.toUp {
      bottom: 0;
      left: 0;
      right: 0;
    }
    &.toDown {
      top: 0;
      left: 0;
      right: 0;
    }
    .slide-out-header {
      width: 100%;
      height: 7vh;
      // color: #ffffff;
      font-size: 5vw;
      line-height: 7vh;
      display: flex;
      flex-direction: row;
      align-items: center;
      i {
        margin: 0 5vw;
        transition: all .1s;
        position: relative;
        font-size: 8vw;
        transform: scaleX(1.15);
        &.active::after {
          content: '';
          display: inline-block;
          width: 250%;
          height: 100%;
          background-color: rgba(255, 255, 255, 0.2);
          position: absolute;
          top: 3%;
          left: -90%;
          border-radius: 50%;
        }
      }
      &.toUp i.active::after,
      &.toDown i.active::after {
        width: 160%;
        height: 120%;
        top: -10%;
        left: -35%;
      }
      &.toRight,
      &.toUp,
      &.toDown {
        flex-direction: row-reverse;
      }
    }
  }

</style>
