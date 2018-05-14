import axios from 'axios';
let qs = require('qs');

const state = {
  userInfo: {}
};

const mutations = {
  registerUserInfo(state, userInfo) {
    state.userInfo = userInfo;
    localStorage.setItem('avatar', state.userInfo.avatar || '');
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
    localStorage.removeItem('userInfoExpire');
  }
};

const actions = {
  //check or update user information according to expire time
  checkUserInfo({ state, commit, dispatch }) {
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
        dispatch('retrieveUserInfo');
      } else if (localStorage.getItem('userInfo')) {
        commit('initializeUserInfo');
      }
    }
  },
  modifyUserInfo({ state, commit, dispatch }, { modifyType, modifiedText }) {
    return new Promise((resolve, reject) => {
      axios({
        method: 'post',
        url: '/modifyUserInfo',
        data: qs.stringify({
          userID: state.userInfo.userID,
          modifyType,
          modifiedText
        })
      }).then(result => {
        setTimeout(() => {
          if (!result.data.errno) {
            dispatch('retrieveUserInfo');
          }
          resolve(result);
        }, 500);
      });
    });
  },
  //request server to update localStrage relative to user's informattion
  retrieveUserInfo({ state, commit }) {
    let userInfo = JSON.parse(localStorage.getItem('userInfo'));
    if (userInfo) {
      let userToken = userInfo.phone,
        password = userInfo.password;
      axios({
        method: 'post',
        url: '/requestLogin',
        data: qs.stringify({
          tokenType: 'phone',
          userToken,
          password
        })
      }).then(result => {
        let data = result.data;
        //force logout if user's password has been modified
        if (data.errno && data.errno == 404) {
          localStorage.removeItem('userInfoExpire');
          localStorage.removeItem('userInfo');
          console.log('手机/邮箱或密码错误!');
          return;
        }
        //reset localStorage of userInfo
        localStorage.setItem('avatar', data.avatar);
        localStorage.setItem('userInfoExpire', Date.now());
        localStorage.setItem('userInfo', JSON.stringify(data));
        commit('initializeUserInfo');
      })
    }
  },
  //request server to toggle user's favor of the current article
  toggleArticleFavor({ state, commit, dispatch }, { articleID, isFavorite }) {
    const userID = state.userInfo.userID;
    return new Promise((resolve, reject) => {
      axios({
        method: 'post',
        url: '/toggleArticleFavor',
        data: qs.stringify({
          userID,
          articleID,
          isFavorite
        })
      }).then(result => {
        if (!result.data.errno) {
          //retrieve user information from server
          dispatch('retrieveUserInfo');
          resolve();
        } else {
          reject(result.data);
        }
      });
    });
  }
};

export default {
  namespaced: true,
  state,
  mutations,
  actions
}