<template>
  <router-link :to="{name:'articleDetail',params:{articleID:article.ID}}" tag="li" class="article">
    <h3 class="article-title">{{article.title}}</h3>
    <div class="article-info">
      <span>时间：{{article.date}}</span>
      <span>作者：{{article.author}}</span>
      <span>分类：{{article.category}}</span>
      <span>热度：{{article.favors|favorsWithSymbol}}</span>
    </div>
    <div class="article-content"> {{article.content|contentBrief}} </div>
    <div class="article-operation">
      <span>阅读全文</span>
      <span>评论</span>
    </div>
  </router-link>
</template>

<script>
export default {
  props: {
    article: Object
  },
  data() {
    return {};
  },
  filters: {
    favorsWithSymbol(value) {
      return value + " ℃";
    },
    contentBrief(content) {
      return content.replace(/(<\/?[^>]+>)|&nbsp;/g, "").slice(0, 200) + "...";
    }
  }
};
</script>


<style lang="less">
.article {
  width: 100%;
  height: 200px;
  box-sizing: border-box;
  padding-left: 3em;
  background-color: #16a951;
  cursor: pointer;
  overflow: hidden;
  box-shadow: inset 0 -3px 10px #44cef6;
  h3 {
    text-indent: 2em;
    margin-top: 1.5em;
    margin-bottom: 1em;
  }
}
</style>
