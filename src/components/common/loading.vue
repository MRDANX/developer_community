<template>
  <div class="loading">
	  <i class="fa fa-spinner fa-pulse" :style="{top:relativeTop,left:relativeLeft,color:color}"></i>
  </div>
</template>

<script>
  export default {
    name: 'loading',
    props: {
      verticalMove: {
        type: Number,
        default: 0
      },
      horizontalMove: {
        type: Number,
        default: 0
      },
      color:{
        type:String,
        default:'#0099CC'
      }
    },
    computed: {
      relativeTop() {
        return this.verticalMove + 'vh';
      },
      relativeLeft() {
        return this.horizontalMove + 'vw';
      }
    }
  }
</script>

<style>
  .loading {
    position: fixed;
    width: 100vw;
    height: 100vh;
    top: 0;
    left: 0;
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 9999;
  }

  i.fa-spinner {
    font-size: 10vw;
    position: relative;
    /* background-color: #FFFFFF; */
    /* border-radius: 50%; */
  }
</style>