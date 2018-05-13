<template>
	<p class="tag" :style="{'background-color':_bgColor}" @click="$refs.hiddenInput.focus()" :class="{active:showDelete}">
		<i class="fa fa-tag"></i><span>{{tagText}}</span><i class="fa fa-close" v-if="showDelete" @click="$emit('deleteTag')"></i>
		<input type="text" @focus="showDelete=true" @blur="showDelete=false" ref="hiddenInput">
  </p>
</template>

<script>
  export default {
    name: 'tag',
    props: {
      tagText: {
        type: String,
        default: 'tag'
      }
    },
    data() {
      return {
        _bgColor: '',
        colorSet: ['#ffbd4c', '#99cc33', '#66cc99', '#0099ff', '#6cbd45', '#cc3333', '#ff9900'],
        showDelete: false
      }
    },
    created() {
      this._bgColor = this.randomColor();
    },
    methods: {
      randomNumber() {
        let min = 0,
          max = this.colorSet.length,
          range = max - min;
        return min + Math.floor(Math.random() * range);
      },
      randomColor() {
        return this.colorSet[this.randomNumber()];
      }
    }
  }
</script>

<style scoped>
  .tag {
    display: inline-block;
    width: fit-content;
    margin: 1vw 2vw;
    padding: 1vw 2vw;
    border-radius: 5px;
    color: #FFFFFF;
    position: relative;
		transition: all .3s;
  }

  .tag.active {
    padding-right: 3vw;
  }

  i.fa-tag {
    margin-right: 1vw;
  }

  i.fa-close {
    position: absolute;
    right: 0;
    top: 0;
		font-size: 3vw;
  }

  input {
		width: 0;
		height: 0;
		border: none;
		outline: none;
  }
</style>