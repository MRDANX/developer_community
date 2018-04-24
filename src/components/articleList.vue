<template>
  <div>
    <article></article>
  </div>
</template>

<script>
import article from "@/components/article";
export default {
  data(){
    return{
      articleList:[{
        title: 'test',
        content: '<p>this is a text.</p>',
        date: new Date().toLocaleDateString(),
        author: 'danxiong',
        category: 'vue',
        favors: 12
      }]
    }
  }
}
</script>

<style>

</style>
