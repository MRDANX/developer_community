import axios from 'axios';

const state = {
  userInfo: {}
};

const mutations = {
  registerUserInfo(state, userInfo) {
    state.userInfo = userInfo;
    localStorage.setItem('userInfo', JSON.stringify(state.userInfo));
    localStorage.setItem('userInfoExpire', Date.now());
  },
  initializeUserInfo(state) {
    let userInfo = localStorage.getItem('userInfo');
    if (userInfo) {
      state.userInfo = JSON.parse(userInfo);
    }
  },
  unregisterUserInfo(state) {
    state.userInfo = {};
    localStorage.removeItem('userInfo');
  }
};

const actions = {
  //check or update user information according to expire time
  checkUserInfo({
    state,
    commit
  }) {
    let expire = +localStorage.getItem('userInfoExpire');
    if (expire) {
      let clearExpire = 7 * 24 * 3600 * 1000;
      let updateExpire = 7 * 3600 * 1000;
      let now = Date.now();
      if (now - expire >= clearExpire) {
        //clear localStorage relative to user's informarion
        localStorage.removeItem('userInfoExpire');
        localStorage.removeItem('userInfo');
      } else if (now - expire >= updateExpire) {
        //request server to update localStrage relative to user's informattion
        let userInfo = JSON.parse(localStorage.getItem('userInfo'));
        if (userInfo) {
          let qs = require('qs');
          let userName = userInfo.userName,
            password = userInfo.password;
          axios({
            method: 'post',
            url: '/requestLogin',
            data: qs.stringify({
              userName,
              password
            })
          }).then(result => {
            let data = result.data;
            if (data.errno && data.errno == 404) {
              localStorage.removeItem('userInfoExpire');
              localStorage.removeItem('userInfo');
              console.log('用户名或密码错误!');
              return;
            }
            localStorage.setItem('userInfoExpire', Date.now());
            localStorage.setItem('userInfo', JSON.stringify(data));
            commit('initializeUserInfo');
          })
        }
      } else if (localStorage.getItem('userInfo')) {
        commit('initializeUserInfo');
      }
    }

  }
};

export default {
  namespaced: true,
  state,
  mutations,
  actions
}
