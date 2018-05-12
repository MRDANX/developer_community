<template>
	<div class="create-article">
		<div class="create-article-header" :class="{hide:hideTop}" @click="hideHeader" ref="articleHeader">
			<i class="fa fa-backward"></i>
			<span>编写文章</span>
			<div class="submit" ref="submit">提交</div>
		</div>
		<form class="create-article-form" :class="{'clear-margin-top':hideTop}">
			<div class="create-article-title">
				<span>标题:</span>
				<input type="text" placeholder="请输入文章标题"/>
			</div>
			<quill-editor v-model="content" :options="editorOptions" class="create-article-editor" />
		</form>
	</div>
</template>

<script>
  import 'quill/dist/quill.core.css';
  import 'quill/dist/quill.snow.css';
  import 'quill/dist/quill.bubble.css';
  import { quillEditor } from 'vue-quill-editor';
  import { mapState } from "vuex";
  export default {
    name: 'createArticle',
    data() {
      return {
        editorOptions: {
          placeholder: '在这里开始书写你的文章'
        },
        content: '',
        hideTop: false,
        clickTime: null
      }
    },
    mounted() {
      let submitButton = this.$refs.submit;
      this.$activeFeedback(submitButton);
      // let articleHeader=this.$refs.articleHeader;
      // articleHeader.addEventListener('dblclick',()=>{
      // 	console.log('dbClick');

      // })
      window.onscroll = () => {
        let scrollTop = document.documentElement.scrollTop || window.pageYOffset || document.body.scrollTop;
        if (scrollTop == 0) {
          this.hideTop = false;
        }
      }
    },
    methods: {
      hideHeader() {
        if (Date.now() - this.clickTime < 400) {

          this.hideTop = true;

        } else {
          this.clickTime = Date.now();
        }


      }
    },
    computed: mapState('user', ['userInfo']),
    components: {
      quillEditor
    }
  }
</script>

<style lang="less">
  .create-article {
    width: 100vw;
    min-height: 100vh;
    background-color: #FFFFFF;
    .create-article-header {
      position: fixed;
      top: 0;
      left: 0;
      width: 100vw;
      box-sizing: border-box;
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 0 3vw;
      height: 8vh;
      font-size: 5vw;
      transition: all .5s;
      background-color: #0080FF;
			color: #FFFFFF;
			z-index: 99;
      &.hide {
        top: -8vh;
      }
      .fa {
        font-size: 6vw;
      }
      span {
        flex-grow: 0.8;
      }
      .submit {
        padding: 1vw 2vw;
        border: 1px solid #FFFFFF;
        border-radius: 5px;
				color: #FFFFFF;
				user-select: none;
        &.active {
          background-color: #FFFFFF;
          color: #0080FF;
        }
      }
    }
    .create-article-form {
      margin-top: 8vh;
      transition: all .5s;
      &.clear-margin-top {
        margin-top: 0;
      }
    }
  }
</style>