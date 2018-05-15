<template>
	<div class="subject-detail">
		{{subject}}
	</div>
</template>

<script>
  export default {
    name: 'subjectDetail',
    props: {
      subject: String
    }
  }
</script>

<style>
  .subject-detail {
    width: 100vw;
    height: 100vh;
    background-color: orange;
  }
</style>