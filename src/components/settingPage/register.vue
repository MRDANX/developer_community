<template>
  <div class="register-panel">
    <div class="user-avatar">
      <img :src="avatar" alt="">
      <!-- a file input covering on img for uploading user's avatar -->
      <input type="file" accept="image/jpeg,image/jpg,image/png" @change="avatarUpload($event.target)">
    </div>
    <div class="input-area">
      <text-input v-model="phone" hint="手机号" 
                  @blur="chekcUserInfoDuplicate('phone')" 
                  :emphasizedHint="checkPhoneText"
                  @clearInputText="checkPhoneText=''"/>
      <text-input v-model="email" hint="邮箱"  
                  @blur="chekcUserInfoDuplicate('email')"
                  :emphasizedHint="checkEmailText"
                  @clearInputText="checkEmailText=''"/>
      <text-input v-model="userName" hint="用户名"  
                  @blur="chekcUserInfoDuplicate('userName')"
                  :emphasizedHint="checkUserNameText"
                  @clearInputText="checkUserNameText=''"/>
      <text-input v-model="password" hint="密　码" 
                  inputType="password" />
      <text-input v-model="confirmPassword"  hint="确认密码" 
                  inputType="password" :emphasizedHint="checkPasswordText"/>
      <button class="register-button" 
              @click="requestRegister" 
              ref="registerButton">注册</button>
    </div>
    <hint v-model="hintText" :verticalMove="-14"/>
    <loading v-if="showLoading" color="#FFFFFF" :verticalMove="-14"/>
  </div>
</template>

<script>
  import textInput from "@/components/common/textInput";
  import hint from "@/components/common/hint";
  import loading from "@/components/common/loading";
  export default {
    name: 'register',
    data() {
      return {
        avatar: '/static/images/avatar/default-avatar.png',
        phone: '',
        email: '',
        userName: '',
        password: '',
        confirmPassword: '',
        phoneReg: /^((13[0-9])|(14[5|7])|(15([0-3]|[5-9]))|(18[0,5-9]))\d{8}$/,
        emailReg: /^(\w)+(\.\w+)*@(\w)+((\.\w+)+)$/,
        checkPhoneText: '',
        checkEmailText: '',
        checkUserNameText: '',
        checkPasswordText: '',
        allowPhone: false,
        allowEmail: false,
        allowUserName: false,
        allowPassword: false,
        hintText: '',
        showLoading: false
      }
    },
    computed: {
      allowRegister() {
        return this.allowPhone && this.allowEmail && this.allowUserName & this.allowPassword;
      }
    },
    methods: {
      avatarUpload(target) {
        //read image uploaded locally and display it as avatar in real time
        let limitSize = 1 * 1024 * 1024,
          tmpAvatar = target.files[0],
          fr = new FileReader();
        if (tmpAvatar) {
          if (tmpAvatar.size >= limitSize) {
            this.hintText = '图片大小不能超过1MB,请重新选择!';
            return;
          }
          fr.readAsDataURL(tmpAvatar);
          fr.onload = () => {
            this.avatar = fr.result;
          }
        }
      },
      requestRegister() {
        let avatar = this.avatar,
          phone = this.phone,
          email = this.email,
          userName = this.userName,
          password = this.password,
          qs = require('qs');
        //remind user and return if the format of phone number or email is wrong 
        if (!this.phoneReg.test(phone) || !this.emailReg.test(email)) {
          this.hintText = '手机号或邮箱格式有误,请重新核对后再输入!';
          return;
        }
        //post a request to register user's information
        if (this.allowRegister) {
          this.showLoading = true;
          this.$axios({
            method: 'post',
            url: '/requestRegister',
            data: qs.stringify({
              avatar,
              phone,
              email,
              userName,
              password
            })
          }).then(result => {
            setTimeout(() => {
              this.showLoading = false;
              this.hintText = result.data.text;
            }, 1000);
            setTimeout(() => {
              this.$emit('input', false);
            }, 1500);
          });
        } else {
          this.hintText = '用户信息有误，请重新确认!'
        }
      },
      checkPassword() {
        if (this.confirmPassword == '') {
          this.checkPasswordText = '';
          return;
        }
        if (this.password != this.confirmPassword) {
          this.checkPasswordText = '两次输入密码不一致';
          this.allowPassword = false;
        } else if (this.password == this.confirmPassword) {
          this.checkPasswordText = '';
          this.allowPassword = true;
        }
      },
      chekcUserInfoDuplicate(type) {
        let field;
        switch (type) {
          case 'phone':
            if (this.checkPhoneText.indexOf('有误') != -1 || this.phone == '') return;
            field = this.phone;
            break;
          case 'email':
            if (this.checkEmailText.indexOf('有误') != -1 || this.email == '') return;
            field = this.email;
            break;
          case 'userName':
            if (this.checkUserNameText.indexOf('有误') != -1 || this.userName == '') return;
            field = this.userName;
            break;
          default:
            break;
        }
        this.$axios({
          method: 'get',
          url: '/checkUserInfoDuplicate',
          params: {
            type,
            field
          }
        }).then(result => {
          let data = result.data;
          switch (type) {
            case 'phone':
              this.checkPhoneText = data.text;
              if (data.err) {
                this.allowPhone = false;
              } else {
                this.allowPhone = true;
              }
              break;
            case 'email':
              this.checkEmailText = data.text;
              if (data.err) {
                this.allowEmail = false;
              } else {
                this.allowEmail = true;
              }
              break;
            case 'userName':
              this.checkUserNameText = data.text;
              if (data.err) {
                this.allowUserName = false;
              } else {
                this.allowUserName = true;
              }
              break;
            default:
              console.log('something went wrong at chekcUserInfoDuplicate 1');
              break;
          }
        })
      }
    },
    watch: {
      phone() {
        if (this.phone == '') {
          this.checkPhoneText = '';
          return;
        }
        /**
         * validate phone number
         * 
         * number segment of China Mobile: 139、138、137、136、135、134、150、151、152、157、158、159、182、183、187、188、147
         * number segment of China Union: 130、131、132、185、186、145
         * number segment of China Telecom: 133、153、180、189
         * 
         */
        if (!this.phoneReg.test(this.phone)) {
          this.checkPhoneText = '手机号格式有误';
        } else {
          this.checkPhoneText = '';
        }
      },
      email() {
        if (this.email == '') {
          this.checkEmailText = '';
          return;
        }
        if (!this.emailReg.test(this.email)) {
          this.checkEmailText = '邮箱格式有误';
        } else {
          this.checkEmailText = '';
        }
      },
      password() {
        this.checkPassword();
      },
      confirmPassword() {
        this.checkPassword();
      }
    },
    mounted() {
      this.$activeFeedback(this.$refs.registerButton);
    },
    components: {
      hint,
      loading,
      textInput
    }
  }
</script>

<style lang="less" scoped>
  .register-panel {
    width: 100vw;
    height: 100vh;
    display: flex;
    flex-flow: column nowrap;
    align-items: center;
    justify-content: space-around;
    .user-avatar {
      position: relative;
      width: 40vw;
      height: 40vw;
      overflow: hidden;
      border-radius: 50%;
      img {
        // width: 100%;
        height: 100%;
      }
      input[type='file'] {
        position: absolute;
        top: -20%;
        left: 0;
        width: 100%;
        height: 120%;
        outline: none;
        background-color: transparent;
      }
    }
    .input-area {
      width: 70vw;
      /deep/ .text-input {
        &::after {
          background-color: #FFFFFF;
        }
        input,
        .input-hint {
          color: #F1F1F1;
        }
        span.fa-stack {
          color: #0080FF;
        }
        span.visibility {
          color: #FAFAFA;
        }
      }
      .login-button,
      .register-button {
        display: block;
        width: 90%;
        height: 8vw;
        outline: none;
        border: none;
        border-radius: ~'8%/50%';
        margin: 8vw auto;
        font-size: 5vw;
        background-color: #4c96fd;
        box-shadow: 0 0 5px #5790c8;
        color: #FFFFFF;
        transform: scale(1);
        &.active {
          transition: all .05s;
          transform: scale(0.9);
        }
      }
    }
  }
</style>