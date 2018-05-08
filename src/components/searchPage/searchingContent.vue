<template>
	<scroll :enableScrollToTopButton="true" >
		<div class="searching-content">
			<transition name="fade">
				<div class="searching-result" v-if="searchText" key="result">
					searching-result
				</div>
				<div class="searching-recommend" v-else key="recommend">
					searching-recommend
				</div>
			</transition>
		</div>
	</scroll>
</template>

<script>
  import scroll from '@/components/common/scroll';
  export default {
    name: 'searchingContent',
    props: {
      value: {
        type: String,
        default: ''
      }
    },
    computed: {
      searchText: {
        get() {
          return this.value;
        },
        set(val) {
          this.$emit('input', val);
        }
      }
    },
    components: {
      scroll
    }
  }
</script>

<style lang="less" scoped>
	.fade-enter,.fade-leave-to{
		opacity: 0;
	}

  .searching-content {
    width: 100%;
    .searching-result {
			width: 100vw;
			height: 10vh;
			background-color: red;
      transition: all .5s;
    }
    .searching-recommend {
			width: 100vw;
			height: 10vh;
			background-color: orange;
      transition: all .5s;
    }
  }
</style>