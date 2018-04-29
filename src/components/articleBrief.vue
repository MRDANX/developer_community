<template>
  <router-link to="" tag="li" class="article">
    <div class="article-meta">
      <div>
        <i class="fa fa-user-circle-o"></i>
        <router-link to="" class="user-name" tag="span">user-name-{{id}}</router-link>
      </div>
      <div>
        <router-link to="" class="article-subject" tag="span">article-subject</router-link>
      </div>
    </div>
    <router-link to="" class="article-content" tag="div">
      <div class="article-title">
        <h3>浏览器的滚动条</h3>
      </div>
      <div class="article-abstrict">
      浏览器的滚动条大家都会遇到，当页面内容的高度超过视口高度的时候，会出现纵向滚动条；当页面内容的宽度超过视口宽度的时候，会出现横向滚动条。也就是当我们的视口展示不下内容的时候，会通过滚动条的方式让用户滚动屏幕看到剩余的内容。
        </div>
    </router-link>
    <div class="article-action">
      <router-link to="" tag="p">
        <i class="fa fa-heart"></i>
        <span>12</span>
      </router-link>
      <router-link to="" tag="p">
        <i class="fa fa-comment"></i>
        <span>评论</span>
      </router-link>
    </div>
  </router-link>
</template>

<script>
  export default {
    name: 'articleBrief',
    props: {
      id: Number
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
      align-content: center;
      i.fa {
        font-size: 6vw;
        margin-right: 2vw;
      }
      >div {
        display: flex;
        align-items: center;
      }
    }
    .article-content {
      .article-title {
        margin: 3vw 0 1vw;
      }
      .article-abstrict {
        margin-bottom: 2vw;
      }
    }
    .article-action {
      display: flex;
      align-content: center;
      color: #777777;
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
