<template>
  <li  class="article">
    <div class="article-meta">
      <router-link :to="'/userInfo/'+articleInfo.userID" tag="div">
        <div class="avatar">
          <img :src="articleInfo.avatar" alt="" v-if="articleInfo.avatar">
          <i class="fa fa-user-circle-o" v-else></i>
        </div>
        <span class="article-author">
          {{articleInfo.author}}
        </span>
      </router-link>
      <div>
        <router-link :to="'/articleSubject/'+articleInfo.subject" class="article-subject" tag="span">{{articleInfo.subject}}</router-link>
      </div>
    </div>
    <router-link :to="'/articleInfo/'+articleInfo.articleID" class="article-content" tag="div">
      <div class="article-info">
        <div class="article-title">
          <h4>{{articleInfo.title}}</h4>
        </div>
        <div class="article-abstrict">
          {{articleInfo.content | abstractContent}}
        </div>
      </div>
      <div class="article-image" v-if="articleInfo.cover">
        <img :src="articleInfo.cover">
      </div>
    </router-link>
    <div class="article-action">
      <p class="favor" :class="{isFavorite}" @click="toggleFavor">
        <i class="fa fa-heart"></i>
        <span>{{articleInfo.favors||'点赞'}}</span>
      </p>
      <p class="comment">
        <i class="fa fa-comment"></i>
        <span>{{articleInfo.comment||'评论'}}</span>
      </p>
    </div>
  </li>
</template>

<script>
  import { mapState } from "vuex";
  export default {
    name: 'articleBrief',
    props: {
      articleInfo: {
        type: Object,
        default: () => {}
      }
    },
    data() {
      return {
        favorLock: false,
      }
    },
    computed: {
      ...mapState('user', ['userInfo']),
      isFavorite() {
        const favoriteArticle = this.userInfo.favoriteArticle,
          articleID = this.articleInfo.articleID;
        //check whether user has logined and show the corresponding style of favor button 
        if (favoriteArticle) {
          for (let i = 0; i < favoriteArticle.length; i++) {
            if (articleID == favoriteArticle[i].articleID) {
              return true;
            }
          }
        }
        return false;
      }
    },
    methods: {
      toggleFavor() {
        if (!this.userInfo.userID) {
          this.$emit('askLogin');
          return;
        }
        const articleID = this.articleInfo.articleID,
          isFavorite = !this.isFavorite;
        if (!this.favorLock) {
          this.favorLock = true;
          this.$store.dispatch('user/toggleArticleFavor', {
            articleID,
            isFavorite
          }).then(result => {
            this.$emit('updateCurrentArticle');
            this.favorLock = false;
          }).catch(err => {
            console.log(err);
          });
        }
      }
    },
    filters: {
      abstractContent(content) {
        return content.replace(/<\/?[^>]+>/g, '').slice(0, 100);;
      }
    }
  };
</script>


<style lang="less" scoped>
  .article {
    width: 100%;
    padding: 3vw;
    box-sizing: border-box;
    .article-meta {
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-size: 3.8vw;
      div.avatar {
        width: 8vw;
        height: 8vw;
        border-radius: 50%;
        overflow: hidden;
        margin-right: 2vw;
        img {
          width: 100%;
          height: 100%;
        }
      }
      i.fa {
        font-size: 8vw;
        color: #666666;
      }
      >div {
        display: flex;
        align-items: center;
      }
    }
    .article-content {
      display: flex;
      justify-content: space-between;
      .article-title {
        margin: 3vw 0 1vw;
        h4 {
          // white-space: nowrap;
          // text-overflow: ellipsis;
          // overflow: hidden;
          display: -webkit-box;
          -webkit-box-orient: vertical;
          -webkit-line-clamp: 2;
          overflow: hidden;
          font-size: 4vw;
        }
      }
      .article-abstrict {
        margin-bottom: 2vw;
        display: -webkit-box;
        -webkit-box-orient: vertical;
        -webkit-line-clamp: 3;
        overflow: hidden;
        font-size: 3.5vw;
      }
      .article-info {
        flex-grow: 1;
        word-break: break-all;
      }
      .article-image {
        max-width: 30%;
        min-width: 30%;
        width: 30%;
        margin-left: 4vw;
        img {
          width: 100%;
          position: relative;
          top: 50%;
          transform: translateY(-50%);
        }
      }
    }
    .article-action {
      display: flex;
      align-items: center;
      color: #777777;
      font-size: 3.8vw;
      >p {
        display: flex;
        align-items: center;
        margin-right: 5vw;
        i {
          margin-right: 2vw;
        }
      }
      .favor.isFavorite {
        color: #6cbd45;
      }
    }
  }
</style>