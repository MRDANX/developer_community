const mysql = require('mysql');

let mysql_config = {
  host: 'localhost',
  port: '3306',
  user: 'root',
  password: 'root',
  database: 'developer_community'
};

let connection;

function handleDisconnection() {
  connection = mysql.createConnection(mysql_config);
  connection.connect(err => {
    if (err) {
      setTimeout(handleDisconnection, 2000);
    }
  });
  connection.on('error', err => {
    console.error('db error: ', err);
    if (err.code === 'PROTOCOL_CONNECTION_LOST') {
      console.log('db reconnect: ', err.message);
      handleDisconnection();
    } else {
      throw err;
    }
  });
  return connection;
}
module.exports = handleDisconnection();