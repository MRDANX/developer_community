<template>
  <scroll :refresh="refresh" :loadMore="loadMore" :enableScrollToTopButton="true" :nowScrollToTop="nowScrollToTop" :enableRefresh="true"
    :enableLoadMore="true" ref="articleList">
    <transition-group name="show" class="articleList" tag="ul">
      <hot-recommend :subject="subject" @askLogin="$refs.articleList.showHint('请先登录')" key="hotRecommend" @showHint="$refs.articleList.showHint($event)"
        class="hot-recommend" />
      <article-brief v-for="(article,index) in articleList" :key="'articleBrief'+article.articleID" :articleInfo="article" @updateCurrentArticle="updateSpecifiedArticle(index)"
        @askLogin="$refs.articleList.showHint('请先登录')" />
    </transition-group>
  </scroll>
</template>

<script>
import scroll from "@/components/common/scroll";
import articleBrief from "@/components/homePage/articleBrief";
import hotRecommend from "@/components/homePage/hotRecommend";
import { differenceBy } from "lodash";
export default {
  name: "articleList",
  props: {
    subject: {
      type: String,
      default: "index"
    },
    nowScrollToTop: Boolean
  },
  data() {
    return {
      articleList: [],
      hintText: "",
      ownSubject: this.subject
    };
  },
  methods: {
    //return a promise which excute asychronized action to refresh data
    refresh() {
      return new Promise((resolve, reject) => {
        this.$axios
          .get("/api/getArticleList", {
            params: {
              subject: this.ownSubject,
              startIndex: 0,
              number: 5
            }
          })
          .then(result => {
            console.log(result);
            let filteredData = differenceBy(
              result.data,
              this.articleList,
              "articleID"
            );
            // let filteredData = result.data.filter(newArticle => {
            //   return !this.articleList.some(existArticle => {
            //     return newArticle.articleID == existArticle.articleID;
            //   })
            // });
            setTimeout(() => {
              if (filteredData.length == 0) {
                reject({
                  errno: 0,
                  text: "已经是最新的了!"
                });
              }
              this.articleList = result.data;
              resolve();
            }, 500);
          })
          .catch(err => {
            if (err.response) {
              this.hintText = err.response;
              console.log("error.response: ", err.response);
            } else if (err.request.readyState == 4 && err.request.status == 0) {
              this.hintText = "请求超时";
              console.warn("Request timeout!");
            } else {
              console.error(err);
            }
          });
      });
    },
    //return a promise which excute asychronized action to load more data
    loadMore() {
      return new Promise((resolve, reject) => {
        this.$axios
          .get("/api/getArticleList", {
            params: {
              subject: this.ownSubject,
              startIndex: this.articleList.length,
              number: 5
            }
          })
          .then(result => {
            setTimeout(() => {
              if (result.data.length == 0) {
                reject({
                  errno: 0,
                  text: "No more data!"
                });
              }
              this.articleList = this.articleList.concat(result.data);
              resolve();
            }, 500);
          })
          .catch(err => {
            if (err.response) {
              console.log("error.response: ", err.response);
            } else if (err.request.readyState == 4 && err.request.status == 0) {
              console.warn("Request timeout!");
            } else {
              console.error(err);
            }
          });
      });
    },
    //update the specified article form server
    updateSpecifiedArticle(index) {
      const articleID = this.articleList[index].articleID;
      this.$axios({
        method: "get",
        url: "/api/getSpecifiedArticle",
        params: {
          articleID
        }
      }).then(result => {
        if (result.data) {
          this.articleList.splice(index, 1, result.data[0]);
        }
      });
    }
  },
  components: {
    scroll,
    articleBrief,
    hotRecommend
  }
};
</script>

<style lang="less" scoped>
.show-enter-active {
  transition: all 0.5s;
}

.show-enter {
  transform: scale(0.5);
  opacity: 0;
}

.show-leave-active {
  position: absolute !important;
  transition: all 0.5s;
}

.show-leave-to {
  transform-origin: center top;
  transform: scale(0.1);
  opacity: 0;
}

.show-move {
  transition: all 0.5s;
}

ul.articleList {
  // display: flex;
  // flex-direction: column;
  // justify-content: space-around;
  padding-top: 1vw;
  position: relative;
  li {
    background-color: #ffffff;
    margin: 3vw 0;
    box-shadow: 0 1px 5px #e1e1e1;
    &.hot-recommend {
      margin-top: 1vw;
    }
  }
}
</style>
