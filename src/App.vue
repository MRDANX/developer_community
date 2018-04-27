<template>
  <transition name="fade">
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
  .fade-enter-active,
  .fade-leave-active {
    position: absolute;
    top: 0;
    left: 0;
  }

  .fade-enter-active {
    transition: all .5s;
  }

  .fade-leave-active {
    transition: all .3s;
  }

  .fade-enter,
  .fade-leave-to {
    opacity: 0;
  }

  .fade-enter-to,
  .fade-leave {
    opacity: 1;
  }

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
