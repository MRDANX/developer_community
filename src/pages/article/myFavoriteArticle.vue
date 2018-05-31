<template>
  <div class="my-favorite-article" ref="wrapper">
    <div class="article-head">
      <i class="fa fa-arrow-left" @click="$router.go(-1)"></i>
      <span>我喜欢的文章</span>
    </div>
    <transition-group name="animate" class="article-list" tag="ul" v-if="articleList.length!=0">
      <article-brief v-for="(article,index) in articleList" :key="index" :articleInfo="article" @updateCurrentArticle="updateSpecifiedArticle(index)"
      />
    </transition-group>
    <div v-else class="none-article">
      <span>你还没有喜欢的文章喔!</span>
    </div>
    <loading v-if="showLoading" />
    <hint v-model="hintText" />
  </div>
</template>

<script>
  import {
    mapState
  } from "vuex";
  import articleBrief from '@/components/homePage/articleBrief';
  import {
    throttle
  } from 'lodash';
  export default {
    name: 'myFavoriteArticle',
    data() {
      return {
        articleList: [],
        showLoading: false,
        hasMore: true,
        hintText: '',
        userID:0
      }
    },
    computed: {
      ...mapState('user', ['userInfo'])
    },
    mounted() {
      window.addEventListener('scroll', throttle(this.checkScrollToBottom, 200));
    },
    activated() {
       if (this.userInfo.userID != this.userID) {
        this.articleList = [];
        this.userID = this.userInfo.userID;
      }
      this.getArticleList();
    },
    methods: {
      getArticleList() {
        let tmpList = this.userInfo.favoriteArticle,
          favoriteList = [];
        for (let i = 0; i < tmpList.length; i++) {
          favoriteList.unshift(tmpList[i].articleID);
        }
        if (favoriteList.length > 0) {
          this.showLoading = true;
          this.$axios({
            method: 'get',
            url: '/api/getMyFavoriteArticle',
            params: {
              articleIDList: JSON.stringify(favoriteList),
              startIndex: this.articleList.length,
              number: 5
            }
          }).then(result => {
            let response = result.data;
            if (response.articleList.length < 5) {
              this.hasMore = false;
            }
            if (response.status == 200) {
              this.articleList = this.articleList.concat(response.articleList);
            }
            this.showLoading = false;
          });
        }

      },

      checkScrollToBottom() {
        let scrollHeight = document.documentElement.scrollHeight || document.body.scrollHeight;
        let scrollTop = document.documentElement.scrollTop || window.pageYOffset || document.body.scrollTop;
        let innerHeight = window.innerHeight;
        if (scrollTop + innerHeight >= scrollHeight - 20) {
          if (this.hasMore) {
            this.getArticleList();
          } else {
            this.hintText = '没有更多了~';
          }
        }
      },
      //update the specified article form server
      updateSpecifiedArticle(index) {
        const articleID = this.articleList[index].articleID;
        this.$axios({
          method: 'get',
          url: '/api/getSpecifiedArticle',
          params: {
            articleID
          }
        }).then(result => {
          if (result.data) {
            this.articleList.splice(index, 1, result.data[0]);
          }
        })
      }
    },
    components: {
      articleBrief
    }
  }

</script>

<style lang="less" scoped>
  .animate-enter-active {
    transition: all .6s !important;
  }

  .animate-enter {
    transform: translateY(-50%) scale(0.5);
    opacity: 0;
  }

  .animate-move {
    transition: all .5s !important;
  }

  .my-favorite-article {
    background-color: #F5F6FA;
    width: 100vw;
    height: fit-content;
    min-height: 100vh;
    .article-head {
      width: 100vw;
      height: 12vw;
      background-color: #0080FF;
      line-height: 12vw;
      color: #FFFFFF;
      padding: 0 3vw;
      box-sizing: border-box;
      font-size: 5vw;
      position: fixed;
      top: 0;
      left: 0;
      z-index: 99;
      i.fa {
        margin-right: 2vw;
      }
    }
    .article-list {
      margin-top: 15vw;

    }
  }

  .none-article {
    text-align: center;
    margin-top: 12vw;
    color: #999999;
    width: 100vw;
    height: 50vw;
    font-size: 6vw;
    background-image: url("/static/images/common/none-data.svg");
    background-size: 100% 100%;
    position: relative;
    span {
      position: absolute;
      bottom: 3vw;
      left: 50%;
      transform: translateX(-50%);
      white-space: nowrap;
    }
  }

</style>
