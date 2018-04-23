import axios from "axios"


const state = {
  userName: 'no name'
};

const mutations = {
  initializeHomePage(state) {

  }
};

const actions = {
  initializeHomePage({state,commit,rootState}) {
    axios('/api/getUser').then(result => {
      if (result.status == 200) {
        state.userName=result.data.userName;
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
