<template>
  <li class="hot-recommend" v-if="isShow&&recommendArticles.length!=0">
    <div class="header">
      <div>
        <!-- fa-h-square -->
        <span class="fa fa-free-code-camp"></span>
        <span>热门推荐</span>
      </div>
      <div>
        <span class="fa fa-refresh" ref="refresh" @click="refresh"></span>
        <span class="fa fa-close" @click="isShow=false"></span>
      </div>
    </div>
    <ul class="content">
      <li v-for="(article,index) in recommendArticles" :key="index">
        <h4>{{article.title}}</h4>
        <div>
          <div @click="toggleFavor(index)" :class="{isFavorite:isFavorite(index)}">
            <i class="fa fa-heart"></i>
            <span>{{article.favors||'点赞'}}</span>
          </div>
          <div>
            <i class="fa fa-user"></i>
            <span>{{article.author}}</span>
          </div>
          <div>
            <i class="fa fa-clock-o"></i>
            <span>{{article.date|dateFormat}}</span>
          </div>
        </div>
      </li>
    </ul>
  </li>
</template>

<script>
  import { mapState } from "vuex";
  export default {
    name: 'hotRecommend',
    props: {
      subject: {
        type: String,
        default: 'index'
      },
    },
    data() {
      return {
        isShow: true,
        favorLock: false,
        recommendArticles: []
      }
    },
    computed: {
      ...mapState('user', ['userInfo'])
    },
    created() {
      this.getRecommendArticles();
    },
    methods: {
      getRecommendArticles() {
        return new Promise((resolve, reject) => {
          this.$axios.get('/getArticleList', {
            params: {
              subject: this.subject,
              startIndex: this.recommendArticles.length,
              number: 3,
              orderBy:'favors'
            },
            timeout: 20000
          }).then(result => {
            if (result.data.length == 0) {
              reject({
                errno: 0,
                text: '已经是最新的了!'
              });
            }
            this.recommendArticles = result.data.concat(this.recommendArticles);
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
        })
      },
      refresh() {
        this.$refs.refresh.classList.add('refreshing');
      },
      isFavorite(index) {
        const favoriteArticle = this.userInfo.favoriteArticle,
          articleID = this.recommendArticles[index].articleID;
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
      toggleFavor(index) {
        if (!this.userInfo.userID) {
          this.$emit('askLogin');
          return;
        }
        const articleID = this.recommendArticles[index].articleID,
          isFavorite = !this.isFavorite(index);
        if (!this.favorLock) {
          this.favorLock = true;
          this.$store.dispatch('user/toggleArticleFavor', {
            articleID,
            isFavorite
          }).then(result => {
            this.updateSpecifiedArticle(index);
            setTimeout(() => {
              this.favorLock = false;
            }, 300);
          }).catch(err => {
            console.log(err);
          });
        }
      },
      //update the specified article form server
      updateSpecifiedArticle(index) {
        const articleID = this.recommendArticles[index].articleID;
        this.$axios({
          method: 'get',
          url: '/getSpecifiedArticle',
          params: {
            articleID
          }
        }).then(result => {
          if (result.data) {
            this.recommendArticles.splice(index, 1, result.data[0]);
          }
        })
      }
    }
  }
</script>

<style lang="less" scoped>
  .hot-recommend {
    width: 100%;
    background-color: #FFFFFF;
    margin: 1vw 0 3vw;
    box-shadow: 0 1px 5px #CCCCCC;
    .header {
      width: 100%;
      display: flex;
      justify-content: space-between;
      color: #0080BB;
      padding: 2vw 3vw;
      box-sizing: border-box;
      font-size: 4.5vw;
      >div:first-of-type {
        span {
          margin-right: 2vw;
        }
      }
      >div:last-of-type {
        color: #777777;
        span {
          margin-left: 5vw;
          transition: transform 3s;
          &.refreshing {
            color: #0080BB;
            transform: rotate(360deg);
          }
        }
      }
    }
    .content {
      li {
        padding: 5vw 0;
        padding: 3vw;
        box-sizing: border-box;
        box-shadow: 0 0px 1px rgba(0, 0, 0, 0.1);
        h4 {
          font-weight: normal;
          font-size: 4vw;
        }
        .isFavorite {
          color: #6cbd45;
          i.fa {
            animation: articleFavorite 1s forwards;
          }
        }
        >div {
          display: flex;
          justify-content: flex-start;
          color: #777777;
          align-content: center;
          margin: 3vw 0;
          font-size: 3.5vw;
          >div {
            margin-right: 5vw;
            i {
              margin-right: 1vw;
            }
          }
        }
      }
    }
  }

  @keyframes articleFavorite {
    0% {
      transform: translateY(0) rotateY(0);
    }
    50% {
      transform: translateY(-3vw) rotateY(180deg);
    }
    100% {
      transform: translateY(0) rotateY(180deg);
    }
  }
</style>