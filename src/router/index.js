import Vue from 'vue'
import Router from 'vue-router'
import welcomePage from '@/pages/welcomePage'
import homePage from '@/pages/homePage'

Vue.use(Router)

export default new Router({
  mode: 'history',
  routes: [
    {
      path: '/',
      name: 'welcomePage',
      component: welcomePage
    },
    {
      path:'/:userId/home',
      name:'homePage',
      component:homePage
    }
  ]
})
