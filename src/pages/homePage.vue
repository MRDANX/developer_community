<template>
  <div class="home-page">
    <!-- nav-bar for customized subjects -->
    <div class="nav">
      <subject-bar class="scroll-bar" :subjectList="customizedSubjectList" @changeCurrentArticleList="changeCurrentArticleList"
        ref="subjectBar" />
      <div class="custom-button" ref="customButton">
        <i class="fa fa-caret-down" @click="showCustomPanel=true"></i>
      </div>
    </div>
    <!-- scrollable content with slot injected -->
    <transition :name="changeArticleListAnimation">
      <keep-alive>
        <router-view :key="currentSubjectName" :nowScrollToTop="nowScrollToTop" />
      </keep-alive>
    </transition>
    <!-- hidden panel for customizing subject -->
    <slide-out slideToDirection="toRight" v-model="showCustomPanel" title="分 类 自 定 义" class="custom-panel" :showModal="true">
      <!-- list for customizing subjects exclude index 0(item home-page)-->
      <ul class="custom-list">
        <li v-for="(subject,index) in subjectList" :key="index" v-if="index!=0" class="custom-item">
          <i class="fa fa-list-ul"></i>
          <span>{{subject.text}}</span>
          <!-- custom switch box component -->
          <switch-box class="sbuject-chekbox" :isChecked="enabledSubjectsIndex.indexOf(index)!=-1" :index="index" @checkout="checkout"
          />
        </li>
      </ul>
    </slide-out>
  </div>
</template>

<script>
  import subjectBar from "@/components/homePage/subjectBar";
  import switchBox from "@/components/common/switchBox";
  import slideOut from "@/components/common/slideOut";
  export default {
    name: "homePage",
    data() {
      return {
        subjectList: [{
            text: "首页",
            to: "index"
          },
          {
            text: "前端",
            to: "frontend"
          },
          {
            text: "Android",
            to: "android"
          },
          {
            text: "人工智能",
            to: "AI"
          },
          {
            text: "iOS",
            to: "iOS"
          },
          {
            text: "产品",
            to: "product"
          },
          {
            text: "设计",
            to: "design"
          },
          {
            text: "工具资源",
            to: "tool"
          },
          {
            text: "阅读",
            to: "read"
          },
          {
            text: "后端",
            to: "backend"
          }
        ],
        enabledSubjectsIndex: [0, 1, 2, 4, 5, 8],
        showCustomPanel: false,
        currentArticleListIndex: 1,
        currentSubjectName: 'index',
        changeArticleListAnimation: 'slide-top',
        nowScrollToTop: false
      };
    },
    created() {
      let enabledSubjectsIndex = JSON.parse(localStorage.getItem('enabledSubjectsIndex'));
      if (enabledSubjectsIndex) {
        this.enabledSubjectsIndex = enabledSubjectsIndex;
      }

      //initialize currentArticleListIndex according to route's params
      let subjectName = this.$route.params.subject;
      this.currentSubjectName = subjectName;
      for (let i = 0; i < this.customizedSubjectList.length; i++) {
        const subject = this.customizedSubjectList[i];
        if (subject.to === subjectName) {
          this.currentArticleListIndex = i;
          return;
        }
      }

      // this.currentArticleListIndex = this.customizedSubjectList.findIndex(subject => {
      //   return subject.to === subjectName;
      // });
      //set the current subject name to the corresponding subject
    },
    mounted() {
      //add active class for custom button
      let customButton = this.$refs.customButton;
      if (customButton) {
        customButton.addEventListener('touchstart', () => {
          customButton.classList.add('active');
        });
        customButton.addEventListener('touchend', () => {
          customButton.classList.remove('active');
        });
      }
    },
    computed: {
      //return the selected subject
      customizedSubjectList() {
        let subjectList = [];
        this.enabledSubjectsIndex.sort().forEach(val => {
          subjectList.push(this.subjectList[val]);
        });
        return subjectList;
      }
    },
    methods: {
      //customed event handler for customized checkbox
      checkout(checkbox) {
        //push the selected subject's index into enabledSubjectsIndex Array if it's checked or delete the selected index if it's unchecked
        if (checkbox.isChecked) {
          this.enabledSubjectsIndex.push(checkbox.index);
        } else {
          let indexOfCheckbox = this.enabledSubjectsIndex.indexOf(checkbox.index);
          if (indexOfCheckbox != -1) {
            this.enabledSubjectsIndex.splice(indexOfCheckbox, 1);
            //go to index page if delete the current show page
            if (this.subjectList[checkbox.index].to == this.currentSubjectName) {
              this.$refs.subjectBar.changeCurrentArticleList(0);
            }
          }
        }
      },
      //change the list of article and play the corresponding animation according to the passed index 
      changeCurrentArticleList({
        articleListIndex,
        currentSubject
      }) {
        //scroll to top when tap the current article header
        if (this.currentArticleListIndex == articleListIndex) {
          this.nowScrollToTop = true;
          this.$nextTick(() => {
            this.nowScrollToTop = false;
          });
          return;
        }
        if (this.currentArticleListIndex < articleListIndex) {
          this.changeArticleListAnimation = 'slide-left';
        } else {
          this.changeArticleListAnimation = 'slide-right';
        }
        this.$router.push({
          name: 'subject',
          params: {
            subject: currentSubject.to
          }
        });
        this.currentSubjectName = currentSubject.to;
        this.currentArticleListIndex = articleListIndex;
      }
    },
    watch: {
      enabledSubjectsIndex() {
        localStorage.setItem('enabledSubjectsIndex', JSON.stringify(this.enabledSubjectsIndex))
      }
    },
    components: {
      subjectBar,
      switchBox,
      slideOut
    }
  };

</script>

<style lang="less" scoped>
  .slide-top-enter-active {
    transition: all .6s cubic-bezier(0.18, 0.89, 0.32, 1.28);
  }

  .slide-left-enter-active,
  .slide-left-leave-active {
    transition: all .5s;
    position: absolute;
  }

  .slide-top-enter {
    opacity: 0;
    transform: translateY(100vh);
  }

  .slide-left-enter {
    transform: translateX(100%);
  }

  .slide-left-leave-to {
    transform: translateX(-100%);
  }

  .slide-right-enter-to,
  .slide-right-leave {
    transform: translateX(0);
  }

  .slide-right-enter-active,
  .slide-right-leave-active {
    transition: all .5s;
    position: absolute;
  }

  .slide-right-enter {
    transform: translateX(-100%);
  }

  .slide-right-leave-to {
    transform: translateX(100%);
  }

  .slide-right-enter-to,
  .slide-right-leave {
    transform: translateX(0);
  }

  .home-page {
    width: 100vw;
    position: relative;
    padding-top: 7vh;
    div.nav {
      width: 100%;
      background-color: #0080FF;
      position: fixed;
      top: 0;
      display: flex;
      z-index: 99;
      height: 7vh;
      .scroll-bar {
        width: 90%;
        display: inline-block;
      }
      div.custom-button {
        width: 10%;
        height: 100%;
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 99;
        background: #0080FF;
        font-size: 7vw;
        color: #FFFFFF;
        position: relative;
        &.active::after {
          content: '';
          border: 5vw solid transparent;
          border-top: 5vw solid rgba(255, 255, 255, 0.2);
          position: absolute;
          top: 50%;
          transform: translateY(-20%);
        }
      }
    }
    .custom-panel {
      /deep/ .slide-out-header {
        background: linear-gradient(to right, #138be0, #96cbf7 20%, #0080FF);
        color: #FFFFFF;
      }
      ul.custom-list {
        width: 80vw;
        height: 93vh;
        background-color: #F1F1F1;
        li.custom-item {
          font-size: 4vh;
          color: #333333;
          height: 8vh;
          line-height: 8vh;
          padding: 1vw 5vw;
          background-color: #ffffff;
          box-shadow: 0 0 5vw #CCCCCC; //   border-bottom: 1px solid #cccccc;
          display: flex;
          align-items: center;
          justify-content: space-between;
          i {
            color: #cccccc;
            margin-right: 5vw;
          }
          span {
            flex-grow: 0.8;
            flex-basis: 8vw;
          }
          .sbuject-chekbox {
            width: 12vw;
            height: 6vw;
          }
        }
      }
    }
    ul.articleList {
      display: flex;
      flex-direction: column;
      justify-content: space-around;
      padding-top: 1vw;
      li {
        color: white;
        background-color: #FFFFFF;
        margin: 1.5vw 0;
        color: black;
        box-shadow: 0 1px 5px #CCCCCC;
      }
    }
  }

</style>
