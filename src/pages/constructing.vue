<template>
  <div class="subject-detail">
    <div class="top-nav">
      <div class="top-nav-content">
        <i class="fa fa-chevron-left" @click="$router.go(-1)"></i>
        <span class="nav-title">建设中。。。</span>
      </div>
    </div>
    <div class="constructing">
      <span>网页熬夜建设中。。。</span>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'subjectDetail',
    props: {
      subject: String
    }
  }

</script>

<style scoped>
  .subject-detail {
    width: 100vw;
    height: 100vh;
    background-color: #F5F6FA;
  }

  .top-nav {
    width: 100vw;
    height: 12vw;
    background-color: #0080FF;
    color: #FFFFFF;
    display: flex;
    align-items: center;
    font-size: 5vw;
    padding: 0 3vw;
    
  }
  i.fa-chevron-left{
    margin-right: 2vw;
    font-size: 5.5vw;
  }
  div.constructing{
    margin-top: 10vw;
    width: 100vw;
    height: 50vw;
    background-image: url("/static/images/common/constructing.svg");
    background-size: 100% 100%;
    position: relative;
  }
  .constructing span{
    font-size: 6vw;
    color: #666666;
    position: absolute;
    bottom: 0;
    left: 50%;
    transform: translate(-50%,200%);
    white-space: nowrap;
  }

</style>
