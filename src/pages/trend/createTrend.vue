<template>
  <div class="create-trend">
    <div class="top-nav">
      <div class="mask"></div>
      <div class="top-nav-content">
        <i class="fa fa-chevron-left" @click="$router.go(-1)"></i>
        <span class="nav-title">发动态</span>
        <span class="send-trend" @click="publishTrend" ref="send">
          <i class="fa fa-send"></i>发送</span>
      </div>
    </div>
    <div class="trend-content">
      <textarea v-model="content" class="content-text" placeholder="一起聊聊吧~" maxlength="200" />
      <div class="content-images">
        <transition-group name="fluent" tag="div" class="images-wrapper">
          <uploaded-image :src="src" v-for="(src,index) in images" :key="src" @deleteImage="images.splice(index,1)" class="uploaded-image"
          />
          <div class="upload-image" key="uploadImageButton" ref="uploadImageButton">
            <span class="plus">+</span>
            <input type="file" @change="uploadImage($event.target)" accept="image/jpeg,image/jpg,image/png" ref="fileUpload" />
          </div>
        </transition-group>
      </div>
    </div>
    <div class="bottom-nav">
      <div class="mask"></div>
      <div class="bottom-content">
        <i class="fa fa-photo" @click="$refs.fileUpload.click()"></i>
        <i class="fa"></i>
        <i class="fa fa-slack1"></i>
        <i class="fa fa-smile-o1"></i>
        <span class="length-left">剩余字数：{{contentLengthLeft}}</span>
      </div>
    </div>
    <hint v-model="hintText" />
    <loading v-if="showLoading" :verticalMove="5" color="#FFFFFF" />
  </div>
</template>

<script>
  import {
    mapState
  } from "vuex";
  import uploadedImage from '@/components/common/uploadedImage';
  export default {
    name: 'createTrend',
    data() {
      return {
        content: '',
        images: [],
        hintText: '',
        showLoading: false
      }
    },
    created() {
      if (!this.userInfo.userID) {
        this.$router.replace('/setting');
        return;
      }
      this.$store.dispatch('user/checkUserInfo');
    },
    mounted() {
      let uploadImageButton = this.$refs.uploadImageButton;
      if (uploadImageButton) {
        this.$activeFeedback(uploadImageButton);
      }
      this.$activeFeedback(this.$refs.send);
    },
    deactivated() {
      setTimeout(() => {
        this.resetInput();
      }, 500);
    },
    computed: {
      ...mapState('user', ['userInfo']),
      contentLengthLeft() {
        return 200 - this.content.length;
      }
    },
    methods: {
      uploadImage(target) {
        //read image uploaded locally and display it as cover in real time
        let limitSize = 1 * 1024 * 1024, //max-size 1MB
          tmpImage = target.files[0],
          fr = new FileReader();
        if (tmpImage) {
          if (tmpImage.size >= limitSize) {
            this.hintText = '图片大小不能超过1MB,请重新选择!';
            return;
          }
          this.showLoading = true;
          fr.readAsDataURL(tmpImage);
          fr.onload = () => {
            if (this.images.indexOf(fr.result) != -1) {
              this.hintText = '该图片已添加!';
              this.showLoading = false;
              return;
            }
            this.images.push(fr.result);
            this.showLoading = false;
          }
        }
      },
      publishTrend() {
        let qs = require('qs'),
          userID = this.userInfo.userID,
          content = this.content,
          images = JSON.stringify(this.images);
        if (!content) {
          this.hintText = '先写下你此刻的心情再发送吧!';
          return;
        }
        this.showLoading = true;
        let token = this.userInfo.token;
        this.$axios({
          method: 'post',
          url: '/api/createUserTrend',
          data: qs.stringify({
            token,
            userID,
            content,
            images,
            topic: ''
          })
        }).then(result => {
          this.showLoading = false;
          if (result.data.errno) {
            this.hintText = result.data.text;
            return;
          }
          this.hintText = '发送成功!';
          setTimeout(() => {
            this.$router.go(-1);
          }, 1500);
        })
      },
      resetInput() {
        this.content = '';
        this.images = [];
      }
    },
    watch: {
      content() {
        if (this.contentLengthLeft == 0) {
          this.hintText = '已达文本输入上限!';
        }
      }
    },
    components: {
      uploadedImage
    }
  }

</script>

<style lang="less" scoped>
  .fluent-enter-active {
    transition: all .8s !important;
  }

  .fluent-leave-active {
    transition: all .8s !important;
    position: absolute !important;
  }

  .fluent-enter,
  .fluent-leave-to {
    opacity: 0;
    transform: scale(0.2);
  }

  .fluent-move {
    transition: all .8s !important;
  }

  .create-trend {
    width: 100vw;
    min-height: 100vh;
    font-size: 5vw;
    background-image: url("/static/images/trendBg.jpg");
    background-size: cover;
    .top-nav {
      position: relative;
      width: 100vw;
      height: 10vw;
      .mask {
        position: absolute;
        top: 0;
        left: 0;
        width: 100vw;
        height: 100%;
        background-image: url("/static/images/trendBg.jpg");
        background-size: 100%;
        filter: blur(5px);
      }
      .top-nav-content {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        padding: 0 3vw;
        box-sizing: border-box;
        display: flex;
        justify-content: space-between;
        align-items: center;
        color: #FFFFFF;
        .nav-title {
          flex-grow: 0.8;
        }
        .send-trend.active {
          color: #009CFF;
        }
        .send-trend i.fa {
          margin-right: 2vw;
        }
      }
    }
    .trend-content {
      width: 100vw;
      font-size: 4vw;
      background-color: rgba(255, 255, 255, 0.2);
      padding-bottom: 0.5vw;
      .content-text {
        width: 100%;
        border: none;
        outline: none;
        min-height: 30vh;
        background-color: transparent;
        font-size: 5vw;
        padding: 3vw;
        box-sizing: border-box;
        color: #FFFFFF;
        &::-webkit-input-placeholder {
          color: #F1F1F1;
        }
      }
      .content-images {
        margin: 2vw 0;
        padding: 0 2vw;
        .upload-image {
          position: relative;
          display: inline-block;
          width: 20vw;
          height: 20vw;
          line-height: 17vw;
          box-sizing: border-box;
          text-align: center;
          border: 1px dashed #FFFFFF;
          font-size: 17vw;
          color: #FFFFFF;
          background-color: rgba(255, 255, 255, 0.2);
          overflow: hidden;
          margin: 1vw 2vw 0;
          border-radius: 2vw;
          transition: all .8s;
          user-select: none;
          .plus {
            user-select: none;
          }
          input[type=file] {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            opacity: 0;
            user-select: none;
          }
          &.active {
            transition: all .1s;
            background-color: rgba(255, 255, 255, 0.3);
          }
        }
      }
    }
    .bottom-nav {
      position: fixed;
      left: 0;
      bottom: 0;
      width: 100vw;
      height: 10vw;
      .mask {
        position: absolute;
        top: 0;
        left: 0;
        width: 100vw;
        height: 100%;
        background-image: url("/static/images/trendBg.jpg");
        background-size: 100%;
        background-position-y: 100%;
        filter: blur(5px);
      }
      .bottom-content {
        position: absolute;
        top: 0;
        left: 0;
        width: 100vw;
        height: 100%;
        padding: 0 5vw;
        box-sizing: border-box;
        display: flex;
        justify-content: space-between;
        align-items: center;
        color: rgba(255, 255, 255, 0.5);
        font-size: 4.2vw;
        i.fa {
          font-size: 6vw;
        }
      }
    }
  }

</style>
