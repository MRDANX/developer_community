<template>
  <ul class="user-info-wrapper" ontouchstart>
    <li class="user-info margin-top" ref="userInfo" @click="showSlideOut=true">
      <div>
        <div class="avatar">
          <img :src="userInfo.avatar"/>
          <!-- <i class="fa fa-user-circle-o" v-else></i> -->
        </div>
        <div class="user-name">
          <span>{{userInfo.userName||'登录/注册'}}</span>
          <span class="job-company">{{userInfo.job||'添加职位'}} @ {{userInfo.company||'添加公司'}}</span>
        </div>
      </div>
      <div class="follower-edit">
        <div>
          <p>{{userInfo.followee&&userInfo.followee.length||0}}</p>
          <p>关注</p>
        </div>
        <div>
          <p>{{userInfo.follower&&userInfo.follower.length||0}}</p>
          <p>关注者</p>
        </div>
        <div class="edit-button" @click="showPersonalSetting=true">编辑
        </div>
      </div>
      <slide-out id="personalSetting" title="个人设置" v-model="showPersonalSetting">
        <personal-setting></personal-setting>
      </slide-out>
    </li>
    <li class="margin-top">动态</li>
    <li class="margin-top">沸点
      <span>{{userInfo.trend&&userInfo.trend.length||0}}</span>
    </li>
    <li>原创文章
      <span>{{userInfo.originalArticle&&userInfo.originalArticle.length||0}}</span>
    </li>
    <li>收藏集
      <span>{{userInfo.collection&&userInfo.collection.length||0}}</span>
    </li>
    <li class="margin-top">喜欢的文章
      <span>{{userInfo.favoriteArticle&&userInfo.favoriteArticle.length||0}}</span>
    </li>
    <li>关注的标签
      <span>{{userInfo.tag&&userInfo.tag.length||0}}</span>
    </li>
  </ul>
</template>

<script>
  import {
    mapState
  } from "vuex";
  import slideOut from "@/components/common/slideOut";
  import personalSetting from "@/components/settingPage/personalSetting";
  export default {
    name: 'userInfo',
    data() {
      return {
        showPersonalSetting: false
      }
    },
    computed: {
      ...mapState('user', ['userInfo'])
    },
    components: {
      slideOut,
      personalSetting
    }
  }
</script>

<style lang="less" scoped>
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
        .edit-button {
          border: 1px solid #0080FF;
          padding: 1vw;
          color: #0080FF;
          border-radius: 5px;
          user-select: none;
          &:active {
            color: #FFFFFF;
            background-color: #0080FF;
          }
        }
      }
    }
  }
</style>