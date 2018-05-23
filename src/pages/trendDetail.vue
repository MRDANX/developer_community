<template>
  <div class="trend-detail">
    <div class="trend-head">
      <i class="fa fa-arrow-left" @click="$router.go(-1)"></i>
      <span>动态详情</span>
    </div>
    <div class="trend-content" v-if="trendInfo">
      <trend :trend="trendInfo" :showFoot="false" />
      <div class="comments" ref="comments">
        <div class="comments-header">
          {{comments.commentNum}}条评论
        </div>
        <transition-group name="comment-slide-in" tag="div">
          <article-comment v-for="(comment,index) in comments" :key="index" :floor="index+1" :comment="comment" @replyAt="replyAt($event)" class="comment" />
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
    </div>
    <div class="not-found" v-else>
      <span>该动态不存在或已被删除!!</span>
    </div>
  </div>
</template>

<script>
  import trend from '@/components/trendPage/trend';
  export default {
    name: 'trendDetail',
    props: ['trendID'],
    data() {
      return {
        trendInfo: null,
        comments:[]
      }
    },
    created() {
      this.initTrend();
    },
    activated() {
      if (this.trendInfo && this.trendInfo.trendID != this.trendID) {
        this.trendInfo = {};
        this.initTrend();
      }
    },
    methods: {
      initTrend() {
        if (this.trendID) {
          this.$axios({
            method: 'get',
            url: '/getSpecifiedTrend',
            params: {
              trendID: this.trendID
            }
          }).then(result => {
            this.trendInfo = result.data[0];
          })
        }
      }
    },
    components: {
      trend
    }
  }

</script>

<style lang="less" scoped>
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
      li {
        list-style-type: none;
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
  }

</style>
