<template>
  <div id="layout">
    <keep-alive>
      <router-view />
    </keep-alive>
    <ul class="fixed-nav">
      <router-link ref="links" v-for="(link,index) in links" :to="link.to" :key="index" class="fa" :class="link.class" tag="li"></router-link>
    </ul>
  </div>
</template>

<script>
  export default {
    name: "layoutPage",
    data() {
      return {
        links: [{
            to: '/subject',
            class: 'fa-home'
          },
          {
            to: '/comment',
            class: 'fa-comments'
          },
          {
            to: '/search',
            class: 'fa-search'
          },
          {
            to: '/setting',
            class: 'fa-user'
          }
        ]
      }
    },
    created(){
      this.$store.dispatch('user/checkUserInfo');
    },
    mounted() {
      this.$refs.links.forEach(link => {
        link.$el.addEventListener('touchstart', () => {
          link.$el.classList.add('active');
        });
        link.$el.addEventListener('touchend', () => {
          link.$el.classList.remove('active');
        });
      })
    }
  };

</script>

<style lang='less'>
  #layout {
    width: 100%;
    background-color: #F5F6FA;
    ul.fixed-nav {
      display: flex;
      justify-content: space-between;
      position: fixed;
      left: 0;
      bottom: 0;
      z-index: 99;
      width: 100vw;
      height: 9vh;
      font-size: 5vh;
      background-color: #FFFFFF;
      box-shadow: 0 -2px 10px #C8CBD4;
      li {
        color: #C8CBD4;
        position: relative;
        line-height: 9vh;
        background-color: #FFFFFF;
        transition: color .3s;
        width: 25vw;
        text-align: center;
        &:nth-child(3) {
          font-size: 4.5vh;
        }
        &.router-link-active {
          color: #0080FF;
        }
        &.active {
          background-color: rgba(0, 0, 0, .1);
        }
      }
    }
  }

</style>
