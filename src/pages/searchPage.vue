<template>
  <div class="search-page">
    <div class="nav" :class="{searching:isSearching}">
      <i class="fa fa-angle-left" ref="goBack" @click="isSearching = false"></i>
      <div class="search-box">
        <input type="text" @focus="isSearching=true" @blur="searchText=''" v-model="searchText" />
        <i class="fa fa-search" ref="searchButton"></i>
      </div>
    </div>
    <div class="content" :class="{searching:isSearching}">
      <transition :name="isSearching?'slide-down':'slide-up'" >
        <keep-alive>
          <component :is="isSearching?'searchingContent':'searchContent'" v-model="searchText"></component>
        </keep-alive>
      </transition>
    </div>
  </div>
</template>

<script>
  import searchContent from '@/components/searchPage/searchContent';
  import searchingContent from '@/components/searchPage/searchingContent';
  export default {
    name: 'searchPage',
    data() {
      return {
        searchText: '',
        isSearching: false,
        slideDirection: 'slide-down'
      }
    },
    methods: {},
    mounted() {
      this.$activeFeedback(this.$refs.goBack);
      this.$activeFeedback(this.$refs.searchButton);
    },
    components: {
      searchContent,
      searchingContent
    }
  }
</script>

<style lang="less" scoped>
  .slide-down-enter-active {
    position: fixed;
    top: 7vh;
    transition: all .5s;
  }

  .slide-down-enter {
    // transform: translateY(-84vh);
    opacity: 0;
  }

  .slide-down-leave-active {
    position: fixed;
    top: 7vh;
    transition: all .5s;
    z-index: 98;
  }

  .slide-down-leave-to {
    transform: translateY(84vh);
  }

  .slide-up-enter-active {
    position: fixed;
    top: 7vh;
    transition: all .5s;
    z-index: 98;
  }

  .slide-up-enter {
    transform: translateY(84vh);
  }

  .slide-up-leave-active {
    position: fixed;
    top: 7vh;
    transition: all .5s;
    z-index: 97;
  }

  .slide-up-leave-to {
    opacity: 0; // transform: translateY(-84vh);
  }

  div.search-page {
    width: 100vw;
    position: relative;
    div.nav {
      width: 100vw;
      background-color: #0080FF;
      height: 7vh;
      text-align: center;
      color: #FFFFFF;
      line-height: 7vh;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 8vw;
      position: relative;
      z-index: 99;
      i.fa-angle-left {
        visibility: hidden;
        width: 0;
        position: absolute;
        left: -5vw;
      }
      div.search-box {
        width: 90%;
        height: 70%;
        border-radius: 10vw;
        position: relative;
        background-color: rgba(255, 255, 255, 0.3);
        transition: all .5s;
        input {
          width: 90%;
          height: 100%;
          border: none;
          outline: none;
          position: absolute;
          left: 0;
          font-size: 6vw;
          margin-left: 3vw;
          color: #333333;
          background-color: transparent;
        }
        i.fa-search {
          width: 10vw;
          height: 4.9vh;
          line-height: 4.9vh;
          border-radius: 5vw;
          position: absolute;
          left: 0vw;
          top: 50%;
          transform: translateY(-50%);
          font-size: 6vw;
          transition: all .5s;
        }
      }
      &.searching {
        justify-content: center;
        i.fa-angle-left {
          visibility: visible;
          left: 1vw;
          width: 8vw;
          height: 8vw;
          line-height: 8vw;
          border-radius: 50%;
          transition: all .5s;
          &.active {
            transition: all .1s;
            background-color: rgba(255, 255, 255, 0.3);
          }
        }
        div.search-box {
          width: 80%;
          input {
            width: 86%;
          }
          i.fa-search {
            left: 70vw;
            &.active {
              transition: all .1s;
              background-color: rgba(255, 255, 255, 0.3);
            }
          }
        }
      }
    }
    div.content {
      width: 100vw;
      height: 84vh;
      position: relative;
    }
  }
</style>