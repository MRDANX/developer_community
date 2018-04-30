<template>
  <div class="subject-bar wrapper" ref="wrapper">
    <ul class="content" ref="content">
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
    methods: {
      _initScroll() {
        //initialize the inner box's width according to each width of inner box's item
        let itemWidth = this.$refs.subjects[0].getBoundingClientRect().width;
        let totalWidth = itemWidth * this.subjectList.length;
        this.$refs.content.style.width = totalWidth + "px";
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
        this.scroll.scrollToElement(this.$refs.subjects[index], 300, true);
        this.currentIndex = index;
        //emit the event of parent component with a parameter currentIndex
        this.$emit('changeCurrentArticleList', this.currentIndex);
      }
    },
    mounted() {
      //initialize the scroll after getting new data
      this.$nextTick(() => {
        this._initScroll();
      });
    },
    updated() {
      this.$nextTick(() => {
        //recalculate the inner box's width and refresh scroll component at nextTick
        let itemWidth = this.$refs.subjects[0].getBoundingClientRect().width;
        let totalWidth = itemWidth * this.subjectList.length;
        this.$refs.content.style.width = totalWidth + "px";
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
      display: flex;
      height: 100%;
      justify-content: space-around;
      li {
        flex: 0 0 20vw;
        font-size: 4vw;
        text-align: center;
        position: relative;
        &::after {
          content: '';
          width: 100%;
          height: 0.5vh;
          background-color: #ffffff;
          position: absolute;
          bottom: 0;
          left: 0;
          transform: scale(0);
          transition: all .2s;
        }
      }
      li.active {
        color: #ffffff;
        &::after {
          transform: scale(1);
          transition: all .3s cubic-bezier(0.18, 0.89, 0.32, 1.28);
          box-shadow: 0 0 1vw #666666;
        }
      }
    }
  }

</style>
