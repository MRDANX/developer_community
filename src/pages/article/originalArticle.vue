<template>
  <div class="original-article">
    <div class="article-head">
      <i class="fa fa-arrow-left" @click="$router.go(-1)"></i>
      <span>文章管理</span>
    </div>
    <transition-group name="article-deleted" class="article-list" tag="ul" v-if="articleList.length!=0">
      <article-brief v-for="(article,index) in articleList" :key="article.articleID" :articleInfo="article" :showAction="false"
        @deleteArticle="deleteArticle(index)" />
    </transition-group>
    <div v-else class="none-article">
      <span>你还没发布过任何文章喔!</span>
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
    throttle,
    differenceBy
  } from "lodash";
  export default {
    name: 'originalArticle',
    data() {
      return {
        articleList: [],
        showLoading: false,
        hasMore: true,
        hintText: '',
        userID: 0
      }
    },
    computed: {
      ...mapState('user', ['userInfo'])
    },
    created() {
      if (!this.userInfo.userID) {
        this.$router.replace('/');
        return;
      }
      window.addEventListener('scroll', throttle(this.checkScrollToBottom, 200));
      // this.getOriginalArticle();
    },
    activated() {
      if (this.userInfo.userID != this.userID) {
        this.articleList = [];
        this.userID = this.userInfo.userID;
      }
      this.getOriginalArticle(0, true);
    },
    methods: {
      getOriginalArticle(startIndex, init) {
        this.showLoading = true;
        this.$axios({
          method: 'get',
          url: '/api/getUserOriginalArticle',
          params: {
            userID: this.userInfo.userID,
            startIndex: startIndex || 0,
            number: 5
          }
        }).then(result => {
          let response = result.data;
          if (response.articleList.length < 5) {
            this.hasMore = false;
          }
          if (response.status == 200) {
            let tmp = differenceBy(response.articleList, this.articleList, 'articleID');
            // console.log('response:', response.articleList);
            // console.log('this:', this.articleList);
            // console.log('tmp:', tmp);
            if (init) {
              this.articleList = tmp.concat(this.articleList);
            } else {
              this.articleList = this.articleList.concat(tmp);
            }
          }
          this.showLoading = false;
        });
      },
      deleteArticle(index) {
        let articleID = this.articleList[index].articleID,
          userID = this.userInfo.userID,
          password = this.userInfo.password,
          token = this.userInfo.token,
          qs = require('qs');
        this.showLoading = true;
        this.$axios({
          method: 'post',
          url: '/api/deleteArticle',
          data: qs.stringify({
            articleID,
            token
          })
        }).then(result => {
          let response = result.data;
          if (response.errno) {
            this.hintText = response.text;
            this.showLoading = false;
            return;
          }
          if (!response.success) {
            this.hintText = response.text;
            this.showLoading = false;
            return;
          }
          this.showLoading = false;
          this.hintText = response.text;
          this.articleList.splice(index, 1);
          this.$store.dispatch('user/retrieveUserInfo');
          // this.getOriginalArticle(0, this.articleList.length);
        });
      },
      checkScrollToBottom() {
        let scrollHeight = document.documentElement.scrollHeight || document.body.scrollHeight;
        let scrollTop = document.documentElement.scrollTop || window.pageYOffset || document.body.scrollTop;
        let innerHeight = window.innerHeight;
        if (scrollTop + innerHeight >= scrollHeight - 20) {
          if (this.hasMore) {
            this.getOriginalArticle(this.articleList.length);
          } else {
            this.hintText = '没有更多了~';
          }
        }
      }
    },
    components: {
      articleBrief
    }
  }

</script>

<style lang="less" scoped>
  .article-deleted-leave-active {
    position: absolute !important;
    transition: all .5s !important;
  }

  .article-deleted-leave-to {
    transform: translateX(100%) scale(0.5);
    opacity: 0;
  }

  .article-deleted-enter-active {
    transition: all .6s .2s !important;
  }

  .article-deleted-enter {
    transform: translateY(-50%) scale(0.5);
    opacity: 0;
  }

  .article-deleted-move {
    transition: all .5s .2s;
  }

  .original-article {
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
      margin-top: 12vw;
      overflow: hidden;
      li {
        background-color: #FFFFFF;
        margin: 2vw 0;
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
  }

</style>
