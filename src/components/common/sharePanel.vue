<template>
  <div class="share-content" ontouchstart>
    <div class="share-icon-wrapper">
      <div class="share-icon">
        <img src="/static/images/shareIcon/moments.svg">
        <span>微信朋友圈</span>
      </div>
      <div class="share-icon">
        <img src="/static/images/shareIcon/wechat.svg">
        <span>微信</span>
      </div>
      <div class="share-icon">
        <img src="/static/images/shareIcon/sina.svg">
        <span>微博</span>
      </div>
      <div class="share-icon">
        <img src="/static/images/shareIcon/qq.svg">
        <span>QQ好友</span>
      </div>
      <div class="share-icon">
        <img src="/static/images/shareIcon/zone.svg">
        <span>QQ空间</span>
      </div>
    </div>
    <div class="share-icon-wrapper">
      <div class="share-icon">
        <img src="/static/images/shareIcon/copyLink.svg">
        <span>复制链接</span>
      </div>
      <div class="share-icon">
        <img src="/static/images/shareIcon/browser.svg">
        <span>浏览器打开</span>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'sharePanel'
  }

</script>

<style lang="less" scoped>
  .share-content {
    width: 100vw;
    min-height: 25vw;
    box-sizing: border-box;
    background-color: #fff;
    overflow: hidden;
    border-top-right-radius: 1vw;
    border-top-left-radius: 1vw;
    .share-icon-wrapper {
      display: flex;
      padding: 3vw;
      box-sizing: border-box;
      border-bottom: 1px solid #DFDFDF;
      .share-icon {
        width: 15vw;
        font-size: 3vw;
        font-weight: bold;
        text-align: center;
        margin: 0 1.9vw;
        img {
          width: 90%;
          &:active {
            transition: all .1s;
            transform: scale(0.9);
          }
        }
      }
    }

  }

</style>
