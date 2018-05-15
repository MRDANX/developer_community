<template>
  <div class="article-detail">
    <div class="header" :class="scrollTop>10?'hide':'show'">
      <i class="fa fa-arrow-left" @click="$router.go(-1)"></i>
      <i class="fa fa-ellipsis-v"></i>
    </div>
    <div class="content-wrapper" v-if="articleInfo.articleID">
      <div class="main-body-wrapper">
        <div class="cover" v-if="articleInfo.cover">
          <img :src="articleInfo.cover" alt="">
        </div>
        <h2 class="title">{{articleInfo.title}}</h2>
        <div class="user-info">
          <div class="user-info-wrapper">
            <div class="avatar">
              <img :src="articleInfo.avatar" alt="">
            </div>
            <span class="author">{{articleInfo.author}}</span>
            <div class="user-follow">
              <i class="fa fa-plus"></i>
              <span>关注</span>
            </div>
          </div>
          <p class="article-info">{{articleInfo.date|dateFormat}} • 字数 {{wordCount}} • 阅读 {{articleInfo.pv}} •
            <i class="fa fa-file-text"></i> {{articleInfo.subject}}</p>
        </div>
        <div class="content">
          <div class="main-body" v-html="articleInfo.content"></div>
          <div class="tags">
            <tag :tagText="tag" v-for="(tag,index) in tags" :key="index" />
          </div>
        </div>
      </div>
      <div class="comments">
        <div class="comments-header">
          {{comments.length}}条评论
        </div>
        <article-comment v-for="(comment,index) in comments" :key="index" :floor="index+1" :comment="comment" />
        <div class="comments-end">
          -- end --
        </div>
      </div>
      <slide-out slideToDirection="toUp" :showModal="true" v-model="showCommentPanel">
        showCommentPanel
      </slide-out>
    </div>
    <div v-else class="loading">
      <loading />
    </div>
    <div class="footer">
      <div class="article-action">
        <i class="fa fa-heart-o"></i>
        <i class="fa fa-heart-o"></i>
        <i class="fa fa-heart-o"></i>
      </div>
      <p>
        <span>喜欢 {{articleInfo.favors}}</span> •
        <span>评论 {{articleInfo.commentNum}}</span>
      </p>
    </div>
  </div>
</template>

<script>
  import tag from "@/components/common/tag";
  import loading from "@/components/common/loading";
  import slideOut from "@/components/common/slideOut";
  import articleComment from "@/components/articleDetail/articleComment";
  export default {
    name: 'articleDetail',
    props: ['articleID'],
    data() {
      return {
        articleInfo: {},
        comments: [],
        showCommentPanel: false
      }
    },
    computed: {
      scrollTop() {
        return document.documentElement.scrollTop || window.pageYOffset || document.body.scrollTop;
      },
      tags() {
        return this.articleInfo.tags.split(',');
      },
      wordCount() {
        return this.articleInfo.content.replace(/<\/?[^>]>/g, '').length;
      }
    },
    created() {
      let articleID = +this.articleID;
      this.getArticleInfo();

    },
    methods: {
      getArticleInfo() {
        this.$axios({
          method: 'get',
          url: '/getSpecifiedArticle',
          params: {
            articleID: this.articleID
          }
        }).then(result => {
          this.articleInfo = result.data[0];
          this.getArticleComment();
        })
      },
      getArticleComment() {
        this.$axios({
          method: 'get',
          url: '/getArticleComment',
          params: {
            articleID: this.articleID,
            startIndex: this.comments.length,
            number: 5
          }
        }).then(result => {
          this.comments = this.comments.concat(result.data);
        })
      }
    },
    filters: {
      dateFormat(dateStr) {
        const date = new Date(dateStr),
          year = date.getFullYear(),
          month = date.getMonth() + 1,
          day = date.getDate(),
          hour = date.getHours(),
          minute = date.getMinutes();
        return `${year}-${month}-${day} ${hour}:${minute}`;
      }
    },
    components: {
      tag,
      loading,
      slideOut,
      articleComment
    }
  }

</script>

<style lang="less" scoped>
  .article-detail {
    width: 100vw;
    font-size: 4vw;
    .header {
      width: 100vw;
      height: 12vw;
      padding: 0 5vw;
      box-sizing: border-box;
      font-size: 6vw;
      background-color: #FFFFFF;
      color: #333333;
      display: flex;
      justify-content: space-between;
      align-items: center;
      box-shadow: 0 1px 5px #CCCCCC;
      position: fixed;
      left: 0;
      z-index: 99;
      transition: all .5s;
      &.hide {
        top: -12vw;
      }
      &.show {
        top: 0;
      }
    }
    .content-wrapper {
      padding: 12vw 0;
      width: 100vw;
      overflow: hidden;
      .main-body-wrapper {
        background-color: #FFFFFF;
        .cover {
          width: 100vw;
          img {
            width: 100%;
          }
        }
        .title {
          font-size: 6vw;
          padding: 0 3vw;
          margin: 3vw 0;
          font-weight: bold;
        }
        .user-info {
          margin: 3vw 0;
          padding: 0 3vw;
          .user-info-wrapper {
            display: flex;
            justify-content: space-between;
            align-items: center;
            .avatar {
              width: 10vw;
              height: 10vw;
              overflow: hidden;
              border-radius: 50%;
              img {
                height: 100%;
              }
            }
            .author {
              font-weight: bold;
              flex-grow: 1;
              margin-left: 3vw;
            }
            .user-follow {
              padding: 1.5vw 3vw;
              background-color: #0080FF;
              color: #FFFFFF;
              border-radius: 1vw;
              height: 5vw;
              line-height: 5vw;
            }
          }
          .article-info {
            font-size: 3.6vw;
            color: #8b8b8b;
            margin-top: 3vw;
          }

        }
        .content {
          overflow: hidden;
          .main-body {
            margin-top: 6vw;
            padding: 0 3vw;
          }
          .tags {
            border-top: 1px solid #E1E1E1;
            padding: 2vw 0;
            margin: 1vw 0;
          }
        }
      }

      .comments {
        padding: 0 3vw;
        width: 100vw;
        box-sizing: border-box;
        margin-top: 3vw;
        background-color: #FFFFFF;
        .comments-header {
          font-size: 5vw;
          padding: 2vw 0;
        }
        .comments-end {
          text-align: center;
          padding: 0 0 5vw;
        }
      }
    }
    .loading {
      width: 100vw;
      height: 100vh;
    }
    .footer {
      width: 100vw;
      height: 12vw;
      box-sizing: border-box;
      padding: 0 3vw;
      box-shadow: 0 -1px 5px #CCCCCC;
      background-color: #FFFFFF;
      position: fixed;
      bottom: 0;
      left: 0;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
  }

</style>
