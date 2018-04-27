import Vue from 'vue';
import Router from 'vue-router';
import layoutPage from '@/pages/layoutPage';
import welcomePage from '@/pages/welcomePage';
import notFoundPage from '@/pages/notFoundPage';
import commentPage from '@/pages/commentPage';
import searchPage from '@/pages/searchPage';
import settingPage from '@/pages/settingPage';
import homePage from '@/pages/homePage';

Vue.use(Router)

export default new Router({
  mode: 'history',
  routes: [{
      path: '/',
      name: 'welcomePage',
      component: welcomePage
    },
    {
      path: '/home',
      component: layoutPage,
      children: [{
          path: '',
          name: 'homePage',
          component: homePage
        },
        {
          path: '/comment',
          name: 'commentPage',
          component: commentPage,
        },
        {
          path: '/search',
          name: 'searchPage',
          component: searchPage
        },
        {
          path: '/setting',
          name: 'settingPage',
          component: settingPage
        }
      ]
    },
    {
      path: '(.*|notFound)',
      name: 'notFound',
      component: notFoundPage
    }
  ]
})
