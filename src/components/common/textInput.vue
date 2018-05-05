<template>
  <div class="text-input">
    <span class="input-hint" :class="{active:isFocus||value}">{{hint}}</span>
    <input class="input-content" :type="innerInputType" :value="value" @input="$emit('input',$event.target.value)" @focus="isFocus=true"
      @blur="isFocus=false" ref="input" />
    <span class="fa-stack fa-lg" v-if="value&&inputType=='text'" @click="$emit('input','')">
      <i class="fa fa-circle fa-stack-2x"></i>
      <i class="fa fa-close fa-inverse fa-stack-1x"></i>
    </span>
    <span class="fa visibility" :class="innerInputType=='password'?'fa-eye':'fa-eye-slash'" v-if="value&&inputType=='password'"
      @click="toggleInputType"></span>
  </div>
</template>

<script>
  export default {
    name: "textInput",
    data() {
      return {
        isFocus: false,
        innerInputType: ""
      };
    },
    props: {
      value: String,
      inputType: {
        type: String,
        default: "text"
      },
      hint: {
        type: String,
        default: "用户"
      }
    },
    methods: {
      toggleInputType() {
        if (this.innerInputType == "text") {
          this.innerInputType = "password";
        } else if (this.innerInputType == "password") {
          this.innerInputType = "text";
        }
        this.$refs.input.focus();
      }
    },
    created() {
      this.innerInputType = this.inputType;
    }
  };

</script>

<style lang="less" scoped>
  .text-input {
    width: 100%;
    height: 10vw;
    position: relative;
    margin: 6vw 0;
    &::after {
      content: "";
      width: 100%;
      height: 2px;
      background: #777777;
      position: absolute;
      bottom: 0;
      left: 0;
    }
    .input-hint {
      position: absolute;
      top: 0;
      left: 1vw;
      line-height: 10vw;
      font-size: 6vw;
      transition: all 0.4s;
      &.active {
        font-size: 4vw;
        transform: translateY(-65%);
        transform-style: preserve-3d;
      }
    }
    .input-content {
      position: absolute;
      top: 0;
      left: 0;
      width: 90%;
      height: 100%;
      font-size: 6vw;
      background-color: transparent;
      text-indent: 1vw;
      border: none;
      outline: none;
    }
    span.fa-stack,
    span.visibility {
      position: absolute;
      right: 0;
      top: 0;
      bottom: 0;
      margin: auto;
      font-size: 3vw;
      line-height: 1.8em;
    }
    span.visibility {
      font-size: 5vw;
    }
  }

</style>
