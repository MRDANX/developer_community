<template>
  <scroll :enableLoadMore="true" :loadMore="loadMoreDetailedArticles" ref="searchingScroll">
    <div class="searching-content">
      <transition name="fade">
        <div class="searching-result" v-if="searchText" key="result">
          <div v-if="getResult" class="detailed-result">
            <div class="related-user" v-if="detailedSearchUsers.length!=0">
              <p>相关用户
                <i class="fa fa-angle-right" v-if="detailedSearchUsers.length>8"></i>
              </p>
              <ul>
                <router-link v-for="(user,index) in detailedSearchUsers.slice(0,7)" :key="index" :to="{name:'userDetail',params:{userID:user.userID}}"
                  tag="li">
                  <div class="avatar">
                    <img :src="user.avatar" />
                  </div>
                  <span class="user-name">{{user.userName}}</span>
                </router-link>
              </ul>
            </div>
            <ul class="related-article" v-if="detailedSearchArticles.length!=0">
              <li class="related-article-header">
                <div class="header-left">
                  <span :class="{active:currentOrderBy=='pv'}" @click="currentOrderBy='pv'">按浏览数排序</span>
                  <span :class="{active:currentOrderBy=='favors'}" @click="currentOrderBy='favors'">按点赞数排序</span>
                </div>
                <div class="header-right">
                  <span>所有时间</span>
                  <i class="fa fa-angle-down"></i>
                </div>
              </li>
              <li class="related-article-content" v-for="(article,index) in detailedSearchArticles" :key="index">
                <router-link :to="{name: 'articleDetail',params:{articleID:article.articleID}}" tag="h4" class="title" v-html="highlightMatch(article.title)"></router-link>
                <p class="content" v-html="highlightMatch(tagFilter(article.content))"></p>
                <p class="meta">
                  <span>{{article.favors}} 人喜欢 • {{article.author}} • {{article.date|timeFromNow}}</span>
                </p>
              </li>
            </ul>
          </div>
          <ul v-else class="simple-result">
            <router-link v-for="(user,index) in simpleSearchUsers" :key="'user'+index" class="result-user" :to="{name:'userDetail',params:{userID:user.userID}}"
              tag="li">
              <div class="result-user-left">
                <div class="avatar">
                  <img :src="user.avatar" />
                </div>
                <div>
                  <p v-html="highlightMatch(user.userName)"></p>
                  <p class="follower">粉丝 {{user.followers}}</p>
                </div>
              </div>
              <span class="result-user-right">作者</span>
            </router-link>
            <li v-for="(article,index) in simpleSearchArticles" :key="'article'+index" class="result-article">
              <router-link class="title" v-html="highlightMatch(article.title)" :to="{name: 'articleDetail',params:{articleID:article.articleID}}"
                tag="span"></router-link>
              <span class="pv">阅读 {{article.pv}}</span>
            </li>
          </ul>
        </div>
        <div class="searching-recommend" v-else key="recommend">
          <div class="searching-hot">
            <div class="hot-header">
              <div class="hot-left">
                <i class="hot-icon"></i>
                <span>热门搜索</span>
              </div>
              <div @click="refreshHotList" class="hot-right">
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
          <transition-group name="clear-history" tag="ul" class="searching-history">
            <li v-for="(history,index) in searchHistory" :key="history" class="history-item">
              <div>
                <i class="fa fa-clock-o"></i>
                <span @click="getResultDirectly(history)">{{history}}</span>
              </div>
              <span class="item-clear" @click="removeClickedHistory(index)" ref="clearItem"></span>

            </li>
            <li class="clear-all-history" @click="clearAllHistory" key="clearAllHistory" v-if="searchHistory.length!=0" ref="clearAll">清除全部搜索记录</li>
          </transition-group>
        </div>
      </transition>
      <loading v-if="showLoading" />
    </div>
  </scroll>
</template>

<script>
  import scroll from '@/components/common/scroll';
  import loading from '@/components/common/loading';
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
        showLoading: false,
        hots: ['单页面应用', 'Android', '前端', 'iOS', '反向代理', 'vue.js', '跨域', '小程序', 'nginx', 'Google', '面向对象', 'node',
          'webpack', '用户体验', 'localStorage', 'mysql', 'bootstrap'
        ],
        currentHotsIndex: 0,
        hotsRefreshing: false,
        searchHistory: [],
        getResult: false,
        currentOrderBy: 'pv',
        simpleSearchUsers: [],
        simpleSearchArticles: [],
        detailedSearchUsers: [],
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
      //disable load more action as default
      this.$refs.searchingScroll.disableLoadMore();
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
          this.getDetailedRestulFromServer();
        });
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
      },
      getSimpleResultFromServer() {
        this.showLoading = true;
        this.$axios({
          method: 'get',
          url: '/api/searchForSimple',
          params: {
            searchText: this.searchText
          }
        }).then(result => {
          this.simpleSearchUsers = result.data.users;
          this.simpleSearchArticles = result.data.articles;
          this.showLoading = false;
        });
      },
      getDetailedRestulFromServer() {
        this.showLoading = true;
        this.$axios({
          method: 'get',
          url: '/api/searchForDetailed',
          params: {
            searchText: this.searchText,
            articleOrderBy: this.currentOrderBy
          }
        }).then(result => {
          this.detailedSearchUsers = result.data.users;
          this.detailedSearchArticles = result.data.articles;
          this.showLoading = false;
        });
      },
      loadMoreDetailedArticles() {
        return new Promise((resolve, reject) => {
          this.$axios({
            method: 'get',
            url: '/api/searchForMoreDetailedArticle',
            params: {
              searchText: this.searchText,
              articleOrderBy: this.currentOrderBy,
              startIndex: this.detailedSearchArticles.length
            }
          }).then(result => {
            if (result.data.length == 0) {
              reject({
                errno: 0,
                text: 'no more data.'
              })
            }
            this.detailedSearchArticles = this.detailedSearchArticles.concat(result.data);
            resolve();
          });
        })

      },
      highlightMatch(text) {
        let regExp = new RegExp(this.searchText, 'ig');
        text = text.replace(/<script>(.*?)<\/script>/ig, '<ｓｃｒｉｐｔ>$1<／ｓｃｒｉｐｔ>');
        return text.replace(regExp, '<strong style="color:#0080FF">$&</strong>');
      },
      tagFilter(text) {
        return text.replace(/<\/?[^>]+>/g, '');
      }
    },
    watch: {
      searchText(n) {
        this.getResult = false;
        if (n == '') {
          this.$refs.searchingScroll.disableLoadMore();
          this.$emit('setSearchButton', false);
        } else {
          this.$refs.searchingScroll.reenableLoadMore();
          this.getSimpleResultFromServer();
        }
      },
      searchButtonPressed(pressed) {
        if (pressed) {
          this.getResult = true;
          if (this.searchText == '') return;
          this.setLocalHistory();
          this.getDetailedRestulFromServer();
          this.$emit('setSearchButton', false);
        }
      },
      searchHistory() {
        localStorage.setItem('searchHistory', JSON.stringify(this.searchHistory));
      },
      currentOrderBy() {
        this.$refs.searchingScroll.reenableLoadMore();
        this.getDetailedRestulFromServer();
      }
    },
    components: {
      scroll,
      loading
    }
  }

</script>

<style lang="less" scoped>
  .fade-enter,
  .fade-leave-to {
    opacity: 0;
  }



  .searching-content {
    width: 100%;
    .searching-result {
      width: 100vw;
      transition: all .5s;
      font-size: 4vw;
      .simple-result {
        background-color: #FFFFFF;
        padding: 0 3vw;
        li {
          border-bottom: 1px solid #CCCCCC;
          &:last-of-type {
            border-bottom: none;
          }
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
            .avatar {
              width: 18vw;
              height: 18vw;
              margin-right: 5vw;
              border-radius: 50%;
              overflow: hidden;
              img {
                height: 100%;
              }
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
          background-color: #FFFFFF;
          border-bottom: 1px solid #CCCCCC;
          margin-bottom: 3vw;
          p {
            margin-bottom: 4vw;
            i.fa {
              float: right;
              font-size: 6vw;
              font-weight: bold;
              color: #666666;
            }
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
              margin-right: 4vw;
              margin-bottom: 3vw;
              .avatar {
                width: 14vw;
                height: 14vw;
                border-radius: 50%;
                overflow: hidden;
                img {
                  height: 100%;
                }
              }
            }
          }
          .user-name {
            overflow: hidden;
            max-width: 20vw;
            white-space: nowrap;
            text-overflow: ellipsis;
          }
        }
        .related-article {
          padding: 0 3vw;
          background-color: #FFFFFF;
          box-shadow: 0 0 4px #CCCCCC;
          .related-article-header {
            display: flex;
            justify-content: space-between;
            padding: 2vw 0;
            .header-left {
              span.active {
                color: #0080FF;
                transition: all .3s;
              }
              span:first-of-type {
                border-right: 1px solid #CCCCCC;
                padding-right: 3vw;
              }
              span:last-of-type {
                padding-left: 3vw;
              }
            }
          }
          .related-article-content {
            margin-top: 5vw;
            padding-bottom: 3vw;
            border-bottom: 1px solid #CCCCCC;
            .title {
              margin-bottom: 2vw;
            }
            .content {
              display: -webkit-box;
              -webkit-box-orient: vertical;
              -webkit-line-clamp: 3;
              overflow: hidden;
            }
            .meta {
              margin-top: 3vw;
            }
          }
        }
      }
    }
    .searching-recommend {
      width: 100vw;
      background-color: #FFFFFF;
      box-shadow: 0 0 1vw #FAFAFA;
      padding: 3vw;
      padding-bottom: 0;
      box-sizing: border-box;
      .searching-hot {
        font-size: 4vw;
        .hot-left {
          display: flex;
          align-items: center;
        }
        .hot-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          padding-bottom: 3vw;
          border-bottom: 1px solid #CCCCCC;
          .hot-icon {
            display: inline-block;
            width: 5vw;
            height: 5vw;
            background-image: url("/static/images/common/hot.svg");
            background-size: cover;
          }
          i.refreshing {
            transition: transform 3s;
            color: #0080FF !important;
            transform: rotate(360deg);
          }
          i {
            margin-right: 2vw;
            color: red;
          }
          div:first-of-type {
            font-size: 4.5vw;
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
          &.clear-history-leave-active {
            position: absolute;
          }

          &.clear-history-leave-to {
            opacity: 0;
            transform: translateX(-100%);
          }
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
            width: 6vw;
            height: 6vw;
            text-align: center;
            border-radius: 50%;
            margin-right: 3vw;
            transition: all .1s;
            transform: scale(1);
            background-image: url("/static/images/common/delete.svg");
            background-size: cover;
            &.active {
              transform: scale(0.9);
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
          &.clear-history-leave-to {
            display: none;
          }
        }
      }
    }
  }

</style>
