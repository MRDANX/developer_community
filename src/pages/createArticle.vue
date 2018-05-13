<template>
	<div class="create-article">
		<transition name="switch-header" mode="out-in">
			<div class="article-header" v-if="headerIndex==0" @click="switchHeader($event)" key="header">
				<i class="fa fa-chevron-left" @click="$router.go(-1)" ref="goBack"></i>
				<span>编写文章</span>
				<div class="submit" ref="submit">发布</div>
        <span class="action-hint" v-if="!clickTime">双击切换至状态栏</span>
			</div>
			<div class="article-status" v-else-if="headerIndex==1" @click="switchHeader" key="status">
				<span class="show-title">{{title||'请输入文章标题'}}</span>
        <span class="show-inputed">当前已输入字数：{{contentLength}}</span>
			</div>
			<div class="pulldown-bar" v-else-if="headerIndex==2" @click="headerIndex=0" key="pulldownBar">
				<i class="fa fa-bullseye" ref="pulldown"></i>
			</div>
		</transition>
		<form class="article-form" :class="{'clear-margin-top':headerIndex==2,'clear-half-margin-top':headerIndex==1}">
			<div class="article-title">
				<input type="text" placeholder="请输入文章标题" v-model="title" onfocus="this.placeholder=''" onblur="this.placeholder='请输入文章标题'" />
			</div>
      <div class="article-cover">
        <div class="cover-upload">
          <span>封面(可选):</span>
          <i class="fa fa-picture-o" ></i>
          <input type="file" ref="coverUpload" @change="uploadCover($event.target)" accept="image/jpeg,image/jpg,image/png"/>
        </div>
        <div class="cover-show" v-if="cover">
          <img :src="cover" alt="">
          <i class="fa fa-close" @click="cover=''"></i>
        </div>
      </div>
			<div class="article-subject">
        <div class="subject-head" @click="showSubjectList=!showSubjectList">
				  <span class="select-hint">选择分类: </span>
          <span class="selected-subject">{{selectedsubject}}</span>
          <i class="fa" v-if="selectedsubject" :class="[showSubjectList?'fa-caret-up':'fa-caret-down']"></i>
        </div>
				<div class="subject-group" :class="{selected:selectedsubject!='',reselect:showSubjectList}">
          <label class="subject" v-for="(subject,index) in subjectList" :key="index" @click="selectCurrentSubject(subject)" :class="{checked:selectedsubject==subject}">{{subject}}</label>
        </div>
			</div>
			<div class="article-tags">
        <div class="tags-show">
				  <span>标签:</span>
          <div class="add-tag" :class="{'adding-tag':addingTag}" key="addingTag">
            <input type="text" @focus="addingTag=true" @blur="addTag" v-model="addingTagText" @keyup.enter="addTag" ref="addingTag">
            <div class="adding-tag-hint">
              <i class="fa fa-plus"></i>
            </div>
          </div>
        </div>
        <transition-group name="fluent" tag="div" class="tags-wrapper">
          <p v-for="(tag,index) in tags" :key="index" class="tag" :style="{'background-color':colorSet[index]}">
            <i class="fa fa-tag"></i><span>{{tag}}</span>
          </p>
        </transition-group>
			</div>
			<quill-editor v-model="content" :options="editorOptions" class="article-editor" />
		</form>
    <hint v-model="hintText" />
    <loading v-if="showLoading" :verticalMove="5"/>
	</div>
</template>

<script>
  import 'quill/dist/quill.core.css';
  import 'quill/dist/quill.snow.css';
  import 'quill/dist/quill.bubble.css';
  import { quillEditor } from 'vue-quill-editor';
  import { mapState } from "vuex";
  import hint from '@/components/common/hint';
  import loading from '@/components/common/loading';
  export default {
    name: 'createArticle',
    data() {
      return {
        editorOptions: {
          placeholder: '在这里开始书写你的文章',
          modules: {
            toolbar: [
              ['bold', 'italic', 'underline', 'strike'],
              [{ 'header': 1 }, { 'header': 2 }],
              [{ 'list': 'ordered' }, { 'list': 'bullet' }],
              ['blockquote', 'code-block'],
              ['clean'],
              [{ 'align': ''},{ 'align': 'right'},{ 'align': 'center'},{ 'align': 'justify'}],
              [{ 'color': [] }, { 'background': [] }],
              [{ 'indent': '-1'}, { 'indent': '+1' }],
              [{ 'size': ['small', false, 'large', 'huge'] }],
              ['image']
            ]
          }
        },
        title: '',
        cover: '',
        selectedsubject: '',
        tags: [],
        content: '',
        headerIndex: 0,
        clickTime: null,
        hintText: '',
        showLoading: false,
        subjectList: ['前端', 'Android', '人工智能', 'iOS', '产品', '设计', '工具资源', '阅读', '后端'],
        showSubjectList: false,
        addingTag: false,
        addingTagText: '',
        colorSet: ['#ffbd4c', '#99cc33', '#66cc99', '#0099ff', '#6cbd45', '#cc3333', '#ff9900']
      }
    },
    mounted() {
      let submitButton = this.$refs.submit;
      this.$activeFeedback(submitButton);
    },
    updated() {
      setTimeout(() => {
        let submitButton = this.$refs.submit,
          pulldownBtn = this.$refs.pulldown;
        if (submitButton) {
          this.$activeFeedback(submitButton);
        }
        if (pulldownBtn) {
          pulldownBtn.addEventListener('touchend', (e) => {
            let clientY = e.changedTouches[0].clientY;
            if (clientY > 120) {
              pulldownBtn.style.top = '0vh';
              pulldownBtn.style.opacity = '0';
              pulldownBtn.style.transition = 'all .2s';
              setTimeout(() => {
                this.headerIndex = 0;
              }, 100);
            } else {
              pulldownBtn.style.transition = 'all .2s';
              pulldownBtn.style.top = '6vh';
              setTimeout(() => {
                pulldownBtn.style.transition = '';
              }, 200);
            }
          });
          pulldownBtn.addEventListener('touchmove', (e) => {
            e.preventDefault();
            let clientY = e.touches[0].clientY;
            if (clientY > 0 && clientY < 200) {
              pulldownBtn.style.top = (+clientY - 10) + 'px';
            }
          });
        }
      }, 500);
    },
    methods: {
      switchHeader(e) {
        if (e.target == this.$refs.submit || e.target == this.$refs.goBack) {
          return;
        }
        if (Date.now() - this.clickTime < 400) {
          this.headerIndex = (this.headerIndex + 1) % 3;
        } else {
          this.clickTime = Date.now();
        }
      },
      uploadCover(target) {
        //read image uploaded locally and display it as cover in real time
        let limitSize = 1 * 1024 * 1024, //max-size 1MB
          tmpCover = target.files[0],
          fr = new FileReader();
        if (tmpCover) {
          if (tmpCover.size >= limitSize) {
            this.hintText = '图片大小不能超过1MB,请重新选择!';
            return;
          }
          this.showLoading = true;
          fr.readAsDataURL(tmpCover);
          fr.onload = () => {
            this.cover = fr.result;
            this.showLoading = false;
          }
        }
      },
      selectCurrentSubject(subject) {
        this.selectedsubject = subject;
        this.showSubjectList = false;
      },
      addTag() {
        this.addingTag = false;
        if (this.addingTagText) {
          this.tags.push(this.addingTagText);
          this.addingTagText = '';
        }
        this.$refs.addingTag.blur();
      },
      randomNumber() {
        return this.$randomNumber(0, this.colorSet.length - 1);
      },
      randomColor() {
        return this.colorSet[this.randomNumber()];
      }
    },
    computed: {
      ...mapState('user', ['userInfo']),
      contentLength() {
        return this.content.replace(/<\/?[^>]+>/g, '').length;
      }
    },
    components: {
      quillEditor,
      hint,
      loading
    }
  }
</script>

<style lang="less" scoped>
  // .switch-header-enter-active,
  // .switch-header-leave-active {
  //   transition: all .3s;
  // }
  .switch-header-enter,
  .switch-header-leave-to {
    opacity: 0;
    transform: translateY(-8vh);
  }

  .fluent-enter-active,
  .fluent-leave-active {
    transition: all 1s;
    position: absolute;
  }

  .fluent-enter {
    opacity: 0;
    transform: translateX(50px);
  }

  .fluent-leave-to {
    opacity: 0;
    transform: scale(0);
  }

  .create-article {
    width: 100vw;
    min-height: 100vh;
    background-color: #FFFFFF;
    .article-header,
    .article-status {
      position: fixed;
      top: 0;
      left: 0;
      width: 100vw;
      height: 14vw;
      box-sizing: border-box;
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 0 3vw;
      font-size: 5vw;
      background-color: #0080FF;
      color: #FFFFFF;
      z-index: 99;
      transition: all .3s;
    }
    .article-header {
      .fa {
        font-size: 6vw;
        width: 8vw;
        height: 8vw;
        line-height: 7.4vw;
        border-radius: 50%;
        text-align: center;
        &:active {
          background-color: rgba(255, 255, 255, 0.3);
        }
        &::before {
          position: relative;
          top: 3px;
        }
      }
      span {
        flex-grow: 0.8;
      }
      .submit {
        padding: 1vw 2vw;
        border: 1px solid #FFFFFF;
        border-radius: 1vw;
        color: #FFFFFF;
        user-select: none;
        background-color: #007FFF;
        &.active {
          background-color: #FAFAFA;
          color: #0080FF;
        }
      }
      .action-hint {
        position: absolute;
        bottom: 0;
        left: 50%;
        transform: translateX(-50%);
        font-size: 3vw;
        color: #FAFAFA;
        opacity: 0;
        animation: blink 8s linear infinite;
      }
    }
    .article-status {
      height: 8vw;
      line-height: 8vw;
      font-size: 4vw;
      .show-title {
        flex-grow: 1;
        max-width: 50vw;
        text-overflow: ellipsis;
        overflow: hidden;
        white-space: nowrap;
      }
    }
    .pulldown-bar {
      position: fixed;
      top: 0;
      left: 0;
      width: 100vw;
      height: 0;
      transition: all .3s;
      z-index: 99;
      i.fa {
        position: absolute;
        right: 10vw;
        top: 6vh;
        font-size: 6vw;
        color: #0080FF; // transition: all .2s;
        &::before {
          position: relative;
          z-index: 98;
        }
        &::after {
          content: '';
          width: 2px;
          height: 200px;
          background-color: #0080FF;
          position: absolute;
          top: -199px;
          left: 50%;
          z-index: 99;
          transform: translateX(-50%);
        }
      }
    }
    .article-form {
      margin-top: 14vw;
      transition: all .6s;
      font-size: 4vw;
      overflow: hidden;
      &.clear-margin-top {
        margin-top: 0;
      }
      &.clear-half-margin-top {
        margin-top: 8vw;
      }
      .article-title {
        padding: 0 5vw;
        margin: 2vw 0;
        input {
          width: 100%;
          border: none;
          outline: none;
          border-bottom: 2px dashed #CCCCCC;
          font-size: 5vw;
          padding: 2vw 0;
          color: #333333;
          text-align: center;
        }
      }
      .article-cover {
        margin: 2vw 0;
        padding: 0 3vw;
        position: relative;
        .cover-upload {
          position: relative;
          overflow: hidden;
          i.fa {
            font-size: 5vw;
            vertical-align: bottom;
            margin-left: 2vw;
          }
          input[type='file'] {
            position: absolute;
            top: 0;
            left: 0;
            opacity: 0;
          }
        }
        .cover-show {
          width: 100%;
          padding: 1.5vw 1vw;
          margin: 2vw 0;
          box-sizing: border-box;
          border-width: 3px;
          border-color: #CCCCCC;
          border-style: dashed solid;
          position: relative;
          img {
            width: 100%;
          }
          i.fa {
            position: absolute;
            right: 0;
            bottom: 0;
            color: #0080FF;
            font-size: 3vw;
          }
        }
      }
      .article-subject {
        width: 100vw;
        padding: 0 3vw;
        box-sizing: border-box;
        .subject-head {
          .selected-subject {
            flex-grow: 1;
            margin-left: 2vw;
          }
        }
        .subject-group {
          margin: 1vw 0;
          display: flex;
          height: 35vw;
          justify-content: flex-start;
          align-items: center;
          flex-wrap: wrap;
          transition: all .5s;
          overflow: hidden;
          &.selected {
            height: 0;
          }
          &.reselect {
            height: 35vw;
          }
          .subject {
            border: 1px solid #F1F1F1;
            color: #909090;
            margin: 1vw 2vw;
            padding: 2vw 3vw;
            border-radius: 5px;
            transition: all .2s;
            &.checked {
              border: 1px solid rgba(0, 127, 255, .15);
              color: #007fff;
              background-color: rgba(0, 127, 255, .05);
            }
          }
        }
      }
      .article-tags {
        padding: 0 3vw; // display: flex;
        // align-items: center;
        margin-top: 1vw;
        position: relative;
        .tags-show {
          display: inline-block;
          margin-right: 2vw;
        }
        .tags-wrapper {
          position: relative;
          margin-top: 2vw;
          width: 100%;
          min-height: 8vw; // display: flex;
          // flex-wrap: wrap;
          transition: all .5s;
          .tag {
            display: inline-block;
            width: fit-content;
            margin: 1vw 2vw 0;
            padding: 1vw 2vw;
            background-color: #ff9900; //#ff9900;#ffbd4c;#99cc33;#66cc99;#0099ff;#6cbd45;#cc3333
            border-radius: 5px;
            color: #FFFFFF;
            i {
              margin-right: 1vw;
            }
          }
        }
        .add-tag {
          position: relative;
          display: inline-block;
          border: 1px dashed #007FFF;
          padding: 1vw 1vw;
          border-radius: 5px;
          color: #666666;
          width: 5vw;
          height: 5vw;
          border-radius: 50%;
          text-align: center;
          transition: all 0.5s;
          font-size: 3.5vw;
          margin-left: 2vw;
          &.adding-tag {
            width: 20vw;
            border-radius: 2vw;
          }
          input {
            position: absolute;
            top: 0;
            left: 0;
            background-color: transparent;
            border: none;
            outline: none;
            width: 100%;
            height: 100%;
            text-align: center;
            font-size: 4.5vw;
            padding: 1vw 1.5vw;
            box-sizing: border-box;
            transition: all 0.5s;
            color: #333333;
          }
          .adding-tag-hint {
            transition: all 0.5s;
            color: #0080FF;
          }
          input:focus+.adding-tag-hint {
            opacity: 0;
          }
        }
      }
      .article-editor {
        margin-top: 3vw;
        max-width: 100vw;
        font-size: 4vw;
        /deep/ .ql-container .ql-editor {
          min-height: 50vh;
        }
      }
    }
  }

  @keyframes blink {
    0% {
      opacity: 0;
    }
    25% {
      opacity: 1;
    }
    50% {
      opacity: 0;
    }
    75% {
      opacity: 1;
    }
    100% {
      opacity: 0;
    }
  }
</style>