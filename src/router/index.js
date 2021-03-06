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
  import ('@/pages/article/createArticle');
const articleDetail = () =>
  import ('@/pages/article/articleDetail');
const subjectDetail = () =>
  import ('@/pages/article/subjectDetail');
const originalArticle = () =>
  import ('@/pages/article/originalArticle');
const myFavoriteArticle = () =>
  import ('@/pages/article/myFavoriteArticle');
const myFavoriteTrend = () =>
  import ('@/pages/trend/myFavoriteTrend');
const createTrend = () =>
  import ('@/pages/trend/createTrend');
const trendDetail = () =>
  import ('@/pages/trend/trendDetail');
const topicTrends = () =>
  import ('@/pages/trend/topicTrends');
const userDetail = () =>
  import ('@/pages/user/userDetail');
const constructing = () =>
  import ('@/pages/constructing');

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
      component: welcomePage,
      redirect:'/subject'
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
      component: createArticle,
      props: route => ({
        edit: route.query.edit && JSON.parse(route.query.edit),
        articleID: route.query.articleID && +route.query.articleID || NaN
      })
    },
    {
      path: '/createTrend',
      name: 'createTrend',
      component: createTrend
    },
    {
      path: '/articleDetail',
      name: 'articleDetail',
      component: articleDetail,
      props: route => ({
        articleID: +route.query.articleID || 0
      })
    },
    {
      path: '/trendDetail',
      name: 'trendDetail',
      component: trendDetail,
      props: route => ({
        trendID: route.query.trendID
      })
    },
    {
      path: '/userDetail/:userID',
      name: 'userDetail',
      component: userDetail,
      props: true
    },
    {
      path: '/subjectDetail',
      name: 'subjectDetail',
      component: subjectDetail,
      props: route => ({
        subject: route.query.subject
      })
    },
    {
      path: '/topicTrend',
      name: 'topicTrends',
      component: topicTrends,
      props: route => ({
        topic: route.query.topic
      })
    },
    {
      path: '/myFavoriteArticle',
      name: 'myFavoriteArticle',
      component: myFavoriteArticle
    },
    {
      path: '/myFavoriteTrend',
      name: 'myFavoriteTrend',
      component: myFavoriteTrend
    },
    {
      path: '/originalArticle',
      name: 'originalArticle',
      component: originalArticle
    },
    {
      path: '/constructing',
      name: 'constructing',
      component: constructing
    },
    {
      path: '(.*|notFound)',
      name: 'notFound',
      component: notFoundPage
    }
  ]
})
