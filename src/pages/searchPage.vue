<template>
  <div class="search-page">
    <div class="searchBar" :class="{searching:isSearching}">
      <i class="fa fa-angle-left" ref="goBack" @click="goBack"></i>
      <div class="search-box">
        <input type="text" @focus="isSearching=true" v-model="searchText" @keyup.enter="searchButtonPressed=true" />
        <i class="fa fa-search" ref="searchButton" @click="searchButtonPressed=true"></i>
      </div>
    </div>
    <div class="content" :class="{searching:isSearching}">
      <transition :name="isSearching?'slide-down':'slide-up'">
        <keep-alive>
          <component :is="isSearching?'searchingContent':'searchContent'" v-model="searchText" :searchButtonPressed="searchButtonPressed"
            @setSearchButton="searchButtonPressed=$event" @focusSearch="isSearching=true" />
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
        searchButtonPressed: false,
        slideDirection: 'slide-down'
      }
    },
    deactivated() {
      // this.searchText='';
      // this.isSearching = false;
    },
    mounted() {
      this.$activeFeedback(this.$refs.goBack);
      this.$activeFeedback(this.$refs.searchButton);
    },
    methods: {
      goBack() {
        this.searchText = '';
        this.$nextTick(() => {
          this.isSearching = false;
        });
      }
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
    top: 14vw;
    transition: all .5s;
  }

  .slide-down-enter {
    // transform: translateY(-84vh);
    opacity: 0;
  }

  .slide-down-leave-active {
    position: fixed;
    top: 14vw;
    transition: all .5s;
    z-index: 98;
  }

  .slide-down-leave-to {
    transform: translateY(84vh);
  }

  .slide-up-enter-active {
    position: fixed;
    top: 14vw;
    transition: all .5s;
    z-index: 98;
  }

  .slide-up-enter {
    transform: translateY(84vh);
  }

  .slide-up-leave-active {
    position: fixed;
    top: 14vw;
    transition: all .5s;
    z-index: 97;
  }

  .slide-up-leave-to {
    opacity: 0; // transform: translateY(-84vh);
  }

  div.search-page {
    width: 100vw;
    position: relative;
    div.searchBar {
      width: 100vw;
      background-color: #0080FF;
      height: 14vw;
      text-align: center;
      color: #FFFFFF;
      line-height: 14vw;
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
          color: #FFFFFF;
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
