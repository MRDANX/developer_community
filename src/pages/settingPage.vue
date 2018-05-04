<template>
  <div class="setting-page">
    <div class="nav">
      <h2>我</h2>
    </div>
    <scroll>
      <ul class="content">
        <li class="user-info" ref="userInfo">
          <div v-if="loggedIn"></div>
          <div v-else>
            <i class="fa fa-user-circle-o avatar"></i>
            <div>
              <span>登录/注册</span>
              <span class="job-company">添加职位 @ 添加公司</span>
            </div>
            <i class="fa fa-angle-right arrow-right"></i>
          </div>
        </li>
        <li class="user-action">
          <ul>
            <li v-for="(action,index) in actions" :key="index" ref="actions">
              <i class="fa" :class="action.icon" :style="{color:action.color}"></i>
              <span class="text">{{action.text}}</span>
              <span v-if="action.number">{{action.number}}</span>
            </li>
          </ul>
        </li>
        <li class="others">
          <ul>
            <li ref="feedback">
              <i class="fa fa-telegram"></i>
              <span>意见反馈</span>
            </li>
            <li ref="setting">
              <i class="fa fa-cog"></i>
              <span>设置</span>
            </li>
          </ul>
        </li>
      </ul>
    </scroll>
  </div>
</template>

<script>
  import scroll from "@/components/scroll";
  export default {
    name: 'settingPage',
    data() {
      return {
        loggedIn: false,
        actions: [{
            icon: 'fa-bell',
            text: '消息中心',
            color: '#0076FE'
          },
          {
            icon: 'fa-heart',
            text: '我喜欢的',
            number: '0 篇',
            color: '#6CBD45'
          },
          {
            icon: 'fa-list',
            text: '收藏集',
            number: '0 个',
            color: '#FF9900'
          },
          {
            icon: 'fa-eye',
            text: '阅读过的文章',
            number: '0 篇',
            color: '#CC3333'
          },
          {
            icon: 'fa-thumbs-up',
            text: '赞过的动态',
            number: '0 个',
            color: '#0099FF'
          },
          {
            icon: 'fa-tags',
            text: '标签管理',
            number: '0 个',
            color: '#ffbd4c'
          }
        ]
      }
    },
    mounted() {
      this.activeFeedback(this.$refs.userInfo);
      this.$refs.actions.forEach(action => {
        this.activeFeedback(action);
      });
      this.activeFeedback(this.$refs.feedback);
      this.activeFeedback(this.$refs.setting);
    },
    methods: {
      activeFeedback(el) {
        el.addEventListener('touchstart', function () {
          this.classList.add('active');
        });
        el.addEventListener('touchend', function () {
          this.classList.remove('active');
        });
      }
    },
    components: {
      scroll
    }
  }

</script>

<style lang="less" scoped>
  div.setting-page {
    width: 100vw;
    position: relative;
    color: #333333;
    div.nav {
      width: 100%;
      background-color: #0080FF;
      height: 11vw;
      text-align: center;
      color: #FFFFFF;
      line-height: 11vw;
      font-size: 4vw;
    }
    ul.content {
      >li {
        background-color: #FFFFFF;
        margin: 3vw 0;
        &.active {
          background-color: rgba(0, 0, 0, 0.1);
        }
      }
      .user-info {
        padding: 3vw;
        i.avatar {
          font-size: 15vw;
          color: #777777;
          margin-right: 5vw;
        }
        i.arrow-right {
          font-size: 10vw;
          color: #CCCCCC;
        }
        >div {
          width: 100%;
          font-size: 6vw;
          display: flex;
          justify-content: space-between;
          align-items: center;
          div {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            span {
              margin-top: 0.5vw;
            }
            span.job-company {
              font-size: 4vw;
            }
          }
        }
      }
      .user-action,
      .others {
        li {
          padding: 2vh 3vw;
          box-sizing: border-box;
          box-shadow: 0 0 0.5vw #EEEEEE;
          display: flex;
          align-items: center;
          &.active {
            background-color: rgba(0, 0, 0, 0.1);
          }
          i {
            font-size: 6vw;
            width: 6vw;
            margin-right: 5vw;
          }
          span {
            font-size: 4.5vw;
          }
          span.text {
            flex-grow: 1;
          }

        }
      }
      .others {
        li {
          i.fa-telegram {
            color: #99CC33;
          }
          i.fa-cog {
            color: #66CC99;
          }
        }
      }
    }
  }

</style>
