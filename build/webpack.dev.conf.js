'use strict'
const utils = require('./utils')
const webpack = require('webpack')
const config = require('../config')
const merge = require('webpack-merge')
const path = require('path')
const baseWebpackConfig = require('./webpack.base.conf')
const CopyWebpackPlugin = require('copy-webpack-plugin')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const FriendlyErrorsPlugin = require('friendly-errors-webpack-plugin')
const portfinder = require('portfinder')

const bodyParser = require('body-parser');
const mysql = require('mysql')

const HOST = process.env.HOST
const PORT = process.env.PORT && Number(process.env.PORT)

/**
 * server code begin here
 */
// set the mysql configuration
var connection = mysql.createConnection({
  host: 'localhost',
  port: '3306',
  user: 'root',
  password: 'root',
  database: 'developer_community'
});
connection.connect();

function getOriginalArticle(userID, simplification) {
  return new Promise((resolve, reject) => {
    let sql = 'SELECT * FROM article where userID=?';
    if (simplification) {
      sql = 'SELECT articleID,title,favors FROM article where userID=?';
    }
    connection.query(sql, [userID], (err, result) => {
      if (err) throw err;
      resolve(result);
    });
  });
}

function getFavoritelArticle(userID) {
  return new Promise((resolve, reject) => {
    let sql = 'SELECT articleID FROM favoriteArticle where userID=?';
    connection.query(sql, [userID], (err, result) => {
      if (err) throw err;
      resolve(result);
    });
  });
}

function getFollower(userID) {
  return new Promise((resolve, reject) => {
    let sql = 'SELECT followerUserID FROM follower where userID=?';
    connection.query(sql, [userID], (err, result) => {
      if (err) throw err;
      resolve(result);
    });
  });
}

function getFollowee(userID) {
  return new Promise((resolve, reject) => {
    let sql = 'SELECT userID FROM follower where followerUserID=?';
    connection.query(sql, [userID], (err, result) => {
      if (err) throw err;
      resolve(result);
    });
  });
}

function getCollection(userID) {
  return new Promise((resolve, reject) => {
    let sql = 'SELECT collectionID,collectionName,articleID FROM collection where userID=?';
    connection.query(sql, [userID], (err, result) => {
      if (err) throw err;
      resolve(result);
    });
  });
}
/**
 * server code end here
 */

const devWebpackConfig = merge(baseWebpackConfig, {
  module: {
    rules: utils.styleLoaders({
      sourceMap: config.dev.cssSourceMap,
      usePostCSS: true
    })
  },
  // cheap-module-eval-source-map is faster for development
  devtool: config.dev.devtool,

  // these devServer options should be customized in /config/index.js
  devServer: {

    //server code
    before(app) {

      //use body-parser for parsing parameters passed from client
      app.use(bodyParser.urlencoded({
        limit: '50mb',
        extended: false
      }));

      //router for requesting login
      app.post('/requestLogin', (req, res) => {
        let tokenType = req.body.tokenType,
          userToken = req.body.userToken,
          password = req.body.password,
          querySql;
        if (tokenType == 'phone') {
          querySql = 'SELECT * FROM user where phone=? AND password=?'
        } else {
          querySql = 'SELECT * FROM user where email=? AND password=?'
        }
        let inserts = [userToken, password];
        new Promise((resolve, reject) => {
          connection.query(querySql, inserts, (err, result) => {
            if (err) throw err;
            if (result.length != 0) {
              resolve(result[0]);
            } else {
              reject({
                errno: 404,
                text: '用户名或密码错误!'
              });
            }
          });
        }).then(userInfo => {
          let userID = userInfo.userID;
          let getOriginalArticlePromise = getOriginalArticle(userID, true);
          let getFavoritelArticlePromise = getFavoritelArticle(userID);
          let getFollowerPromise = getFollower(userID);
          let getFolloweePromise = getFollowee(userID);
          let getCollectionPromise = getCollection(userID);
          let allPromise = Promise.all([getOriginalArticlePromise, getFavoritelArticlePromise, getFollowerPromise, getFolloweePromise, getCollectionPromise]).then(result => {
            //use es6 grammar to deconstruct result into corresponding variable
            let [originalArticle, favoriteArticle, follower, followee, collection] = result;
            Object.assign(userInfo, {
              originalArticle,
              favoriteArticle,
              follower,
              followee,
              collection
            });
            res.json(userInfo);
          }).catch(err => {
            res.end('something went wrong when query database');
          });
        }).catch(err => {
          res.json(err);
        });
      });

      //router for check whether field is duplicated
      app.get('/checkUserInfoDuplicate', (req, res) => {
        let type = req.query.type,
          field = req.query.field,
          checkSql = `SELECT * FROM user WHERE ${type}=?`,
          inserts = [field],
          chineseType;
        switch (type) {
          case 'phone':
            chineseType = '手机号';
            break;
          case 'email':
            chineseType = '邮箱';
            break;
          case 'userName':
            chineseType = '用户名';
            break;
          default:
            console.log('something went wrong at server\'s chekcUserInfoDuplicate 1');
            break;
        }
        connection.query(checkSql, inserts, (err, result) => {
          if (err) throw err;
          if (result.length >= 1) {
            res.json({ err: 'duplicated', text: `该${chineseType}已被注册!` });
          } else {
            res.json({ err: null, text: `该${chineseType}可注册!` })
          }
        })

      });

      //router for registering user's information
      app.post('/requestRegister', (req, res) => {
        let registerSql = "INSERT INTO user(avatar,phone,email,userName,password) VALUE(?,?,?,?,?)",
          data = req.body,
          avatar = data.avatar,
          phone = data.phone,
          email = data.email,
          userName = data.userName,
          password = data.password,
          inserts = [avatar, phone, email, userName, password];
        connection.query(registerSql, inserts, (err, result) => {
          if (err) throw err;
          if (result.affectedRows == 1) {
            res.json({ err: null, text: '注册成功!' });
          } else {
            res.json({ err: 'failed', text: '注册失败,请重新尝试一次!' });
          }
        });
      });

      //router for modifying user's information
      app.post('/modifyUserInfo', (req, res) => {
        let modifySql,
          userID = req.body.userID,
          modifyType = req.body.modifyType,
          modifiedText = req.body.modifiedText;
        //dictionary of modify type
        let modifyTypeDict = [{
            text: '头像',
            value: 'avatar'
          },
          {
            text: '用户名',
            value: 'userName'
          }, {
            text: '职位',
            value: 'job'
          }, {
            text: '公司',
            value: 'company'
          }, {
            text: '简介',
            value: 'introduce'
          }, {
            text: '博客地址',
            value: 'blogAddr'
          }
        ];
        modifyTypeDict.forEach(type => {
          if (modifyType == type.text) {
            modifyType = type.value;
          }
        });
        modifySql = `UPDATE user SET ${modifyType}=? WHERE userID=?`;
        let inserts = [modifiedText, userID];
        connection.query(modifySql, inserts, (err, result) => {
          if (err) {
            if (err.code == 'ER_DUP_ENTRY') {
              res.json({ errno: 1062, text: '用户名已存在!' });
              return
            } else {
              throw err;
            }
          }
          if (result.affectedRows == 1) {
            res.json({ errno: null, text: '修改成功!' });
          } else {
            console.log('failed to update user\'s information');
          }
        });
      });
      //router for getting articleList
      app.get('/api/getArticleList', (req, res) => {
        let getArticleListSql = 'SELECT a.*,u.userName as author,u.avatar FROM article a,user u where a.userID=u.userID AND subject=? LIMIT ?,?';
        // let inserts = [req.query.articleID];
        // getArticleSql = mysql.format(getArticleSql, inserts);
        let query = req.query,
          subject = query.subject,
          startIndex = +query.startIndex || 0,
          number = +query.number || 10;
        let inserts = [subject, startIndex, number];
        switch (subject) {
          case 'index':
            subject = '';
            getArticleListSql = 'SELECT a.*,u.userName as author,u.avatar FROM article a,user u where a.userID=u.userID LIMIT ?,?';
            inserts = [startIndex, number];
            break;
          case 'frontend':
            subject = '前端';
            inserts = [subject, startIndex, number];
            break;
          case 'backend':
            subject = '后端';
            inserts = [subject, startIndex, number];
            break;
          case 'android':
            subject = 'Android';
            inserts = [subject, startIndex, number];
            break;
          case 'iOS':
            subject = 'iOS';
            inserts = [subject, startIndex, number];
            break;
          case 'product':
            subject = '产品';
            inserts = [subject, startIndex, number];
            break;
          case 'design':
            subject = '设计';
            inserts = [subject, startIndex, number];
            break;
          case 'tool':
            subject = '工具资源';
            inserts = [subject, startIndex, number];
            break;
          case 'read':
            subject = '阅读';
            inserts = [subject, startIndex, number];
            break;
          case 'AI':
            subject = '人工智能';
            inserts = [subject, startIndex, number];
            break;
          default:
            break;
        }
        setTimeout(() => {
          connection.query(getArticleListSql, inserts, function(err, result) {
            if (err) throw err;
            //return data of article list as format JSON
            res.json(result);
          });
        }, 1000);
      });
    },

    clientLogLevel: 'warning',
    historyApiFallback: {
      rewrites: [{
        from: /.*/,
        to: path.posix.join(config.dev.assetsPublicPath, 'index.html')
      }, ],
    },
    hot: true,
    contentBase: false, // since we use CopyWebpackPlugin.
    compress: true,
    host: HOST || config.dev.host,
    port: PORT || config.dev.port,
    open: config.dev.autoOpenBrowser,
    overlay: config.dev.errorOverlay ? {
      warnings: false,
      errors: true
    } : false,
    publicPath: config.dev.assetsPublicPath,
    proxy: config.dev.proxyTable,
    quiet: true, // necessary for FriendlyErrorsPlugin
    watchOptions: {
      poll: config.dev.poll,
    }
  },
  plugins: [
    new webpack.DefinePlugin({
      'process.env': require('../config/dev.env')
    }),
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NamedModulesPlugin(), // HMR shows correct file names in console on update.
    new webpack.NoEmitOnErrorsPlugin(),
    // https://github.com/ampedandwired/html-webpack-plugin
    new HtmlWebpackPlugin({
      filename: 'index.html',
      template: 'index.html',
      inject: true
    }),
    // copy custom static assets
    new CopyWebpackPlugin([{
      from: path.resolve(__dirname, '../static'),
      to: config.dev.assetsSubDirectory,
      ignore: ['.*']
    }])
  ]
})

module.exports = new Promise((resolve, reject) => {
  portfinder.basePort = process.env.PORT || config.dev.port
  portfinder.getPort((err, port) => {
    if (err) {
      reject(err)
    } else {
      // publish the new Port, necessary for e2e tests
      process.env.PORT = port
      // add port to devServer config
      devWebpackConfig.devServer.port = port

      // Add FriendlyErrorsPlugin
      devWebpackConfig.plugins.push(new FriendlyErrorsPlugin({
        compilationSuccessInfo: {
          messages: [`Your application is running here: http://${devWebpackConfig.devServer.host}:${port}`],
        },
        onErrors: config.dev.notifyOnErrors ?
          utils.createNotifierCallback() : undefined
      }))

      resolve(devWebpackConfig)
    }
  })
})