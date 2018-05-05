<template>
  <ul class="personal-setting" ontouchstart>
    <li>
      <span>头像</span>
      <div class="avatar">
        <img :src="userInfo.avatar" alt="" v-if="userInfo.avatar">
        <i class="fa fa-user-circle-o" v-else></i>
      </div>
    </li>
    <li>
      <span>用户名</span>
      <span>{{userInfo.userName}}</span>
    </li>
    <li>
      <span>职位</span>
      <span :class="{deactive:!userInfo.job}">{{userInfo.job||'添加职位'}}</span>
    </li>
    <li>
      <span>公司</span>
      <span :class="{deactive:!userInfo.company}">{{userInfo.company||'添加公司'}}</span>
    </li>
    <li>
      <span>简介</span>
      <span :class="{deactive:!userInfo.introduce}">{{userInfo.introduce||'个人介绍'}}</span>
    </li>
    <li>
      <span>博客地址</span>
      <span :class="{deactive:!userInfo.blogAddr}">{{userInfo.blogAddr||'例如:github.com'}}</span>
    </li>
  </ul>
</template>

<script>
  import {
    mapState
  } from "vuex";
  export default {
    name: 'personalSetting',
    computed: {
      ...mapState('user', ['userInfo'])
    }
  }

</script>

<style lang="less">
  .personal-setting {
    width: 100vw;
    height: 93vh;
    li {
	  padding: 0 5vw;
	  box-sizing: border-box;
	  width: 100%;
      height: 20vw;
      display: flex;
	  align-items: center;
	  justify-content: space-between;
      background-color: #FFFFFF;
      box-shadow: 0 0 1px #CCCCCC;
	  font-size: 5vw;
	  &:active{
		  background-color: #CCCCCC;
	  }
	  span.deactive{
		  color: #999999;
	  }
	  div.avatar{
		  width: 16%;
		  height: 80%;
		  position: relative;
		  img{
			  height: 100%;
		  }
		  i.fa{
			  font-size: 14vw;
			  color: #666666;
			  position: absolute;
			  top: 50%;
			  transform: translateY(-50%);
		  }
	  }
    }
  }

</style>
