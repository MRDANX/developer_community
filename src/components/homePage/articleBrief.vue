<template>
  <router-link to="" tag="li" class="article">
    <div class="article-meta">
      <router-link to="" tag="div">
        <i class="fa fa-user-circle-o"></i>
        <span class="article-author">
          {{articleInfo.author}}
        </span>
      </router-link>
      <div>
        <router-link to="" class="article-subject" tag="span">{{articleInfo.subject}}</router-link>
      </div>
    </div>
    <router-link to="" class="article-content" tag="div">
      <div class="article-title">
        <h4>{{articleInfo.title}}</h4>
      </div>
      <div class="article-abstrict">
        {{articleInfo.content | abstractContent}}
      </div>
    </router-link>
    <div class="article-action">
      <router-link to="" tag="p">
        <i class="fa fa-heart"></i>
        <span>{{articleInfo.favors}}</span>
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
      i.fa {
        font-size: 6vw;
        margin-right: 2vw;
        color: #666666;
      }
      >div {
        display: flex;
        align-items: center;
      }
    }
    .article-content {
      .article-title {
        margin: 3vw 0 1vw;
        h4 {
          white-space: nowrap;
          text-overflow: ellipsis;
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
