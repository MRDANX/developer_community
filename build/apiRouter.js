const connection = require('./mysqlConnection');
const bodyParser = require('body-parser');
const jwt = require('jsonwebtoken');
const base64 = require('js-base64').Base64;

const secretKey = 'developer_community';
const expireTime = 7 * 24 * 60 * 60;

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

function getOriginalArticleNumber(userID) {
  return new Promise((resolve, reject) => {
    let sql = 'SELECT COUNT(*) AS originalArticleNum FROM article where userID=?';
    connection.query(sql, [userID], (err, result) => {
      if (err) throw err;
      resolve(result[0].originalArticleNum);
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

function getFavoritelArticleNumber(userID) {
  return new Promise((resolve, reject) => {
    let sql = 'SELECT count(*) as favoriteArticleNum FROM favoriteArticle where userID=?';
    connection.query(sql, [userID], (err, result) => {
      if (err) throw err;
      resolve(result[0].favoriteArticleNum);
    });
  });
}

function getFavoritelTrend(userID) {
  return new Promise((resolve, reject) => {
    let sql = 'SELECT trendID FROM favoriteTrend where userID=?';
    connection.query(sql, [userID], (err, result) => {
      if (err) throw err;
      resolve(result);
    });
  });
}

function getTrendNumber(userID) {
  return new Promise((resolve, reject) => {
    let sql = 'SELECT count(*) as trendNum FROM trend where userID=?';
    connection.query(sql, [userID], (err, result) => {
      if (err) throw err;
      resolve(result[0].trendNum);
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

function getFollowerNumber(userID) {
  return new Promise((resolve, reject) => {
    let sql = 'SELECT COUNT(*) AS followerNum FROM follower where userID=?';
    connection.query(sql, [userID], (err, result) => {
      if (err) throw err;
      resolve(result[0].followerNum);
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

function getFolloweeNumber(userID) {
  return new Promise((resolve, reject) => {
    let sql = 'SELECT COUNT(*) AS followeeNum FROM follower where followerUserID=?';
    connection.query(sql, [userID], (err, result) => {
      if (err) throw err;
      resolve(result[0].followeeNum);
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

function getCollectionNumber(userID) {
  return new Promise((resolve, reject) => {
    let sql = 'SELECT COUNT(*) AS collectionNum FROM collection where userID=?';
    connection.query(sql, [userID], (err, result) => {
      if (err) throw err;
      resolve(result[0].collectionNum);
    });
  });
}

function base64ToImage(base64, publicPath) {
  return new Promise((resolve, reject) => {
    let regExp = /^data:image\/(\w+);base64,/,
      match = base64.match(regExp);
    if (!match) {
      resolve(base64);
    }
    let suffix = match[1],
      filePath = `${publicPath}/${Date.now()}.${suffix}`,
      imgData = base64.replace(regExp, '');
    let dataBuffer = new Buffer(imgData, 'base64');
    let fs = require('fs');
    fs.writeFile('dist/'+filePath, dataBuffer, err => {
      if (err) {
        console.log('save image failed at function base64ToImage');
        reject();
      } else {
        console.log('用户动态图片保存成功');
        resolve('/' + filePath)
      }
    })
  });
}

//middleware for verifing user's login info
function verifyUser(req, res, next) {
  let token = req.body.token;
  let decoded = jwt.verify(token, secretKey, (err, decoded) => {
    if (!err) {
      let sql = 'SELECT COUNT(*) AS count FROM user WHERE phone=? AND password=?',
        inserts = [decoded.userToken, decoded.password];
      connection.query(sql, inserts, (err, result) => {
        if (err) {
          // console.log(err);
          res.json({
            errno: 500,
            text: '服务器错误，请联系管理员!'
          });
          return;
        }
        if (result[0].count > 0) {
          next();
        } else {
          res.json({
            errno: 500,
            text: 'something wrong at function verifyUser!'
          });
        }
      })
    } else {
      console.error('Error when decoding token: ', err);
      res.json({
        errno: 401,
        text: '用户信息已过期，请重新登录!'
      });
      return;
    }
  })
}

function initApiRouter(app) {

  //use body-parser for parsing parameters passed from client
  app.use(bodyParser.urlencoded({
    limit: '50mb',
    extended: false
  }));

  //router for requesting login
  app.post('/api/requestLogin', (req, res) => {
    let tokenType = req.body.tokenType,
      encoded = req.body.encoded,
      userToken,
      password,
      querySql;
    jwt.verify(encoded, secretKey, (err, decoded) => {
      if (!err) {
        userToken = decoded.userToken;
        password = decoded.password;
      } else {
        console.error('Error when decoding login info');
      }
    });
    if (tokenType == 'phone') {
      querySql = 'SELECT * FROM user where phone=? AND password=?';
    } else {
      querySql = 'SELECT * FROM user where email=? AND password=?';
    }
    let inserts = [userToken, password];
    new Promise((resolve, reject) => {
      connection.query(querySql, inserts, (err, result) => {
        if (err) throw err;
        if (result.length != 0) {
          resolve(result[0]);
        } else {
          reject({
            errno: 401,
            text: '手机号/邮箱或密码错误!'
          });
        }
      });
    }).then(userInfo => {
      let userID = userInfo.userID;
      let phone = userInfo.phone;
      let password = userInfo.password;
      let token = jwt.sign({
        userToken: phone,
        password
      }, secretKey, {
        expiresIn: expireTime
      });
      let getOriginalArticlePromise = getOriginalArticle(userID, true);
      let getTrendNumberPromise = getTrendNumber(userID);
      let getFavoritelArticlePromise = getFavoritelArticle(userID);
      let getFavoritelTrendPromise = getFavoritelTrend(userID);
      let getFollowerPromise = getFollower(userID);
      let getFolloweePromise = getFollowee(userID);
      let getCollectionPromise = getCollection(userID);
      Promise.all([getOriginalArticlePromise, getTrendNumberPromise, getFavoritelArticlePromise, getFavoritelTrendPromise, getFollowerPromise, getFolloweePromise, getCollectionPromise]).then(result => {
        //use es6 grammar to deconstruct result into corresponding variable
        let [originalArticle, trendNum, favoriteArticle, favoriteTrend, follower, followee, collection] = result;
        delete userInfo.password;
        Object.assign(userInfo, {
          originalArticle,
          trendNum,
          favoriteArticle,
          favoriteTrend,
          follower,
          followee,
          collection,
          token
        });
        res.json(userInfo);
      }).catch(err => {
        res.end('something went wrong when querying database');
        console.error(err);
      });
    }).catch(err => {
      res.json(err);
    });
  });

  //router for user's detail info
  app.get('/api/getUserDetail', (req, res) => {
    let userID = +req.query.userID,
      querySql = 'SELECT * FROM user where userID=?';
    let inserts = [userID];
    new Promise((resolve, reject) => {
      connection.query(querySql, inserts, (err, result) => {
        if (err) throw err;
        if (result.length != 0) {
          resolve(result[0]);
        } else {
          reject({
            errno: 404,
            text: '用户不存在!'
          });
        }
      });
    }).then(userInfo => {
      let getOriginalArticleNumberPromise = getOriginalArticleNumber(userID);
      let getTrendNumberPromise = getTrendNumber(userID);
      let getFavoritelArticleNumberPromise = getFavoritelArticleNumber(userID);
      let getFollowerNumberPromise = getFollowerNumber(userID);
      let getFolloweeNumberPromise = getFolloweeNumber(userID);
      let getCollectionNumberPromise = getCollectionNumber(userID);
      Promise.all([getOriginalArticleNumberPromise, getTrendNumberPromise, getFavoritelArticleNumberPromise, getFollowerNumberPromise, getFolloweeNumberPromise, getCollectionNumberPromise]).then(result => {
        //use es6 grammar to deconstruct result into corresponding variable
        let [originalArticleNum, trendNum, favoriteArticleNum, followerNum, followeeNum, collectionNum] = result;
        Object.assign(userInfo, {
          originalArticleNum,
          trendNum,
          favoriteArticleNum,
          followerNum,
          followeeNum,
          collectionNum
        });
        res.json(userInfo);
      }).catch(err => {
        res.end('something went wrong when querying database');
      });
    }).catch(err => {
      res.json('something went wrong when querying database after');
    });
  });

  //router for check whether field is duplicated
  app.get('/api/checkUserInfoDuplicate', (req, res) => {
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
        res.json({
          err: 'duplicated',
          text: `该${chineseType}已被使用!`
        });
      } else {
        res.json({
          err: null,
          text: `该${chineseType}可注册!`
        })
      }
    })

  });

  //router for registering user's information
  app.post('/api/requestRegister', async (req, res) => {
    let registerSql = "INSERT INTO user(avatar,phone,email,userName,password) VALUE(?,?,?,?,?)";
    let {
      avatar,
      phone,
      email,
      userName,
      encodedPassword
    } = req.body;

    let decoded = jwt.decode(encodedPassword, secretKey);
    let password = decoded && decoded.password;
    let publicPath = 'static/images/avatar';
    await base64ToImage(avatar, publicPath).then(avatarPath => {
      avatar = avatarPath;
    }).catch(err => {
      console.log(err);
      res.json({
        err: 'failed',
        text: '注册失败,请重新尝试一次!'
      });
      return;
    });
    let inserts = [avatar, phone, email, userName, password];
    connection.query(registerSql, inserts, (err, result) => {
      if (err) throw err;
      if (result.affectedRows == 1) {
        res.json({
          err: null,
          text: '注册成功!'
        });
      } else {
        res.json({
          err: 'failed',
          text: '注册失败,请重新尝试一次!'
        });
      }
    });
  });

  //router for modifying user's information
  app.post('/api/modifyUserInfo', verifyUser, async (req, res) => {
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
    if (modifyType == 'avatar') {
      let publicPath = 'static/images/avatar';
      await base64ToImage(modifiedText, publicPath).then(avatarPath => {
        modifiedText = avatarPath;
      }).catch(err => {
        console.log(err);
      })
    }
    modifySql = `UPDATE user SET ${modifyType}=? WHERE userID=?`;
    let inserts = [modifiedText, userID];
    connection.query(modifySql, inserts, (err, result) => {
      if (err) {
        if (err.code == 'ER_DUP_ENTRY') {
          res.json({
            errno: 1062,
            text: '用户名已存在!'
          });
          return;
        } else {
          throw err;
        }
      }
      if (result.affectedRows == 1) {
        res.json({
          errno: null,
          text: '修改成功!'
        });
      } else {
        console.log('failed to update user\'s information');
      }
    });

  });

  //router for getting articleList
  app.get('/api/getArticleList', (req, res) => {

    let query = req.query,
      subject = query.subject,
      orderBy = query.orderBy || 'date',
      startIndex = +query.startIndex || 0,
      number = +query.number || 3;
    let getArticleListSql = `SELECT * FROM articleDetail WHERE subject=? ORDER BY ${orderBy} DESC LIMIT ?,?`;
    let inserts = [subject, startIndex, number];
    switch (subject) {
      case 'index':
        getArticleListSql = `SELECT * FROM articleDetail ORDER BY ${orderBy} DESC LIMIT ?,?`;
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
    connection.query(getArticleListSql, inserts, function (err, result) {
      if (err) throw err;
      //return data of article list as format JSON
      res.json(result);
    });
  });

  //router for getting info of the article that propose to edit
  app.get('/api/getArticleAuthorID', (req, res) => {
    let articleID = req.query.articleID,
      sql = 'SELECT userID FROM article WHERE articleID=?';
    connection.query(sql, [articleID], (err, result) => {
      if (err) throw err;
      if (result.length == 1) {
        res.json({
          status: 200,
          authorID: result[0].userID
        });
      } else {
        res.json({
          status: 404,
          text: 'Article Not Found!'
        });
      }
    });
  });

  //router for getting info of the article that propose to edit
  app.get('/api/editArticle', (req, res) => {
    let editingArticleSql = 'SELECT articleID,userID,title,cover,subject,tags,content FROM article WHERE articleID=?';
    let articleID = +req.query.articleID,
      inserts = [articleID];
    connection.query(editingArticleSql, inserts, (err, result) => {
      if (err) throw err;
      if (result.length == 1) {
        res.json({
          status: 200,
          text: 'Article Found',
          articleInfo: result[0]
        })
      } else {
        res.json({
          status: 404,
          text: 'Article Not Found',
          articleInfo: null
        });
      }
    })
  });

  //router for update edited article
  app.post('/api/editArticle', verifyUser, async (req, res) => {
    let editArticleSql = 'UPDATE article SET title=?,content=?,subject=?,tags=?,cover=? WHERE articleID=?',
      data = req.body,
      articleID = data.articleID,
      title = data.title,
      cover = data.cover,
      subject = data.subject,
      tags = data.tags,
      content = data.content,
      publicPath = 'static/images/articleCover';
    await base64ToImage(cover, publicPath).then(coverPath => {
      cover = coverPath;
    });
    let inserts = [title, content, subject, tags, cover, articleID];
    connection.query(editArticleSql, inserts, (err, result) => {
      if (err) throw err;
      if (result.affectedRows == 1) {
        res.json({
          status: 200,
          text: '修改文章成功'
        });
      } else {
        res.json({
          status: 500,
          text: '修改文章失败'
        });
      }
    });
  });

  //router for getting the specified article info
  app.get('/api/getSpecifiedArticle', (req, res) => {
    let getSpecifiedArticleSql = 'SELECT * FROM articleDetail WHERE articleID=?';
    let articleID = +req.query.articleID,
      inserts = [articleID];
    connection.query(getSpecifiedArticleSql, inserts, (err, result) => {
      if (err) throw err;
      res.json(result);
    });
  });

  //router for getting users favorite articles
  app.get('/api/getMyFavoriteArticle', (req, res) => {
    let getSql = 'SELECT * FROM articleDetail WHERE articleID IN (?) ORDER BY FIELD(??,?) LIMIT ?,?',
      articleIDList = JSON.parse(req.query.articleIDList),
      startIndex = +req.query.startIndex || 0,
      number = +req.query.number || 5,
      inserts = [articleIDList, 'articleID', articleIDList, startIndex, number];
    connection.query(getSql, inserts, (err, result) => {
      if (err) throw err;
      if (result.length >= 0) {
        res.json({
          status: 200,
          text: 'Get Article List successful.',
          articleList: result
        });
      } else {
        res.json({
          status: 500,
          text: 'Internal server encounted.',
          articleList: null
        })
      }
    })
  });

  //router for getting users original articles
  app.get('/api/getUserOriginalArticle', (req, res) => {
    let userID = +req.query.userID,
      startIndex = +req.query.startIndex || 0,
      number = +req.query.number || 5,
      originalSql = 'SELECT * FROM articleDetail WHERE userID=? ORDER BY date DESC LIMIT ?,?',
      inserts = [userID, startIndex, number];
    connection.query(originalSql, inserts, (err, result) => {
      if (err) throw err;
      if (result.length >= 0) {
        res.json({
          status: 200,
          text: 'Get Original Article successful.',
          articleList: result
        });
      } else {
        res.json({
          status: 500,
          text: 'Internal server encounted.',
          articleList: null
        })
      }
    })
  });

  //router for increasing PV of article
  app.post('/api/increaseArticlePV', (req, res) => {
    let increaseSql = 'UPDATE article SET pv=pv+1 WHERE articleID=?',
      articleID = req.body.articleID;
    connection.query(increaseSql, [articleID], (err, result) => {
      if (err) throw err;
      res.json('article has been read.')
    });
  });

  //router for getting comments for article
  app.get('/api/getArticleComment', (req, res) => {
    let query = req.query,
      articleID = query.articleID,
      startIndex = +query.startIndex || 0,
      number = +query.number || 3;
    let getCommentsSql = "SELECT a.*, u.userName, u.avatar FROM articlecomment a INNER JOIN USER u ON a.userID = u.userID WHERE articleID=? ORDER BY date LIMIT ?,?",
      inserts = [articleID, startIndex, number];
    connection.query(getCommentsSql, inserts, (err, result) => {
      if (err) throw err;
      res.json(result);
    });
  });

  //router for publishing comment of an article
  app.post('/api/publishComment', (req, res) => {
    let data = req.body,
      userID = +data.userID,
      articleID = +data.articleID,
      commentText = data.commentText;
    let publishSql = 'INSERT INTO articleComment(userID,articleID,content,date) VALUE(?,?,?,?)',
      inserts = [userID, articleID, commentText, new Date()];
    connection.query(publishSql, inserts, (err, result) => {
      if (err) throw err;
      if (result.affectedRows == 1) {
        res.json({
          errno: null,
          text: '提交评论成功'
        });
      } else {
        res.json({
          errno: 1,
          text: '提交评论失败'
        });
      }
    });
  });

  //router for deleting users article
  app.post('/api/deleteArticle', verifyUser, (req, res) => {
    let articleID = req.body.articleID,
      deleteSql = 'DELETE FROM article WHERE articleID=?',
      deleteInserts = [articleID];
    connection.query(deleteSql, deleteInserts, (err, result) => {
      if (err) throw err;
      if (result.affectedRows == 1) {
        res.json({
          success: 1,
          text: '删除文章成功'
        });
      } else {
        res.json({
          success: 0,
          text: '删除文章失败'
        });
      }
    });
  });

  //router for publishing comment of a trend
  app.post('/api/publishTrendComment', (req, res) => {
    let data = req.body,
      userID = +data.userID,
      trendID = +data.trendID,
      commentText = data.commentText;
    let publishSql = 'INSERT INTO trendComment(userID,trendID,content,date) VALUE(?,?,?,?)',
      inserts = [userID, trendID, commentText, new Date()];
    connection.query(publishSql, inserts, (err, result) => {
      if (err) throw err;
      if (result.affectedRows == 1) {
        res.json({
          errno: null,
          text: '提交评论成功'
        });
      } else {
        res.json({
          errno: 1,
          text: '提交评论失败'
        });
      }
    });
  });

  //router for publishing article
  app.post('/api/createUserArticle', async (req, res) => {
    let createArticleSql = 'INSERT INTO article(userID,title,date,content,subject,tags,cover) VALUE(?,?,?,?,?,?,?)',
      data = req.body,
      userID = data.userID,
      title = data.title,
      cover = data.cover,
      subject = data.subject,
      tags = data.tags || null,
      content = data.content,
      publicPath = 'static/images/articleCover';
    await base64ToImage(cover, publicPath).then(coverPath => {
      cover = coverPath;
    });
    let inserts = [userID, title, new Date(), content, subject, tags, cover];
    connection.query(createArticleSql, inserts, (err, result) => {
      if (err) throw err;
      if (result.affectedRows == 1) {
        res.json({
          success: 1,
          text: '发布文章成功'
        });
      } else {
        res.json({
          success: 0,
          text: '发布文章失败'
        });
      }
    });
  });

  //router for toggle user's favor of article
  app.post('/api/toggleArticleFavor', (req, res) => {
    let data = req.body,
      userID = +data.userID,
      articleID = +data.articleID,
      isFavorite = JSON.parse(data.isFavorite),
      inserts = [userID, articleID],
      toggleFavorSql;
    if (isFavorite) {
      toggleFavorSql = 'INSERT INTO favoriteArticle(userID,articleID) VALUE(?,?)';
    } else {
      toggleFavorSql = 'DELETE FROM favoriteArticle WHERE userID=? AND articleID=?';
    }
    connection.query(toggleFavorSql, inserts, (err, result) => {
      if (err) throw err;
      if (result.affectedRows == 1) {
        res.json({
          errno: null,
          text: '更新文章点赞表成功'
        })
      } else {
        res.json({
          errno: 1,
          text: '更新文章点赞表失败'
        })
      }
    });
  });

  //router for searching for simple article and user
  app.get('/api/searchForSimple', (req, res) => {
    let searchText = req.query.searchText;
    let getUsersSql = `SELECT u.userID,avatar,userName,COUNT(followerUserID) as followers FROM user u LEFT JOIN follower f ON u.userID=f.userID WHERE userName like '%${searchText}%' GROUP BY u.userID LIMIT 3`,
      getArticlesSql = `SELECT articleID,title,pv FROM article WHERE title like '%${searchText}%' LIMIT 5`;
    let getUsers = new Promise((resolve, reject) => {
      connection.query(getUsersSql, (err, users) => {
        if (err) throw err;
        resolve(users);
      });
    });
    let getArticles = new Promise((resolve, reject) => {
      connection.query(getArticlesSql, (err, articles) => {
        if (err) throw err;
        resolve(articles);
      });
    });
    Promise.all([getUsers, getArticles]).then(result => {
      let [users, articles] = result;
      res.json({
        users,
        articles
      })
    })
  });

  //router for searching for detailed article and user
  app.get('/api/searchForDetailed', (req, res) => {
    let searchText = req.query.searchText,
      articleOrderBy = req.query.articleOrderBy;
    let getUsersSql = `SELECT userID,avatar,userName FROM user WHERE userName like '%${searchText}%' LIMIT 10`,
      getArticlesSql = `SELECT articleID, userName AS author, title, content, favors, date FROM article a JOIN USER u ON a.userID=u.userID WHERE title LIKE '%${searchText}%' OR content LIKE '%${searchText}%' ORDER BY ${articleOrderBy} DESC LIMIT 5`
    let getUsers = new Promise((resolve, reject) => {
      connection.query(getUsersSql, (err, users) => {
        if (err) throw err;
        resolve(users);
      });
    });
    let getArticles = new Promise((resolve, reject) => {
      connection.query(getArticlesSql, (err, articles) => {
        if (err) throw err;
        resolve(articles);
      });
    });
    Promise.all([getUsers, getArticles]).then(result => {
      let [users, articles] = result;
      res.json({
        users,
        articles
      })
    })
  });

  //router for getting more detailed searched article 
  app.get('/api/searchForMoreDetailedArticle', (req, res) => {
    let searchText = req.query.searchText,
      articleOrderBy = req.query.articleOrderBy,
      startIndex = +req.query.startIndex,
      getArticlesSql = `SELECT articleID, userName AS author, title, content, favors, date FROM article a JOIN USER u ON a.userID=u.userID WHERE title LIKE '%${searchText}%' OR content LIKE '%${searchText}%' ORDER BY ${articleOrderBy} DESC LIMIT ${startIndex},5`;
    new Promise((resolve, reject) => {
      connection.query(getArticlesSql, (err, articles) => {
        if (err) throw err;
        resolve(articles);
      });
    }).then(articles => {
      res.json(articles);
    });
  });

  //router for getting trend list
  app.get('/api/getTrendList', (req, res) => {
    let startIndex = +req.query.startIndex,
      number = +req.query.number,
      orderBy = req.query.orderBy || 'date';
    let getTrendSql = `SELECT * FROM trendList ORDER BY ${orderBy} DESC LIMIT ?,?`,
      inserts = [startIndex, number];
    connection.query(getTrendSql, inserts, (err, result) => {
      if (err) throw err;
      res.json(result);
    });
  });

  //router for getting users favorite trends
  app.get('/api/getMyFavoriteTrend', (req, res) => {
    let getSql = 'SELECT * FROM trendList WHERE trendID IN (?) ORDER BY FIELD(??,?) LIMIT ?,?',
      trendIDList = JSON.parse(req.query.trendIDList),
      startIndex = +req.query.startIndex || 0,
      number = +req.query.number || 5,
      inserts = [trendIDList, 'trendID', trendIDList, startIndex, number];
    connection.query(getSql, inserts, (err, result) => {
      if (err) throw err;
      if (result.length >= 0) {
        res.json({
          status: 200,
          text: 'Get trend List successful.',
          trendList: result
        });
      } else {
        res.json({
          status: 500,
          text: 'Internal server encounted.',
          trendList: null
        })
      }
    })
  });
  //router for getting comments for trend
  app.get('/api/getTrendComment', (req, res) => {
    let query = req.query,
      trendID = query.trendID;
    let getCommentsSql = "SELECT a.*, u.userName, u.avatar FROM trendcomment a INNER JOIN user u ON a.userID = u.userID WHERE trendID=? ORDER BY date ",
      inserts = [trendID];
    connection.query(getCommentsSql, inserts, (err, result) => {
      if (err) throw err;
      res.json(result);
    });
  });

  //router for gettin trend by topic
  app.get('/api/getTrendTopic', (req, res) => {
    let trendTopicSql = 'SELECT * FROM trendTopic';
    connection.query(trendTopicSql, (err, result) => {
      if (err) throw err;
      res.json(result);
    });
  });

  //router for gettin trend topics
  app.get('/api/getTrendByTopic', (req, res) => {
    let trendTopicSql = 'SELECT * FROM trendList WHERE topic=?',
      topic = req.query.topic;
    connection.query(trendTopicSql, [topic], (err, result) => {
      if (err) throw err;
      res.json(result);
    });
  });

  //router for getting the specified trend info
  app.get('/api/getSpecifiedTrend', (req, res) => {
    let getSpecifiedTrendSql = 'SELECT * FROM trendList WHERE trendID = ?';
    let trendID = +req.query.trendID,
      inserts = [trendID];
    connection.query(getSpecifiedTrendSql, inserts, (err, result) => {
      if (err) throw err;
      res.json(result);
    })
  });

  //router for getting trend for logged user
  app.get('/api/getUsersTrend', (req, res) => {
    let getUsersTrendSql = 'SELECT * FROM trendList WHERE userID IN ( SELECT userID FROM follower WHERE followerUserID = ? ) ORDER BY date DESC',
      followerUserID = +req.query.followerUserID;
    connection.query(getUsersTrendSql, [followerUserID], (err, result) => {
      if (err) throw err;
      res.json(result);
    })
  });

  //router for publishing trend
  app.post('/api/createUserTrend', verifyUser, (req, res) => {
    let createTrendSql = 'INSERT INTO trend(userID,content,date,images,topic) VALUE(?,?,?,?,?)',
      data = req.body,
      userID = data.userID,
      content = data.content,
      date = new Date(),
      images = JSON.parse(data.images),
      topic = data.topic,
      imagesPath;
    let publicPath = 'static/images/trend',
      saveImagePromiseList = [];
    images = images.map(image => {
      saveImagePromiseList.push(base64ToImage(image, publicPath));
    });
    Promise.all(saveImagePromiseList).then(result => {
      imagesPath = result.toString();
      let inserts = [userID, content, date, imagesPath, topic];
      connection.query(createTrendSql, inserts, (err, result) => {
        if (err) throw err;
        res.json(result);
      });
    })
  });

  //router for toggle user's favor of trend
  app.post('/api/toggleTrendFavor', (req, res) => {
    let data = req.body,
      userID = +data.userID,
      trendID = +data.trendID,
      isFavorite = JSON.parse(data.isFavorite),
      inserts = [userID, trendID],
      toggleFavorSql;
    if (isFavorite) {
      toggleFavorSql = 'INSERT INTO favoriteTrend(userID,trendID) VALUE(?,?)';
    } else {
      toggleFavorSql = 'DELETE FROM favoriteTrend WHERE userID=? AND trendID=?';
    }
    connection.query(toggleFavorSql, inserts, (err, result) => {
      if (err) throw err;
      if (result.affectedRows == 1) {
        res.json({
          errno: null,
          text: '更新动态点赞表成功'
        });
      } else {
        res.json({
          errno: 1,
          text: '更新动态点赞表失败'
        });
      }
    });
  });

  //router for toggle user's follow
  app.post('/api/toggleUserFollow', (req, res) => {
    let data = req.body,
      userID = +data.userID,
      followeeUserID = +data.followeeUserID,
      wantFollow = JSON.parse(data.wantFollow),
      inserts = [followeeUserID, userID],
      toggleFollowSql;
    if (wantFollow) {
      toggleFollowSql = 'INSERT INTO follower(userID,followerUserID) VALUE(?,?)';
    } else {
      toggleFollowSql = 'DELETE FROM follower WHERE UserID=? AND followerUserID=?';
    }
    connection.query(toggleFollowSql, inserts, (err, result) => {
      if (err) throw err;
      if (result.affectedRows == 1) {
        res.json({
          errno: null,
          text: '更新关注信息成功'
        })
      } else {
        res.json({
          errno: 1,
          text: '更新关注信息失败'
        })
      }
    });
  });
}

module.exports = initApiRouter;
