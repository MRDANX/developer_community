// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue';
import App from './App';
import router from './router';
import store from './store';
import axios from 'axios';
import 'es6-promise/auto';
import 'font-awesome/css/font-awesome.min.css';

Vue.config.productionTip = false;

Vue.prototype.$axios = axios;

//method that add listener for toggling active class to the passing element
function activeFeedback(el) {
  el.addEventListener("touchstart", function() {
    this.classList.add("active");
  });
  el.addEventListener("touchend", function() {
    this.classList.remove("active");
  });
}

Vue.filter('dateFormat', function(time) {
  let dayMilli, days, hoursMilli, hours, minutesMilli, minutes, secondMill, seconds;
  dayMilli = Date.now() - new Date(time).getTime();
  days = Math.floor(dayMilli / (24 * 3600 * 1000));
  hoursMilli = dayMilli % (24 * 3600 * 1000);
  hours = Math.floor(hoursMilli / (3600 * 1000));
  minutesMilli = hoursMilli % (3600 * 1000);
  minutes = Math.floor(minutesMilli / (60 * 1000));
  secondMill = minutesMilli % (60 * 1000);
  seconds = Math.floor(secondMill / 1000);
  if (days) {
    return days + '天前';
  } else if (hours) {
    return hours + '小时前';
  } else if (minutes) {
    return minutes + '分前';
  } else if (seconds) {
    return seconds + '秒前';
  } else {
    return 'something went wrong!';
  }
});

Vue.prototype.$activeFeedback = activeFeedback;
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