<template>
	<scroll>
		<div class="searching-content">
			<transition name="fade">
				<div class="searching-result" v-if="searchText" key="result">
          <div v-if="getResult" class="detailed-result">
            <div class="related-user">
              <p>相关用户</p>
              <ul>
                <li v-for="(user,index) in detailedSearchUsers" :key="index">
                  <img :src="user.avatar" />
                  <span>{{user.author}}</span>
                </li>
              </ul>
            </div>
            <ul class="related-article">
              <li class="related-article-header">
                <div class="header-left">
                  <span>按浏览数排序</span>
                  <span>按点赞数排序</span>
                </div>
                <div class="header-right">
                  <span>所有时间</span>
                  <i class="fa fa-angle-down"></i>
                </div>
              </li>
              <li class="related-article-content">

              </li>
            </ul>
          </div>
          <ul v-else class="simple-result">
            <li v-for="(user,index) in simpleSearchUsers" :key="'user'+index" class="result-user">
              <div class="result-user-left">
                <img :src="user.avatar"/>
                <div>
                  <p>{{user.author}}</p>
                  <p class="follower">粉丝 {{user.follower}}</p>
                </div>
              </div>
              <span class="result-user-right">作者</span>
            </li>
            <li v-for="(article,index) in simpleSearchArticles" :key="'article'+index" class="result-article">
              <span class="title">{{article.title}}</span>
              <span  class="pv">阅读 {{article.pv}}</span>
            </li>
          </ul>
				</div>
				<div class="searching-recommend" v-else key="recommend">
					<div class="searching-hot">
            <div class="hot-header">
              <div>
                <i class="fa fa-free-code-camp"></i>
                <span>热门搜索</span>
              </div>
              <div @click="refreshHotList">
                <i class="fa fa-refresh" :class="{refreshing:hotsRefreshing}"></i>
                <span>换一批</span>
              </div>
            </div>
            <transition name="fade" mode="out-in">
              <ul class="hot-list" :key="currentHotsIndex">
                <li v-for="(hot,index) in sliceHots" :key="index" class="hot-list-item" @click="getResultDirectly(hot)" ref="hotList">{{hot}}</li>
              </ul>
            </transition>
          </div>
            <transition-group name="clear-history" tag="ul" class="searching-history" >
              <li v-for="(history,index) in searchHistory" :key="history" class="history-item">
                <div>
                  <i class="fa fa-clock-o"></i>
                  <span @click="getResultDirectly(history)">{{history}}</span>
                </div>
                <span class="item-clear" @click="removeClickedHistory(index)" ref="clearItem">X</span>
              </li>
              <li class="clear-all-history" @click="clearAllHistory" key="clearAllHistory" v-if="searchHistory.length!=0" ref="clearAll">清除全部搜索记录</li>
            </transition-group>
				</div>
			</transition>
		</div>
	</scroll>
</template>

<script>
  import scroll from '@/components/common/scroll';
  export default {
    name: 'searchingContent',
    props: {
      value: {
        type: String,
        default: ''
      },
      searchButtonPressed: {
        type: Boolean,
        default: false
      }
    },
    data() {
      return {
        hots: ['单页面应用', 'Android', '前端', 'iOS', '反向代理', 'vue.js', '跨域', '小程序', 'nginx', 'Google', '面向对象', 'node', 'webpack', '用户体验', 'localStorage', 'mysql', 'bootstrap'],
        currentHotsIndex: 0,
        hotsRefreshing: false,
        searchHistory: [],
        getResult: false,
        simpleSearchUsers: [{
          userID: 1,
          avatar: '/static/images/logo.png',
          author: 'danxiong',
          follower: 5
        }, {
          userID: 2,
          avatar: '/static/images/logo.png',
          author: 'danxiong1995',
          follower: 15
        }],
        simpleSearchArticles: [{
          articleID: 1,
          title: '这是一个很长很长很长的标题这是一个很长很长很长的标题这是一个很长很长很长的标题',
          pv: 122
        }, {
          articleID: 2,
          title: '这是一个很长很长很长的标题这是一个很长很长很长的标题这是一个很长很长很长的标题',
          pv: 122
        }, {
          articleID: 3,
          title: '这是一个很长很长很长的标题这是一个很长很长很长的标题这是一个很长很长很长的标题',
          pv: 122
        }],
        detailedSearchUsers: [{
          userID: 1,
          avatar: '/static/images/logo.png',
          author: 'danxiong',
        }, {
          userID: 2,
          avatar: '/static/images/logo.png',
          author: 'danxiong',
        }],
        detailedSearchArticles: []
      }
    },
    created() {
      //get search history from loaclStorage with item searchHistory
      let searchHistory = JSON.parse(localStorage.getItem('searchHistory'));
      if (searchHistory) {
        this.searchHistory = searchHistory;
      }
    },
    mounted() {
      //add active effect
      if (this.searchHistory.length != 0) {
        this.$refs.clearItem.forEach(el => {
          this.$activeFeedback(el);
        });
        this.$activeFeedback(this.$refs.clearAll);
      }
      this.$refs.hotList.forEach(el => {
        this.$activeFeedback(el);
      });
    },
    updated() {
      if (this.searchHistory.length != 0 && this.searchText == '') {
        this.$refs.clearItem.forEach(el => {
          this.$activeFeedback(el);
        });
        this.$activeFeedback(this.$refs.clearAll);
      }
      if (this.$refs.hotList) {
        this.$refs.hotList.forEach(el => {
          this.$activeFeedback(el);
        });
      }
    },
    computed: {
      searchText: {
        get() {
          return this.value;
        },
        set(val) {
          this.$emit('input', val);
        }
      },
      sliceHots() {
        let currentHotsIndex = this.currentHotsIndex;
        return this.hots.slice(currentHotsIndex, currentHotsIndex + 10);
      }
    },
    methods: {
      //refresh hotsList when refresh block is clicked
      refreshHotList() {
        if (this.refreshTimer) return;
        this.currentHotsIndex = this.currentHotsIndex + 10;
        if (this.currentHotsIndex >= this.hots.length) {
          this.currentHotsIndex = 0;
        }
        this.hotsRefreshing = true;
        this.refreshTimer = setTimeout(() => {
          this.hotsRefreshing = false;
          this.refreshTimer = null;
        }, 3000);
      },
      //remove the exact search history according to the clicked index
      removeClickedHistory(index) {
        this.searchHistory.splice(index, 1);
      },
      //clear all search history
      clearAllHistory() {
        let searchHistory = localStorage.getItem('searchHistory');
        if (searchHistory) {
          localStorage.removeItem('searchHistory');
          this.searchHistory = [];
        }
      },
      getResultDirectly(text) {
        this.searchText = text;
        this.$nextTick(() => {
          this.setLocalHistory();
          this.getResult = true;
        })
      },
      setLocalHistory() {
        let localSearchHistory = JSON.parse(localStorage.getItem('searchHistory'));
        if (localSearchHistory) {
          let existIndex = localSearchHistory.indexOf(this.searchText);
          if (existIndex != -1) {
            let toFront = this.searchHistory.splice(existIndex, 1);
            this.searchHistory.unshift(toFront[0]);
          } else {
            this.searchHistory.unshift(this.searchText);
          }
          localStorage.setItem('searchHistory', JSON.stringify(this.searchHistory));
        } else {
          this.searchHistory.unshift(this.searchText);
          localStorage.setItem('searchHistory', JSON.stringify(this.searchHistory))
        }
      }
    },
    watch: {
      searchText(n) {
        this.getResult = false;
        if (n == '') {
          this.$emit('setSearchButton', false);
        } else {

        }
      },
      searchButtonPressed(pressed) {
        if (pressed) {
          this.getResult = true;
          if (this.searchText == '') return;
          this.setLocalHistory();
          this.$emit('setSearchButton', false);
        }
      },
      searchHistory() {
        localStorage.setItem('searchHistory', JSON.stringify(this.searchHistory));
      }
    },
    components: {
      scroll
    }
  }
</script>

<style lang="less" scoped>
  .fade-enter,
  .fade-leave-to {
    opacity: 0;
  }

  .clear-history-leave-active {
    position: absolute;
  }

  .clear-history-leave-to {
    opacity: 0;
    transform: translateX(-100%);
  }

  .searching-content {
    width: 100%;
    .searching-result {
      width: 100vw;
      background-color: #FFFFFF;
      transition: all .5s;
      font-size: 4vw;
      .simple-result {
        padding: 0 3vw;
        li {
          border-bottom: 1px solid #CCCCCC;
        }
        .result-user {
          display: flex;
          justify-content: space-between;
          align-items: center;
          width: 100%;
          height: 18vw;
          padding: 3vw 0;
          .result-user-left {
            flex: 1;
            display: flex;
            align-items: center;
            >div>p {
              margin: 3vw 0;
              &.follower {
                color: #666666;
              }
            }
            img {
              height: 18vw;
              margin-right: 5vw;
            }
          }
          .result-user-right {
            color: #666666;
          }
        }
        .result-article {
          padding: 3vw 0;
          .title {
            margin-right: 3vw;
          }
          .pv {
            color: #666666;
          }
        }
      }
      .detailed-result {
        .related-user {
          padding: 3vw;
          border-bottom: 1px solid #CCCCCC;
          p{
            margin-bottom: 3vw;
          }
          ul {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            li {
              height: 20vw;
              display: flex;
              flex-direction: column;
              align-items: center;
              font-size: 4vw;
              margin-right: 5vw;
              img {
                height: 70%;
              }
            }
          }
        }
        .related-article {}
      }
    }
    .searching-recommend {
      width: 100vw;
      background-color: #FFFFFF;
      box-shadow: 0 0 1vw #CCCCCC;
      padding: 3vw;
      padding-bottom: 0;
      box-sizing: border-box;
      .searching-hot {
        font-size: 4vw;
        .hot-header {
          display: flex;
          justify-content: space-between;
          padding-bottom: 3vw;
          border-bottom: 1px solid #CCCCCC;
          i.refreshing {
            transition: transform 3s;
            color: #0080FF !important;
            transform: rotate(360deg);
          }
          i {
            margin-right: 2vw;
            color: red;
          }
          div:last-of-type {
            color: #666666;
            i {
              color: #666666;
            }
          }
        }
        .hot-list {
          display: flex;
          flex-wrap: wrap;
          padding: 3vw 0;
          transition: all .5s;
          position: relative;
          .hot-list-item {
            padding: 1vw 3vw;
            margin: 1.5vw 2vw;
            border-radius: 5px;
            color: #666666;
            border: 1px solid #999999;
            &.active {
              background-color: #CCCCCC;
            }
          }
        }
      }
      .searching-history {
        // display: flex;
        // flex-flow: column nowrap;
        position: relative;
        .history-item {
          transition: all .5s;
          display: flex;
          justify-content: space-between;
          align-items: center;
          width: 100%;
          height: 10vw;
          padding: 3vw 0;
          font-size: 5vw;
          font-weight: normal;
          border-bottom: 1px solid #CCCCCC;
          background-color: #FFFFFF;
          color: #333333;
          &::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 1px;
            background-color: #CCCCCC;
            transform: scaleX(0);
            transition: all .3s;
          }
          &:first-of-type::before {
            transform: scaleX(1);
          }
          i.fa-clock-o {
            font-size: 6vw;
            margin-right: 2vw;
            color: #777777;
          }
          span.item-clear {
            font-size: 3.5vw;
            width: 5vw;
            height: 5vw;
            text-align: center;
            line-height: 5vw;
            border-radius: 50%;
            background: #666666;
            color: #FFFFFF;
            font-family: cursive;
            margin-right: 3vw;
            transition: all .1s;
            &.active {
              font-size: 3vw;
              transform: scale(0.8);
            }
          }
        }
        .clear-all-history {
          width: 100%;
          transition: all .5s;
          padding: 3vw 0;
          text-align: center;
          font-size: 5vw;
          color: #666666;
          background-color: #FFFFFF;
          &.active {
            transition: all .3s;
            font-size: 4vw;
          }
        }
      }
    }
  }
</style>