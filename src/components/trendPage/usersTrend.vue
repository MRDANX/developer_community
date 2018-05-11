<template>
	<scroll ref="usersTrendScroll">
		<div class="users-trend">
			<ul v-if="userInfo.userID" class="users-trend-list">
				<trend v-for="(trend,index) in trendList" :key="index" :trend="trend" ref="trends"/>
			</ul>
			<div v-else class="ask-for-login">
				<i class="fa fa-coffee"></i>
				<p>需要您登录，登录后使用更多功能</p>
				<router-link to="setting" tag="div" class="login-register-button" ref="loginRegisterButton">登录/注册</router-link>
			</div>
		</div>
	</scroll>
</template>

<script>
  import scroll from "@/components/common/scroll";
  import trend from "@/components/trendPage/trend";
  import { mapState } from "vuex";
  export default {
    name: 'usersTrend',
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
          images: '/static/images/logo.png,/static/images/test1.jpg,/static/images/logo.png,/static/images/test2.jpg,/static/images/logo.png,/static/images/test3.jpg',
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
        }]
      }
		},
		mounted(){
			let loginRegisterButton=this.$refs.loginRegisterButton;
			if(loginRegisterButton){
				this.$activeFeedback(loginRegisterButton.$el);
			}
			if(!this.userInfo.userID){
				this.$refs.usersTrendScroll._disable();
			}
		},
    computed: {
      ...mapState('user', ['userInfo'])
    },
    components: {
      trend,
      scroll
    }
  }
</script>

<style lang="less" scoped>
  .users-trend {
    width: 100vw;
		.users-trend-list{

		}
		.ask-for-login{
			width: 100vw;
			height: 84vh;
			position: relative;
			display: flex;
			flex-direction: column;
			padding-top: 20vh;
			box-sizing: border-box;
			justify-content: flex-start;
			align-items: center;
			font-size: 4vw;
			i.fa{
				font-size: 20vw;
				color: #CCCCCC;
			}
			p{
				margin: 3vw 0;
			}
			.login-register-button{
				padding: 0 3vw;
				width: 20vw;
				height: 10vw;
				line-height: 10vw;
				border-radius: 5px;
				text-align: center;
				background-color: #0080FF;
				color:#FFFFFF;
				&.active{
					transition: all .1s;
					transform: scale(0.8);
				}
			}
		}
  }
</style>