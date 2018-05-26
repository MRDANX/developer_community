<template>
  <div class="topic-trends">
    <div class="topic-head">
      <i class="fa fa-arrow-left" @click="$router.go(-1)"></i>
      <span>话题展示</span>
    </div>
    <ul class="trend-list">
      <trend v-for="(trend,index) in trendList" :key="index" :trend="trend" @updateCurrentTrend="updateSpecifiedTrend(index)" @showSharePanel="showSharePanel=true"
      />
    </ul>
    <slide-out slideToDirection="toUp" v-model="showSharePanel" class="share-panel" :showModal="true">
      <share-panel/>
    </slide-out>
  </div>
</template>

<script>
  import trend from '@/components/trendPage/trend';
  import slideOut from "@/components/common/slideOut";
  import sharePanel from "@/components/common/sharePanel";
  export default {
    name: 'topicTrends',
    props: ['topic'],
    data() {
      return {
        trendList: [],
        showSharePanel: false
      }
    },
    created() {
      this.getTrendList();
    },
    activated() {
      if (this.trendList.length != 0 && this.topic != this.trendList[0].title) {
        this.getTrendList();
      }
    },
    methods: {
      getTrendList() {
        this.$axios({
          method: 'get',
          url: '/api/getTrendByTopic',
          params: {
            topic: this.topic
          }
        }).then(result => {
          this.trendList = result.data;
        })
      },
      updateSpecifiedTrend(index) {
        const trendID = this.trendList[index].trendID;
        this.$axios({
          method: 'get',
          url: '/api/getSpecifiedTrend',
          params: {
            trendID
          }
        }).then(result => {
          if (result.data) {
            this.trendList.splice(index, 1, result.data[0]);
          }
        })
      }
    },
    components: {
      trend,
      slideOut,
      sharePanel
    }
  }

</script>

<style lang="less" scoped>
  .topic-trends {
    width: 100vw;
    height: 100vh;
    background-color: #F5F6FA;
    .topic-head{
      width: 100vw;
      height: 12vw;
      background-color: #0080FF;
      line-height: 12vw;
      color: #FFFFFF;
      padding: 0 3vw;
      box-sizing: border-box;
      font-size: 5vw; 
      position: fixed;
      top: 0;
      left: 0;
      z-index: 99;
      i.fa{
        margin-right: 2vw;
      }
    }
    .trend-list{
      margin-top: 14vw;
    }
  }

</style>
