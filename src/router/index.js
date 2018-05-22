import Vue from 'vue';
import Router from 'vue-router';

import welcomePage from '@/pages/welcomePage';

// const welcomePage = () =>
//   import ('@/pages/welcomePage');
const notFoundPage = () =>
  import ('@/pages/notFoundPage');
const layoutPage = () =>
  import ('@/pages/layoutPage');
const homePage = () =>
  import ( /* webpackChunkName: "home" */ '@/pages/homePage');
const articleList = () =>
  import ( /* webpackChunkName: "home" */ '@/components/homePage/articleList');
const trendPage = () =>
  import ('@/pages/trendPage');
const searchPage = () =>
  import ('@/pages/searchPage');
const settingPage = () =>
  import ('@/pages/settingPage');
const createArticle = () =>
  import ('@/pages/createArticle');
const createTrend = () =>
  import ('@/pages/createTrend');
const articleDetail = () =>
  import ('@/pages/articleDetail');
const userDetail = () =>
  import ('@/pages/userDetail');
const subjectDetail = () =>
  import ('@/pages/subjectDetail');
const topicTrends = () =>
  import ('@/pages/topicTrends');

Vue.use(Router);

let fromSubject = 'index';
Router.prototype.go = function (number) {
  this.isBack = true;
  window.history.go(number);
};

export default new Router({
  mode: 'history',
  routes: [{
      path: '/',
      name: 'welcomePage',
      component: welcomePage
    },
    {
      path: '/subject',
      component: layoutPage,
      children: [{
          path: '',
          component: homePage,
          children: [{
              path: '',
              beforeEnter(to, from, next) {
                if (to.path == '/subject') {
                  next({
                    name: 'subject',
                    params: {
                      subject: fromSubject
                    }
                  })
                }
              }
            },
            {
              path: ':subject(index|frontend|android|read|AI|iOS|product|design|tool|read|backend)',
              name: 'subject',
              component: articleList,
              props: true
            }
          ]
        },
        {
          path: '/trend',
          name: 'trendPage',
          component: trendPage,
          beforeEnter(to, from, next) {
            if (from.name == 'subject') {
              fromSubject = from.params.subject;
            }
            next();
          },
        },
        {
          path: '/search',
          name: 'searchPage',
          component: searchPage,
          beforeEnter(to, from, next) {
            if (from.name == 'subject') {
              fromSubject = from.params.subject;
            }
            next();
          },
        },
        {
          path: '/setting',
          name: 'settingPage',
          component: settingPage,
          beforeEnter(to, from, next) {
            if (from.name == 'subject') {
              fromSubject = from.params.subject;
            }
            next();
          },
        }
      ]
    },
    {
      path: '/createArticle',
      name: 'createArticle',
      component: createArticle
    },
    {
      path: '/createTrend',
      name: 'createTrend',
      component: createTrend
    },
    {
      path: '/articleDetail/:articleID(\\d+)',
      name: 'articleDetail',
      component: articleDetail,
      props: true
    },
    {
      path: '/userDetail/:userID',
      name: 'userDetail',
      component: userDetail,
      props: true
    },
    {
      path: '/subjectDetail/:subject',
      name: 'subjectDetail',
      component: subjectDetail,
      props: true
    },
    {
      path: '/topicTrend',
      name: 'topicTrends',
      component: topicTrends,
      props: route=>({topic:route.query.topic})
    },
    {
      path: '(.*|notFound)',
      name: 'notFound',
      component: notFoundPage
    }
  ]
})
