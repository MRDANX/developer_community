<template>
  <scroll :refresh="refresh" :loadMore="loadMore" :enableScrollToTopButton="true" :nowScrollToTop="nowScrollToTop" :enableRefresh="true" :enableLoadMore="true" ref="articleList">
    <ul class="articleList">
      <hot-recommend :recommendArticles="recommendArticles"/>
      <article-brief v-for="(item,index) in articleList" :key="index" :articleInfo="item" />
    </ul>
  </scroll>
</template>

<script>
  import scroll from "@/components/common/scroll";
  import articleBrief from "@/components/homePage/articleBrief";
  import hotRecommend from "@/components/homePage/hotRecommend";
  export default {
    name: 'articleList',
    props: {
      subject: {
        type: String,
        default: 'index'
      },
      nowScrollToTop: Boolean
    },
    data() {
      return {
        articleList: []
      }
    },
    computed:{
      recommendArticles(){
        return this.articleList.slice(0,3);
      }
    },
    methods: {
      //return a promise which excute asychronized action to refresh data
      refresh() {
        return new Promise((resolve, reject) => {
          this.$axios.get('/api/getArticleList', {
            params: {
              subject: this.subject,
              startIndex: this.articleList.length,
              number: 5
            },
            timeout: 4000
          }).then(result => {
            if (result.data.length == 0) {
              reject({
                errno: 0,
                text: 'It\'s up to date!'
              });
            }
            this.articleList = result.data.concat(this.articleList);
            resolve();
          }).catch(err => {
            if (err.response) {
              console.log('error.response: ', err.response);
            } else if (err.request.readyState == 4 && err.request.status == 0) {
              console.warn('Request timeout!');
            } else {
              console.error(err);
            }
          });
          // article sample 
          // {
          //   articleID:1,
          //   userID:1,
          //   title: 'title',
          //   author: 'author',
          //   subject: 'subject',
          //   abstract: 'abstract',
          //   favors: 999,
          //   date: 'date'
          // };
        })
      },
      //return a promise which excute asychronized action to load more data
      loadMore() {
        return new Promise((resolve, reject) => {
          // setTimeout(() => {
          this.$axios.get('/api/getArticleList', {
            params: {
              subject: this.subject,
              startIndex: this.articleList.length,
              number: 5
            },
            timeout: 4000
          }).then(result => {
            if (result.data.length == 0) {
              reject({
                errno: 0,
                text: 'No more data!'
              });
            }
            this.articleList = this.articleList.concat(result.data);
            resolve();
          }).catch(err => {
            if (err.response) {
              console.log('error.response: ', err.response);
            } else if (err.request.readyState == 4 && err.request.status == 0) {
              console.warn('Request timeout!');
            } else {
              console.error(err);
            }
          });
        });
      }
    },
    components: {
      scroll,
      articleBrief,
      hotRecommend
    }
  }

</script>

<style lang="less" scoped>
  ul.articleList {
    display: flex;
    flex-direction: column;
    justify-content: space-around;
    padding-top: 1vw;
    li {
      color: white;
      background-color: #FFFFFF;
      margin: 1.5vw 0;
      color: black;
      box-shadow: 0 1px 5px #CCCCCC;
    }
  }

</style>
