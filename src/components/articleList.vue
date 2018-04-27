<template>
  <div class="wrapper">
    <!-- <ul> -->
    <transition-group tag="ul" name="flip" mode="out-in">
      <article-brief v-for="article in articleList" :article="article" :key="article.articleID"></article-brief>
    </transition-group>
    <!-- </ul> -->
    <div id="loading" class="loading">loading...</div>
  </div>
</template>

<script>
import _ from "lodash";
import articleBrief from "@/components/articleBrief";
export default {
  props: {
    userID: {
      type: Number,
      default: 1
    }
  },
  data() {
    return {
      articleList: [],
      loadAmount: 5
    };
  },
  components: {
    articleBrief
  },
  created() {
    //handler for lazily loading the list of article
    let lazyLoadHandler = _.debounce(() => {
      let root = document.documentElement;

      let clientHeight = root.clientHeight, //get the height of visible window
        offsetHeight = root.offsetHeight, //get the real height of the content
        scrollTop = root.scrollTop; // get the position of scrollbar

      let loadingElement = document.getElementById("loading");

      //check out whether has scrolled to the bottom of the list of article
      if (scrollTop / (offsetHeight - clientHeight) >= 0.95) {
        loadingElement.style.display = "block";
        //simulation for getting server's data with internet delay 1s
        setTimeout(() => {
          this.$axios("/api/getArticles", {
            params: {
              userID: this.userID,
              startIndex: this.articleList.length,
              loadAmount: this.loadAmount
            }
          })
            .then(res => {
              //check out whether all data has been loaded,remove the listener and modify the innerHTML to remind user
              if (res.data.length == 0) {
                loadingElement.innerHTML = "it's bottom.";
                loadingElement.style.display = "block";
                window.removeEventListener("scroll", lazyLoadHandler);
                return;
              }
              res.data.forEach(article => {
                this.articleList.push(article);
              });
              loadingElement.style.display = "none";
            })
            .catch(err => {
              console.log(err);
            });
        }, 1000);
      }
    }, 200);
    // add scroll eventlistener for lazily loading list of article when scroll to the bottom
    window.addEventListener("scroll", lazyLoadHandler);
    //initialize the list of article according to the variable loadAmount
    this.$axios("/api/getArticles", {
      params: {
        userID: this.userID,
        startIndex: this.articleList.length,
        loadAmount: this.loadAmount
      }
    })
      .then(res => {
        this.articleList = res.data;
      })
      .catch(err => {
        console.log(err);
      });
  }
};
</script>

<style scoped>
div.wrapper{
  padding-bottom: 10vh;
}
ul {
  position: relative;
}
ul > li {
  position: relative;
  z-index: 1;
}

.flip-move {
  transition: all 1s;
}

.flip-enter-active {
  transition: all 1s;
}

.flip-leave-active {
  transition: all 1s;
  position: absolute;
}
.flip-enter {
  opacity: 0;
  transform: translateY(-100%);
  z-index: -2;
}
.flip-enter-to {
  opacity: 1;
  transform: translateY(0);
  z-index: 1;
}
.flip-leave {
  opacity: 1;
  transform: translateY(0);
}
.flip-leave-to {
  opacity: 0;
  transform: translateY(-100%);
}

.loading {
  background-color: #ccffff;
  text-align: center;
  font-size: 40px;
  display: none;
}
</style>
