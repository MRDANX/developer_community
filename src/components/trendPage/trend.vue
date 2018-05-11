<template>
	<li class="trend-item">
		<div class="trend-head">
			<div class="user-avatar">
				<img :src="trend.avatar" />
			</div>
			<div class="user-info">
				<p class="user-name">{{trend.userName}}</p>
				<p class="user-meta">{{trend.job}} @ {{trend.company}} • {{trend.date}}</p>
			</div>
			<div class="user-follow">
				<i class="fa fa-plus"></i>
				<span>关注</span>
			</div>
		</div>
		<div class="trend-content" ref="trendContent">
			<p class="trend-text" v-html="trend.content"></p>
			<div class="trend-image-set" v-if="trend.images">
				<img :src="image" v-for="(image,index) in trend.images.split(',')" :key="index">
			</div>
		</div>
		<div class="trend-foot" ref="trendFoot">
			<div class="trend-favor">
				<i class="fa fa-thumbs-o-up"></i>
				<span>{{trend.favors||'赞'}}</span>
			</div>
			<div class="trend-comment">
				<i class="fa fa-commenting-o"></i>
				<span>{{trend.commentNum||'评论'}}</span>
			</div>
			<div class="trend-share">
				<i class="fa fa-share-alt"></i>
			</div>
		</div>
	</li>
</template>

<script>
  export default {
    name: 'trend',
    props: {
      trend: {
        type: Object,
        default: () => {}
      }
    },
    mounted() {
      let trendContent = this.$refs.trendContent;
      let trendFoot = this.$refs.trendFoot;
      if (trendContent) {
        this.$activeFeedback(trendContent);
      }
      if (trendFoot) {
        for (let i = 0; i < trendFoot.children.length; i++) {
          const element = trendFoot.children[i];
          this.$activeFeedback(element)
        }
      }
    }
  }
</script>

<style lang="less" scoped>
  .trend-item {
    margin: 3vw 0;
    background-color: #FFFFFF;
    .trend-head {
      padding: 3vw;
      display: flex;
      justify-content: space-between;
      align-items: center;
      height: 10vw;
      .user-avatar {
        height: 10vw;
        width: 10vw;
        border-radius: 50%;
        overflow: hidden;
        img {
          height: 100%;
        }
      }
      .user-info {
        flex-grow: 1;
        margin-left: 3vw;
        .user-name {
          font-weight: bold;
        }
        .user-meta {
          padding: 1vw 0;
          font-size: 3.5vw;
          color: #666666;
        }
      }
      .user-follow {
        padding: 1vw 2vw;
        background-color: #0080FF;
        color: #FFFFFF;
        border-radius: 1vw;
      }
    }
    .trend-content {
      padding: 3vw;
      &.active {
        background-color: #F1F1F1;
      }
      .trend-text {
        display: -webkit-box;
        -webkit-box-orient: vertical;
        -webkit-line-clamp: 3;
        overflow: hidden;
      }
      .trend-image-set {
        display: flex;
        flex-wrap: wrap;
        margin-top: 3vw;
        img {
          height: 20vw;
          margin: 0 1vw 1vw 0;
        }
      }
    }
    .trend-foot {
      display: flex;
      justify-content: space-between;
      align-items: center;
      border-top: 1px solid #F0F0F0;
      height: 10vw;
      color: #666666;
      font-size: 5vw;
      >div {
        flex: 1 1 30vw;
        height: 10vw;
        line-height: 10vw;
        text-align: center;
        &.active {
          background-color: #F1F1F1;
        }
      } // .trend-comment>span {
      //   vertical-align: middle;
      // }
    }
  }
</style>