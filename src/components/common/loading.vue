<template>
  <div class="loading">
	  <i class="fa fa-spinner fa-pulse"></i>
  </div>
</template>

<script>
  export default {
    name: 'loading'
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
    color: #0099CC;
    font-size: 10vw;
  }
</style>