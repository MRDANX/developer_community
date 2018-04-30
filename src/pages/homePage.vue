<template>
  <div class="home-page">
    <!-- nav-bar for customized subjects -->
    <div class="nav">
      <subject-bar class="scroll-bar" :subjectList="customizedSubjectList" @changeCurrentArticleList="changeCurrentArticleList"></subject-bar>
      <div class="custom-button" ref="customButton">
        <i class="fa fa-caret-down" @click="showCustom=true"></i>
      </div>
    </div>
    <!-- scrollable content with slot injected -->
    <scroll :refresh="refresh" :loadMore="loadMore" :enableScrollToTopButton="true" :scrollToTop="scrollToTop">
      <transition :name="changeArticleListAnimation" appear>
        <ul class="articleList" :key="currentArticleListIndex">
          <article-brief v-for="(item,index) in data" :key="index" :id="currentArticleListIndex+'-'+item" />
        </ul>
      </transition>
    </scroll>
    <!-- hidden panel for customizing subject -->
    <slide-out class="customize-subject" slideToDirection="toDown" :showOut="showCustom" title="首页特别展示" @hide="showCustom=false">
      <!-- list for customizing subjects exclude index 0(item home-page)-->
      <ul class="custom-list">
        <li v-for="(subject,index) in subjectList" :key="index" v-if="index!=0" class="custom-item">
          <i class="fa fa-list-ul"></i>
          <span>{{subject.text}}</span>
          <!-- custom switch box component -->
          <switch-box class="sbuject-chekbox" :isChecked="enabledSubjectsIndex.indexOf(index)!=-1" :index="index" v-on:checkout="checkout"
          />
        </li>
      </ul>
    </slide-out>
  </div>
</template>

<script>
  import _ from 'lodash';
  import subjectBar from "@/components/subjectBar";
  import switchBox from "@/components/switchBox";
  import scroll from "@/components/scroll";
  import articleBrief from "@/components/articleBrief";
  import slideOut from "@/components/slideOut";
  export default {
    name: "homePage",
    data() {
      return {
        data: [],
        subjectList: [{
            text: "首页",
            to: "home"
          },
          {
            text: "前端",
            to: "home"
          },
          {
            text: "Android",
            to: "home"
          },
          {
            text: "人工智能",
            to: "home"
          },
          {
            text: "iOS",
            to: "home"
          },
          {
            text: "产品",
            to: "home"
          },
          {
            text: "设计",
            to: "home"
          },
          {
            text: "工具资源",
            to: "home"
          },
          {
            text: "阅读",
            to: "home"
          },
          {
            text: "后端",
            to: "home"
          }
        ],
        enabledSubjectsIndex: [0, 1, 2, 6, 8],
        showCustom: false,
        currentArticleListIndex: 0,
        changeArticleListAnimation: 'slide-top',
        scrollToTop: false
      };
    },
    created() {
      for (let i = 1; i <= 20; i++) {
        this.data.push(_.random(1, 100));
      }
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
        //push the selected subject's index into enabledSubjectsIndex Array if it's checked
        if (checkbox.isChecked) {
          this.enabledSubjectsIndex.push(checkbox.index);
        } else {
          let indexOfCheckbox = this.enabledSubjectsIndex.indexOf(checkbox.index);
          if (indexOfCheckbox != -1) {
            this.enabledSubjectsIndex.splice(indexOfCheckbox, 1);
          }
        }
      },
      //return a promise which excute asychronized action to refresh data
      refresh() {
        return new Promise((resolve, reject) => {
          setTimeout(() => {
            this.data.unshift(_.random(1, 100));
            resolve();
          }, 1000);
        })
      },
      //return a promise which excute asychronized action to load more data
      loadMore() {
        return new Promise((resolve, reject) => {
          setTimeout(() => {
            for (let i = 0; i < 5; i++) {
              this.data.push(_.random(1, 100));
            }
            resolve();
            //reject sample
            // reject({errno:0,text:'no more data!'})
          }, 1000);
        });
      },
      //change the list of article and play the corresponding animation according to the passed index 
      changeCurrentArticleList(articleListIndex) {
        if (this.currentArticleListIndex == articleListIndex) {
          this.scrollToTop = true;
          this.$nextTick(() => {
            this.scrollToTop = false;
          })
          return;
        }
        if (this.currentArticleListIndex < articleListIndex) {
          this.changeArticleListAnimation = 'slide-left';
        } else {
          this.changeArticleListAnimation = 'slide-right';
        }
        this.currentArticleListIndex = articleListIndex;
      }
    },
    components: {
      subjectBar,
      switchBox,
      scroll,
      articleBrief,
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
        &.active i {
          transition: all .1s;
          transform: rotate(-90deg);
        }
      }
    }
    div.customize-subject {
      ul.custom-list {
        width: 100vw;
        li.custom-item {
          font-size: 4vh;
          color: #333333;
          height: 8vh;
          line-height: 8vh;
          padding: 1vw 10vw;
          background-color: #ffffff;
          border-bottom: 1px solid #cccccc;
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
