import Vue from 'vue';
import Router from 'vue-router';
// import welcomePage from '@/pages/welcomePage';
// import layoutPage from '@/pages/layoutPage';
// import notFoundPage from '@/pages/notFoundPage';
// import trendPage from '@/pages/trendPage';
// import searchPage from '@/pages/searchPage';
// import settingPage from '@/pages/settingPage';
// import homePage from '@/pages/homePage';
// import articleList from '@/components/articleList';
const welcomePage = () =>
  import ('@/pages/welcomePage');
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

Vue.use(Router);

let fromSubject = 'index';
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
          path: '/comment',
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
      path: '(.*|notFound)',
      name: 'notFound',
      component: notFoundPage
    }
  ]
})