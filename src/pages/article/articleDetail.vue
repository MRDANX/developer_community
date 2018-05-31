<template>
  <div class="article-detail">
    <div class="header" ref="header">
      <i class="fa fa-arrow-left" @click.self="$router.go(-1)"></i>
      <h4 class="head-title" ref="headTitle" @click="scrollToTop">{{articleInfo.title}}</h4>
      <i class="fa fa-ellipsis-v1"></i>
    </div>
    <transition name="fade-in">
      <div class="content-wrapper" v-if="articleInfo.articleID" key="article" ref="contentWrapper">
        <div class="main-body-wrapper" ref="mainBody">
          <div class="cover" v-if="articleInfo.cover">
            <img :src="articleInfo.cover" alt="">
          </div>
          <h2 class="title" ref="title">{{articleInfo.title}}</h2>
          <div class="user-info">
            <div class="user-info-wrapper">
              <router-link :to="{name:'userDetail',params:{userID:articleInfo.userID}}" tag="div" class="avatar">
                <img :src="articleInfo.avatar" alt="">
              </router-link>
              <router-link :to="{name:'userDetail',params:{userID:articleInfo.userID}}" tag="span" class="author">{{articleInfo.author}}</router-link>
              <div class="user-follow" :class="{isFollowee}">
                <div class="not-follow" @click="toggleFollow">
                  <i class="fa fa-plus"></i>
                  <span>关注</span>
                </div>
                <div class="has-follow" @click="toggleFollow">
                  <i class="fa fa-check"></i>
                  <span>已关注</span>
                </div>
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
        <div class="comments" ref="comments">
          <div class="comments-header">
            {{articleInfo.commentNum}}条评论
          </div>
          <transition-group name="comment-slide-in" tag="div">
            <article-comment v-for="(comment,index) in comments" :key="index" :floor="index+1" :comment="comment" @replyAt="replyAt($event)"
              class="comment" />
            <div class="comments-bottom" key="bottom">
              <div v-if="hasMoreComments" @click="getArticleComment">
                <div class="comment-loading fa-spin" :class="{'loading-comment':loadingComment}">
                  <img src="/static/images/common/loading.svg">
                </div>
                <div class="loading-more" :class="{'load-more':!loadingComment}">加载更多</div>
              </div>
              <div class="comments-end" v-else>-- end --</div>
            </div>
          </transition-group>
        </div>
        <slide-out slideToDirection="toUp" :showModal="true" v-model="showCommentPanel">
          <div class="comment-panel">
            <textarea name="comment" class="comment-area" v-model="commentText"></textarea>
            <div class="comment-action">
              <div class="publish-comment" @click="publishComment">发表评论</div>
            </div>
          </div>
        </slide-out>
      </div>
      <div v-else class="loading" key="loading">
        <loading />
      </div>
    </transition>
    <div class="footer">
      <div class="footer-mask"></div>
      <div class="article-action">
        <i class="fa fa-heart-o favor" :class="{isFavorite}" @click="toggleFavor"></i>
        <i class="fa fa-comment-o" @click="showCommentPanel=true"></i>
        <i class="fa fa-plus-square-o"></i>
      </div>
      <p class="meta">
        <span>喜欢 {{articleInfo.favors}}</span> •
        <span @click="scrollToComment">评论 {{articleInfo.commentNum}}</span>
      </p>
    </div>
    <hint v-model="hintText" />
    <loading v-if="showLoading" color="#FFFFFF" />
  </div>
</template>

<script>
  import tag from "@/components/common/tag";
  import slideOut from "@/components/common/slideOut";
  import articleComment from "@/components/articleDetail/articleComment";
  import {
    mapState
  } from "vuex";
  export default {
    name: 'articleDetail',
    props: ['articleID'],
    data() {
      return {
        articleInfo: {},
        comments: [],
        showCommentPanel: false,
        commentText: '',
        hintText: '',
        favorLock: false,
        showLoading: false,
        loadingComment: false,
        hasMoreComments: true,
        initialComments: false,
        followLock: false
      }
    },
    computed: {
      ...mapState('user', ['userInfo']),
      // scrollTop() {
      //   return document.documentElement.scrollTop || window.pageYOffset || document.body.scrollTop;
      // },
      tags() {
        return this.articleInfo.tags && this.articleInfo.tags.split(',');
      },
      wordCount() {
        return this.articleInfo.content.replace(/<\/?[^>]>/g, '').length;
      },
      isFavorite() {
        const favoriteArticle = this.userInfo.favoriteArticle,
          articleID = this.articleID;
        //check whether user has logined and show the corresponding style of favor button 
        if (favoriteArticle) {
          for (let i = 0; i < favoriteArticle.length; i++) {
            if (articleID == favoriteArticle[i].articleID) {
              return true;
            }
          }
        }
        return false;
      },
      isFollowee() {
        const followee = this.userInfo.followee,
          userID = this.articleInfo.userID;
        if (followee) {
          for (let i = 0; i < followee.length; i++) {
            if (userID == followee[i].userID) {
              return true;
            }
          }
        }
        return false;
      }
    },
    created() {
      this.getArticleInfo();
    },
    mounted() {
      window.addEventListener('scroll', this.initializeComments);
      window.addEventListener('scroll', this.toggleHeadTitle);
      this.initializeComments();
    },
    // updated() {
    //load comments if it's in the visible view and it's not yet been initialized
    // let comments = this.$refs.comments;
    // if (comments && !this.initialComments) {
    //   this.initializeComments();
    // }
    // },
    activated() {
      if (this.articleID != this.articleInfo.articleID) {
        this.articleInfo = {};
        this.comments = [];
        this.initialComments = false;
        this.hasMoreComments = true;
        setTimeout(() => {
          this.initializeComments();
        }, 200);
        window.addEventListener('scroll', this.initializeComments);
        this.getArticleInfo();
      }
    },
    methods: {
      getArticleInfo() {
        this.$axios({
          method: 'get',
          url: '/api/getSpecifiedArticle',
          params: {
            articleID: this.articleID
          }
        }).then(result => {
          if (!result.data[0]) {
            this.$router.push('/notFound');
            return;
          }
          this.articleInfo = result.data[0];
        })
      },
      getArticleComment() {
        this.loadingComment = true;
        this.$axios({
          method: 'get',
          url: '/api/getArticleComment',
          params: {
            articleID: this.articleID,
            startIndex: this.comments.length,
            number: 5
          }
        }).then(result => {
          if (result.data.length < 5) {
            this.hasMoreComments = false;
            // return;
          }
          this.loadingComment = false;
          this.comments = this.comments.concat(result.data);
        })
      },
      initializeComments() {
        if (!this.$refs.comments) {
          return;
        }
        let clientHeight = document.documentElement.clientHeight || document.body.clientHeight,
          commentsTop = this.$refs.comments.getBoundingClientRect().top;
        if (commentsTop < clientHeight && !this.initialComments) {
          this.initialComments = true;
          this.getArticleComment();
          //increase pv of article when initialize its comments
          let qs = require('qs');
          this.$axios({
            method: 'post',
            url: '/api/increaseArticlePV',
            data: qs.stringify({
              articleID: this.articleID
            })
          }).then(result => {
            // console.log('increase pv');
          });
        }
      },
      toggleHeadTitle() {
        let headTitle = this.$refs.headTitle,
          header = this.$refs.header,
          title = this.$refs.title;
        if (!headTitle || !header || !title) {
          return;
        }
        let headerBottom = header.getBoundingClientRect().bottom,
          titleTop = title.getBoundingClientRect().bottom;
        if (titleTop < headerBottom) {
          headTitle.style.opacity = 1;
          headTitle.style.transform = 'scale(1)';
        } else {
          headTitle.style.opacity = 0;
          headTitle.style.transform = 'scale(0.9)';
        }
      },
      publishComment() {
        //check whether user has logged in
        if (!this.userInfo.userID) {
          this.hintText = '请先登录';
          return;
        }
        if (!this.commentText) {
          this.hintText = '请先输入评论再发表';
          return;
        }
        let qs = require('qs'),
          userID = this.userInfo.userID,
          articleID = this.articleID,
          commentText = this.commentText;
        this.showLoading = true;
        //post a publish comment request
        this.$axios({
          method: 'post',
          url: '/api/publishComment',
          data: qs.stringify({
            userID,
            articleID,
            commentText
          })
        }).then(result => {
          if (!result.data.errno) {
            this.getArticleComment();
            this.scrollToBottom();
            // this.getArticleInfo();
          } else {
            console.log(result.data);
          }
          this.showCommentPanel = false;
          this.showLoading = false;
          this.commentText = '';
        })
      },
      toggleFavor() {
        if (!this.userInfo.userID) {
          this.hintText = '请先登录';
          return;
        }
        const articleID = this.articleID,
          isFavorite = !this.isFavorite;
        if (!this.favorLock) {
          this.favorLock = true;
          this.$store.dispatch('user/toggleArticleFavor', {
            articleID,
            isFavorite
          }).then(result => {
            this.getArticleInfo();
            setTimeout(() => {
              this.favorLock = false;
            }, 300);
          }).catch(err => {
            console.log(err);
          });
        }
      },
      toggleFollow() {
        if (!this.userInfo.userID) {
          this.hintText = '请先登录';
          return;
        }
        const followeeUserID = this.articleInfo.userID,
          wantFollow = !this.isFollowee;
        if (!this.followLock) {
          this.followLock = true;
          this.$store.dispatch('user/toggleUserFollow', {
            followeeUserID,
            wantFollow
          }).then(result => {
            setTimeout(() => {
              this.followLock = false;
            }, 300);
          }).catch(err => {
            console.log(err);
          });
        }
      },
      replyAt(userName) {
        this.commentText = `＠${userName} `;
        this.showCommentPanel = true;
      },
      scrollToTop() {
        window.scrollTo({
          top: 0,
          behavior: 'smooth'
        });
      },
      scrollToBottom() {
        let contentWrapper = this.$refs.contentWrapper,
          bottom = contentWrapper.scrollHeight;
        window.scrollTo({
          top: bottom,
          behavior: 'smooth'
        });
      },
      scrollToComment() {
        let comments = this.$refs.comments,
          offsetTop = comments.offsetTop;
        window.scrollTo({
          top: offsetTop,
          behavior: 'smooth'
        });

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
    watch: {
      initialComments(newVal) {
        if (newVal) {
          window.removeEventListener('scroll', this.initializeComments);
        }
      }
    },
    components: {
      tag,
      slideOut,
      articleComment
    }
  }

</script>

<style lang="less" scoped>
  .comment-slide-in-enter-active {
    transition: all 1.5s;
  }

  .comment-slide-in-move {
    transition: all .5s;
  }

  .fade-in-enter-active {
    transition: all .5s;
  }

  .fade-in-enter {
    opacity: 0;
  }

  .article-detail {
    width: 100vw;
    font-size: 4vw;
    height: 100vh;
    background-color: #FFFFFF;
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
      overflow: hidden;
      .head-title {
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        max-width: 74vw;
        position: relative; // top: 10vw;
        opacity: 0;
        transform: scale(0.9);
        transition: all .5s;
        font-size: 4vw;

      }
    }
    .content-wrapper {
      padding: 12vw 0;
      width: 100vw;
      box-sizing: border-box;
      overflow-x: hidden;
      .main-body-wrapper {
        background-color: #FFFFFF;
        overflow: hidden;
        .cover {
          width: 100vw;
          max-height: 50vw;
          overflow: hidden;
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
              color: #CB4E44;
            }
            .author {
              font-weight: bold;
              flex-grow: 1;
              margin-left: 3vw;
            }
            .user-follow {
              padding: 1vw 2vw;
              background-color: #0080FF;
              color: #FFFFFF;
              border-radius: 1vw;
              height: 6vw;
              line-height: 6vw;
              width: 14vw;
              text-align: center;
              transition: all .5s;
              overflow: hidden;
              .not-follow {
                display: block;
              }
              .has-follow {
                display: none;
                white-space: nowrap;
              }
              &.isFollowee {
                background-color: #6A03F2;
                width: 18vw;
                .not-follow {
                  display: none;
                }
                .has-follow {
                  display: block;
                }
              }
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
            margin: 4vw 0;
            padding: 0 3vw;
            /deep/ img{
              max-width: 94vw;
            }
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
        .comment:nth-of-type(2n).comment-slide-in-enter {
          opacity: 0;
          transform: translateX(-100%);
        }
        .comment:nth-of-type(2n+1).comment-slide-in-enter {
          opacity: 0;
          transform: translateX(100%);
        }
        .comments-bottom {
          text-align: center;
          padding: 0 0 5vw;
          color: #666666;
          .comment-loading {
            width: 6vw;
            height: 6vw;
            margin: 0 auto;
            display: none;
            img {
              height: 100%;
            }
            &.loading-comment {
              display: block;
            }
          }
          .loading-more {
            display: none;
            &.load-more {
              display: block;
            }
          }

        }
      }
      .comment-panel {
        width: 100vw;
        height: 40vw;
        background-color: #FAFAFA;
        box-shadow: 0 -0.1vw 1vw #FFFFFF;
        padding: 3vw;
        box-sizing: border-box;
        .comment-area {
          width: 100%;
          min-height: 25vw;
          font-size: 4.5vw;
          outline: none;
          box-shadow: 0 0 1vw #CCCCCC;
          box-sizing: border-box;
          padding: 2vw;
        }
        .comment-action {
          margin-top: 1.5vw;
          display: flex;
          justify-content: flex-end;
          .publish-comment {
            border: 1px solid #0080FF;
            padding: 1vw 4vw;
            border-radius: 1vw;
            color: #0080FF;
            user-select: none;
            &:active {
              color: #FFFFFF;
              background-color: #0080FF;
            }
          }
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
      box-shadow: 0 -1px 2px #D1D1D1; // background-color: #FFFFFF;
      position: fixed;
      bottom: 0;
      left: 0;
      z-index: 99;
      transition: all .5s;
      display: flex;
      justify-content: space-between;
      align-items: center;
      .footer-mask {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(255, 255, 255, 0.8);
        filter: blur(5px);
        z-index: -1;
      }
      .article-action {
        font-size: 6vw;
        flex-grow: 0.5;
        display: flex;
        justify-content: space-between;
        align-items: center;
        color: #0080FF; // position: relative;
        i.favor {
          width: 6vw;
          height: 6vw;
          position: relative;
          &::before {
            position: absolute;
          }
          &::after {
            content: "\F004";
            position: absolute;
            transform: scale(0);
            transition: all .3s ease-in-out;
          }
          &.isFavorite::after {
            transform: scale(1);
          }
        }
        i.fa-comment-o {
          position: relative;
          top: -2px;
        }
      }
      .meta {
        color: #8b8b8b;
        font-size: 4.5vw;
      }
    }
  }

</style>
