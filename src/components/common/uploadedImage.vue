<template>
  <div class="uploaded-image">
    <div class="image-wrapper">
      <img :src="src">
    </div>
    <i class="fa fa-close" @click="$emit('deleteImage')"></i>
  </div>
</template>

<script>
  export default {
    name: 'uploadedImage',
    props: {
      src: {
        type: String,
        default: ''
      }
    }
  }

</script>

<style lang="less" scoped>
  .uploaded-image {
    position: relative;
    width: 20vw;
    height: 20vw;
    display: inline-block;
    margin: 1vw 2vw;
    .image-wrapper {
      position: relative;
      width: 100%;
      height: 100%; // border-radius: 2vw;
      overflow: hidden;
      img {
        position: absolute;
        top: 0;
        left: 50%;
        height: 100%;
        transform: translateX(-50%);
      }
    }
    i {
      position: absolute;
      top: 0;
      right: 0;
      padding: .2vw .55vw;
      transform: translate(50%, -50%);
      width: 5vw;
      height: 5vw;
      box-sizing: border-box;
      text-align: center;
      line-height: 4vw;
      font-size: 4vw;
      color: #fff;
      border-radius: 50%;
      border: 1px solid #fff;
      background-color: hsla(0, 0%, 100%, .2);
    }
  }

</style>
