import Vue from 'vue';
import Router from 'vue-router';
import homePage from '@/pages/homePage';
import welcomePage from '@/pages/welcomePage';
import notFoundPage from '@/pages/notFoundPage';
import articleList from '@/components/articleList';
import articleDetail from '@/components/articleDetail';

Vue.use(Router)

export default new Router({
  mode: 'history',
  routes: [{
      path: '/',
      name: 'welcomePage',
      component: welcomePage
    },
    {
      path: '/:userID(\\d+)',
      component: homePage,
      children: [{
          path: '',
          name: 'homePage',
          component: articleList
        },
        {
          path: 'article/:articleID',
          name: 'articleDetail',
          component: articleDetail,
          props: true
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
