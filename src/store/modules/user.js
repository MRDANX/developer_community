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
    } else {
      state.userInfo = {};
    }
  },
  unregisterUserInfo(state) {
    state.userInfo = {};
    localStorage.removeItem('userInfo');
    localStorage.removeItem('userInfoExpire');
  },
  updateToken(state, token) {
    state.userInfo.token = token;
    localStorage.setItem('userInfo', JSON.stringify(state.userInfo));
  }
};

const actions = {
  //check or update user information according to expire time
  checkUserInfo({
    state,
    commit,
    dispatch
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
        dispatch('retrieveUserInfo');
      } else if (localStorage.getItem('userInfo')) {
        commit('initializeUserInfo');
      }
    }
  },
  modifyUserInfo({
    state,
    commit,
    dispatch
  }, {
    modifyType,
    modifiedText
  }) {
    return new Promise((resolve, reject) => {
      axios({
        method: 'post',
        url: '/api/modifyUserInfo',
        data: qs.stringify({
          userID: state.userInfo.userID,
          token: state.userInfo.token,
          modifyType,
          modifiedText
        })
      }).then(result => {
        let response = result.data;
        setTimeout(() => {
          dispatch('retrieveUserInfo');
          resolve(result);
        }, 200);
      });
    });
  },
  //request server to update localStrage relative to user's informattion
  retrieveUserInfo({
    state,
    commit
  }) {
    let userInfo = JSON.parse(localStorage.getItem('userInfo'));
    if (userInfo) {
      let token = userInfo.token;
      axios({
        method: 'post',
        url: '/api/requestLogin',
        data: qs.stringify({
          tokenType: 'phone',
          encoded: token
        })
      }).then(result => {
        let data = result.data;
        //force logout if user's password has been modified
        if (data.errno && data.errno == 401) {
          localStorage.removeItem('userInfoExpire');
          localStorage.removeItem('userInfo');
          console.log('手机/邮箱或密码错误!');
          setTimeout(() => {
            commit('initializeUserInfo');
          }, 1000);
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
  toggleArticleFavor({
    state,
    dispatch
  }, {
    articleID,
    isFavorite
  }) {
    const userID = state.userInfo.userID;
    return new Promise((resolve, reject) => {
      axios({
        method: 'post',
        url: '/api/toggleArticleFavor',
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
  },
  //request server to toggle user's favor of the current trend
  toggleTrendFavor({
    state,
    dispatch
  }, {
    trendID,
    isFavorite
  }) {
    const userID = state.userInfo.userID;
    return new Promise((resolve, reject) => {
      axios({
        method: 'post',
        url: '/api/toggleTrendFavor',
        data: qs.stringify({
          userID,
          trendID,
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
  },
  toggleUserFollow({
    state,
    dispatch
  }, {
    followeeUserID,
    wantFollow
  }) {
    const userID = state.userInfo.userID;
    return new Promise((resolve, reject) => {
      axios({
        method: 'post',
        url: '/api/toggleUserFollow',
        data: qs.stringify({
          userID,
          followeeUserID,
          wantFollow
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
