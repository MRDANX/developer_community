<template>
  <div class="wrapper" ref="wrapper">
    <div>
      <div class="top-refresh" v-if="isPullingDownRelease" :class="{positionChange:isPullingDown}">
        <span v-if="isPullingDown" class="loading-tips" ref="loadingTips">释放加载更多</span>
        <i class="fa fa-spinner fa-pulse" v-else></i>
      </div>
      <ul class="content">
        <li v-for="item in testData" :key="item">
          {{item}}
        </li>
      </ul>
      <div class="bottom-load" ref="bottomLoad" v-if="isPullingUp">
        <i class="fa fa-spinner fa-spin"></i>
      </div>
    </div>
    <!-- <i class="fa fa-spinner fa-pulse"></i> -->
  </div>
</template>

<script>
  import BScroll from 'better-scroll'
  export default {
    name: 'scroll',
    data() {
      return {
        testData: [],
        isPullingDown: false,
        isPullingDownRelease: false,
        isPullingUp: false
      }
    },
    created() {
      for (let i = 1; i <= 30; i++) {
        this.testData.push(i);
      }
    },
    mounted() {
      this.$nextTick(() => {
        this.loadData();
      })
    },
    watch: {
      testData() {
        this.$nextTick(() => {
          this.scroll.refresh();
        })
      }
    },
    methods: {
      loadData() {
        //return directively if the wrapper element isn't existed
        if (!this.$refs.wrapper) {
          console.error('wrapper is not existed.');
          return;
        }
        //create and initialize scroll if it's not existed
        if (!this.scroll) {
          this.scroll = new BScroll(this.$refs.wrapper, {
            probeType: 2
          });
          //excute the handler when scrolling
          this.scroll.on('scroll', (pos) => {
            if (pos.y > 10) {
              //show up the top refreshing 
              this.isPullingDown = true;
              this.isPullingDownRelease = true;
              //dynamically calculate the fontSize of the refreshing tips
              this.$refs.loadingTips.style.fontSize = ((pos.y / 25) + 3) + 'vw';
            }
          });
          //excute the handler when release touch
          this.scroll.on('touchEnd', (pos) => {
            if (pos.y > 50) {
              //execute pull down refresh data procedure if the position y greater than 50
              this.isPullingDown = false;
              //asynchronized code here
              setTimeout(() => {
                this.testData.unshift('pullDown: ' + (this.testData.length + 1));
                this.isPullingDownRelease = false;
              }, 1500);
            } else if (pos.y <= (this.scroll.maxScrollY - 30)) {
              //execute pull up load more data procedure if the position y less than maxScrollY -30
              this.isPullingUp = true;
              //asynchronized code here
              setTimeout(() => {
                this.testData = this.testData.concat([55, 56, 57, 58, 59, 60]);
                this.isPullingUp = false;
              }, 1500);
            } else {
              this.isPullingUp = false;
              this.isPullingDown = false;
              this.isPullingDownRelease = false;
            }
          });
        } else {
          this.scroll.refresh();
        }
      }
    }
  }

</script>

<style lang="less" scoped>
  div.wrapper {
    width: 100vw;
    height: 84vh;
    position: relative;
    .top-refresh {
      text-align: center;
      font-size: 10vw;
      color: #CCCCCC;
      &.positionChange {
        position: absolute;
        top: -12vw;
        left: 0;
        right: 0;
        margin: auto; //   .loading-tips{
        // 	transform: scale(1);
        //   }
      }
      .loading-tips {
        font-size: 3vw; // transform: scale(0);
        // transition: all .5s;
      }
    }
    .bottom-load {
      text-align: center;
      font-size: 8vw;
      color: #CCCC99;
    }
    ul.content {
      display: flex;
      flex-direction: column;
      justify-content: space-around;
      li {
        width: 100%;
        height: 5vh;
        line-height: 5vh;
        background-color: #6699CC;
        margin: 1vh 0;
        color: white;
        text-align: center;
      }
    }
  }

</style>
