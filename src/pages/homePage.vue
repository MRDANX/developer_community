<template>
  <div class="home-page">
    <!-- nav-bar for customized subjects -->
    <div class="nav">
      <subject-bar class="scroll-bar" :subjectList="customizedSubjectList"></subject-bar>
      <i class="fa fa-caret-down" @click="toggleCustom"></i>
    </div>
    <!-- panel for customizing subject -->
    <div class="customize-subject" :class="{active:showCustom}">
      <!-- custom-panel header -->
      <div class="custom-header">
        <i class="fa fa-arrow-left" @click="toggleCustom"></i>
        首页特别展示
      </div>
      <!-- list for customizing subject exclude index 0(item home-page)-->
      <ul class="custom-list">
        <li v-for="(subject,index) in subjectList" :key="index" v-if="index!=0" class="custom-item">
          <i class="fa fa-list-ul"></i>
          <span>{{subject.text}}</span>
          <!-- custom checkbox component -->
          <checkbox class="sbuject-chekbox" :isChecked="enabledSubjectsIndex.indexOf(index)!=-1" :index="index" v-on:checkout="checkout"
          />
        </li>
      </ul>
    </div>
    <!-- <span>homePage</span> -->
    <scroll></scroll>
  </div>
</template>

<script>
  import subjectBar from "@/components/subjectBar";
  import checkbox from '@/components/checkbox';
  import scroll from '@/components/scroll';
  export default {
    name: "homePage",
    data() {
      return {
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
        enabledSubjectsIndex: [0, 1, 2],
        showCustom: false
      };
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
      //toggle custom panel and enable/disable scroll
      toggleCustom() {
        this.showCustom = !this.showCustom;
        if (this.showCustom) {
          document.documentElement.style.overflow = 'hidden';
        } else {
          document.documentElement.style.overflow = 'scroll';
        }
      },
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
      }
    },
    components: {
      subjectBar,
      checkbox,
      scroll
    }
  };

</script>

<style lang="less" scoped>
  .home-page {
    width: 100vw;
    position: relative;
    padding-top: 7vh;
    div.nav {
      width: 100%;
      background-color: #3366cc;
      position: fixed;
      top: 0;
      z-index: 99;
      height: 7vh;
      .scroll-bar {
        width: 90%;
        display: inline-block;
      }
      i.fa-caret-down {
        font-size: 7vw;
        color: white;
        position: absolute;
        top: 50%;
        transform: translateY(-50%);
        right: 3vw;
        &:active{
          background-color: #3366aa;
        }
      }
    }
    div.customize-subject {
      position: fixed;
      top: 0;
      left: 0;
      transition: all 0.3s ease-out;
      transform: translateX(100%);
      width: 100vw;
      height: 100vh;
      background-color: #F1F1F1;
      z-index: 100;
      &.active {
        transform: translateX(0);
      }
      .custom-header {
        width: 100vw;
        height: 7vh;
        background-color: #3366cc;
        color: #FFFFFF;
        font-size: 3.5vh;
        line-height: 7vh;
        i {
          margin: 0 5vw 0 3vw;
          transform: scaleX(1.3);
        }
      }
      ul.custom-list {
        width: 100vw;
        li.custom-item {
          font-size: 4vh;
          color: #333333;
          height: 8vh;
          line-height: 8vh;
          padding: 1vw 10vw;
          background-color: #FFFFFF;
          border-bottom: 1px solid #CCCCCC;
          display: flex;
          align-items: center;
          justify-content: space-between;
          i {
            color: #CCCCCC;
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
  }

</style>
