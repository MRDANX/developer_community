<template>
  <div class="article-comment">
    <div class="comment-info">
      <div class="avatar">
        <img :src="comment.avatar">
      </div>
      <div class="comment-meta">
        <p class="user-name">{{comment.userName}}</p>
        <p class="others">{{floor}}楼 • {{comment.date|dateFormat}}</p>
      </div>
      <div class="comment-action">
        <p class="add-comment" @click="$emit('replyAt',comment.userName)">
          <i class="fa fa-comments-o"></i>
        </p>
        <!-- <p class="favor">
          <i class="fa fa-thumbs-o-up"></i>{{comment.favors}}
        </p> -->
      </div>
    </div>
    <div class="comment-content">
      {{comment.content}}
    </div>
  </div>
</template>

<script>
  export default {
    name: 'articleComment',
    props: ['comment', 'floor'],
    filters: {
      dateFormat(dateStr) {
        const date = new Date(dateStr),
          year = date.getFullYear(),
          month = date.getMonth() + 1,
          day = date.getDate(),
          hour = date.getHours(),
          minute = date.getMinutes();
        return `${year}.${month}.${day} ${hour}:${minute}`;
      }
    }
  }

</script>

<style lang="less" scoped>
  .article-comment {
    width: 100%;
    border-top: 1px solid #E1E1E1;
    padding: 3vw 0;
    .comment-info {
      display: flex;
      justify-content: space-between;
      align-items: center;
      .avatar {
        height: 14vw;
        width: 14vw;
        border-radius: 50%;
        overflow: hidden;
        img {
          height: 100%;
        }
      }
      .comment-meta {
        flex-grow: 1;
        margin-left: 3vw;
        .user-name {
          font-weight: bold;
        }
        .others {
          margin-top: 1vw;
          font-size: 3.4vw;
          color: #666666;
        }
      }
      .comment-action {
        display: flex;
        justify-content: space-around;
        min-width: 26vw;
        font-size: 6vw;
        color: #666666;
      }
    }
    .comment-content {
      margin: 2vw 0;
      padding: 0 1vw;
      box-sizing: border-box;
    }
  }

</style>
