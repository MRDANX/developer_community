<template>
  <div class="user-detail">
    <div class="detail-header">
      <i class="fa fa-arrow-left" @click="$router.go(-1)"></i>
      <span>用户信息</span>
    </div>
    <ul class="user-info-wrapper" ontouchstart>
      <li class="user-info margin-top" ref="userInfo">
        <div>
          <div class="avatar">
            <img :src="userInfo.avatar" />
            <!-- <i class="fa fa-user-circle-o" v-else></i> -->
          </div>
          <div class="user-name">
            <span>{{userInfo.userName}}</span>
            <span class="job-company">{{userInfo.job}} @ {{userInfo.company}}</span>
          </div>
        </div>
        <div class="follower-edit">
          <div>
            <p>{{userInfo.followeeNum}}</p>
            <p>关注</p>
          </div>
          <div>
            <p>{{userInfo.followerNum||0}}</p>
            <p>关注者</p>
          </div>
          <div class="follow-button"><i class="fa fa-plus"></i>关注</div>
        </div>
      </li>
      <li class="margin-top">所有动态</li>
      <li class="margin-top">用户动态
        <span>{{userInfo.trendNum}}</span>
      </li>
      <li>原创文章
        <span>{{userInfo.originalArticleNum}}</span>
      </li>
      <li>收藏集
        <span>{{userInfo.collectionNum}}</span>
      </li>
      <li class="margin-top">喜欢的文章
        <span>{{userInfo.favoriteArticleNum}}</span>
      </li>
      <li>关注的标签
        <span>{{userInfo.tagNum||0}}</span>
      </li>
    </ul>
  </div>

</template>

<script>
  export default {
    name: 'userDetail',
    props: ['userID'],
    data() {
      return {
        userInfo: {
        }
      }
    },
    created() {
      this.$axios({
        method: 'get',
        url: '/getUserDetail',
        params: {
          userID: this.userID
        }
      }).then(result => {
        this.userInfo = result.data;
      })
    }
  }

</script>

<style lang="less" scoped>
  .user-detail {
    width: 100vw;
    height: 100vh;
    background-color: #F1F1F1;
    font-size: 4vw;
    .detail-header {
      width: 100%;
      height: 10vw;
      background-color: #0080FF;
      display: flex;
      align-items: center;
      justify-content: space-between;
      font-size: 5vw;
      padding: 0 3vw;
      box-sizing: border-box;
      color: #FFFFFF;
      i.fa {
        font-size: 6vw;
      }
      span {
        flex-grow: 1;
        margin-left: 5vw;
      }
    }
    .user-info-wrapper {
      width: 100vw;
      height: 93vh;
      overflow: hidden;
      .margin-top {
        margin-top: 3vw;
      }
      li {
        background-color: #FFFFFF;
      }
      li:not(:first-of-type) {
        height: 12vw;
        box-shadow: 0 0 1px #DDDDDD;
        padding: 0 5vw;
        line-height: 12vw;
        font-size: 5vw;
        &:active {
          background-color: #CCCCCC;
        }
        >span {
          float: right;
        }
      }
      .user-info {
        padding: 3vw;
        i.fa-user-circle-o {
          font-size: 15vw;
          color: #777777;
          text-align: center;
          line-height: 20vw;
        }
        >div {
          width: 100%;
          font-size: 6vw;
          display: flex;
          justify-content: space-between;
          align-items: center;
          div.avatar {
            width: 20vw;
            height: 20vw;
            overflow: hidden;
            border-radius: 50%;
            img {
              // width: 100%;
              height: 100%;
            }
          }
          div.user-name {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            text-indent: 5vw;
            span {
              margin-top: 0.5vw;
            }
            span.job-company {
              font-size: 4vw;
            }
          }
        }
        div.follower-edit {
          margin-top: 3vw;
          font-size: 5vw;
          text-align: center;
          .follow-button {
            border: 1px solid #0080FF;
            padding: 1vw 2vw;
            color: #0080FF;
            border-radius: 5px;
            user-select: none;
            i.fa{
              margin-right: 2vw;
            }
            &:active {
              color: #FFFFFF;
              background-color: #0080FF;
            }
          }
        }
      }
    }
  }

</style>
