<template>
  <div class="personal-setting-wrapper">
    <ul class="personal-setting" ref="settingList" ontouchstart>
      <li>
        <span>头像</span>
        <div class="avatar">
          <img :src="userInfo.avatar" alt="" v-if="userInfo.avatar">
          <i class="fa fa-user-circle-o" v-else></i>
        </div>
      </li>
      <li>
        <span>用户名</span>
        <span @click="popup($event.target,'用户名')">{{userInfo.userName}}</span>
      </li>
      <li>
        <span>职位</span>
        <span :class="{deactive:!userInfo.job}" @click="popup($event.target,'职位')">{{userInfo.job||"添加职位"}}</span>
      </li>
      <li>
        <span>公司</span>
        <span :class="{deactive:!userInfo.company}" @click="popup($event.target,'公司')">{{userInfo.company||"添加公司"}}</span>
      </li>
      <li>
        <span>简介</span>
        <span :class="{deactive:!userInfo.introduce}" @click="popup($event.target,'简介')">{{userInfo.introduce||'这家伙很懒，啥都没写！'}}</span>
      </li>
      <li>
        <span>博客地址</span>
        <span :class="{deactive:!userInfo.blogAddr}" @click="popup($event.target,'博客地址')">{{userInfo.blogAddr||"例如:github.com"}}</span>
      </li>
    </ul>
    <div class="popup-mask" v-show="showPopup" @click="showPopup=false"></div>
    <transition name="scale">
      <div class="popup-content" v-show="showPopup">
        <h4>修改{{modifyType}}</h4>
        <input type="text" v-model="modifiedText" />
        <div class="button-group" ref="buttonGroup">
          <button @click="showPopup=false">取消</button>
          <button @click="confirmModify">确认</button>
        </div>
      </div>
    </transition>
    <hint v-model="hintText" :delay="2500">{{hintText}}</hint>
    <loading v-if="showLoading"/>
  </div>
</template>

<script>
  import {
    mapState
  } from "vuex";
  import hint from "@/components/common/hint";
  import loading from "@/components/common/loading";
  export default {
    name: 'personalSetting',
    data() {
      return {
        showPopup: false,
        showLoading: false,
        modifyType: '',
        oldText: '',
        modifiedText: '',
        hintText: ''
      }
    },
    mounted() {
      let butttons = this.$refs.buttonGroup.children;
      for (let i = 0; i < butttons.length; i++) {
        this.$activeFeedback(butttons[i]);
      }
      // let settingList=this.$refs.settingList.children;
      // for (let i = 0; i < settingList.length; i++) {
      //   settingList[i].addEventListener('click')
      // }
      // console.dir(settingList);

    },
    methods: {
      confirmModify() {
        let userID = this.userInfo.userID,
          modifyType = this.modifyType,
          modifiedText = this.modifiedText;
        if (modifiedText == this.oldText) {
          this.showPopup = false;
          return;
        }
        this.showLoading = true;
        this.$store.dispatch('user/modifyUserInfo', {
          userID,
          modifyType,
          modifiedText
        }).then(result => {
          if (result.status == 200 && result.data.errno == 1062) {
            this.hintText = result.data.text;
          } else if (result.status == 200 && !result.data.errno) {
            this.hintText = result.data.text
          }
          this.showLoading = false;
          this.showPopup = false;
        });
      },
      popup(target, modifyType) {
        let text = target.innerText,
          title = modifyType;
        this.modifyType = title;
        this.oldText = text;
        this.modifiedText = text;
        this.showPopup = true;
      }
    },
    computed: {
      ...mapState('user', ['userInfo'])
    },
    components: {
      hint,
      loading
    }
  }
</script>

<style lang="less" scoped>
  .scale-enter-active {
    transition: all .3s;
  }

  .scale-leave-active {
    transition: all .2s;
  }

  .scale-enter-to,
  .scale-leave {
    transform: scale(1);
  }

  .scale-enter,
  .scale-leave-to {
    transform: scale(0);
  }

  .personal-setting-wrapper {
    width: 100vw;
    height: 93vh;
    position: relative;
    .personal-setting {
      li {
        padding: 0 5vw;
        box-sizing: border-box;
        width: 100%;
        height: 10vh;
        display: flex;
        align-items: center;
        justify-content: space-between;
        background-color: #FFFFFF;
        box-shadow: 0 0 1px #CCCCCC;
        font-size: 5vw;
        &:active {
          background-color: #DDDDDD;
        }
        span {
          overflow: hidden;
          white-space: nowrap;
          text-overflow: ellipsis;
          max-width: 60vw;
          min-width: 20vw;
          min-height: 5vw;
        }
        span.deactive {
          color: #999999;
        }
        div.avatar {
          width: 16%;
          height: 80%;
          position: relative;
          img {
            height: 100%;
          }
          i.fa {
            font-size: 14vw;
            color: #666666;
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
          }
        }
      }
    }
    div.popup-mask {
      position: absolute;
      top: -7vh;
      left: 0;
      width: 100vw;
      height: 100vh;
      background-color: rgba(0, 0, 0, 0.8);
    }
    .popup-content {
      position: absolute;
      left: 0;
      right: 0;
      top: 0;
      bottom: 0;
      margin: auto;
      width: 90vw;
      height: 50vw;
      padding: 5vw;
      z-index: 999;
      box-sizing: border-box;
      background-color: #FFFFFF;
      box-shadow: 0 0 1vw #CCCCCC;
      display: flex;
      flex-flow: column wrap;
      justify-content: space-between;
      input {
        border: none;
        border-bottom: 1px solid #666666;
        outline: none;
        font-size: 5vw;
        text-indent: 1vw;
        padding: 1vw 0;
      }
      .button-group {
        display: flex;
        justify-content: flex-end;
        button {
          outline: none;
          border: none;
          background-color: #0080ff;
          box-shadow: 0 0 3px #0080ff;
          border-radius: 5px;
          color: #F6F6F6;
          width: 15vw;
          height: 8vw;
          margin-left: 5vw;
          &.active {
            transition: all 0.1s;
            transform: scale(0.9);
          }
        }
      }
    }
  }
</style>