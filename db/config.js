var mysql      = require('mysql');

// local
var dbConfig = mysql.createConnection({
  host     : '127.0.0.1',
  user     : 'root',
  password : '1234',
  port     : 3306,
  database : '4flix'
});

module.exports = dbConfig;