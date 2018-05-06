// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue';
import App from './App';
import router from './router';
import store from './store';
import axios from 'axios';
import 'es6-promise/auto';
// import MintUI from 'mint-ui';
// import 'mint-ui/lib/style.css';
import 'font-awesome/css/font-awesome.min.css';

Vue.config.productionTip = false;

Vue.prototype.$axios = axios;

//method that add listener for toggling active class to the passing element
function activeFeedback(el) {
  el.addEventListener("touchstart", function () {
    this.classList.add("active");
  });
  el.addEventListener("touchend", function () {
    this.classList.remove("active");
  });
}
Vue.prototype.$activeFeedback = activeFeedback;
// Vue.use(MintUI);
/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  store,
  components: {
    App
  },
  template: '<App/>'
});
