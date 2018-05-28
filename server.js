// var cookieParser = require('cookie-parser');
// var multer = require('multer');
// var path = require('path')
// const mysql = require('mysql')
const express = require('express');
const bodyParser = require('body-parser');
const history = require('connect-history-api-fallback')
const initApiRouter = require('./apiRouter');

const app = express();

// connection.connect();
app.use(history());

//serve the static resource
app.use(express.static('dist'));

//use body-parser for parsing parameters passed from client
app.use(bodyParser.urlencoded({
  limit: '50mb',
  extended: false
}));

initApiRouter(app);

var server = app.listen(80, () => {
  var hostname = server.address().address;
  var port = server.address().port;
  console.log(`Server listening on ${hostname}:${port}...`);
});
