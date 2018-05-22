<template>
	<scroll>
		<div class="topic-trend">
			<div class="topic-banner">
				<slider :loop="true" :autoPlay="true">
					<div class="banner">
						<img src="/static/images/test1.jpg" alt="">
					</div>
					<div class="banner">
						<img src="/static/images/test2.jpg" alt="">
					</div>
					<div class="banner">
						<img src="/static/images/test3.jpg" alt="">
					</div>
				</slider>
			</div>
			<ul class="more-topic">
				<li class="head"><i class="topic-icon"></i>更多话题</li>
				<li class="topic" v-for="(topic,index) in topics" :key="index">
					<div class="topic-image">
						<img :src="topic.image">
					</div>
					<div class="topic-content">
						<p class="title">{{topic.title}}</p>
						<p class="desc">{{topic.desc}}</p>
					</div>
					<!-- <div class="focus">关注</div> -->
				</li>
			</ul>
		</div>
	</scroll>
</template>

<script>
  import slider from "@/components/trendPage/slider";
  import scroll from "@/components/common/scroll";
  export default {
    name: 'topicTrend',
    data() {
      return {
        topics: [{
          topicID: 1,
          image: '/static/images/test1.jpg',
          title: '每天一道算法题',
          desc: '每天精选一道算法题，帮助你更好地提高算法能力'
        },{
          topicID: 1,
          image: '/static/images/test1.jpg',
          title: '每天一道算法题',
          desc: '每天精选一道算法题，帮助你更好地提高算法能力'
        },{
          topicID: 1,
          image: '/static/images/test1.jpg',
          title: '每天一道算法题',
          desc: '每天精选一道算法题，帮助你更好地提高算法能力'
        },{
          topicID: 1,
          image: '/static/images/test1.jpg',
          title: '每天一道算法题',
          desc: '每天精选一道算法题，帮助你更好地提高算法能力'
        },{
          topicID: 1,
          image: '/static/images/test1.jpg',
          title: '每天一道算法题',
          desc: '每天精选一道算法题，帮助你更好地提高算法能力'
        }]
      }
    },
    components: {
      scroll,
      slider
    }
  }
</script>

<style lang="less" scoped>
  .topic-trend {
    width: 100vw;
    .topic-banner {
      width: 100vw;
      height: 40vw;
      margin: 3vw 0;
      overflow: hidden;
      .banner {
        width: 96vw;
        margin: 0 2vw;
        position: relative;
        img {
          width: 100%;
          position: absolute;
          top: 50%;
          transform: translateY(-50%);
        }
      }
    }
    .more-topic {
      width: 100vw;
      background-color: #FFFFFF;
      overflow: hidden;
      li.head {
        padding: 0 3vw;
        font-size: 4.5vw;
        height: 10vw;
        line-height: 10vw;
        border-bottom: 1px solid #F0F0F0;
        display: flex;
        align-items: center;
				// i.fa{
				// 	margin-right: 2vw;
				// 	font-size: 5vw;
        // }
        .topic-icon{
          width: 6vw;
          height: 6vw;
          margin-right: 2vw;
          display: inline-block;
          background-image: url('/static/images/common/topic.svg');
          background-size: cover;
        }
      }
      li.topic {
        padding: 0 3vw;
				height: 20vw;
        display: flex;
        justify-content: space-between;
				align-items: center;
        border-bottom: 1px solid #F0F0F0;
        .topic-image {
          height: 14vw;
          width: 14vw;
          overflow: hidden;
					border-radius: 5px;
					position: relative;
          img {
						height: 100%;
						position: absolute;
						left: 50%;
						transform: translateX(-50%);
          }
        }
        .topic-content {
					width: 75vw;
					.title{
						font-size: 4.5vw;
						margin-bottom: 1vw;
						font-weight: bold;
					}
					.desc{
						font-size: 3.8vw;
						white-space: nowrap;
						text-overflow: ellipsis;
						overflow: hidden;
						color: #555555;
					}
        }
        // .focus {
        //   height: 8vw;
        //   width: 10vw;
        //   border-radius: 5px;
        //   background-color: #0080FF;
        //   color: #FFFFFF;
        //   text-align: center;
        //   line-height: 8vw;
        //   font-size: 4vw;
        //   padding: 0 2vw;
        // }
      }
    }
  }
</style>