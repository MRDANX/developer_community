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
      height: 100%;
      // border-radius: 2vw;
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
      padding: 0.2vw 0.55vw;
      transform: translate(30%, -30%);
      color: #FFFFFF;
      border-radius: 50%;
      border: 1px solid #FFFFFF;
      background-color: rgba(255, 255, 255, 0.2);
    }
  }
</style>