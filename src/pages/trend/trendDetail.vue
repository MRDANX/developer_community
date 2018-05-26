<template>
  <div class="trend-detail">
    <div class="trend-head">
      <i class="fa fa-arrow-left" @click="$router.go(-1)"></i>
      <span>动态详情</span>
    </div>
    <div class="trend-content" v-if="trendInfo" ref="trendContent">
      <div class="mask" :class="{commentFocusing}" @click="commentFocusing=false" @touchstart="commentFocusing=false||$refs.commentBox.blur()"></div>
      <trend :trend="trendInfo" :showFoot="false" />
      <div class="comments">
        <div class="comments-header">
          {{comments.length||0}} 条评论
        </div>
        <transition-group name="comment-slide-in" tag="div">
          <article-comment v-for="(comment,index) in comments" :key="index" :floor="index+1" :comment="comment" @replyAt="replyAt($event)"
            class="comment" />
          <div class="comments-bottom" key="bottom">
            <div v-if="loadingComment">
              <div class="comment-loading fa-spin" :class="{'loading-comment':loadingComment}">
                <img src="/static/images/common/loading.svg">
              </div>
            </div>
            <div class="comments-end" v-else>-- end --</div>
          </div>
        </transition-group>
      </div>
      <div class="publish-comment" ref="publishComment">
        <div class="input-box" :class="{commentFocusing}">
          <input type="text" v-model="commentText" @focus="commentFocusing=true" placeholder="输入评论..." ref="commentBox">
        </div>
        <div class="send-comment" :class="{commentFocusing,active:commentText}" @click="publishComment"></div>
        <div class="trend-action" :class="{commentFocusing}">
          <div class="trend-favor" :class="{isFavorite}" @click="toggleFavor">
            <i class="fa" :class="[isFavorite?'fa-thumbs-up':'fa-thumbs-o-up']"></i>
            <span>{{trendInfo.favors||'赞'}}</span>
          </div>
          <div @click="showSharePanel=true" class="share-icon"></div>
        </div>
      </div>
      <slide-out slideToDirection="toUp" v-model="showSharePanel" class="share-panel" :showModal="true">
        <share-panel/>
      </slide-out>
    </div>
    <div class="not-found" v-else>
      <span>该动态不存在或已被删除!!</span>
    </div>
    <hint v-model="hintText" />
    <loading v-if="showLoading" color="#FFFFFF" />
  </div>
</template>

<script>
  import {
    mapState
  } from "vuex";
  import trend from '@/components/trendPage/trend';
  import articleComment from "@/components/articleDetail/articleComment";
  import hint from "@/components/common/hint";
  import slideOut from "@/components/common/slideOut";
  import loading from "@/components/common/loading";
  import sharePanel from "@/components/common/sharePanel";
  export default {
    name: 'trendDetail',
    props: ['trendID'],
    data() {
      return {
        trendInfo: {},
        comments: [],
        loadingComment: false,
        favorLock: false,
        showSharePanel: false,
        commentText: '',
        commentFocusing: false,
        hintText: '',
        showLoading: false
      }
    },
    computed: {
      ...mapState('user', ['userInfo']),
      isFavorite() {
        if (this.trendInfo) {
          const favoriteTrend = this.userInfo.favoriteTrend,
            trendID = this.trendInfo.trendID;
          //check whether user has logined and show the corresponding style of favor button 
          if (favoriteTrend) {
            for (let i = 0; i < favoriteTrend.length; i++) {
              if (trendID == favoriteTrend[i].trendID) {
                return true;
              }
            }
          }
        }
        return false;
      }
    },
    created() {
      this.getTrend();
      this.getTrendComment();
    },
    activated() {
      if (this.trendInfo && this.trendInfo.trendID != this.trendID) {
        this.trendInfo = {};
        this.commentText = '';
        this.getTrend();
        this.getTrendComment();
      }
    },
    methods: {
      getTrend() {
        if (this.trendID) {
          this.$axios({
            method: 'get',
            url: '/api/getSpecifiedTrend',
            params: {
              trendID: this.trendID
            }
          }).then(result => {
            this.trendInfo = result.data[0];
          })
        }
      },
      getTrendComment() {
        if (this.trendID) {
          this.loadingComment = true;
          this.$axios({
            method: 'get',
            url: '/api/getTrendComment',
            params: {
              trendID: this.trendID
            }
          }).then(result => {
            this.loadingComment = false;
            this.comments = result.data;
          })
        }
      },
      toggleFavor() {
        if (!this.userInfo.userID) {
          this.hintText = '请先登录';
          return;
        }
        const trendID = this.trendInfo.trendID,
          isFavorite = !this.isFavorite;
        if (!this.favorLock) {
          this.favorLock = true;
          this.$store.dispatch('user/toggleTrendFavor', {
            trendID,
            isFavorite
          }).then(result => {
            this.getTrend();
            setTimeout(() => {
              this.favorLock = false;
            }, 300);
          }).catch(err => {
            console.log(err);
          });
        }
      },
      replyAt(atSomebody) {
        this.commentText = '@' + atSomebody + ' ';
        this.$refs.commentBox.focus();
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
          trendID = this.trendID,
          commentText = this.commentText;
        this.showLoading = true;
        //post a publish comment request
        this.$axios({
          method: 'post',
          url: '/api/publishTrendComment',
          data: qs.stringify({
            userID,
            trendID,
            commentText
          })
        }).then(result => {
          if (!result.data.errno) {
            this.getTrendComment();
          } else {
            console.log(result.data);
          }
          this.scrollToBottom();
          this.showLoading = false;
          this.commentFocusing = false;
          this.commentText = '';
        })
      },
      scrollToBottom() {
        let scrollTop = document.documentElement.scrollTop || document.body.scrollTop,
          trendContent = this.$refs.trendContent,
          bottom = trendContent.scrollHeight;
        let toBottomTimer = setInterval(() => {
          scrollTop += 50;
          window.scrollTo(0, scrollTop);
          if (scrollTop >= bottom) {
            clearInterval(toBottomTimer);
          }
        }, 20)
      }
    },
    components: {
      hint,
      trend,
      loading,
      slideOut,
      sharePanel,
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

  .trend-detail {
    width: 100vw;
    height: 100vh;
    background-color: #F5F6FA;
    .trend-head {
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
    .trend-content {
      margin-top: 14vw;
      margin-bottom: 12vw;
      .mask {
        margin-top: 12vw;
        width: 100vw;
        height: ~'calc(100vh - 24vw)';
        background-color: rgba(0, 0, 0, 0.3);
        display: none;
        position: fixed;
        top: 0;
        z-index: 2;
        &.commentFocusing {
          display: block;
        }
      }
      li {
        list-style-type: none;
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
    }
    .not-found {
      text-align: center;
      margin-top: 10vh;
      color: #999999;
      width: 100vw;
      height: 50vw;
      font-size: 6vw;
      background-image: url("/static/images/common/none-follow.svg");
      background-size: 100% 100%;
      position: relative;
      span {
        position: absolute;
        bottom: 2vw;
        left: 50%;
        transform: translateX(-50%);
        white-space: nowrap;
      }
    }
    .publish-comment {
      border-top: 1px solid #CCCCCC;
      width: 100vw;
      height: 12vw;
      position: fixed;
      bottom: 0;
      left: 0;
      background-color: #FFFFFF;
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 0 5vw;
      box-sizing: border-box;
      .input-box {
        width: 50vw;
        height: 8vw;
        transition: all .5s linear;
        background-color: #DDDDDD;
        border-radius: 5vw;
        padding: 0 0.5em;
        input {
          border: none;
          outline: none;
          width: 100%;
          height: 100%;
          background-color: transparent;
          font-size: 5vw;
          line-height: 8vw;
          vertical-align: middle;
          color: #666666;
          caret-color: #0080FF;
        }
        &.commentFocusing {
          width: 85vw;
          background-color: #DEDEDE;
          input {
            color: #000000;
          }
        }
      }
      .share-icon {
        width: 6vw;
        height: 6vw;
        background-image: url("/static/images/common/share.svg");
        background-size: 100% 100%;
      }
      .send-comment {
        width: 8vw;
        height: 8vw;
        margin-left: 5vw;
        background-image: url("/static/images/common/send-disable.svg");
        background-size: 100% 100%;
        transition: all .5s;
        opacity: 0;
        &.active {
          background-image: url("/static/images/common/send-enable.svg");
        }
        &.commentFocusing {
          opacity: 1;
        }
      }
      .trend-action {
        display: flex;
        justify-content: space-between;
        align-items: center;
        width: 20vw;
        margin-right: 5vw;
        overflow: hidden;
        opacity: 1;
        transition: all .5s;
        &.commentFocusing {
          margin-right: 0;
          width: 0;
          opacity: 0;
        }
        .trend-favor {
          font-size: 5.5vw;
          color: #666666;
          transition: all .5s;
          overflow: hidden;
          white-space: nowrap;
        }
        .trend-favor.isFavorite {
          color: #0080FF;
          .fa {
            transform-origin: left bottom;
            animation: trendFavorite 1s;
          }
        }
      }

    }
  }

  @keyframes trendFavorite {
    0% {
      transform: rotate(0) scale(1);
    }
    50% {
      transform: rotate(-15deg) scale(1.1);
    }
    100% {
      transform: rotate(0) scale(1);
    }
  }

</style>
