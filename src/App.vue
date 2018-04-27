<template>
  <transition name="slide" >
    <keep-alive>
      <router-view/>
    </keep-alive>
  </transition>

</template>

<script>
  export default {
    name: "App"
  };

</script>

<style>
  .slide-enter-active{
    transition: all .3s;
  }

  .slide-enter {
    opacity: 0;
    transform: translateX(100%);
  }

  .slide-enter-to {
    transform: translateX(0);
    opacity: 1;
  }

  .slide-leave-active{
    transition: all .3s;
  }

  .slide-leave {
    opacity: 1;
    transform: translateX(0);
  }

  .slide-leave-to {
    opacity: 0;
    transform: translateX(-100%);
  }
  /* .slide-leave-active{
    transition: all .5s;
  }

  .slide-leave {
    transform: translateX(0);
  }

  .slide-leave-to {
    transform: translateX(100%);
  } */
  /* .slide-leave-active{
    transition: all 15s;
  }
  .slide-leave{
    transform: translateX(0);
  }
  .slide-leave-to{
    transform: translateX(100%);
  } */
  html,
  body,
  h1,
  h2,
  h3,
  h4,
  h5,
  ul,
  li,
  p {
    padding: 0;
    margin: 0;
  }

  html,
  body {
    background-color: #f1f1f1;
  }

  ul {
    list-style-type: none;
    padding: 0;
  }

  h1,
  h2 {
    font-weight: normal;
  }

</style>
