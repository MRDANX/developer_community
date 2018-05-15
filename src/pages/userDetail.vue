<template>
	<div class="user-detail">
		{{userID}}
	</div>
</template>

<script>
  export default {
    name: 'subjectDetail',
    props: {
      userID: Number
    }
  }
</script>

<style>
  .user-detail {
    width: 100vw;
    height: 100vh;
    background-color: lightseagreen;
  }
</style>