import axios from 'axios'


const state = {
  userName: 'no name'
};

const mutations = {
  //initialize home page data
  initializeHomePage(state, data) {
    state.userName = data.userName;
  }
};

const actions = {
  //initialize home page data
  initializeHomePage({
    // state,
    commit,
    // rootState
  }) {
    axios('/api/getUser').then(result => {
      if (result.status == 200) {
        let data = result.data;
        commit('initializeHomePage', data);
      }


    })
  }
};

const getters = {

};

export default {
  namespaced: true,
  state,
  mutations,
  getters,
  actions
}
