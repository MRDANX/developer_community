<template>
  <div class="subject-bar wrapper" ref="wrapper">
    <ul class="content">
      <li ref="subjects" v-for="(subject,index) in subjectList" :key="index" @click="changeCurrentArticleList(index)" :class="{active:currentIndex==index}">
        {{subject.text}}
      </li>
    </ul>
  </div>
</template>
<script>
  import BScroll from "better-scroll";
  export default {
    name: "subjectBar",
    props: {
      subjectList: Array
    },
    data() {
      return {
        currentIndex: 0
      };
    },
    created() {
      //initialize currentIndex according to route's params
      let subjectName = this.$route.params.subject;
      for (let i = 0; i < this.subjectList.length; i++) {
        const subject = this.subjectList[i];
        if (subject.to === subjectName) {
          this.currentIndex = i;
          return;
        }
      }
      //simulate to do the click event on subject's block
      this.changeCurrentArticleList(this.currentIndex);
    },
    methods: {
      _initScroll() {
        //initialize scroll
        this.scroll = new BScroll(this.$refs.wrapper, {
          scrollX: true,
          scrollY: false,
          click: true,
          bounceTime: 300
        });
      },
      //change the currently display article list
      changeCurrentArticleList(index) {
        //scroll to the center of the scrollbar
        this.scroll && this.scroll.scrollToElement(this.$refs.subjects[index], 300, true);
        this.currentIndex = index;
        //emit the event of parent component with a parameter currentIndex
        this.$emit('changeCurrentArticleList', {
          articleListIndex: this.currentIndex,
          currentSubject: this.subjectList[this.currentIndex],
        });
      }
    },
    mounted() {
      //initialize the scroll after getting new data
      this.$nextTick(() => {
        this._initScroll();
        this.scroll && this.scroll.scrollToElement(this.$refs.subjects[this.currentIndex], 500, true);
      });
      this.$refs.subjects.forEach(subject => {
        subject.addEventListener('touchstart', () => {
          subject.classList.add('touch');
        });
        subject.addEventListener('touchend', () => {
          subject.classList.remove('touch');
        });
      });
    },
    updated() {
      //refresh scroll when data was updated and DOM was rendered
      this.$nextTick(() => {
        this.scroll.refresh();
      })
    }
  }

  ;
</script>
<style lang="less" scoped>
  .subject-bar {
    width: 100%;
    height: 100%;
    line-height: 7vh;
    font-weight: bold;
    color: rgba(255, 255, 255, 0.7);
    ul {
      width: fit-content;
      height: 100%;
      white-space: nowrap;
      li {
        display: inline-block;
        padding: 0 4vw;
        font-size: 4vw;
        height: 100%;
        position: relative;
        &.touch::before {
          content: '';
          width: 100%;
          height: 100%;
          position: absolute;
          left: 0;
          top: 0;
          background-color: rgba(255, 255, 255, 0.1);
        }
        &::after {
          content: '';
          width: 100%;
          height: 0.5vh;
          background-color: #ffffff;
          position: absolute;
          bottom: 0;
          left: 0;
          transform: scale(0);
          transition: all .3s;
        }
      }
      li.active {
        color: #ffffff;
        &::after {
          transform: scale(1);
          transition: all .5s cubic-bezier(0.18, 0.89, 0.32, 1.28);
          box-shadow: 0 0 1vw #666666;
        }
      }
    }
  }
</style>