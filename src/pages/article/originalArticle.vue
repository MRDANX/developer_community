<template>
  <div class="original-article">
    <div class="article-head">
      <i class="fa fa-arrow-left" @click="$router.go(-1)"></i>
      <span>文章管理</span>
    </div>
    <ul class="article-list">
      <article-brief v-for="(article,index) in articleList" :key="index" :articleInfo="article" :showAction="false" />
    </ul>
  </div>
</template>

<script>
  import {
    mapState
  } from "vuex";
  import articleBrief from '@/components/homePage/articleBrief';
  export default {
    name: 'originalArticle',
    data() {
      return {
        articleList: []
      }
    },
    computed: {
      ...mapState('user', ['userInfo'])
    },
    created() {
      if (!this.userInfo.userID) {
        this.$router.push('/');
        return;
      }
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
      }
    },
    components: {
      articleBrief
    }
  }

</script>

<style lang="less" scoped>
  .original-article {
    background-color: #F5F6FA;
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
