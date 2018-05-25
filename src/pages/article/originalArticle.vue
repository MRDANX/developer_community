<template>
  <div class="original-article">
    <div class="article-head">
      <i class="fa fa-arrow-left" @click="$router.go(-1)"></i>
      <span>文章管理</span>
    </div>
    <transition-group name="article-deleted" class="article-list" tag="ul">
      <article-brief v-for="(article,index) in articleList" :key="article.articleID" :articleInfo="article" :showAction="false"
        @deleteArticle="deleteArticle(index)" />
    </transition-group>
    <loading v-if="showLoading" />
  </div>
</template>

<script>
  import {
    mapState
  } from "vuex";
  import articleBrief from '@/components/homePage/articleBrief';
  import loading from "@/components/common/loading";
  export default {
    name: 'originalArticle',
    data() {
      return {
        articleList: [],
        showLoading: false
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
      this.getOriginalArticle();
    },
    activated() {
      this.getOriginalArticle();
    },
    methods: {
      getOriginalArticle() {
        this.$axios({
          method: 'get',
          url: '/getUserOriginalArticle',
          params: {
            userID: this.userInfo.userID
          }
        }).then(result => {
          this.articleList = result.data;
        });
      },
      deleteArticle(index) {
        let articleID = this.articleList[index].articleID,
          userID = this.userInfo.userID,
          password = this.userInfo.password,
          qs = require('qs');
        this.showLoading = true;
        this.$axios({
          method: 'post',
          url: '/deleteArticle',
          data: qs.stringify({
            articleID,
            userID,
            password
          })
        }).then(result => {
          if (result.data.err) {
            this.hintText = result.data.text;
            this.showLoading = false;
            return;
          }
          this.showLoading = false;
          // this.articleList.splice(index, 1);
          this.getOriginalArticle();
          this.$store.dispatch('user/retrieveUserInfo');
        });
      }
    },
    components: {
      loading,
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
    // transform-origin: right bottom;
    transform: translateX(100%) scale(0.5);
    opacity: 0;
  }

  .article-deleted-move {
    transition: all .5s .2s;
  }

  .original-article {
    background-color: #F5F6FA;
    width: 100vw;
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
  }

</style>
