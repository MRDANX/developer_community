<template>
  <transition name="hint-fade">
    <div class="hint" v-if="value">{{value}}</div>
  </transition>
</template>

<script>
  export default {
    name: 'hint',
    props: {
      value: {
        type: String,
        default: ''
      }
    },
    watch: {
      value(n, o) {
        if (n != '') {
          setTimeout(() => {
            this.$emit('input', '');
          }, 2000);
        }
      }
    }
  }

</script>

<style scoped>
  .hint-fade-enter,
  .hint-fade-leave-to {
    opacity: 0;
  }

  .hint {
    transition: all .5s;
    position: absolute;
    left: 50%;
    transform: translateX(-50%);
    bottom: 20vh;
    color: #F1F1F1;
    font-size: 4vw;
    padding: 2vw 4vw;
    border-radius: 5px;
    background-color: rgba(0, 0, 0, 0.8);
  }

</style>
