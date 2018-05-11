<template>
	<scroll :enalbeLoadMore='true'>
		<div class="recommend-trend">
			<div class="slide-trend">
				<slider>
					<div class="slide-trend-item">1</div>
					<div class="slide-trend-item">2</div>
					<div class="slide-trend-item">3</div>
					<div class="slide-trend-item">4</div>
					<div class="slide-trend-item">5</div>
					<div class="slide-trend-item">6</div>
					<div class="slide-trend-item">7</div>
					<div class="slide-trend-item">8</div>
				</slider>
			</div>
			<ul class="trend-list">
				<trend v-for="(trend,index) in trendList" :key="index" :trend="trend" ref="trends"/>
			</ul>
		</div>
	</scroll>
</template>

<script>
  import scroll from "@/components/common/scroll";
  import slider from "@/components/trendPage/slider";
  import trend from "@/components/trendPage/trend";
  export default {
    name: 'recommendTrend',
    data() {
      return {
        trendList: [{
          avatar: '/static/images/logo.png',
          userName: '我是谁',
          job: '全栈工程师',
          company: '有限公司',
          date: '3天前',
          content: '这是内容<br>这是内容这是<br>内容<br>这是内容<br>这是内容',
          favors: 12,
          images: '/static/images/logo.png,/static/images/test1.jpg,/static/images/logo.png,/static/images/test2.jpg,/static/images/test3.jpg',
          commentNum: 10
        }, {
          avatar: '/static/images/logo.png',
          userName: '我是谁',
          job: '全栈工程师',
          company: '有限公司',
          date: '3天前',
          content: '这是内容这是内容这是内容这是内容这是内容',
          favors: 12,
          images: '/static/images/test3.jpg',
          commentNum: 10
        }, {
          avatar: '/static/images/logo.png',
          userName: '我是谁',
          job: '全栈工程师',
          company: '有限公司',
          date: '3天前',
          content: '这是内容这是内容这是内容这是内容这是内容',
          images: '',
          favors: 12,
          commentNum: 10
        }, {
          avatar: '/static/images/logo.png',
          userName: '我是谁',
          job: '全栈工程师',
          company: '有限公司',
          date: '3天前',
          content: '这是内容这是内容这是内容这是内容这是内容',
          images: '',
          favors: 12,
          commentNum: 10
        }, {
          avatar: '/static/images/logo.png',
          userName: '我是谁',
          job: '全栈工程师',
          company: '有限公司',
          date: '3天前',
          content: '这是内容这是内容这是内容这是内容这是内容',
          images: '',
          favors: 12,
          commentNum: 10
        }, {
          avatar: '/static/images/logo.png',
          userName: '我是谁',
          job: '全栈工程师',
          company: '有限公司',
          date: '3天前',
          content: '这是内容这是内容这是内容这是内容这是内容',
          images: '',
          favors: 12,
          commentNum: 10
        }, {
          avatar: '/static/images/logo.png',
          userName: '我是谁',
          job: '全栈工程师',
          company: '有限公司',
          date: '3天前',
          content: '这是内容这是内容这是内容这是内容这是内容',
          images: '',
          favors: 12,
          commentNum: 10
        }]
      }
    },
    components: {
      slider,
      scroll,
      trend
    }
  }
</script>

<style lang="less" scoped>
  .recommend-trend {
    width: 100vw;
    .slide-trend {
      width: 100vw;
      height: 25vw;
      margin-top: 3vw;
      .slide-trend-item {
        width: 80vw;
        height: 100%;
        margin: 0 3vw;
        background-color: red;
      }
    }
    .trend-list {
      font-size: 4vw;
      overflow: hidden;
    }
  }
</style>