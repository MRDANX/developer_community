<template>
  <router-link to="" tag="li" class="article">
    <div class="article-meta">
      <router-link to="" tag="div">
        <div class="avatar">
          <img :src="articleInfo.avatar" alt="" v-if="articleInfo.avatar">
          <i class="fa fa-user-circle-o" v-else></i>
        </div>
        <span class="article-author">
          {{articleInfo.author}}
        </span>
      </router-link>
      <div>
        <router-link to="" class="article-subject" tag="span">{{articleInfo.subject}}</router-link>
      </div>
    </div>
    <router-link to="" class="article-content" tag="div">
      <div class="article-info">
        <div class="article-title">
          <h4>{{articleInfo.title}}</h4>
        </div>
        <div class="article-abstrict">
          {{articleInfo.content | abstractContent}}
        </div>
      </div>
      <div class="article-image" v-if="articleInfo.image">
        <img :src="articleInfo.image" alt="">
      </div>
    </router-link>
    <div class="article-action">
      <router-link to="" tag="p">
        <i class="fa fa-heart"></i>
        <span>{{articleInfo.favors||'点赞'}}</span>
      </router-link>
      <router-link to="" tag="p">
        <i class="fa fa-comment"></i>
        <span>{{articleInfo.comment||'评论'}}</span>
      </router-link>
    </div>
  </router-link>
</template>

<script>
  export default {
    name: 'articleBrief',
    props: {
      articleInfo: {
        type: Object,
        default: () => {}
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
    }
  }
</style>