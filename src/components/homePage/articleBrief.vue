<template>
  <li class="article">
    <div class="article-meta">
      <router-link :to="{name:'userDetail',params:{userID:articleInfo.userID}}" tag="div">
        <div class="avatar">
          <img :src="articleInfo.avatar" alt="" v-if="articleInfo.avatar">
          <i class="fa fa-user-circle-o" v-else></i>
        </div>
        <span class="article-author">
          {{articleInfo.author}}
        </span>
      </router-link>
      <div>
        <router-link :to="{path:'/subjectDetail',query:{subject:articleInfo.subject}}" class="article-subject" tag="span">{{articleInfo.subject}}</router-link>
      </div>
    </div>
    <router-link :to="{name:'articleDetail',params:{articleID:articleInfo.articleID}}" class="article-content" tag="div">
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
    <div class="article-action" v-if="showAction">
      <p class="favor" :class="{isFavorite}" @click="toggleFavor">
        <i class="fa fa-heart"></i>
        <span>{{articleInfo.favors||'点赞'}}</span>
      </p>
      <p class="comment">
        <i class="fa fa-comment"></i>
        <span>{{articleInfo.commentNum||'评论'}}</span>
      </p>
    </div>
    <div class="edit-action" v-else>
      <div class="action">
        <img src="/static/images/common/edit.svg" alt="" @click="goEdit">
      </div>
      <div class="action">
        <div class="delete" :class="{'delete-confirm':showDeleteConfirm}">
          <img src="/static/images/common/cancel.svg" alt="" @click="showDeleteConfirm=false">
          <img src="/static/images/common/confirm.svg" alt="" @click="confirmDelete">
        </div>
        <img src="/static/images/common/delete-red.svg" alt="" @click="showDeleteConfirm=!showDeleteConfirm">
      </div>
    </div>
  </li>
</template>

<script>
  import {
    mapState
  } from "vuex";
  export default {
    name: 'articleBrief',
    props: {
      articleInfo: {
        type: Object,
        default: () => {}
      },
      showAction: {
        type: Boolean,
        default: true
      }
    },
    data() {
      return {
        favorLock: false,
        showDeleteConfirm: false
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
            setTimeout(() => {
              this.favorLock = false;
            }, 300);
          }).catch(err => {
            console.log(err);
          });
        }
      },
      confirmDelete() {
        this.showDeleteConfirm = false;
        this.$emit('deleteArticle');
      },
      goEdit(){
        this.$router.push({path:'/createArticle',query:{edit:true}})
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
        i.fa {
          animation: articleFavorite 1s forwards;
        }
        color: #0080FF;
      }
    }
    .edit-action {
      display: flex;
      align-items: center;
      justify-content: flex-end;
      margin-top: 1.5vw;
      padding: 2vw 0 0;
      box-sizing: border-box;
      height: 10vw;
      border-top: 1px dashed #CCCCCC;
      .action {
        height: 100%;
        position: relative;
        margin-right: 5vw;
        .delete {
          width: 200%;
          height: 80%;
          position: absolute;
          top: -90%;
          left: -50%;
          display: flex;
          justify-content: space-between;
          transition: all .5s;
          transform-origin: 50% 180%;
          transform: rotate(180deg) scale(0);
          &.delete-confirm {
            transform: rotate(0deg) scale(1);
          }
          img {
            height: 100%;
            margin: 0;
          }
        }
        img {
          height: 100%;
          &:active {
            transform: scale(0.85);
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
