import Vue from 'vue'
import Vuex from 'vuex'
import welcome from './modules/welcome'
import user from './modules/user'
import 'es6-promise/auto';

Vue.use(Vuex);

export default new Vuex.Store({
    modules:{
        welcome,
        user
    },
    //delete in product environment
    strict:true
})