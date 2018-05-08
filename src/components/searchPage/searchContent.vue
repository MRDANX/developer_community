<template>
	<scroll :enableScrollToTopButton="true" :enableLoadMore="true" :loadMore="loadMore">
		<div class="search-content">
			<div class="carousel">
				<carousel :loop="true" :autoPlay="true" :showDot="true">
					<img src="/static/images/activity/carousel1.jpg" class="item">
					<img src="/static/images/activity/carousel2.jpg" class="item">
					<img src="/static/images/activity/carousel3.jpg" class="item">
				</carousel>
			</div>
			<div class="activity">
				<div>
					<i class="fa fa-book"></i>
					<span>小册</span>
				</div>
				<div>
					<i class="fa fa-free-code-camp"></i>
					<span>本周最热</span>
				</div>
				<div>
					<i class="fa fa-bookmark"></i>
					<span>收藏集</span>
				</div>
				<div>
					<i class="fa fa-bullhorn"></i>
					<span>活动</span>
				</div>
			</div>
			<ul class="hot-article">
				<li class="title">
					<div class="title-left">
						<i class="fa fa-free-code-camp"></i>
						<span>热门文章</span>
					</div>
					<div class="title-right">
						<i class="fa fa-cogs"></i>
						<span>定制热门</span>
					</div>
				</li>
				<li  v-for="(article,index) in articleList" :key="index" class="article" >
					<div class="article-info">
						<h4>{{article.title}}</h4>
						<p>
							<span>{{article.favors}}人喜欢 • {{article.author}} • {{article.date|dateFormat}}</span>
						</p>
					</div>
					<img :src="article.image" class="article-img" v-if="article.image">
				</li>
				<li v-if="articleList.length==0" class="article-loading" v-for="i in 3" :key="i">
					<div class="article-info">
						<h4></h4>
						<p>
							<span class="text"></span> • <span class="text"></span> • <span class="text"></span>
						</p>
					</div>
					<div class="article-img"/>
				</li>
			</ul>
		</div>
	</scroll>
</template>

<script>
  import carousel from '@/components/searchPage/carousel';
  import scroll from '@/components/common/scroll';
  export default {
    name: 'searchContent',
    data() {
      return {
        articleList: []
      }
    },
    beforeMount() {
      // setTimeout(() => {
        this.$axios.get('/api/getArticleList', {
          params: {
            subject: 'index',
            startIndex: this.articleList.length,
            number: 5
          },
          timeout: 4000
        }).then(result => {
          if (result.data.length == 0) {
            reject({
              errno: 0,
              text: '已经是最新的了!'
            });
          }
          this.articleList = result.data.concat(this.articleList);
        }).catch(err => {
          if (err.response) {
            console.log('error.response: ', err.response);
          } else if (err.request.readyState == 4 && err.request.status == 0) {
            console.warn('Request timeout!');
          } else {
            console.error(err);
          }
        });
      // }, 500);
    },
    methods: {
      loadMore() {
        return new Promise((resolve, reject) => {
          this.$axios.get('/api/getArticleList', {
            params: {
              subject: 'index',
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
    filters: {
      dateFormat(time) {
        let dayMilli, days, hoursMilli, hours, minutesMilli, minutes, secondMill, seconds;
        dayMilli = Date.now() - new Date(time).getTime();
        days = Math.floor(dayMilli / (24 * 3600 * 1000));
        hoursMilli = dayMilli % (24 * 3600 * 1000);
        hours = Math.floor(hoursMilli / (3600 * 1000));
        minutesMilli = hoursMilli % (3600 * 1000);
        minutes = Math.floor(minutesMilli / (60 * 1000));
        secondMill = minutesMilli % (60 * 1000);
        seconds = Math.floor(secondMill / 1000);
        if (days) {
          return days + '天前';
        } else if (hours) {
          return hours + '小时前';
        } else if (minutes) {
          return minutes + '分前';
        } else if (seconds) {
          return seconds + '秒前';
        } else {
          return 'something went wrong!';
        }
      }
    },
    components: {
      scroll,
      carousel
    }
  }
</script>

<style lang="less" scoped>
  .search-content {
    width: 100%;
    .carousel {
      width: 100vw;
      height: 40vw;
    }
    .activity {
      width: 100%;
      height: 10vh;
      box-shadow: 0 0 1vw #CCCCCC;
      background-color: #FFFFFF;
      display: flex;
      justify-content: space-around;
      align-items: center;
      padding: 3vw 0;
      div {
        width: 25vw;
        height: 100%;
        text-align: center;
        display: flex;
        flex-direction: column;
        justify-content: space-around;
        align-items: center;
        i {
          font-size: 8vw;
          display: block;
          &.fa-book {
            color: #0080FF;
          }
          &.fa-free-code-camp {
            color: #FF5E34;
          }
          &.fa-bookmark {
            color: #1AC09A;
          }
          &.fa-bullhorn {
            color: #FFCC00;
          }
        }
        span {
          font-size: 4.5vw;
        }
      }
    }
    .hot-article {
      width: 100%;
      margin-top: 5vw;
      box-shadow: 0 0 1vw #CCCCCC;
			background-color: #FFFFFF;
      .title {
        display: flex;
        padding: 3vw;
        font-size: 4.6vw;
        box-shadow: 1px 0 1px #CCCCCC;
        justify-content: space-between;
        i {
          margin-right: 1vw;
        }
        i.fa-free-code-camp {
          color: #FD3400;
        }
        .title-right {
          color: #666666;
          font-size: 4vw;
        }
      }
      .article {
        height: 20vw;
        padding: 3vw;
        display: flex;
        justify-content: space-between;
        align-items: center;
        box-shadow: 0 0 1px #CCCCCC;
        .article-info {
          flex: 0.96;
          h4 {
            font-size: 4.5vw;
            font-weight: normal;
          }
          span {
            font-size: 4vw;
            display: inline-block;
            margin: 2vw 0;
            color: #555555;
          }
        }
        .article-img {
          max-width: 30vw;
          height: 100%;
        }
      }
      .article-loading {
        animation: blink 2.5s linear infinite;
        height: 20vw;
        padding: 3vw;
        display: flex;
        justify-content: space-between;
        align-items: center;
        box-shadow: 0 0 1px #CCCCCC;
        .article-info {
          flex: 0.96;
          h4 {
            width: 60vw;
            height: 6vw;
            font-size: 4.5vw;
            font-weight: normal;
            background-color: #CCCCCC;
						border-radius: 10px;
						margin-bottom: 3vw;
          }
          p {
            line-height: 5vw;
            font-size: 5vw;
            color: #555555;
            span {
              width: 16vw;
              height: 5vw;
              display: inline-block;
              background-color: #CCCCCC;
              vertical-align: middle;
              border-radius: 10px;
            }
          }
        }
        .article-img {
          width: 30vw;
          height: 20vw;
          border-radius: 5px;
          background-color: #CCCCCC;
        }
      }
    }
  }

  @keyframes blink {
    0% {
      opacity: 1;
    }
    25% {
      opacity: 0.5;
    }
    50% {
      opacity: 0;
    }
    75% {
      opacity: 0.5;
    }
    100% {
      opacity: 1;
    }
  }
</style>