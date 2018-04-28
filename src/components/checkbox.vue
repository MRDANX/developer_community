<template>
  <div class="checkbox">
    <label :for="'checkbox'+index" class="checkbox-container" :class="{active:checked}" @click="checked=!checked"></label>
    <input type="checkbox" :id="'checkbox'+index" v-model="checked" class="input-checkbox" />
  </div>
</template>

<script>
  export default {
    name: 'checkbox',
    props: {
      isChecked: {
        type: Boolean,
        default: true
      },
      index: {
        type: Number,
        default: 0
      }
    },
    data() {
      return {
        checked: this.isChecked
      }
    },
    watch: {
      checked(isChecked, old) {
        this.$emit('checkout', {
          isChecked: isChecked,
          index: this.index
        });
      }
    }
  }

</script>

<style lang="less" scoped>
  .checkbox {
    display: inline-block;
    label.checkbox-container {
      width: 100%;
      height: 100%;
      position: relative;
      display: block;
      &::before {
        content: '';
        width: 100%;
        height: 50%;
        position: absolute;
        left: 0;
        top: 50%;
        transition: all .5s ease-in-out;
        transform: translateY(-50%);
        background-color: #CCCCCC;
        box-shadow: 0 0 1vw #CCCCCC;
        border-radius: ~"15%/50%";
      }
      &.active::before {
        background-color: #99CCFF;
        box-shadow: 0 0 1vw #99CCFF;
      }
      &::after {
        content: '';
        width: 50%;
        height: 100%;
        position: absolute;
        top: 0;
        left: 0;
        transition: all .5s;
        background-color: white;
        border-radius: 50%;
        box-shadow: 0 0 0.5vw #333333;
      }
      &.active::after {
        left: 50%;
        background-color: #0066CC;
        box-shadow: 0 0 0.5vw #0066CC;
      }
    }
    input.input-checkbox {
      display: none;
    }
  }

</style>
